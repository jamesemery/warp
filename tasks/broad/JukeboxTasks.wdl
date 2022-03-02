version 1.0

import "../../structs/dna_seq/JukeboxStructs.wdl" as Structs

task VerifyPipelineInputs {
  input {
    Array[File]? input_cram_list
    Array[File]? input_bam_list

    String docker = "us.gcr.io/broad-dsp-gcr-public/base/python:3.9-debian"
    Int cpu = 1
    Int memory_mb = 1000
    Int disk_size_gb = 10
  }

    command <<<
      set -e
      python3 <<CODE

      is_cram = False
      # WDL will add an empty string element if the input was not defined
      input_crams = [ x for x in [ "~{sep='", "' input_cram_list}" ]  if x != "" ]
      input_bams = [ x for x in [ "~{sep='", "' input_bam_list}" ] if x != "" ]

      if input_crams and not input_bams:
        is_cram = True
      elif input_bams and not input_crams:
        pass
      else:
        raise ValueError("Invalid Input. Input must be either list of crams or list of bams")

      with open("output.txt", "w") as f:
        if is_cram:
          f.write("true")
        else:
          f.write("false")

      CODE
    >>>

    runtime {
      docker: docker
      cpu: cpu
      memory: "${memory_mb} MiB"
      disks: "local-disk ${disk_size_gb} HDD"
    }

    output {
      Boolean is_cram = read_boolean("output.txt")
    }
}

task SplitCram {
  input {
    File input_cram_bam
    String base_file_name
    Int reads_per_file
    Int disk_size_gb = ceil(3 * size(input_cram_bam, "GB"))
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/crammer:1.3_0c527b2e"
  }

  command <<<

    mkdir -p /cromwell_root/splitout
    /crammer --split --out /cromwell_root/splitout/~{base_file_name}-%d.cram \
    --progress --nreads-per-file ~{reads_per_file}  < ~{input_cram_bam}
  >>>
  runtime {
    preemptible: preemptible
    memory: "8000 MiB"
    cpu: "1"
    disks: "local-disk " + disk_size_gb + " HDD"
    docker: docker
    maxRetries: 1
  }
  output {
    Array[File] split_outputs = glob("/cromwell_root/splitout/*.cram")
  }
}

# Convert recalibrated cram to bam
task ConvertCramOrBamToUBam {
  input {
    File input_file
    String base_file_name
    Float split_chunk_size
    Int additional_disk
    Int disk_size_gb = ceil((2 * split_chunk_size) + additional_disk)
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/gatk_ultima_md:0.5.7_2.23.8-35"
  }

  command <<<
    set -eo pipefail

    samtools view -H ~{input_file} | grep "^@RG" | \
    awk '{for (i=1;i<=NF;i++){if ($i ~/tp:/) {print substr($i,4)}}}' | head -1 \
    > tp_direction.txt

    a=`cat tp_direction.txt`

    if [ "$a" = "reference" ];
    then
    tp_flag="--ATTRIBUTE_TO_REVERSE tp"
    sort_order_flag="--SO queryname"
    else
    tp_flag=""
    sort_order_flag="--SO unsorted"
    fi

    samtools view -b -F 2048 -h ~{input_file} | \
    java -Xmx11g -jar /usr/gitc/picard.jar RevertSam -I /dev/stdin \
    -O ~{base_file_name}.u.bam \
    --MAX_DISCARD_FRACTION 0.005 \
    --ATTRIBUTE_TO_CLEAR XT \
    --ATTRIBUTE_TO_CLEAR XN \
    --ATTRIBUTE_TO_CLEAR AS \
    --ATTRIBUTE_TO_CLEAR OC \
    --ATTRIBUTE_TO_CLEAR OP \
    $tp_flag \
    --REMOVE_DUPLICATE_INFORMATION \
    --REMOVE_ALIGNMENT_INFORMATION \
    --VALIDATION_STRINGENCY LENIENT \
    $sort_order_flag
  >>>
  runtime {
    preemptible: preemptible
    memory: "13 GB"
    cpu: "2"
    disks: "local-disk " + disk_size_gb + " HDD"
    docker: docker
    maxRetries: 1
  }
  output {
    File unmapped_bam = "~{base_file_name}.u.bam"
  }
}

#TODO: use the WARP version of this task once the MBA code is updated in picard public. Extra args will need to be parameterized
# Read unmapped BAM, convert on-the-fly to FASTQ and stream to BWA MEM for alignment, then stream to MergeBamAlignment
task SamToFastqAndBwaMemAndMba {
  input {
    # This is the .alt file from bwa-kit (https://github.com/lh3/bwa/tree/master/bwakit),
    # listing the reference contigs that are "alternative".
    AlignmentReferences alignment_references
    File input_bam
    String output_bam_basename

    Int disk_size
    Int preemptible = 3
    String docker = "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.6-1599252698"
  }
  command <<<
    # This is done before "set -o pipefail" because "bwa" will have a rc=1 and we don't want to allow rc=1 to succeed
    # because the sed may also fail with that error and that is something we actually want to fail on.
    BWA_VERSION=$(/usr/gitc/bwa 2>&1 | \
    grep -e '^Version' | \
    sed 's/Version: //')

    set -o pipefail
    set -e

    if [ -z ${BWA_VERSION} ]; then
      exit 1;
    fi

    # set the bash variable needed for the command-line
    bash_ref_fasta=~{alignment_references.references.ref_fasta}
    # if ref_alt has data in it,
    if [ -s ~{alignment_references.ref_alt} ]; then
    java -Xms5000m -jar /usr/gitc/picard.jar \
    SamToFastq \
    INPUT=~{input_bam} \
    FASTQ=/dev/stdout \
    INTERLEAVE=true \
    NON_PF=true | \
    /usr/gitc/bwa mem -K 100000000 -p -v 3 -t 16 -Y $bash_ref_fasta \
    /dev/stdin - 2> >(tee ~{output_bam_basename}.bwa.stderr.log >&2) | \
    java -Xms3000m -jar /usr/gitc/picard.jar \
    MergeBamAlignment \
    VALIDATION_STRINGENCY=SILENT \
    EXPECTED_ORIENTATIONS=FR \
    ATTRIBUTES_TO_RETAIN=X0 \
    ATTRIBUTES_TO_RETAIN=tm \
    ATTRIBUTES_TO_RETAIN=tf \
    ATTRIBUTES_TO_RETAIN=RX \
    ATTRIBUTES_TO_REMOVE=NM \
    ATTRIBUTES_TO_REMOVE=MD \
    ATTRIBUTES_TO_REVERSE=ti \
    ATTRIBUTES_TO_REVERSE=tp \
    ALIGNED_BAM=/dev/stdin \
    UNMAPPED_BAM=~{input_bam} \
    OUTPUT=~{output_bam_basename}.bam \
    REFERENCE_SEQUENCE=~{alignment_references.references.ref_fasta} \
    SORT_ORDER="queryname" \
    IS_BISULFITE_SEQUENCE=false \
    CLIP_ADAPTERS=false \
    ALIGNED_READS_ONLY=false \
    MAX_RECORDS_IN_RAM=2000000 \
    ADD_MATE_CIGAR=true \
    MAX_INSERTIONS_OR_DELETIONS=-1 \
    PRIMARY_ALIGNMENT_STRATEGY=MostDistant \
    PROGRAM_RECORD_ID="bwamem" \
    PROGRAM_GROUP_VERSION="${BWA_VERSION}" \
    PROGRAM_GROUP_COMMAND_LINE="/usr/gitc/bwa mem -K 100000000 -p -v 3 -t 16 -Y $bash_ref_fasta" \
    PROGRAM_GROUP_NAME="bwamem" \
    UNMAPPED_READ_STRATEGY=COPY_TO_TAG \
    ALIGNER_PROPER_PAIR_FLAGS=true \
    UNMAP_CONTAMINANT_READS=false \
    ADD_PG_TAG_TO_READS=false

    echo "Piped SAM->FASTQ->BWA->MergeBamAlignment complete."
    echo "Checking that log contains non-zero ALT contigs."

    grep -m1 "read .* ALT contigs" ~{output_bam_basename}.bwa.stderr.log | \
    grep -v "read 0 ALT contigs"

    # else ref_alt is empty or could not be found
    else
    exit 1;
    fi
  >>>
  runtime {
    preemptible: preemptible
    memory: "14 GB"
    cpu: "16"
    disks: "local-disk " + disk_size + " HDD"
    docker: docker
    maxRetries: 1
  }
  output {
    File output_bam = "~{output_bam_basename}.bam"
    File bwa_stderr_log = "~{output_bam_basename}.bwa.stderr.log"
  }
}

task MarkDuplicatesSpark {
  input {
    Array[File] input_bams
    String output_bam_basename
    Int memory_gb
    Int disk_size_gb
    Int cpu
    
    String docker = "gcr.io/terra-project-249020/gatk_ultima_md:0.5.7_2.23.8-35"
  }
  parameter_meta {
    input_bams: {
                  localization_optional: true
                }
  }

  command <<<

    bams_dirname=$(echo "~{sep='\n'input_bams}" | tail -1 | xargs dirname)

    java -Xmx190g -jar /usr/gitc/GATK_ultima.jar MarkDuplicatesSpark \
    --spark-master local[~{cpu - 8}] \
    --input ~{sep=" --input " input_bams} \
    --output ~{output_bam_basename}.bam \
    --create-output-bam-index true \
    --spark-verbosity WARN \
    --verbosity WARNING \
    --FLOW_END_LOCATION_SIGNIFICANT true \
    --FLOW_USE_CLIPPED_LOCATIONS true \
    --ENDS_READ_UNCERTAINTY 1 \
    --FLOW_SKIP_START_HOMOPOLYMERS 0

  >>>
  runtime {
    disks: "local-disk " + disk_size_gb + " LOCAL"
    cpu: cpu
    memory: memory_gb + " GB"
    preemptible: 0
    docker: docker
  }
  output {
    File output_bam = "~{output_bam_basename}.bam"
    File output_bam_index = "~{output_bam_basename}.bam.bai"
  }
}

task FilterByRsq{
  input { 
    File input_bam
    Float rsq_threshold
    Int additional_disk
    Int disk_size_gb = ceil(2 * size(input_bam, "GB") + additional_disk)
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/jukebox_vc:0.6.2_8f51ed"
  }

  String output_filename = basename(input_bam, ".bam") + ".filter.rq.bam"
  command <<< 
    set -eo pipefail

    source ~/.bashrc

    conda activate genomics.py3

    bamtools filter -in ~{input_bam} -out ~{output_filename} -tag "rq":"<=~{rsq_threshold}"
  >>>
  output {
    File output_bam = "~{output_filename}"
  }

  runtime {
    memory: "5000 MiB"
    docker: docker
    preemptible: preemptible
    disks: "local-disk " + disk_size_gb + " HDD"
  }

}

task ExtractSampleNameFlowOrder{
  input{
    File input_bam
    References references
    
    Int preemptible = 3
    String docker = "broadinstitute/gatk:4.1.4.1"
  }
  parameter_meta {
    input_bam: {
     localization_optional: true
    }
  }

  command <<<
    set -e
    set -o pipefail

    gatk  GetSampleName  \
    -I ~{input_bam} \
    -R ~{references.ref_fasta} \
    -O sample_name.txt

    gsutil cat ~{input_bam} | gatk ViewSam -I /dev/stdin \
    --HEADER_ONLY true --ALIGNMENT_STATUS All --PF_STATUS All \
    | grep "^@RG" | awk '{for (i=1;i<=NF;i++){if ($i ~/FO:/) {print substr($i,4,4)}}}' | head -1 \
    > flow_order.txt

    gsutil cat ~{input_bam} | gatk ViewSam -I /dev/stdin \
    --HEADER_ONLY true --ALIGNMENT_STATUS All --PF_STATUS All \
    | grep "^@RG" | awk '{for (i=1;i<=NF;i++){if ($i ~/BC:/) {print substr($i,4)}}}' | head -1 \
    > barcode.txt

    gsutil cat ~{input_bam} | gatk ViewSam -I /dev/stdin \
    --HEADER_ONLY true --ALIGNMENT_STATUS All --PF_STATUS All \
    | grep "^@RG" | awk '{for (i=1;i<=NF;i++){if ($i ~/ID:/) {print substr($i,4)}}}' | head -1 \
    > id.txt

  >>>
  runtime {
    cpu: 1
    memory: "2000 MiB"
    preemptible: preemptible
    docker: docker
  }

  output {
    String sample_name = read_string("sample_name.txt")
    String flow_order = read_string("flow_order.txt")
    String barcode_seq = read_string("barcode.txt")
    String readgroup_id = read_string("id.txt")
    File sample_name_file = "sample_name.txt"
    File flow_order_file = "flow_order.txt"
    File barcode_seq_file = "barcode.txt"
    File readgroup_id_file = "id.txt"
  }
}

#TODO: use WARP version of this task by parameterizing --adjust-MQ
# We used to report contamination/0.75, as we think that HaplotypeCaller works better with the inflated contamination value.
# But for the purpose of reporting contamination this is misleading. We now report the output of VerifyBamId without scaling.
task CheckContamination {
  input {
    File input_bam
    File input_bam_index
    File contamination_sites_ud
    File contamination_sites_bed
    File contamination_sites_mu
    References references
    String output_prefix
    Int disk_size

    Int preemptible = 3
  }
  command <<<
    set -e

    # creates a ~{output_prefix}.selfSM file, a TSV file with 2 rows, 19 columns.
    # First row are the keys (e.g., SEQ_SM, RG, FREEMIX), second row are the associated values
    /usr/gitc/VerifyBamID \
    --Verbose \
    --NumPC 4 \
    --Output ~{output_prefix} \
    --BamFile ~{input_bam} \
    --Reference ~{references.ref_fasta} \
    --UDPath ~{contamination_sites_ud} \
    --MeanPath ~{contamination_sites_mu} \
    --BedPath ~{contamination_sites_bed} \
    --adjust-MQ 0 \
    1>/dev/null

    # used to read from the selfSM file and calculate contamination, which gets printed out
    python3 <<CODE
    import csv
    import sys
    with open('~{output_prefix}.selfSM') as selfSM:
      reader = csv.DictReader(selfSM, delimiter='\t')
      i = 0
      for row in reader:
        if float(row["FREELK0"])==0 and float(row["FREELK1"])==0:
          # a zero value for the likelihoods implies no data. This usually indicates a problem rather than a real event.
          # if the bam isn't really empty, this is probably due to the use of a incompatible reference build between
          # vcf and bam.
          sys.stderr.write("Found zero likelihoods. Bam is either very-very shallow, or aligned to the wrong reference (relative to the vcf).")
          sys.exit(1)
        with open('contamination.txt', 'w') as f:
          print(float(row["FREEMIX"]), file=f)

        with open('coverage.txt', 'w') as f2:
          print(float(row["AVG_DP"]), file = f2)

        i = i + 1
        # there should be exactly one row, and if this isn't the case the format of the output is unexpectedly different
        # and the results are not reliable.
        if i != 1:
          sys.stderr.write("Found %d rows in .selfSM file. Was expecting exactly 1. This is an error"%(i))
          sys.exit(2)
    CODE
  >>>

  runtime {
    preemptible: preemptible
    memory: "2 GB"
    disks: "local-disk " + disk_size + " HDD"
    docker: "us.gcr.io/broad-gotc-prod/verify-bam-id:f6cb51761861e57c43879aa262df5cf8e670cf7c-1606775309"
    maxRetries: 1
  }

  output {
    File selfSM = "~{output_prefix}.selfSM"
    Float contamination = read_float("contamination.txt")
    Float contamination_coverage = read_float("coverage.txt")
  }
}

#TODO: use warp version of this task once HC has been merged into GATK public
# Call variants on a single sample with HaplotypeCaller to produce a VCF
task HaplotypeCaller {
  input {
    References references
    Array[File] input_bam_list
    File interval_list
    String vcf_basename
    Boolean make_bamout
    Boolean native_sw = false
    String? contamination_extra_args 
    
    Int disk_size
    Int memory_gb
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/gatk_ultima:0.6.1"
  }

  parameter_meta {
    input_bam_list: {
      localization_optional: true
    }
  }
  
  String bam_writer_type = if defined(contamination_extra_args) then "NO_HAPLOTYPES" else "CALLED_HAPLOTYPES_NO_READS"
  String output_suffix = ".g.vcf.gz" 
  String output_filename = vcf_basename + output_suffix

  command {
    touch ~{output_filename}.tbi
    touch ~{output_filename}
    touch realigned.bam
    touch realigned.bai

    java -XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10 -Xms~{memory_gb-2}g \
      -jar /usr/gitc/GATK_ultima.jar \
      HaplotypeCaller \
      -R ~{references.ref_fasta} \
      -O ~{output_filename} \
      -I ~{sep = ' -I ' input_bam_list} \
      --intervals ~{interval_list} \
      --smith-waterman ~{if (native_sw) then "JAVA" else "FASTEST_AVAILABLE"} \
      -ERC GVCF \
      ~{true="--bamout realigned.bam" false="" make_bamout} \
      -mbq 0 \
      --flow-filter-alleles \
      --flow-filter-alleles-sor-threshold 3 \
      --flow-assembly-collapse-hmer-size 12 \
      --flow-matrix-mods 10,12,11,12 \
      --bam-writer-type ~{bam_writer_type} \
      --apply-frd --minimum-mapping-quality 1 \
      --mapping-quality-threshold-for-genotyping 1 \
      --override-fragment-softclip-check \
      --flow-likelihood-parallel-threads 2 \
      --flow-likelihood-optimized-comp \
      --adaptive-pruning \
      --pruning-lod-threshold 3.0 \
      --enable-dynamic-read-disqualification-for-genotyping \
      --dynamic-read-disqualification-threshold 10 \
      -G StandardAnnotation \
      -G StandardHCAnnotation \
      -G AS_StandardAnnotation\
      -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
      --likelihood-calculation-engine FlowBased \
      -A AssemblyComplexity \
      --assembly-complexity-reference-mode \
      ~{contamination_extra_args}
  }

  runtime {
    preemptible: preemptible
    memory: "~{memory_gb} GB"
    cpu: "2"
    disks: "local-disk " + disk_size + " HDD"
    docker: docker
    continueOnReturnCode: [0,134,139]
    bootDiskSizeGb: 15
    maxRetries: 1
#    continueOnReturnCode: true
  }
  output {
    File output_vcf = "~{output_filename}"
    File output_vcf_index = "~{output_filename}.tbi"
    File bamout = "realigned.bam"
    File bamout_index = "realigned.bai"
  }
}
# Combine multiple VCFs or GVCFs from scattered HaplotypeCaller runs
task MergeBams {
  input {
    Array[File] input_bams
    String output_bam_name
    
    Int disk_size_gb = ceil(2 * size(input_bams,"GB") + 20)
    
    Int preemptible = 3
    String docker = "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.6-1599252698"
  }
  # Using MergeVcfs instead of GatherVcfs so we can create indices
  # See https://github.com/broadinstitute/picard/issues/789 for relevant GatherVcfs ticket
  command {

    java -Xms9000m -jar /usr/gitc/picard.jar \
    MergeSamFiles \
    INPUT=~{sep=' INPUT=' input_bams} \
    OUTPUT=~{output_bam_name}

    samtools index ~{output_bam_name}
  }
  runtime {
    preemptible: preemptible
    memory: "10 GB"
    disks: "local-disk " + ceil(disk_size_gb) + " HDD"
    docker: docker 
    maxRetries: 1
  }
  output {
    File output_bam = "~{output_bam_name}"
    File output_bam_index = "~{output_bam_name}.bai"
  }
}

task ConvertGVCFtoVCF {
  input {
    File input_gvcf
    File input_gvcf_index
    String output_vcf_name
    References references
    Int disk_size_gb

    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/gatk_ultima:0.6.1"
  }
  command {
    java -XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10 -Xms10000m \
    -jar /usr/gitc/GATK_ultima.jar GenotypeGVCFs \
    -R ~{references.ref_fasta} \
    -V ~{input_gvcf} \
    -O ~{output_vcf_name} \
    -A  StrandBiasBySample \
    -A AS_HmerLength
  }
  runtime {
    preemptible: preemptible
    memory: "12 GB"
    cpu: "1"
    disks: "local-disk " + disk_size_gb + " HDD"
    docker: docker
    maxRetries: 1
  }
  output {
    File output_vcf = "~{output_vcf_name}"
    File output_vcf_index = "~{output_vcf_name}.tbi"
  }
}

task FilterVCF {
  input {
    File input_vcf
    File input_model
    File runs_file
    References references
    String model_name
    Boolean filter_cg_insertions
    File? blacklist_file
    String final_vcf_base_name
    String flow_order
    Array[File] annotation_intervals
    Int disk_size_gb
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/jukebox_vc:0.6.2_8f51ed"
  }
  String used_flow_order = (if flow_order=="" then "TACG" else flow_order)
  command <<<

    source ~/.bashrc
    conda activate genomics.py3

    cd /VariantCalling/src/python/pipelines
    python filter_variants_pipeline.py --input_file ~{input_vcf} \
    --model_file ~{input_model} \
    --model_name ~{model_name} \
    --runs_file ~{runs_file} \
    --reference_file ~{references.ref_fasta} \
    --hpol_filter_length_dist 12 10 \
    --flow_order ~{used_flow_order} \
    ~{true="--blacklist_cg_insertions" false="" filter_cg_insertions} \
    ~{"--blacklist " + blacklist_file} \
    --annotate_intervals ~{sep=" --annotate_intervals " annotation_intervals} \
    --output_file /cromwell_root/~{final_vcf_base_name}.filtered.vcf.gz
  >>>
  runtime {
    preemptible: preemptible 
    memory: "64 GB"
    disks: "local-disk " + disk_size_gb + " HDD"
    docker: docker
  }
  output {
    File output_vcf_filtered = "/cromwell_root/~{final_vcf_base_name}.filtered.vcf.gz"
    File output_vcf_filtered_index = "/cromwell_root/~{final_vcf_base_name}.filtered.vcf.gz.tbi"
  }
}

task TrainModel {
  input {
    File input_file
    File? input_file_index
    File? input_interval
    File? ref_fasta
    File? ref_index
    File? runs_file
    File? blacklist_file
    String input_vcf_name
    Array[File] annotation_intervals
    String apply_model
    Int additional_disk
    Int disk_size_gb = ceil(size(input_file, "GB") +
                        size(ref_fasta, "GB") +
                        size(annotation_intervals, "GB") +
                        size(blacklist_file, "GB") + additional_disk)
    
    Int? exome_weight
    String? exome_weight_annotation
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/jukebox_vc:0.6.2_8f51ed"
  }
  command <<<

    source ~/.bashrc
    conda activate genomics.py3
    cd /VariantCalling/src/python/pipelines
    python train_models_pipeline.py \
    --input_file ~{input_file} \
    ~{"--input_interval " + input_interval} \
    ~{"--reference " + ref_fasta} \
    ~{"--runs_intervals " + runs_file} \
    --evaluate_concordance \
    --apply_model ~{apply_model} \
    ~{"--blacklist " + blacklist_file} \
    ~{"--exome_weight " + exome_weight} \
    ~{"--exome_weight_annotation " + exome_weight_annotation} \
    --annotate_intervals ~{sep=" --annotate_intervals " annotation_intervals} \
    --output_file_prefix /cromwell_root/~{input_vcf_name}.model
  >>>
  runtime {
    preemptible: preemptible
    memory: "64 GB"
    disks: "local-disk " + disk_size_gb + " HDD"
    docker: docker
  }
  output {
    File model_h5 = "/cromwell_root/~{input_vcf_name}.model.h5"
    File model_pkl = "/cromwell_root/~{input_vcf_name}.model.pkl"
  }
}

task CollectDuplicateMetrics {
  input {
    File input_bam
    String metrics_filename
    Int disk_size_gb
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/gatk_ultima_md:0.5.7_2.23.8-35"
  }


  command <<<

    samtools view -h ~{input_bam} | \
    java -Xms8000m -jar /usr/gitc/picard.jar CollectDuplicateMetrics \
    -I /dev/stdin \
    -M ~{metrics_filename}

  >>>

  runtime {
    disks: "local-disk " + disk_size_gb + " HDD"
    cpu: 1
    memory: "4000 MiB"
    preemptible: preemptible
    docker: docker
  }

  output {
    File duplicate_metrics = "~{metrics_filename}"
  }
}

#TODO: use WARP version of this task after parameterizing USE_FAST_ALGORITHM, COUNT_UNPAIRED, and COVERAGE_CAP
task CollectWgsMetrics {
  input {
    File input_bam
    File input_bam_index
    String metrics_filename
    File wgs_coverage_interval_list
    References references
    Int? read_length
    Int disk_size
    
    Int preemptible = 3
    String docker = "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.6-1599252698"
  }

  command {

    java -Xms8000m -jar /usr/gitc/picard.jar \
    CollectWgsMetrics \
    INPUT=~{input_bam} \
    VALIDATION_STRINGENCY=SILENT \
    REFERENCE_SEQUENCE=~{references.ref_fasta} \
    INCLUDE_BQ_HISTOGRAM=true \
    INTERVALS=~{wgs_coverage_interval_list} \
    OUTPUT=~{metrics_filename} \
    USE_FAST_ALGORITHM=false \
    COUNT_UNPAIRED=true \
    COVERAGE_CAP=12500 \
    READ_LENGTH=~{default=250 read_length}
  }
  runtime {
    preemptible: preemptible
    memory: "10 GB"
    disks: "local-disk " + disk_size + " HDD"
    docker: docker
  }
  output {
    File metrics = "~{metrics_filename}"
  }
}

#TODO: use WARP version of this task after parameterizing USE_FAST_ALGORITHM and COUNT_UNPAIRED
# Collect raw WGS metrics (commonly used QC thresholds)
task CollectRawWgsMetrics {
  input {
    File input_bam
    File input_bam_index
    String metrics_filename
    File wgs_coverage_interval_list
    References references
    Int? read_length
    Int disk_size
    Int memory_size
    
    Int preemptible = 3
    String docker = "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.6-1599252698"
  }

  command {

    java -Xms8000m -jar /usr/gitc/picard.jar \
    CollectRawWgsMetrics \
    INPUT=~{input_bam} \
    VALIDATION_STRINGENCY=SILENT \
    REFERENCE_SEQUENCE=~{references.ref_fasta} \
    INCLUDE_BQ_HISTOGRAM=true \
    INTERVALS=~{wgs_coverage_interval_list} \
    OUTPUT=~{metrics_filename} \
    COUNT_UNPAIRED=true \
    USE_FAST_ALGORITHM=false \
    READ_LENGTH=~{default=250 read_length}
  }
  runtime {
    preemptible: preemptible
    memory: memory_size + " GB"
    disks: "local-disk " + disk_size + " HDD"
    docker: docker
  }
  output {
    File metrics = "~{metrics_filename}"
  }
}

#TODO: Use WARP version of this task once extra args and programs are parameterized
# Collect quality metrics from the aggregated bam
task CollectAggregationMetrics {
  input {
    File input_bam
    File input_bam_index
    String output_bam_prefix
    References references
    Int disk_size
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/gatk_ultima_md:0.5.7_2.23.8-35"
  }


  command {

    java -Xms5000m -jar /usr/gitc/picard.jar \
    CollectMultipleMetrics \
    INPUT=~{input_bam} \
    REFERENCE_SEQUENCE=~{references.ref_fasta} \
    OUTPUT=~{output_bam_prefix} \
    ASSUME_SORTED=true \
    PROGRAM="null" \
    PROGRAM="CollectAlignmentSummaryMetrics" \
    EXTRA_ARGUMENT="CollectAlignmentSummaryMetrics::ADAPTER_SEQUENCE=CCATAGAGAG" \
    PROGRAM="CollectGcBiasMetrics" \
    PROGRAM="QualityScoreDistribution" \
    METRIC_ACCUMULATION_LEVEL="SAMPLE" \
    METRIC_ACCUMULATION_LEVEL="LIBRARY"
  }
  runtime {
    memory: "7 GB"
    disks: "local-disk " + disk_size + " HDD"
    preemptible: preemptible
    docker: docker
  }
  output {
    File alignment_summary_metrics = "~{output_bam_prefix}.alignment_summary_metrics"
    File? alignment_summary_pdf = "~{output_bam_prefix}.read_length_histogram.pdf"
    File gc_bias_detail_metrics = "~{output_bam_prefix}.gc_bias.detail_metrics"
    File gc_bias_pdf = "~{output_bam_prefix}.gc_bias.pdf"
    File gc_bias_summary_metrics = "~{output_bam_prefix}.gc_bias.summary_metrics"
    File quality_distribution_pdf = "~{output_bam_prefix}.quality_distribution.pdf"
    File quality_distribution_metrics = "~{output_bam_prefix}.quality_distribution_metrics"
  }
}

task AnnotateVCF {
  input {
    File input_vcf
    File input_vcf_index
    References references
    File reference_dbsnp
    File reference_dbsnp_index
    String flow_order
    String final_vcf_base_name
    Int additional_disk
    Int disk_size_gb = ceil(2 * size(input_vcf, "GB") + size(references.ref_fasta, "GB") + size(reference_dbsnp, "GB") + additional_disk)
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/gatk_ultima:0.6.1"
  }
  command <<<

    java -XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10 -Xms10000m \
    -jar /usr/gitc/GATK_ultima.jar VariantAnnotator \
    -R ~{references.ref_fasta} \
    -V ~{input_vcf} \
    -O ~{final_vcf_base_name}.annotated.vcf.gz \
    --dbsnp ~{reference_dbsnp} \
    -A StrandOddsRatio \
    -G StandardFlowBasedAnnotation \
    --flow-order-for-annotations ~{flow_order}

  >>>
  runtime {
    preemptible: preemptible
    memory: "15 GB"
    disks: "local-disk " + disk_size_gb + " HDD"
    docker: docker
    maxRetries: 1
  }
  output {
    File output_vcf_annotated = "~{final_vcf_base_name}.annotated.vcf.gz"
    File output_vcf_annotated_index = "~{final_vcf_base_name}.annotated.vcf.gz.tbi"
  }
}

task AddIntervalAnnotationsToVCF {
  input {
    File input_vcf
    File input_vcf_index
    String final_vcf_base_name
    Array[File] annotation_intervals
    Int disk_size_gb = ceil(2 * size(input_vcf, "GB") + 1)
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/jukebox_vc:0.6.2_8f51ed"
  }

  command <<<

    source ~/.bashrc
    conda activate genomics.py3

    export header_file=header.hdr
    export id_file=header.ID
    for f in ~{sep=" " annotation_intervals}
    do
        echo Annotating ~{input_vcf} with $(basename $f)
        head -1 $f > $header_file
        cat $header_file | sed 's/[<>]/ /' | sed 's/[=]/ /' | sed 's/[=]/ /' | sed 's/[,]/ /' | awk '{print $3}' > $id_file
        mv ~{input_vcf} ~{input_vcf}.tmp
        bcftools annotate -a $f \
            -c CHROM,FROM,TO,"$(<$id_file)" \
            -h $header_file ~{input_vcf}.tmp \
            | bcftools view - -Oz -o ~{input_vcf}
    done
    mv ~{input_vcf} ~{final_vcf_base_name}.intervals_annotated.vcf.gz
    bcftools index -f -t ~{final_vcf_base_name}.intervals_annotated.vcf.gz

    >>>
  runtime {
    preemptible: preemptible
    memory: "15 GB"
    disks: "local-disk " + disk_size_gb + " HDD"
    docker: docker
  }
  output {
    File output_vcf = "/cromwell_root/~{final_vcf_base_name}.intervals_annotated.vcf.gz"
    File output_vcf_index = "/cromwell_root/~{final_vcf_base_name}.intervals_annotated.vcf.gz.tbi"
  }
}

task AnnotateVCF_AF {
  input {
    File input_vcf
    File input_vcf_index
    String final_vcf_base_name
    File af_only_gnomad
    File af_only_gnomad_index
    Int additional_disk
    Int disk_size_gb = ceil(3 * size(input_vcf, "GB") + size(af_only_gnomad, "GB") + additional_disk)
    
    Int preemptible = 3
    String docker = "gcr.io/terra-project-249020/jukebox_vc:0.6.2_8f51ed"
  }
  command <<<

    source ~/.bashrc
    conda activate genomics.py3

    echo '[[annotation]]
    file="~{af_only_gnomad}"
    fields = ["AF"]
    ops=["self"]
    names=["GNOMAD_AF"]' > conf.toml

    vcfanno conf.toml ~{input_vcf} > ~{final_vcf_base_name}.annotated.AF.vcf
    bgzip -c ~{final_vcf_base_name}.annotated.AF.vcf > ~{final_vcf_base_name}.annotated.AF.vcf.gz

    # Ugly patch to recover QUAL values that vcfanno sometimes loses
    # QUAL values are hard pasted from the original VCF
    grep "^#" ~{final_vcf_base_name}.annotated.AF.vcf > header
    bcftools view ~{input_vcf} | grep -v "^#" | awk '{print $6}' > quals.txt
    cat ~{final_vcf_base_name}.annotated.AF.vcf | grep -v '^#' | cut -f1-5 > left_part
    cat ~{final_vcf_base_name}.annotated.AF.vcf | grep -v '^#' | cut -f7- > right_part
    paste left_part quals.txt right_part > pasted
    cat header pasted | bcftools view -Oz -o ~{final_vcf_base_name}.annotated.AF.vcf.gz -

    bcftools index -t ~{final_vcf_base_name}.annotated.AF.vcf.gz
  >>>
  runtime {
    preemptible: preemptible
    memory: "10 GB"
    disks: "local-disk " + disk_size_gb + " HDD"
    docker: docker
    maxRetries: 1
  }
  output {
    File output_vcf_annotated = "~{final_vcf_base_name}.annotated.AF.vcf.gz"
    File output_vcf_annotated_index = "~{final_vcf_base_name}.annotated.AF.vcf.gz.tbi"
  }
}

task MoveAnnotationsToGvcf {
	input {
		File filtered_vcf
		File filtered_vcf_index
		File gvcf
		File gvcf_index
		String annotation = "TREE_SCORE"

    String docker = "us.gcr.io/broad-dsde-methods/imputation_bcftools_vcftools_docker:v1.0.0"
	}
	String filename = basename(gvcf, ".g.vcf.gz")
	Int disk_size_gb = ceil(size(filtered_vcf, "GB") + size(gvcf, "GB") * 2 + 30)

	command {
		set -e

		bcftools annotate -a ~{filtered_vcf} -c TREE_SCORE ~{gvcf} -o ~{filename}.annotated.g.vcf.gz -O z
		tabix -p vcf ~{filename}.annotated.g.vcf.gz
	}
	output {
		File output_gvcf = "~{filename}.annotated.g.vcf.gz"
		File output_gvcf_index = "~{filename}.annotated.g.vcf.gz.tbi"
	}

	runtime {
		docker: docker
		memory: "7 GiB"
    disks: "local-disk " + disk_size_gb + " HDD"
	}
}