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

process INGEST_HPA_SUBCELL {
    memory '4.GB'
    time '20.min'
    
    output:
    path "hpa_subcell.tsv", emit: hpa_file
    
    script:
    """
    python -m napistu ingestion proteinatlas-subcell hpa_subcell.tsv
    """
}

process INGEST_INTACT {
    memory '8.GB'
    time '1.h'
    
    output:
    path "intact_xmls", emit: intact_dir
    
    script:
    """
    python -m napistu ingestion intact intact_xmls "${params.species}"
    """
}

process INGEST_REACTOME_FI {
    memory '2.GB'
    time '15.min'
    
    output:
    path "reactome_fi.tsv", emit: reactome_fi_file
    
    script:
    """
    python -m napistu ingestion reactome_fi reactome_fi.tsv
    """
}

process INGEST_GTEX_RNASEQ {
    memory '4.GB'
    time '30.min'
    
    output:
    path "gtex_rnaseq.tsv", emit: gtex_file
    
    script:
    """
    python -m napistu ingestion gtex-rnaseq-expression gtex_rnaseq.tsv
    """
}