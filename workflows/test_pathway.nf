// test_pathway.nf
// Main entry point for test pathway workflow

nextflow.enable.dsl=2

include { COPY_TEST_DATA; INTEGRATE_TEST_REACTOME } from '../modules/local/test_data'
include { DROP_COFACTORS } from '../modules/local/refine'
include { EXPORT_IGRAPH; EXPORT_DISTANCES; EXPORT_SBML_DFS_TABLES } from '../modules/local/exporter'
include { CREATE_TARFILES } from '../modules/local/bash'

workflow TEST_PATHWAY {
    
    main:
    // Copy test data (no input needed - uses environment variable)
    test_data = COPY_TEST_DATA()
    
    // Integrate test Reactome pathways
    reactome_model = INTEGRATE_TEST_REACTOME(test_data)
    
    // Optional: Remove cofactors
    if (params.drop_cofactors) {
        final_sbml_dfs = DROP_COFACTORS(reactome_model)
    } else {
        final_sbml_dfs = reactome_model
    }
    
    // Export igraph
    igraph = EXPORT_IGRAPH(final_sbml_dfs)
    
    // Export distances (with limited steps for faster testing)
    distances = EXPORT_DISTANCES(igraph)
    
    // Export tables
    tables_dir = EXPORT_SBML_DFS_TABLES(final_sbml_dfs)
    
    // Create final tar files
    tar_files = CREATE_TARFILES(final_sbml_dfs, igraph, distances)
    
    // Validate outputs
    final_sbml_dfs.view { "Final SBML_dfs model: $it" }
    igraph.view { "NapistuGraph: $it" }
    distances.view { "Precomputed distances: $it" }
    tar_files.standard_tar.view { "Standard tar: $it" }
    
    emit:
    sbml_dfs = final_sbml_dfs
    graph = igraph
    distances = distances
    tables = tables_dir
    standard_tar = tar_files.standard_tar
    full_tar = tar_files.full_tar
}

workflow {
    TEST_PATHWAY()
}