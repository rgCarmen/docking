#!/bin/bash

# Paths
OUT_DIR="./DiffDock/results/1G9V_RQ3"
PROTEIN="${HOME}/docking/data_sets/astex_diverse_set/1G9V_RQ3/1G9V_RQ3_protein.pdb"
LIGAND="${HOME}/docking/data_sets/astex_diverse_set/1G9V_RQ3/1G9V_RQ3_ligand.sdf"

# Procesar resultados con bust
echo "Procesando resultados con bust..."

#for SDF in $OUT_DIR/complex_0/*.sdf; do
SDF="${HOME}/docking/results/results_astex_equibind/1G9V_RQ3/lig_equibind_corrected.sdf"
if [ -f "$SDF" ]; then
OUT_CSV="${SDF%.sdf}.csv"
echo "Ok"
bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "csv" #> $OUT_CSV

fi

#done

echo "Ejecución completada."
