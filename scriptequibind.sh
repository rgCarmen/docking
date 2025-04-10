#!/bin/bash

# Configuración de archivos y rutas

cd EquiBind
source ~/miniconda3/etc/profile.d/conda.sh 
conda activate equibind || { echo "ERROR: No se activó el entorno 'equibind'."; exit 1; }

CONFIG="./configs_clean/inference.yml"

INPUT_DIR="../astex_diverse_set"
OUT_DIR="results_astex"


OUT_FORMAT="csv"


# Modificar inference.yml

sed -i "s|^inference_path: .*|inference_path: $INPUT_DIR|" "$CONFIG"
sed -i "s|^output_directory: .*|output_directory: $OUT_DIR|" "$CONFIG"


# Ejecución Equibind
echo "Ejecutando Equibind..."

python inference.py --config=$CONFIG


# Evaluar con PoseBuster


echo "Procesando resultados con bust..."

 for P in "$OUT_DIR"/*/; do

    BASE=$(basename "$P")


    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand.sdf"
    SDF="results_astex${OUTPUT_DIR}/${BASE}/lig_equibind_corrected.sdf"

    bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt ""$OUT_FORMAT  | awk -v protein="$BASE" 'NR>1 {print protein "," $0}'>> $OUT_DIR/resultsBust.csv
done

echo "Ejecución terminada"

