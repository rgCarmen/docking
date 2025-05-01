#!/bin/bash

cd $HOME/tfg/EquiBind

INPUT_DIR="$HOME/docking/data_sets/astex_diverse_set"
OUT_DIR="$HOME/docking/results/results_astex_equibind"


OUT_FORMAT="csv"

echo "Procesando resultados con bust..."

 for P in "$OUT_DIR"/*/; do

    BASE=$(basename "$P")


    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand.sdf"
    SDF="${OUT_DIR}/${BASE}/lig_equibind_corrected.sdf"


    bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "$OUT_FORMAT"  | awk -v protein="$BASE" 'NR>1 {print protein "," $0}'>> $OUT_DIR/resultsBust.csv
done


echo "Ejecución terminada"