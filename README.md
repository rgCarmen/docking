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

## Descripción de carpetas y archivos

- **analysisResults.ipynb**: Jupiter Notebook para el análisis de los resultados obtenidos de las diferentes herramientas de docking.
- **data_sets/**: Contiene los conjuntos de datos utilizados.
- **results/**: Resultados generados por las diferentes herramientas de docking.
  - Cada subcarpeta corresponde a un método y/o conjunto de datos específico 
  - Dentro de cada subcarpeta hay directorios por complejo con elarchivos SDF resultante.
- **scripts/**: Scripts para ejecutar las diferentes herramientas de docking y procesar los resultados.

  ### DiffDock
  - *diffdock_parallel.sh*
    Script para ejecutar DiffDock sobre un conjunto de complejos proteína-ligando y obtener la evaluación de los resultados mediante PoseBusters.

  **Uso**
    ```bash
    ./diffdock_parallel.sh <num_procesos> <ruta_diffdock> <ruta_dataset> <ruta_resultados>
    ```

    ```
    # ./diffdock_parallel.sh -h
    
    Parámetros:
      num_procesos     Número de procesos en paralelo a ejecutar.
      ruta_diffdock    Ruta a la carpeta de instalación de DiffDock.
      ruta_dataset     Ruta al dataset con proteínas y ligandos.
      ruta_resultados  Carpeta donde se guardarán los resultados.

    Ejemplo:
      ./diffdock_parallel.sh 4 ~/DiffDock ~/docking/data_sets/posebusters_benchmark_set ~/docking/results/results_posebuster_diffdock_start
    ```
    
    ❗**Requisitos:**
          Repositorio de la herramienta  [DiffDock](https://github.com/gcorso/DiffDock) y
          Entorno conda *diffdock* para la ejecución (se activa dentro del script).

  ### EquiBind
    - *scriptequibind.sh*
       Script para ejecutar EquiBind sobre un conjunto de complejos proteína-ligando y obtener la evaluación de los resultados mediante PoseBusters.

  **Uso**
    ```bash
    ./scriptequibind.sh <ruta_equibind> <ruta_dataset> <ruta_resultados>
    ```

    ```
    # ./scriptequibind.sh -h
    Parámetros:
      ruta_equibind    Ruta al repositorio de EquiBind.
      ruta_dataset     Ruta al dataset con proteínas y ligandos.
      ruta_resultados  Carpeta donde se guardarán los resultados.


    Ejemplo:
      ./scriptequibind.sh $HOME/EquiBind $HOME/docking/data_sets/posebusters_benchmark_set $HOME/docking/results/results_posebusters_equibind
    ```
    
    ❗**Requisitos:**
          Repositorio de la herramienta  [EquiBind](https://github.com/HannesStark/EquiBind) y
          Entorno conda equibind para la ejecución.

  ### DeepDock
    - *scriptdeepdock.sh*
      Script para ejecutar DeepDock sobre un conjunto de complejos proteína-ligando

      **Uso**
      
      ```bash
      ./scriptdeepdock.sh <set> <input_dir>
      ```

      ```bash
      # ./scriptdeepdock.sh -h
        Parámetros:
          set         Nombre del conjunto de docking (por ejemplo, posebusters_benchmark_set).
          input_dir   Ruta al directorio donde están las carpetas de los complejos.

        Ejemplo:
          ./scriptdeepdock.sh posebusters_benchmark_set ../posebusters_benchmark_set
      ```
    - *docking.py*
      Script auxiliar para realizar la inferencia con DeepDock.
   
     - *bustdeepdock.sh*
      Script para obtener la evaluación de los resultados mediante PoseBusters.
  
    **Uso**
  
          ```bash
              ./bustdeepdock.sh <input_dir> <out_dir>
          ```

          ```bash
              # ./bustdeepdock.sh -h
              Parámetros:
                  input_dir   Ruta al directorio donde están las carpetas de los complejos.
                  out_dir     Carpeta donde se guardarán los resultados.

              Ejemplo:
                  ./bustdeepdock.sh $HOME/docking/data_sets/posebusters_benchmark_set $HOME/docking/results
          ```

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
        ./scriptdeepdock.sh astex_diverse_set ../astex_diverse_set
    ```
    
    ```bash
        #  salir del contenedor (esto también lo detiene)
        exit
    ```
    
    ```bash
        # evaluar con PoseBusters (ya en el host)
        ./bustdeepdock.sh ../astex_diverse_set results/result_astex_diverse_set
    ```
   
      
  ### **UniMol**
    - *scriptunimol.sh*
      Script para ejecutar UniMol Docking sobre un conjunto de complejos proteína-ligando.

      **Uso**
    ```bash
    ./scriptunimol.sh <ruta_unimol> <ruta_dataset> <ruta_resultados> <ruta_script_grid>
    ```
    
    ```
    Parámetros:
      ruta_unimol      Ruta al repositorio de UniMol.
      ruta_dataset     Ruta al dataset con proteínas y ligandos.
      ruta_resultados  Carpeta donde se guardarán los resultados.
      ruta_script_grid Ruta al script unimol_grid.py.

    Ejemplo:
      ./scriptunimol.sh $HOME/Uni-Mol $HOME/docking/data_sets/posebusters_benchmark_set $HOME/docking/results/results_pb_start_gridlig_unimol docking/scripts/unimol_grid.py
    ```
  
    - *unimol_grid.py*
      Script para calcular la malla de docking del complejo. Es llamado por  *scriptunimol.sh*
      
     ❗**Requisitos:**
                  Repositorio de la herramienta  [UniMol](https://github.com/deepmodeling/Uni-Mol/tree/main/unimol_docking_v2) y
                  Entorno conda unicore para la ejecución.

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

