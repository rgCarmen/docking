#!/bin/bash

INPUT_DIR="../data_sets/posebusters_benchmark_set"
echo $INPUT_DIR

echo "Ejecutando Obabel..."
for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    echo "Protein" $BASE

    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand"
    if ! ls "${LIGAND}.mol2" 1> /dev/null 2>&1;then
        obabel "${LIGAND}.sdf" -O "${LIGAND}.mol2" -h

    fi
done