#!/bin/bash

# Configuración de archivos y rutas

INPUT_DIR="${HOME}/docking/data_sets/posebusters_benchmark_set"
OUT_DIR="${HOME}/docking/results"
OUT_FORMAT="csv"

# Ejecución de PoseBusters
echo "Procesando resultados con bust..."

for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")


    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand.sdf"
    SDF="${INPUT_DIR}/${BASE}/${BASE}_ligand_opt_start_deepdock.sdf"
    

    if [ -f "$SDF" ]; then
        echo $BASE

        bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "$OUT_FORMAT"  | awk -v protein="$BASE" 'NR>1 {print protein "," $0}'>> $OUT_DIR/resultsBustPBDeepDockStart.csv
    fi

done

echo "Ejecución terminada"