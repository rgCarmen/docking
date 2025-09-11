#!/bin/bash

help() {
    echo "Uso: $0 <ruta_unimol> <ruta_dataset> <ruta_resultados> <ruta_script_grid>"
    echo
    echo "Parámetros:"
    echo "  ruta_unimol      Ruta al repositorio de UniMol."
    echo "  ruta_dataset     Ruta al dataset con proteínas y ligandos."
    echo "  ruta_resultados  Carpeta donde se guardarán los resultados."
    echo "  ruta_script_grid Ruta al script unimol_grid.py."
    echo
    echo "Ejemplo:"
    echo "  $0 \$HOME/Uni-Mol \$HOME/docking/data_sets/posebusters_benchmark_set \$HOME/docking/results/results_pb_start_gridlig_unimol docking/scripts/unimol_grid.py"
    exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
fi

if [ $# -lt 4 ]; then
    echo "ERROR: Faltan argumentos. Usa --help para más información."
    exit 1
fi

UNIMOL=$1 

if [ ! -d "$UNIMOL" ]; then
    echo "ERROR: la ruta de UniMol no existe -> $UNIMOL"
    exit 1
fi

INPUT_DIR=$2 


if [ ! -d "$INPUT_DIR" ]; then
    echo "ERROR: la ruta del dataset no existe -> $INPUT_DIR"
    exit 1
fi

OUT_DIR=$3 

GRID_SCRIPT=$4 #docking/scripts/unimol_grid.py
if [ ! -f "$GRID_SCRIPT" ]; then
    echo "ERROR: la ruta del script no existe -> $GRID_SCRIPT"
    exit 1
fi

# Activar el entorno
source ~/miniconda3/etc/profile.d/conda.sh 
conda activate unicore || { echo "ERROR: No se activó el entorno 'unicore'."; exit 1; }

cd $UNIMOL/unimol_docking_v2/interface



echo "Ejecutando UniMol..."

for P in "$INPUT_DIR"/*/; do

    BASE=$(basename "$P")
    echo "Complex $BASE"

    LIGAND="${INPUT_DIR}/${BASE}/${BASE}_ligand_start_conf.sdf"
    PROTEIN="${INPUT_DIR}/${BASE}/${BASE}_protein.pdb"
    GRID="${INPUT_DIR}/${BASE}/${BASE}.json"

   
    python $GRID_SCRIPT --ligand $LIGAND --grid $GRID
    
   

    #Ejecutar UNIMOL 

    python demo.py --mode single --conf-size 10 --cluster \
            --input-protein $PROTEIN \
            --input-ligand $LIGAND \
            --input-docking-grid $GRID \
            --output-ligand-name "${BASE}_unimol" \
            --output-ligand-dir  "${OUT_DIR}/${BASE}"\
            --steric-clash-fix \
            --model-dir ~/unimol_docking_v2_240517.pt

  
done