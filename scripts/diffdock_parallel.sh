#!/bin/bash

help() {
    echo "Uso: $0 <num_procesos> <ruta_diffdock> <ruta_dataset> <ruta_resultados> [set]"
    echo
    echo "Parámetros:"
    echo "  num_procesos     Número de procesos en paralelo a ejecutar."
    echo "  ruta_diffdock    Ruta a la carpeta de instalación de DiffDock."
    echo "  ruta_dataset     Ruta al dataset con proteínas y ligandos."
    echo "  ruta_resultados  Carpeta donde se guardarán los resultados."
    echo
    echo "Ejemplo:"
    echo "  $0 4 ~/DiffDock ~/docking/data_sets/posebusters_benchmark_set ~/docking/results/results_posebuster_diffdock_start"
    exit 0 #terminar ejecución
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
fi

if [ $# -lt 4 ]; then
    echo "ERROR: Faltan argumentos. Usa --help para más información."
    exit 1
fi

NUM_PROCESOS=$1

# Establecer las rutas
DIFFDOCK=$2 
DIR=$3 # dataset 

# comprobar rutas
if [ ! -d "$DIFFDOCK" ]; then
    echo "ERROR: la ruta de DiffDock no existe -> $DIFFDOCK"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "ERROR: la ruta del dataset no existe -> $DIR"
    exit 1
fi

RESULT_NAME=$4 



CONFIG="default_inference_args.yaml"
OUT_CSV_ALL="$RESULT_NAME/evaluation.csv"

# Activar entorno conda
cd $DIFFDOCK
source ~/miniconda3/etc/profile.d/conda.sh 
conda activate diffdock || { echo "ERROR: no se activo el entorno'diffdock'."; exit 1; }



IDS="$DIR/ids.txt"
ls -d $DIR/*/ | xargs -n 1 basename > $IDS


mkdir -p "$RESULT_NAME/temp"


procesar_proteina() {

BASE=$1

echo "Complejo $BASE"


PROTEIN="$DIR/${BASE}/${BASE}_protein.pdb"
LIGAND="$DIR/${BASE}/${BASE}_ligand_start_conf.sdf"
LIGAND_TRUE="$DIR/${BASE}/${BASE}_ligand.sdf"


OUT_DIR="$RESULT_NAME/$BASE"
SDF="$OUT_DIR"/complex_0/rank1.sdf
OUT_FORMAT="csv"



# Ejecutar DiffDock
echo "Ejecutando DiffDock..."
    
python -m inference --config "$CONFIG" --protein_path "$PROTEIN" --ligand "$LIGAND" --out_dir "$OUT_DIR" > /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Falló la ejecución de DiffDock para $BASE"
    rm -rf "$OUT_DIR" #ELIMINAR DIRECTORIO QUE HA CREADO pero esta vacio
    return 1
fi



# Procesar resultados con bust
echo "Procesando resultados con..."

if [ -f "$SDF" ]; then
    bust "$SDF" -l "$LIGAND_TRUE" -p "$PROTEIN" --outfmt "$OUT_FORMAT" | awk -v protein="$BASE" 'NR>1 {print protein "," $0}' > "$HOME/docking/results/$RESULT_NAME/temp/${BASE}.csv"
fi

}

export -f procesar_proteina
export CONFIG OUT_CSV_ALL RESULT_NAME DIR
cat "$IDS" | xargs -I {} -P $NUM_PROCESOS bash -c 'procesar_proteina "$@"' _ {}

echo "Obteniendo resultados"
cat "$HOME/docking/results/$RESULT_NAME/temp"/*.csv >> $OUT_CSV_ALL
rm -rf "$HOME/docking/results/$RESULT_NAME/temp"

rm $IDS


echo "Ejecución completada"



