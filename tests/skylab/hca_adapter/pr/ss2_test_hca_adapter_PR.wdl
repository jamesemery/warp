version 1.0

import "../../../../projects/smartseq2/CreateSs2AdapterMetadata.wdl" as test_target_adapter
import "../../../../tests/skylab/hca_adapter/pr/ValidateHcaAdapter.wdl" as checker_adapter

# this workflow will be run by the jenkins script that gets executed by PRs.
workflow TestSs2HcaAdapter {
  input {
    # hca ss2 inputs 
    Array[File] output_bams
    Array[File] output_bais
    File output_loom
    Array[String] input_ids
    Array[String] fastq_1_uuids
    Array[String] fastq_2_uuids
    Array[String]? fastq_i1_uuids

    Array[String] all_libraries
    Array[String] all_organs
    Array[String] all_species
    Array[String] all_project_ids
    Array[String] all_project_names

    String cromwell_url = "https://firecloud-orchestration.dsde-dev.broadinstitute.org"
    String staging_area = "gs://fc-b4648544-9363-4a04-aa37-e7031c078a67/"
    String version_timestamp
    String pipeline_type = "SS2"

    # ss2 truth inputs
    File ss2_metadata_analysis_file_intermediate_bam_json
    File ss2_metadata_analysis_file_intermediate_bai_json
    File ss2_metadata_analysis_file_project_loom_json
    File ss2_descriptors_analysis_file_intermediate_reference_json
    File ss2_descriptors_analysis_file_intermediate_bam_json
    File ss2_descriptors_analysis_file_intermediate_bai_json
    File ss2_descriptors_analysis_file_project_loom_json
    File ss2_metadata_analysis_process_file_intermediate_json
    File ss2_metadata_analysis_process_project_loom_json
    File ss2_metadata_analysis_protocol_file_intermediate_json
    File ss2_metadata_analysis_protocol_file_project_json
    File ss2_metadata_reference_file_json
    File ss2_links_json
  }

  call test_target_adapter.CreateSs2AdapterMetadata as target_adapter {
    input:
      output_bams = output_bams,
      output_bais = output_bais,
      output_loom = output_loom,
      input_ids = input_ids,
      fastq_1_uuids = fastq_1_uuids,
      fastq_2_uuids = fastq_2_uuids,
      fastq_i1_uuids = fastq_i1_uuids,
      all_libraries = all_libraries,
      all_organs = all_organs,
      all_species = all_species,
      all_project_ids = all_project_ids,
      all_project_names = all_project_names,
      cromwell_url = cromwell_url,
      staging_area = staging_area,
      version_timestamp = version_timestamp,
      pipeline_type = pipeline_type
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_descriptors_bam {
    input:
      test_json = target_adapter.output_analysis_file_descriptor_objects[0],
      truth_json = ss2_descriptors_analysis_file_intermediate_bam_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_descriptors_bai {
    input:
      test_json = target_adapter.output_analysis_file_descriptor_objects[1],
      truth_json = ss2_descriptors_analysis_file_intermediate_bai_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_descriptors_loom {
    input:
      test_json = target_adapter.output_analysis_file_descriptor_objects[2],
      truth_json = ss2_descriptors_analysis_file_project_loom_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_metadata_analysis_files_bam {
    input:
      test_json = target_adapter.output_analysis_file_metadata_objects[0],
      truth_json = ss2_metadata_analysis_file_intermediate_bam_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_metadata_analysis_files_bai {
    input:
      test_json = target_adapter.output_analysis_file_metadata_objects[1],
      truth_json = ss2_metadata_analysis_file_intermediate_bai_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_metadata_analysis_files_loom {
    input:
      test_json = target_adapter.output_analysis_file_metadata_objects[2],
      truth_json = ss2_metadata_analysis_file_project_loom_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_metadata_analysis_process {
    input:
      test_json = target_adapter.output_analysis_process_objects[0],
      truth_json = ss2_metadata_analysis_process_file_intermediate_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_ss2_project_metadata_analysis_process {
    input:
      test_json = target_adapter.output_analysis_process_objects[1],
      truth_json = ss2_metadata_analysis_process_project_loom_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_metadata_analysis_protocol {
    input:
      test_json = target_adapter.output_analysis_protocol_objects[0],
      truth_json = ss2_metadata_analysis_protocol_file_intermediate_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_ss2_project_metadata_analysis_protocol {
    input:
      test_json = target_adapter.output_analysis_protocol_objects[1],
      truth_json = ss2_metadata_analysis_protocol_file_project_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_links {
    input:
      test_json = target_adapter.output_links_objects[0],
      truth_json = ss2_links_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_descriptors_reference {
    input:
      test_json = target_adapter.output_reference_file_descriptor_objects[0],
      truth_json = ss2_descriptors_analysis_file_intermediate_reference_json
  }

  call checker_adapter.CompareAdapterFiles as checker_adapter_metadata_reference_file {
    input:
      test_json = target_adapter.output_reference_metadata_objects[0],
      truth_json = ss2_metadata_reference_file_json
  }

  output {
    Array[File] analysis_file = target_adapter.output_analysis_file_metadata_objects
    Array[File] analysis_process = target_adapter.output_analysis_process_objects
    Array[File] analysis_protocol = target_adapter.output_analysis_protocol_objects
    Array[File] analysis_output = target_adapter.output_data_objects
    File reference_genome = target_adapter.output_data_objects[0]
    Array[File] reference_genome_reference_file = target_adapter.output_reference_metadata_objects
    Array[File] reference_genome_descriptor = target_adapter.output_reference_file_descriptor_objects
    Array[File] analysis_file_descriptor = target_adapter.output_analysis_file_descriptor_objects
    Array[File] links = target_adapter.output_links_objects
  }
}