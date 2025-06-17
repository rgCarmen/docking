#!/bin/bash

# Configuración de rutas

EQUIBIND= $HOME/EquiBind
CONFIG="./configs_clean/inference.yml"

SET="posebusters_benchmark_set"
INPUT_DIR="$HOME/docking/data_sets/$SET"
OUT_DIR="$HOME/docking/results/results_posebusters_equibind"

OUT_FORMAT="csv"
INPUT_DIR_TEMP="$HOME/docking/$SET"

##############################################################################################################3

# ACTIVAR ENTORNO CONDA DE EQUIBIND
cd $EQUIBIND
source ~/miniconda3/etc/profile.d/conda.sh 
conda activate equibind || { echo "ERROR: No se activó el entorno 'equibind'."; exit 1; }


# Crear directorio para inference path con el formato correcto para EquiBind
mkdir -p "$INPUT_DIR_TEMP"

for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    mkdir -p "$INPUT_DIR_TEMP/$BASE"

    LIGAND="$P/${BASE}_ligand_start_conf.sdf"
   
    PROTEIN="$P/${BASE}_protein.pdb"

    cp "$LIGANDO" "$INPUT_DIR_TEMP/$BASE/${BASE}_ligand.sdf"
    cp "$PROTEIN" "$INPUT_DIR_TEMP/$BASE/"
done


# MODIFIDCAR inference.yml (para establecer el directorio de entrada y salida)

sed -i "s|^inference_path: .*|inference_path: $INPUT_DIR_TEMP|" "$CONFIG"
sed -i "s|^output_directory: .*|output_directory: $OUT_DIR|" "$CONFIG"


# EJECUCIÓN EQUIBIND
echo "Ejecutando Equibind..."
python inference.py --config=$CONFIG


# EVALUAR LOS RESULTADOS CON POSEBUSTERS
rm -rf $INPUT_DIR_TEMP

echo "Procesando resultados con bust..."

 for P in "$OUT_DIR"/*/; do

    BASE=$(basename "$P")

    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand.sdf"
    SDF="${OUT_DIR}/${BASE}/lig_equibind_corrected.sdf"

    bust "$SDF" -l "$LIGAND" -p "$PROTEIN" --outfmt "$OUT_FORMAT"  | awk -v protein="$BASE" 'NR>1 {print protein "," $0}'>> $OUT_DIR/resultsBust.csv
done

echo "Ejecución terminada"

