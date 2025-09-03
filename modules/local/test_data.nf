// modules/local/test_data.nf
// Processes for handling test data

process COPY_TEST_DATA {
    memory '1.GB'
    time '5.min'
    
    output:
    path "test_data", emit: test_data_dir
    
    script:
    """
    mkdir -p test_data
    
    # Use environment variable set in config
    echo "DEBUG: TEST_DATA_PATH is set to: \$TEST_DATA_PATH"
    echo "DEBUG: Current working directory: \$(pwd)"
    echo "DEBUG: Listing parent directory:"
    ls -la ../

    if [[ -d "\$TEST_DATA_PATH" ]]; then
        echo "Found test data directory: \$TEST_DATA_PATH"
        ls -la "\$TEST_DATA_PATH"
        cp \$TEST_DATA_PATH/pw_index_metabolism.tsv test_data/
        cp \$TEST_DATA_PATH/reactome_glucose_metabolism.sbml test_data/
        cp \$TEST_DATA_PATH/reactome_glycolysis.sbml test_data/
        cp \$TEST_DATA_PATH/reactome_ppp.sbml test_data/
        cp \$TEST_DATA_PATH/reactome_tca.sbml test_data/
        echo "Copied test data from \$TEST_DATA_PATH"
    else
        echo "ERROR: Test data path not found: \$TEST_DATA_PATH"
        echo "DEBUG: Contents of current directory:"
        ls -la
        echo "DEBUG: Attempting to find test data files:"
        find .. -name "pw_index_metabolism.tsv" -type f 2>/dev/null || echo "No pw_index_metabolism.tsv found"
        exit 1
    fi
    """
}

process INTEGRATE_TEST_REACTOME {
    memory '4.GB'
    time '30.min'
    
    input:
    path test_data_dir
    
    output:
    path "reactome.pkl", emit: model
    
    script:
    """
    # Create reactome directory structure
    mkdir -p reactome
    cp ${test_data_dir}/* reactome/
    
    # Integrate the test Reactome pathways
    python -m napistu integrate reactome \\
        --overwrite \\
        --permissive \\
        reactome/pw_index_metabolism.tsv \\
        reactome.pkl
    """
}