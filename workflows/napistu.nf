// Import all necessary modules
include { INGEST_REACTOME; INGEST_STRING; INGEST_TRRUST; INGEST_BIGG; INGEST_HPA_SUBCELL; INGEST_INTACT } from '../modules/local/ingestion'
include { INTEGRATE_REACTOME; INTEGRATE_STRING_DB; INTEGRATE_TRRUST; INTEGRATE_BIGG; INTEGRATE_REACTOME_FI; INTEGRATE_INTACT; INTEGRATE_OMNIPATH; CREATE_DOGMA } from '../modules/local/integration'
include { UNCOMPARTMENTALIZE_MODEL; DROP_COFACTORS; FILTER_HPA_COMPARTMENTS } from '../modules/local/refine'
include { CREATE_CONSENSUS } from '../modules/local/consensus'
include { EXPORT_IGRAPH; EXPORT_DISTANCES } from '../modules/local/exporter'
include { CREATE_TARFILES } from '../modules/local/bash'

workflow NAPISTU_CONSENSUS {
    
    main:
    // Initialize empty channel for collecting models
    models = Channel.empty()
    
    // Process Reactome if enabled
    if ('reactome' in params.sources) {
        reactome_dir = INGEST_REACTOME()
        reactome_model = INTEGRATE_REACTOME(reactome_dir)
        
        if (params.uncompartmentalize) {
            reactome_final = UNCOMPARTMENTALIZE_MODEL(reactome_model)
        } else {
            reactome_final = reactome_model
        }
        
        models = models.mix(reactome_final)
    }
    
    // Process STRING if enabled
    if ('string' in params.sources) {
        string_data = INGEST_STRING()
        string_integrated = INTEGRATE_STRING_DB(string_data)
        hpa_data = INGEST_HPA_SUBCELL()
        string_filtered = FILTER_HPA_COMPARTMENTS(string_integrated, hpa_data)
        
        models = models.mix(string_filtered)
    }
    
    // Process BiGG if enabled
    if ('bigg' in params.sources) {
        bigg_dir = INGEST_BIGG()
        bigg_integrated = INTEGRATE_BIGG(bigg_dir)
        
        if (params.uncompartmentalize) {
            bigg_final = UNCOMPARTMENTALIZE_MODEL(bigg_integrated)
        } else {
            bigg_final = bigg_integrated
        }
        
        models = models.mix(bigg_final)
    }
    
    // Process TRRUST if enabled
    if ('trrust' in params.sources) {
        trrust_file = INGEST_TRRUST()
        trrust_model = INTEGRATE_TRRUST(trrust_file)
        
        if (params.uncompartmentalize) {
            trrust_final = UNCOMPARTMENTALIZE_MODEL(trrust_model)
        } else {
            trrust_final = trrust_model
        }
        
        models = models.mix(trrust_final)
    }
    
    // Process Reactome FI if enabled
    if ('reactome_fi' in params.sources) {
        reactome_fi_model = INTEGRATE_REACTOME_FI()
        models = models.mix(reactome_fi_model)
    }
    
    // Process IntAct if enabled
    if ('intact' in params.sources) {
        intact_dir = INGEST_INTACT()
        intact_model = INTEGRATE_INTACT(intact_dir)
        models = models.mix(intact_model)
    }
    
    // Process OmniPath if enabled
    if ('omnipath' in params.sources) {
        omnipath_model = INTEGRATE_OMNIPATH()
        models = models.mix(omnipath_model)
    }
    
    // Always include dogma (required for consensus)
    dogma_model = CREATE_DOGMA()
    models = models.mix(dogma_model)
    
    // Create consensus from all collected models
    all_models = models.collect()
    consensus = CREATE_CONSENSUS(all_models)
    
    // Optional post-processing
    if (params.drop_cofactors) {
        final_sbml_dfs = DROP_COFACTORS(consensus)
    } else {
        final_sbml_dfs = consensus
    }
    
    // Export results
    igraph = EXPORT_IGRAPH(final_sbml_dfs)
    distances = EXPORT_DISTANCES(igraph)
    tar_files = CREATE_TARFILES(final_sbml_dfs, igraph, distances)
    
    emit:
    sbml_dfs = final_sbml_dfs
    graph = igraph
    distances = distances
    standard_tar = tar_files.standard_tar
    full_tar = tar_files.full_tar
}