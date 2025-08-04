#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Import the main workflow
include { NAPISTU_CONSENSUS } from './workflows/napistu'

workflow {
    NAPISTU_CONSENSUS()
}