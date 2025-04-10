#!/bin/bash

# Paths
OUT_DIR="./DiffDock/results/1G9V_RQ3"
PROTEIN="./astex_diverse_set/1G9V_RQ3/1G9V_RQ3_protein.pdb"
LIGAND="./astex_diverse_set/1G9V_RQ3/1G9V_RQ3_ligand.sdf"

# Procesar resultados con bust
echo "Procesando resultados con bust..."

for SDF in $OUT_DIR/complex_0/*.sdf; do

if [ -f "$SDF" ]; then
OUT_CSV="${SDF%.sdf}.csv"

bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "long" > $OUT_CSV

fi

done

echo "Ejecución completada."
