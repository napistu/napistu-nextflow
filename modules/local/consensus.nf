// Consensus CLI calls
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
