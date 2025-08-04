// Refinement CLI calls which modify `sbml_dfs`

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