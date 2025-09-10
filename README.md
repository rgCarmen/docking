# Docking Benchmark Pipeline

Este repositorio contiene scripts y recursos para la evaluación y comparación de diferentes métodos de docking molecular sobre conjuntos de datos de benchmarking como Astex y PoseBusters.

## Estructura del repositorio

```
analysisResults.ipynb
README.txt
data_sets/
    astex_diverse_set/
        ...
    posebusters_benchmark_set/
        ...
results/
    ...
scripts/
    bustdeepdock.sh
    docking.py
    scriptdeepdock.sh
    scriptdiffdock.sh
    scriptequibind.sh
    scriptunimol.sh
    diffdock_parallel.sh
    ...
```

### Descripción de carpetas y archivos

- **analysisResults.ipynb**: Jupiter Notebook para el análisis de los resultados obtenidos de las diferentes herramientas de docking.
- **data_sets/**: Contiene los conjuntos de datos utilizados.
- **results/**: Resultados generados por las diferentes herramientas de docking.
  - Cada subcarpeta corresponde a un método y/o conjunto de datos específico 
  - Dentro de cada subcarpeta hay directorios por complejo con elarchivos SDF resultante.
- **scripts/**: Scripts para ejecutar las diferentes herramientas de docking y procesar los resultados.

  #### DiffDock
  - *diffdock_parallel.sh*
    Script para ejecutar DiffDock sobre un conjunto de complejos proteína-ligando y obtener la evaluación de los resultados mediante PoseBusters.
    ```bash
    ./diffdock_parallel.sh <num_procesos>
    ```
    ❗Se necesita el repositorio de la herramienta  [DiffDock](https://github.com/gcorso/DiffDock) y el entorno conda diffdock para la ejecución.

  #### EquiBind
    - *scriptequibind.sh*
       Script para ejecutar EquiBind sobre un conjunto de complejos proteína-ligando y obtener la evaluación de los resultados mediante PoseBusters.
    ```bash
    ./scriptequibind.sh
    ```
    ❗Se necesita el repositorio de la herramienta  [EquiBind](https://github.com/HannesStark/EquiBind)  y el entorno conda equibind para la ejecución.

  #### DeepDock
    - *scriptdeepdock.sh*
      Script para ejecutar DeepDock sobre un conjunto de complejos proteína-ligando
    - *docking.py*
      Script auxiliar para realizar la inferencia con DeepDock.
   
     -*bustdeepdock.sh*
      Script para obtener la evaluación de los resultados mediante PoseBusters.

   ❗La ejecución se realiza dentro del contenedor oficial `omendezlucio/deepdock:latest`.  Se copian las carpetas y scripts necesarios como volúmenes (`-v`).
      ```bash
        #  lanzar el contenedor con volúmenes montados
        docker run -it \
        -v ~/docking/data_sets/astex_diverse_set:/astex_diverse_set \
        -v ~/docking/scripts/docking.py:/DeepDock/docking.py \
        -v ~/docking/scripts/scriptdeepdock.sh:/DeepDock/scriptdeepdock.sh \
        omendezlucio/deepdock:latest
      ```
  
    ```bash
        # ejecutar DeepDock dentro del contenedor
        cd DeepDock
        ./scriptdeepdock.sh
    ```
    
    ```bash
        #  salir del contenedor (esto también lo detiene)
        exit
    ```
    
    ```bash
        # evaluar con PoseBusters (ya en el host)
        ./bustdeepdock.sh
    ```
   
      
  #### **UniMol**
    - *scriptunimol.sh*
      Script para ejecutar UniMol Docking sobre un conjunto de complejos proteína-ligando.
    ```bash
    ./scriptunimol.sh
    ```
  
    - *unimol_grid.py*
      Script para calcular la malla de docking del complejo. Es llamado por  *scriptunimol.sh*
      
     ❗Se necesita el repositorio de la herramienta  [UniMol](https://github.com/deepmodeling/Uni-Mol/tree/main/unimol_docking_v2)  y el entorno conda unicore para la ejecución.

## Herramientas empleadas y Requisitos

### Herramientas de docking

| Herramienta | Repositorio | Python | Dependencias principales |
|-------------|-------------|--------|--------------------------|
| **EquiBind** | [GitHub](https://github.com/HannesStark/EquiBind) (acceso: 9 jun 2025) | 3.8.19 | `pytorch==1.10`, `rdkit==2024.3.5`, `biopandas==0.5.1` |
| **DiffDock** | [GitHub](https://github.com/gcorso/DiffDock) (acceso: 15 abr 2025) | 3.9.18 | `e3nn==0.5.0` (en lugar de 0.5.1), `pandas==2.2.3`, `pytorch-lightning==2.2.5` (en lugar de 1.9.5), `rdkit==2024.9.6` (en lugar de 2022.03.3) |
| **DeepDock** | [GitHub](https://github.com/OptiMaL-PSE-Lab/DeepDock) (acceso: 30 mar 2025) | – (Docker) | Imagen oficial: `omendezlucio/deepdock:latest` |
| **Uni-Mol Docking V2** | [GitHub](https://github.com/deepmodeling/Uni-Mol/tree/main/unimol_docking_v2) (acceso: 27 abr 2025) | 3.9 | `rdkit==2022.9.3`, `biopandas==0.4.1`, `Uni-Core` (instalado desde repo con `python setup.py install`) |

---

### Herramientas adicionales de evaluación y análisis

| Herramienta | Versión | Descripción |
|-------------|---------|-------------|
| **PoseBusters** | 0.3.6 | Instalado con `pip install posebusters`, utilizado con el comando `bust` |
| **Open Babel** | 3.1.1 | Conversión de formatos moleculares |
| **RDKit** | 2024.9.6 | Análisis y visualización de moléculas |

