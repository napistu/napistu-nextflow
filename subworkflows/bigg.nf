workflow BIGG_PROCESSING {
    take:
    species
    
    main:
    bigg_raw = INGEST_BIGG()
    bigg_integrated = INTEGRATE_BIGG(bigg_raw, species)
    bigg_with_ids = EXPAND_BIGG_IDENTIFIERS(bigg_integrated, species)
    
    emit:
    bigg_with_ids
}