// Integration CLI calls which create `sbml_dfs` from individual sources

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
        --permissive \\
        --species "${params.species}" \\
        ${reactome_dir}/sbml/pw_index.tsv \\
        reactome.pkl
    """
}

process INTEGRATE_STRING_DB {
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

process INTEGRATE_REACTOME_FI {
    memory '8.GB'
    time '30.min'
    
    input:
    path reactome_fi_file
    
    output:
    path "reactome_fi.pkl", emit: model
    
    script:
    """
    python -m napistu integrate reactome_fi ${reactome_fi_file} reactome_fi.pkl
    """
}

process INTEGRATE_INTACT {
    memory '16.GB'
    time '1.h'
    
    input:
    path intact_dir
    
    output:
    path "intact.pkl", emit: model
    
    script:
    """
    python -m napistu integrate intact ${intact_dir} "${params.species}" intact.pkl
    """
}

process INTEGRATE_OMNIPATH {
    memory '8.GB'
    time '45.min'
    
    output:
    path "omnipath.pkl", emit: model
    
    script:
    """
    python -m napistu integrate omnipath -o "${params.species}" omnipath.pkl
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