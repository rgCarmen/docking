#!/bin/bash

INPUT_DIR="../astex_diverse_set"

echo "Ejecutando DeepDock..."
 for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    echo $BASE

    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand"
    if ! ls "${LIGAND}.mol2" 1> /dev/null 2>&1;then
        obabel "${LIGAND}.sdf" -O "${LIGAND}.mol2" -h

    fi
    python docking.py $BASE

    #remove created files
    rm $BASE*
    #bust
done