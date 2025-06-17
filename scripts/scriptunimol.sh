#!/bin/bash

UNIMOL= "../Uni-Mol"
SET="posebusters_benchmark_set"
INPUT_DIR="${HOME}/docking/data_sets/${SET}"
OUT_DIR="${HOME}/docking/results/results_pb_start_gridlig_unimol"


# Activar el entorno
source ~/miniconda3/etc/profile.d/conda.sh 
conda activate unicore || { echo "ERROR: No se activó el entorno 'unicore'."; exit 1; }

cd $UNIMOL/unimol_docking_v2/interface



echo "Ejecutando UniMol..."
pwd
for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    echo "Complex $BASE

    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand_start_conf.sdf"
    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    GRID="${INPUT_DIR}/${BASE}/${BASE}.json"

    #calculate grid
    if [ -f "$GRID" ]; then
        echo "Grid ya exite"
    else
        python /home/carmen/docking/scripts/unimol_grid.py --ligand $LIGAND --grid $GRID
    fi
   

    #Ejcutar UNIMOL 

    python demo.py --mode single --conf-size 10 --cluster \
            --input-protein $PROTEIN \
            --input-ligand $LIGAND \
            --input-docking-grid $GRID \
            --output-ligand-name "${BASE}_unimol" \
            --output-ligand-dir  "${OUT_DIR}/${BASE}"\
            --steric-clash-fix \
            --model-dir ~/unimol_docking_v2_240517.pt

  
done