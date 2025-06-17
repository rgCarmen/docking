#!/bin/bash

cd $HOME/tfg/EquiBind

INPUT_DIR="$HOME/docking/data_sets/astex_diverse_set"
OUT_DIR="$HOME/docking/results/results_astex_start_equibind"

OUT_FORMAT="csv"

echo "Procesando resultados con bust..."

 for P in "$INPUT_DIR"/*/; do #

    BASE=$(basename "$P")


    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand.sdf"
    START_LIG="${INPUT_DIR}/${BASE}/${BASE}_ligand_start_conf.sdf"



    

    SDF="${OUT_DIR}/${BASE}/lig_equibind_corrected.sdf"


    bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "$OUT_FORMAT"  | awk -v protein="$BASE" 'NR>1 {print protein "," $0}'>> $OUT_DIR/resultsBust-correct.csv
done


echo "Ejecución terminada"