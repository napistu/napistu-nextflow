// Data ingestion processes - direct CLI wrappers
process INGEST_REACTOME {
    memory '4.GB'
    time '30.min'
    
    output:
    path "reactome", emit: reactome_dir
    
    script:
    """
    python -m napistu ingestion reactome reactome
    """
}

process INGEST_STRING {
    memory '8.GB' 
    time '45.min'
    
    output:
    tuple path("string_db"), path("string_aliases"), emit: string_data
    
    script:
    """
    python -m napistu ingestion string-db --species "${params.species}" string_db
    python -m napistu ingestion string-aliases --species "${params.species}" string_aliases
    """
}

process INGEST_TRRUST {
    memory '2.GB'
    time '10.min'
    
    output:
    path "trrust.tsv", emit: trrust_file
    
    script:
    """
    python -m napistu ingestion trrust trrust.tsv
    """
}

process INGEST_BIGG {
    memory '4.GB'
    time '20.min'
    
    output:  
    path "bigg", emit: bigg_dir
    
    script:
    """
    python -m napistu ingestion bigg bigg
    """
}