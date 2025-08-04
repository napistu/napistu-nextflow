// Bash utilities which do NOT use the Napistu CLI

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