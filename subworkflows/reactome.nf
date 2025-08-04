workflow REACTOME_PROCESSING {
    take:
    species
    
    main:
    // Reactome-specific pipeline
    reactome_raw = INGEST_REACTOME()
    reactome_integrated = INTEGRATE_REACTOME(reactome_raw, species)
    
    emit:
    reactome_integrated
}