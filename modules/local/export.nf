// Export and packaging
process EXPORT_IGRAPH {
    memory '16.GB'
    time '1.h'
    
    input:
    path sbml_dfs
    
    output:
    path "napistu_graph.pkl", emit: igraph
    
    script:
    """
    python -m napistu exporter export_igraph \\
        -g regulatory \\
        -w mixed \\
        ${sbml_dfs} \\
        napistu_graph.pkl
    """
}

process EXPORT_DISTANCES {
    memory '32.GB'
    cpus 8
    time '2.h'
    
    input:
    path igraph
    
    output:
    path "precomputed_distances.parquet", emit: distances
    
    script:
    """
    python -m napistu exporter export_precomputed_distances \\
        -s 3 \\
        -q 0.3 \\
        -w "['weight', 'upstream_weight']" \\
        ${igraph} \\
        precomputed_distances.parquet
    """
}

process CREATE_TARFILES {
    publishDir params.outdir, mode: 'copy'
    
    input:
    path sbml_dfs
    path igraph  
    path distances
    
    output:
    path "human_consensus.tar.gz", emit: standard_tar
    path "human_consensus_w_distances.tar.gz", emit: full_tar
    
    script:
    """
    # Standard package (no distances)
    mkdir -p standard
    cp ${sbml_dfs} ${igraph} standard/
    tar -czf human_consensus.tar.gz -C standard .
    
    # Full package (with distances)  
    mkdir -p full
    cp ${sbml_dfs} ${igraph} ${distances} full/
    tar -czf human_consensus_w_distances.tar.gz -C full .
    """
}