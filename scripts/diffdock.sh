#!/bin/bash

# Configuración de archivos y rutas

ASTEX="../astex_diverse_set/astex_diverse_set.txt"
CONFIG="default_inference_args.yaml"

# Activar entorno conda
cd DiffDock
source ~/miniconda3/etc/profile.d/conda.sh # conda init (no funciona ni idea por que)
conda activate diffdock || { echo "ERROR: No se activó el entorno 'diffdock'."; exit 1; }

python -c "import esm; print(esm.__file__)"

while IFS= read -r BASE; do

echo "Protein $BASE"

PROTEIN="../astex_diverse_set/${BASE}/${BASE}_protein.pdb"
LIGAND="../astex_diverse_set/${BASE}/${BASE}_ligand.sdf"

OUT_DIR="results_astex/$BASE"
SDF="$OUT_DIR"/complex_0/rank1.sdf

OUT_FORMAT="csv"


# Ejecutar DiffDock
echo "Ejecutando DiffDock..."
#echo "LIGAND: $LIGAND"
python -m inference --config "$CONFIG" --protein_path "$PROTEIN" --ligand "$LIGAND" --out_dir "$OUT_DIR"


if [ $? -ne 0 ]; then
    echo "ERROR: Falló la ejecución de DiffDock para $BASE"
    continue
fi

# Procesar resultados con bust
echo "Procesando resultados con bust..."


#OUT_CSV="${SDF%.sdf}.csv"
OUT_CSV_ALL="evaluation.csv"

if [ -f "$SDF" ]; then
bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "$OUT_FORMAT" | awk -v protein="$BASE" 'NR>1 {print protein "|" $0}' >> $OUT_CSV_ALL
fi

done < "$ASTEX"


echo "Ejecución completada."



