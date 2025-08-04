workflow STRING_PROCESSING {
    take:
    species  // Input parameter
    
    main:
    // Step 1: Ingest STRING data  
    string_db = INGEST_STRING_DB(species)
    string_aliases = INGEST_STRING_ALIASES(species) 
    
    // Step 2: Integrate STRING
    string_integrated = INTEGRATE_STRING_DB(string_db, string_aliases)
    
    // Step 3: Ingest HPA for filtering
    hpa_data = INGEST_HPA_SUBCELL()
    
    // Step 4: Filter STRING by HPA compartments
    string_filtered = FILTER_HPA_COMPARTMENTS(string_integrated, hpa_data)
    
    emit:
    string_filtered  // Final STRING model ready for consensus
}