// Consensus and post-processing
process CREATE_CONSENSUS {
    memory '64.GB'
    cpus 16
    time '3.h'
    
    input:
    path models  // Collection of all model files
    
    output:
    path "consensus.pkl", emit: consensus
    
    script:
    """
    python -m napistu consensus create \\
        --nondogmatic \\
        ${models.join(' ')} \\
        consensus.pkl
    """
}

process DROP_COFACTORS {
    memory '16.GB'
    time '30.min'
    
    input:
    path consensus_model
    
    output:
    path "sbml_dfs.pkl", emit: final_model
    
    script:
    """
    python -m napistu refine drop_cofactors \\
        ${consensus_model} \\
        sbml_dfs.pkl
    """
}