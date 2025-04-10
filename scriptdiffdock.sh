#!/bin/bash

# Configuración de archivos y rutas
BASE=$1

CONFIG="default_inference_args.yaml"

PROTEIN="../astex_diverse_set/${BASE}/${BASE}_protein.pdb"
LIGAND="../astex_diverse_set/${BASE}/${BASE}_ligand.sdf"

OUT_DIR="results_astex/$BASE"

SDF1="$OUT_DIR"/complex_0/rank1.sdf


OUT_FORMAT="csv"

# Activar entorno conda

cd DiffDock
source ~/miniconda3/etc/profile.d/conda.sh # conda init (no funciona ni idea por que)
conda activate diffdock || { echo "ERROR: No se activó el entorno 'diffdock'."; exit 1; }

python -c "import esm; print(esm.__file__)"

# Ejecutar DiffDock
echo "Ejecutando DiffDock... para $BASE"
#echo "LIGAND: $LIGAND"
python -m inference --config "$CONFIG" --protein_path "$PROTEIN" --ligand "$LIGAND" --out_dir "$OUT_DIR"


if [ $? -ne 0 ]; then
    echo "ERROR: Falló la ejecución de DiffDock."
    exit 1
fi

# Procesar resultados con bust
echo "Procesando resultados con bust..."

if [ "$2" -eq 0 ]; then

    if [ -f "$SDF" ]; then
    bust "$SDF1" -l "$LIGAND" -p "$PROTEIN" --outfmt "$OUT_FORMAT" > $OUT_DIR/complex_0/result.csv
    else
        echo "ERROR: Archivo $SDF1 no encontrado"
        exit 1
    fi
else

    for SDF in "$OUT_DIR"/complex_0/*.sdf; do

    if [ -f "$SDF" ]; then
    OUT_CSV="${SDF%.sdf}.csv"

    bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "$OUT_FORMAT" > $OUT_CSV

    fi

    done
fi

echo "Ejecución completada."


