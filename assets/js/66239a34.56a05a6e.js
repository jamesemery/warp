"use strict";(self.webpackChunkwebsite_2=self.webpackChunkwebsite_2||[]).push([[8420],{3905:function(e,t,a){a.d(t,{Zo:function(){return c},kt:function(){return u}});var n=a(7294);function r(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function i(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function o(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?i(Object(a),!0).forEach((function(t){r(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):i(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function l(e,t){if(null==e)return{};var a,n,r=function(e,t){if(null==e)return{};var a,n,r={},i=Object.keys(e);for(n=0;n<i.length;n++)a=i[n],t.indexOf(a)>=0||(r[a]=e[a]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(n=0;n<i.length;n++)a=i[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(r[a]=e[a])}return r}var s=n.createContext({}),p=function(e){var t=n.useContext(s),a=t;return e&&(a="function"==typeof e?e(t):o(o({},t),e)),a},c=function(e){var t=p(e.components);return n.createElement(s.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},m=n.forwardRef((function(e,t){var a=e.components,r=e.mdxType,i=e.originalType,s=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),m=p(a),u=r,h=m["".concat(s,".").concat(u)]||m[u]||d[u]||i;return a?n.createElement(h,o(o({ref:t},c),{},{components:a})):n.createElement(h,o({ref:t},c))}));function u(e,t){var a=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=a.length,o=new Array(i);o[0]=m;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:r,o[1]=l;for(var p=2;p<i;p++)o[p]=a[p];return n.createElement.apply(null,o)}return n.createElement.apply(null,a)}m.displayName="MDXCreateElement"},9056:function(e,t,a){a.r(t),a.d(t,{frontMatter:function(){return o},contentTitle:function(){return l},metadata:function(){return s},toc:function(){return p},default:function(){return d}});var n=a(7462),r=a(3366),i=(a(7294),a(3905)),o={},l="Consortia Data Processing",s={unversionedId:"Pipelines/Optimus_Pipeline/consortia-processing",id:"Pipelines/Optimus_Pipeline/consortia-processing",isDocsHomePage:!1,title:"Consortia Data Processing",description:"Human Cell Atlas Data Coordination Platform Matrix Processing",source:"@site/docs/Pipelines/Optimus_Pipeline/consortia-processing.md",sourceDirName:"Pipelines/Optimus_Pipeline",slug:"/Pipelines/Optimus_Pipeline/consortia-processing",permalink:"/warp/docs/Pipelines/Optimus_Pipeline/consortia-processing",editUrl:"https://github.com/broadinstitute/warp/edit/develop/website/docs/Pipelines/Optimus_Pipeline/consortia-processing.md",tags:[],version:"current",lastUpdatedBy:"dependabot[bot]",lastUpdatedAt:1651704288,formattedLastUpdatedAt:"5/4/2022",frontMatter:{},sidebar:"docsSidebar",previous:{title:"Optimus Count Matrix Overview",permalink:"/warp/docs/Pipelines/Optimus_Pipeline/Loom_schema"},next:{title:"RNA with UMIs Overview",permalink:"/warp/docs/Pipelines/RNA_with_UMIs_Pipeline/README"}},p=[{value:"Human Cell Atlas Data Coordination Platform Matrix Processing",id:"human-cell-atlas-data-coordination-platform-matrix-processing",children:[{value:"DCP project matrix post-processing",id:"dcp-project-matrix-post-processing",children:[]},{value:"Post-processing steps",id:"post-processing-steps",children:[]},{value:"Making project matrix cell barcodes unique",id:"making-project-matrix-cell-barcodes-unique",children:[]},{value:"Mapping DCP project matrix data to the metadata manifest",id:"mapping-dcp-project-matrix-data-to-the-metadata-manifest",children:[]},{value:"Mapping DCP project matrix data to the contributor matrices",id:"mapping-dcp-project-matrix-data-to-the-contributor-matrices",children:[]}]},{value:"Brain Initiative Cell Census Network Processing",id:"brain-initiative-cell-census-network-processing",children:[{value:"Optimus reference files for BICCN data processing",id:"optimus-reference-files-for-biccn-data-processing",children:[]}]}],c={toc:p};function d(e){var t=e.components,o=(0,r.Z)(e,["components"]);return(0,i.kt)("wrapper",(0,n.Z)({},c,o,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"consortia-data-processing"},"Consortia Data Processing"),(0,i.kt)("h2",{id:"human-cell-atlas-data-coordination-platform-matrix-processing"},"Human Cell Atlas Data Coordination Platform Matrix Processing"),(0,i.kt)("p",null,"Optimus supports data processing for the Human Cell Atlas (HCA) Data Coordination Platform (DCP). Learn more about the DCP at the ",(0,i.kt)("a",{parentName:"p",href:"https://data.humancellatlas.org/"},"HCA Data Portal"),")."),(0,i.kt)("p",null,"All DCP Projects processed with Optimus have matrices containing the standard metrics and counts detailed in the ",(0,i.kt)("a",{parentName:"p",href:"/warp/docs/Pipelines/Optimus_Pipeline/Loom_schema"},"Optimus Count Matrix Overview"),", but also have additional post-processing to combine project data and incorporate DCP-curated metadata."),(0,i.kt)("div",{className:"admonition admonition-warning alert alert--danger"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M5.05.31c.81 2.17.41 3.38-.52 4.31C3.55 5.67 1.98 6.45.9 7.98c-1.45 2.05-1.7 6.53 3.53 7.7-2.2-1.16-2.67-4.52-.3-6.61-.61 2.03.53 3.33 1.94 2.86 1.39-.47 2.3.53 2.27 1.67-.02.78-.31 1.44-1.13 1.81 3.42-.59 4.78-3.42 4.78-5.56 0-2.84-2.53-3.22-1.25-5.61-1.52.13-2.03 1.13-1.89 2.75.09 1.08-1.02 1.8-1.86 1.33-.67-.41-.66-1.19-.06-1.78C8.18 5.31 8.68 2.45 5.05.32L5.03.3l.02.01z"}))),"warning")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"This section details matrices produced for the Human Cell Atlas (HCA) ",(0,i.kt)("a",{parentName:"p",href:"https://data.humancellatlas.org/"},"Data Coordination Platform (DCP)2.0"),", which includes matrices processed with Optimus v4.1.7 and later. The DCP is currently reprocessing data generated with earlier Optimus versions and will deprecate previous matrices once reprocessing is complete."))),(0,i.kt)("h3",{id:"dcp-project-matrix-post-processing"},"DCP project matrix post-processing"),(0,i.kt)("p",null,"DCP project matrices combine project data from individual library preparations that contain the same species, developmental age, and sequencing technology. "),(0,i.kt)("p",null,"Key differences between the standard Optimus Loom matrix described in the ",(0,i.kt)("a",{parentName:"p",href:"/warp/docs/Pipelines/Optimus_Pipeline/Loom_schema"},"Optimus Count Matrix Overview")," and the DCP Project matrix include: "),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Combined project data in the DCP matrix"),(0,i.kt)("li",{parentName:"ul"},"Filtering: to reduce file size, DCP project matrices are in sparse format and minimally filtered so that ",(0,i.kt)("strong",{parentName:"li"},"only cells with 100 molecules or more")," are retained."),(0,i.kt)("li",{parentName:"ul"},"DCP-curated metadata in the Loom global attributes: see table below."),(0,i.kt)("li",{parentName:"ul"},"input_ids in the global attributes: all input_ids representing each library preparation in the matrix are added as a comma-separated string.")),(0,i.kt)("p",null,"DCP project matrices contain DCP-curated metadata in the Loom global attributes which may be useful when exploring the data and linking it back to the Project metadata. "),(0,i.kt)("p",null,"Read more about each metadata field in the DCP ",(0,i.kt)("a",{parentName:"p",href:"https://data.humancellatlas.org/metadata"},"Metadata Dictionary"),"."),(0,i.kt)("table",null,(0,i.kt)("thead",{parentName:"table"},(0,i.kt)("tr",{parentName:"thead"},(0,i.kt)("th",{parentName:"tr",align:null},"Metadata Attribute Name in Count Matrix"),(0,i.kt)("th",{parentName:"tr",align:null},"Metadata Description"))),(0,i.kt)("tbody",{parentName:"table"},(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"donor_organism.genus_species")),(0,i.kt)("td",{parentName:"tr",align:null},"species information; human or mouse")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"library_preparation_protocol.library_construction_approach")),(0,i.kt)("td",{parentName:"tr",align:null},"technology used for library preparation, i.e 10x or SS2")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"specimen_from_organism.organ")),(0,i.kt)("td",{parentName:"tr",align:null},"organ")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"project.project_core.project_name")),(0,i.kt)("td",{parentName:"tr",align:null},"project name")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"project.provenance.document_id")),(0,i.kt)("td",{parentName:"tr",align:null},"project id")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"input_id")),(0,i.kt)("td",{parentName:"tr",align:null},"metadata values for  ",(0,i.kt)("inlineCode",{parentName:"td"},"sequencing_process.provenance.document_id"),"; unique ID to demarcate the library prep")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"input_name")),(0,i.kt)("td",{parentName:"tr",align:null},"metadata values for ",(0,i.kt)("inlineCode",{parentName:"td"},"sequencing_input.biomaterial_core.biomaterial_id"),"; unique ID for the biomaterial")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"input_id_metadata_field")),(0,i.kt)("td",{parentName:"tr",align:null},"string describing the DCP-curated metadata field used for input_id: ",(0,i.kt)("inlineCode",{parentName:"td"},"sequencing_process.provenance.document_id"))),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"input_name_metadata_field")),(0,i.kt)("td",{parentName:"tr",align:null},"string describing the DCP-curated metadata field used for input_name: ",(0,i.kt)("inlineCode",{parentName:"td"},"sequencing_input.biomaterial_core.biomaterial_id"))))),(0,i.kt)("h3",{id:"post-processing-steps"},"Post-processing steps"),(0,i.kt)("p",null,"To create the DCP project matrices, Loom outputs from individual 10x library preparations, each with their own ",(0,i.kt)("inlineCode",{parentName:"p"},"input_id"),", are combined into a single Loom file."),(0,i.kt)("p",null,(0,i.kt)("img",{src:a(6954).Z})),(0,i.kt)("h3",{id:"making-project-matrix-cell-barcodes-unique"},"Making project matrix cell barcodes unique"),(0,i.kt)("p",null,"Since DCP project matrices often contain combined data from multiple library preparations, the project matrix cell barcodes are modified so that they are unique for each library preparation, allowing the barcodes to be used by downstream community tools like Cumulus and Seurat."),(0,i.kt)("p",null,"In the standard Optimus matrix, cell barcodes are listed in both the Loom columns ",(0,i.kt)("inlineCode",{parentName:"p"},"CellID")," and the ",(0,i.kt)("inlineCode",{parentName:"p"},"cell_names"),"."),(0,i.kt)("p",null,"For DCP projects, however, ",(0,i.kt)("strong",{parentName:"p"},"the cell barcodes in the  ",(0,i.kt)("inlineCode",{parentName:"strong"},"cell_names")," column are modified")," so that each cell barcode belonging to an individual library preparation is unique. This is done by adding a numerical suffix to the barcodes that corresponds to the ",(0,i.kt)("inlineCode",{parentName:"p"},"input_id")," for the library preparation from which the cell barcodes came. "),(0,i.kt)("p",null,"The ",(0,i.kt)("inlineCode",{parentName:"p"},"input_ids")," are listed in the matrix global attributes. The order of the input_ids serves as an index for the cell barcode suffix."),(0,i.kt)("p",null,(0,i.kt)("img",{src:a(1954).Z})),(0,i.kt)("h4",{id:"example-cell-barcodes-from-a-dcp-project-matrix"},"Example cell barcodes from a DCP project matrix"),(0,i.kt)("p",null,"Let's use loompy to look at the global attribute ",(0,i.kt)("inlineCode",{parentName:"p"},"input_id")," for a DCP project matrix (loom format):"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-python"},">>> ds.attrs.input_id\n'166c1b1a-ad9c-4476-a4ec-8b52eb5032c7, 22b7da3d-a301-433e-99e1-e67266c1ee8b, 337a48c5-e363-45aa-886f-ccd4425edc2b, 40630e8b-c3a3-4813-b1e4-b156637c5cc3, 58d703d1-d366-42d0-af44-a3bb836838a5, 70c8d647-7984-4d03-912a-f2437aa1ba4f, 7c86cf30-4284-4a0d-817f-6047560c05c3, 8ef7aca4-be00-4c03-8576-1b2eff4ce7af, ae0cfa6e-e7cb-4a88-9f89-1c44abaa2291, cbd23025-b1bf-4e9e-a297-ddab4a217b76, df049da4-3d20-4da7-a1d7-7d6e8f7740ff, e17bf5ea-788b-4756-a008-a07aec091e10'\n>>> \n")),(0,i.kt)("p",null,"Notice the attribute's value is a string of comma- ",(0,i.kt)("strong",{parentName:"p"},"and space-")," separated UUIDs."),(0,i.kt)("p",null,"Each of these UUIDs represents one library preparation. This matrix contains data from 12 library preparations total. "),(0,i.kt)("p",null,"Now let's look at the ",(0,i.kt)("inlineCode",{parentName:"p"},"cell_names")," column attribute which contains the unique cell barcodes:"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-python"},">>> ds.ca.cell_names\narray(['GGACAAGAGTGCGTGA-0', 'GATCGATCACCAGGTC-0', 'AGCGGTCAGGGCTTGA-0',\n       ..., 'GTACGTAAGCTATGCT-11', 'CAGAATCTCTGAGTGT-11',\n       'AACACGTAGTGTTTGC-11'], dtype=object)\n>>> \n")),(0,i.kt)("p",null,"The suffix appended to the barcodes in the ",(0,i.kt)("inlineCode",{parentName:"p"},"cell_names")," column is the index for the ",(0,i.kt)("inlineCode",{parentName:"p"},"input_id")," UUID to which the cell barcodes belong. "),(0,i.kt)("p",null,'For example, cell barcodes with a "-0" suffix belong to the library preparation represented by the first UUID, ',(0,i.kt)("inlineCode",{parentName:"p"},"166c1b1a-ad9c-4476-a4ec-8b52eb5032c7"),', whereas cell barcodes with a "-11" suffix represent the 10th UUID, ',(0,i.kt)("inlineCode",{parentName:"p"},"cbd23025-b1bf-4e9e-a297-ddab4a217b76"),"."),(0,i.kt)("h3",{id:"mapping-dcp-project-matrix-data-to-the-metadata-manifest"},"Mapping DCP project matrix data to the metadata manifest"),(0,i.kt)("p",null,"While the project matrices contain some project metadata (listed in the table above), there is additionally useful metadata in the project's metadata manifest, a TSV file containing all of a project's metadata, including donor and disease state information."),(0,i.kt)("p",null,"In addition to the global attribute ",(0,i.kt)("inlineCode",{parentName:"p"},"input_id"),", each project matrix has an ",(0,i.kt)("inlineCode",{parentName:"p"},"input_id")," column that can be useful for mapping matrix data back to the DCP metadata manifest. "),(0,i.kt)("p",null,"The values listed in the ",(0,i.kt)("inlineCode",{parentName:"p"},"input_id")," column match the library preparation UUID in the metadata manifest column ",(0,i.kt)("inlineCode",{parentName:"p"},"sequencing_process.provenance.document_id"),". "),(0,i.kt)("p",null,"Read more about the metadata manifest in the DCP ",(0,i.kt)("a",{parentName:"p",href:"https://data.humancellatlas.org/guides"},"Exploring Projects guide"),"."),(0,i.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"Explore HCA Project matrices in Terra")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"HCA matrices produced with Optimus are compatible with multiple downstream community analysis tools. For a tutorial on using the Optimus matrix with ",(0,i.kt)("a",{parentName:"p",href:"https://satijalab.org/seurat/index.html"},"Seurat"),", ",(0,i.kt)("a",{parentName:"p",href:"https://scanpy.readthedocs.io/en/stable/"},"Scanpy"),", ",(0,i.kt)("a",{parentName:"p",href:"https://cumulus.readthedocs.io/en/latest/index.html"},"Cumulus"),", or ",(0,i.kt)("a",{parentName:"p",href:"https://pegasus.readthedocs.io/en/stable/#"},"Pegasus"),", see the public ",(0,i.kt)("a",{parentName:"p",href:"https://app.terra.bio/#workspaces/featured-workspaces-hca/Intro-to-HCA-data-on-Terra"},"Intro-to-HCA-data-on-Terra workspace")," (login required) and its accompanying ",(0,i.kt)("a",{parentName:"p",href:"https://support.terra.bio/hc/en-us/articles/360060041772"},"step-by-step guide"),"."))),(0,i.kt)("h3",{id:"mapping-dcp-project-matrix-data-to-the-contributor-matrices"},"Mapping DCP project matrix data to the contributor matrices"),(0,i.kt)("p",null,"Contributor matrices contain data analyzed and provided by the original project contributors. While they vary in format and content from project to project, they often include cell type annotations and additional metadata such as donor information and cell barcodes. "),(0,i.kt)("p",null,(0,i.kt)("em",{parentName:"p"},"If the contributor matrix contains donor metadata that matches a field in the project metadata manifest"),", the matrix can be linked to the DCP-generated project matrix in a two-step process."),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},"First, map the DCP matrix to the metadata manifest using the Loom's ",(0,i.kt)("inlineCode",{parentName:"p"},"input_id")," ",(0,i.kt)("strong",{parentName:"p"},"column"),"; this column contains the same library preparation/donor IDs as the project metadata manifest's ",(0,i.kt)("inlineCode",{parentName:"p"},"sequencing_process.provenance.document_id")," column. ")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},"Second, map the contributor matrix to the metadata manifest using the contributor matrix column that matches the metadata manifest. "))),(0,i.kt)("p",null,"Contributor matrices might contain a column for cell barcodes for each library/preparation donor. These barcodes should match the non-unique barcodes listed in the DCP project matrix, with the exception of cells that might have been filtered out of the Loom matrix due to low UMIs. The Loom's non-unique barcodes are listed in the ",(0,i.kt)("inlineCode",{parentName:"p"},"CellID")," column. "),(0,i.kt)("p",null,(0,i.kt)("img",{src:a(1662).Z})),(0,i.kt)("p",null,"For example code showing how to link a contributor matrix to a DCP project matrix, see the ",(0,i.kt)("a",{target:"_blank",href:a(7449).Z},"Matrix_matching Jupyter Notebook"),"."),(0,i.kt)("p",null,"If you have any questions related to the contributor matrix and content, reach out to the individual project contributors listed on the Project page."),(0,i.kt)("h2",{id:"brain-initiative-cell-census-network-processing"},"Brain Initiative Cell Census Network Processing"),(0,i.kt)("p",null,"The Optimus pipeline supports data processing for the ",(0,i.kt)("a",{parentName:"p",href:"https://biccn.org/"},"BRAIN Initiative Cell Census Network (BICCN)"),". An overview of the BICCN pipeline resources is available on the BICCN's ",(0,i.kt)("a",{parentName:"p",href:"https://biccn.org/tools/biccn-pipelines"},"Pipelines page"),"."),(0,i.kt)("h3",{id:"optimus-reference-files-for-biccn-data-processing"},"Optimus reference files for BICCN data processing"),(0,i.kt)("p",null,"The BICCN 2.0 Whole Mouse Brain Working Group uses the Ensembl GRCm38 reference for alignment and a modified GTF for gene annotation (see table below). All Optimus pipeline reference inputs were created with the ",(0,i.kt)("a",{parentName:"p",href:"https://github.com/broadinstitute/warp/tree/master/pipelines/skylab/build_indices"},"BuildIndices workflow"),"."),(0,i.kt)("p",null,"BICCN processes single-nucleus data, which is enriched in pre-mRNAs containing introns. To account for this, the BuildIndices workflow uses the ",(0,i.kt)("inlineCode",{parentName:"p"},"BuildStarSingleNucleus")," task to add intron annotations to the GTF with a custom ",(0,i.kt)("a",{parentName:"p",href:"https://github.com/broadinstitute/warp/blob/master/dockers/skylab/snss2-build-indices/add-introns-to-gtf.py"},"python script"),". The GTF contains all annotations for any ",(0,i.kt)("inlineCode",{parentName:"p"},"gene_id")," that has at least one transcript. This reduces the number of genes in the GTF to ","~","32,000. "),(0,i.kt)("p",null,"All reference files are available in a public Google bucket (see table below) and are accompanied by a README that details reference provenance (gs://gcp-public-data--broad-references/mm10/v0/README_mm10_singlecell_gencode.txt). "),(0,i.kt)("table",null,(0,i.kt)("thead",{parentName:"table"},(0,i.kt)("tr",{parentName:"thead"},(0,i.kt)("th",{parentName:"tr",align:null},"Optimus reference input name"),(0,i.kt)("th",{parentName:"tr",align:null},"Google bucket URI"),(0,i.kt)("th",{parentName:"tr",align:null},"Reference source"),(0,i.kt)("th",{parentName:"tr",align:null},"Description"))),(0,i.kt)("tbody",{parentName:"table"},(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"annotations_gtf")),(0,i.kt)("td",{parentName:"tr",align:null},"gs://gcp-public-data--broad-references/mm10/v0/single_nucleus/modified_gencode.vM23.primary_assembly.annotation.gtf"),(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("a",{parentName:"td",href:"https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.annotation.gtf.gzf"},"https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.annotation.gtf.gzf")),(0,i.kt)("td",{parentName:"tr",align:null},"Modified GENCODE GTF including intron annotations that can be used for intron counting with featureCounts.")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"ref_genome_fasta")),(0,i.kt)("td",{parentName:"tr",align:null},"gs://gcp-public-data--broad-references/mm10/v0/single_nucleus/modified_mm10.primary_assembly.genome.fa"),(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("a",{parentName:"td",href:"https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/GRCm38.p6.genome.fa.gz"},"https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/GRCm38.p6.genome.fa.gz")),(0,i.kt)("td",{parentName:"tr",align:null},"FASTA filed used to create the STAR reference files.")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"tar_star_reference")),(0,i.kt)("td",{parentName:"tr",align:null},"gs://gcp-public-data--broad-references/mm10/v0/single_nucleus/star/modified_star_2.7.9a_primary_gencode_mouse_vM23.tar"),(0,i.kt)("td",{parentName:"tr",align:null},"NA \u2014 built with the BuildIndices workflow."),(0,i.kt)("td",{parentName:"tr",align:null},"Reference files used for alignment with STAR.")),(0,i.kt)("tr",{parentName:"tbody"},(0,i.kt)("td",{parentName:"tr",align:null},(0,i.kt)("inlineCode",{parentName:"td"},"whitelist")),(0,i.kt)("td",{parentName:"tr",align:null},"gs://hca-dcp-sc-pipelines-test-data/whitelists/737K-august-2016.txt (for v2 chemistry) and gs://hca-dcp-sc-pipelines-test-data/whitelists/3M-february-2018.txt (for v3 chemisty)"),(0,i.kt)("td",{parentName:"tr",align:null},"See ",(0,i.kt)("a",{parentName:"td",href:"https://kb.10xgenomics.com/hc/en-us/articles/115004506263-What-is-a-barcode-whitelist"},"10x barcode descriptions"),"."),(0,i.kt)("td",{parentName:"tr",align:null},"List of barcode sequences included in 10x library preparations. Each barcode demarcates an individual cell.")))))}d.isMDXComponent=!0},7449:function(e,t,a){t.Z=a.p+"assets/files/Matrix_matching-2c4edc3d0b1881f352a39bd44e22513d.ipynb"},1662:function(e,t,a){t.Z=a.p+"assets/images/mapping_matrices-431db5e1dfb615be0c1741fbb863465e.png"},6954:function(e,t,a){t.Z=a.p+"assets/images/post_processing-256dd7dbd7f417796924b928983dadc3.png"},1954:function(e,t,a){t.Z=a.p+"assets/images/unique_barcodes-9a129aad53dcd952b00b44ad268b51f3.png"}}]);