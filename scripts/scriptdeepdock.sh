#!/bin/bash

INPUT_DIR="../astex_diverse_set"

echo $INPUT_DIR

echo "Ejecutando DeepDock..."
for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    echo "Protein" $BASE

    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand"
    #if ! ls "${LIGAND}.mol2" 1> /dev/null 2>&1;then
        #obabel "${LIGAND}.sdf" -O "${LIGAND}.mol2" -h

    #fi
    SDF="$INPUT_DIR/${BASE}/${BASE}_ligand_opt_deepdock.sdf"
    if [ -f "$SDF" ]; then
        echo "Docking ya existe"
    else
        python docking.py $BASE
        #remove created files
        rm $BASE*
    fi

    
    #bust
done