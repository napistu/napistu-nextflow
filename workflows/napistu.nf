// Import source-specific subworkflows
include { STRING_PROCESSING } from '../subworkflows/string'
include { REACTOME_PROCESSING } from '../subworkflows/reactome'  
include { BIGG_PROCESSING } from '../subworkflows/bigg'
include { TRRUST_PROCESSING } from '../subworkflows/trrust'
include { DOGMA_PROCESSING } from '../subworkflows/dogma'

workflow NAPISTU_CONSENSUS {
    
    // Phase 1: Process selected sources (runs in parallel)
    processed_models = Channel.empty()
    
    if ('string' in params.sources) {
        string_model = STRING_PROCESSING(params.species)
        processed_models = processed_models.mix(string_model)
    }
    
    if ('reactome' in params.sources) {
        reactome_model = REACTOME_PROCESSING(params.species)
        processed_models = processed_models.mix(reactome_model)
    }
    
    if ('bigg' in params.sources) {
        bigg_model = BIGG_PROCESSING(params.species)
        processed_models = processed_models.mix(bigg_model)
    }
    
    if ('trrust' in params.sources) {
        trrust_model = TRRUST_PROCESSING(params.species)
        processed_models = processed_models.mix(trrust_model)
    }
    
    // Always include dogma (required for consensus)
    dogma_model = DOGMA_PROCESSING(params.species)
    processed_models = processed_models.mix(dogma_model)
    
    // Phase 2: Optional global processing steps
    if (params.uncompartmentalize) {
        final_models = processed_models.map { model ->
            UNCOMPARTMENTALIZE_MODEL(model)
        }
    } else {
        final_models = processed_models
    }
    
    // Phase 3: Collect all models and create consensus
    all_models = final_models.collect()
    consensus = CREATE_CONSENSUS(all_models)
    
    // Phase 4: Optional post-processing  
    if (params.drop_cofactors) {
        final_result = DROP_COFACTORS(consensus)
    } else {
        final_result = consensus
    }
    
    // Phase 5: Export
    EXPORT_RESULTS(final_result)
}