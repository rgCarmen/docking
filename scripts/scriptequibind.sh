#!/bin/bash

help() {
    echo "Uso: $0 <ruta_equibind> <ruta_dataset> <ruta_resultados>"
    echo
    echo "Parámetros:"
    echo "  ruta_equibind    Ruta al repositorio de EquiBind."
    echo "  ruta_dataset     Ruta al dataset con proteínas y ligandos."
    echo "  ruta_resultados  Carpeta donde se guardarán los resultados."
    echo
    echo "Ejemplo:"
    echo "  $0 \$HOME/EquiBind \$HOME/docking/data_sets/posebusters_benchmark_set \$HOME/docking/results/results_posebusters_equibind"
    exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
fi

if [ $# -lt 3 ]; then
    echo "ERROR: Faltan argumentos. Usa --help para más información."
    exit 1
fi

# Configuración de rutas

EQUIBIND=$1 
CONFIG="./configs_clean/inference.yml"


INPUT_DIR=$2  
OUT_DIR=$3 

OUT_FORMAT="csv"
INPUT_DIR_TEMP="$INPUT_DIR/temp_equibind"

if [ ! -d "$EQUIBIND" ]; then
    echo "ERROR: la ruta de EquiBind no existe -> $EQUIBIND"
    exit 1
fi

if [ ! -d "$INPUT_DIR" ]; then
    echo "ERROR: la ruta del dataset no existe -> $INPUT_DIR"
    exit 1
fi

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

    cp "$LIGAND" "$INPUT_DIR_TEMP/$BASE/${BASE}_ligand.sdf"
    cp "$PROTEIN" "$INPUT_DIR_TEMP/$BASE/"
done


# MODIFIDCAR inference.yml (para establecer el directorio de entrada y salida) !!Se encuentra en la ruta de EquiBind!!

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

