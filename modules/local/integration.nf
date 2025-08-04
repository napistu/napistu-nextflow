// Integration processes
process INTEGRATE_REACTOME {
    memory '16.GB'
    time '1.h'
    
    input:
    path reactome_dir
    
    output:
    path "reactome.pkl", emit: model
    
    script:
    """
    python -m napistu integrate reactome \\
        ${reactome_dir}/sbml/pw_index.tsv \\
        reactome.pkl \\
        --species "${params.species}" \\
        --permissive
    """
}

process INTEGRATE_STRING {
    memory '32.GB'
    time '2.h'
    
    input:
    tuple path(string_db), path(string_aliases)
    
    output:
    path "string.pkl", emit: model
    
    script:
    """
    python -m napistu integrate string-db \\
        ${string_db} ${string_aliases} string.pkl
    """
}

process INTEGRATE_TRRUST {
    memory '8.GB'
    time '30.min'
    
    input:
    path trrust_file
    
    output:
    path "trrust.pkl", emit: model
    
    script:
    """
    python -m napistu integrate trrust ${trrust_file} trrust.pkl
    """
}

process INTEGRATE_BIGG {
    memory '16.GB'
    time '1.h'
    
    input:
    path bigg_dir
    
    output:
    path "bigg.pkl", emit: model
    
    script:
    """
    python -m napistu integrate bigg \\
        --species "${params.species}" \\
        ${bigg_dir}/pw_index.tsv \\
        bigg.pkl
    """
}

process CREATE_DOGMA {
    memory '8.GB'
    time '30.min'
    
    output:
    path "dogma.pkl", emit: model
    
    script:
    """
    python -m napistu integrate dogmatic_scaffold \\
        --species "${params.species}" \\
        dogma.pkl
    """
}