#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh 
conda activate unicore || { echo "ERROR: No se activó el entorno 'unicore'."; exit 1; }

cd $HOME/Uni-Mol/unimol_docking_v2/interface

INPUT_DIR="${HOME}/docking/data_sets/posebusters_benchmark_set"
OUT_DIR="${HOME}/docking/results/results_posebusters_unimol"



echo $INPUT_DIR

echo "Ejecutando UniMol..."
pwd
for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    echo "Protein" $BASE

    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand.sdf"
    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    GRID="${INPUT_DIR}/${BASE}/${BASE}.json"

    #calculate grid
    if [ -f "$GRID" ]; then
        echo "Grid ya exite"
    else
        python /home/carmen/docking/scripts/unimol_grid.py --ligand $LIGAND --grid $GRID
    fi
   

    #ejecutar unimol

    if [[ ${BASE} > "7P2W_4QR" ]]; then

         python demo.py --mode single --conf-size 10 --cluster \
            --input-protein $PROTEIN \
            --input-ligand $LIGAND \
            --input-docking-grid $GRID \
            --output-ligand-name "${BASE}_unimol" \
            --output-ligand-dir  "${OUT_DIR}/${BASE}"\
            --steric-clash-fix \
            --model-dir ~/unimol_docking_v2_240517.pt

    else
        echo "Skipped"
    fi
done

#probar con batch one2one  -> antes hay que hacer un csv indicando proteina, ligando, grid y out_name