# Cálculo de la Matriz de Admitancia Nodal Ybus con Transformadores

**Descripción del Proyecto**

Este proyecto implementa el cálculo de la matriz de admitancia nodal **Ybus**, considerando la presencia de **transformadores con taps** en el sistema eléctrico de potencia.

La matriz **Ybus** es fundamental en los estudios de flujo de carga y análisis de estabilidad en redes de transmisión, ya que representa las relaciones de admitancia entre los nodos del sistema.

**Introducción**

En los sistemas de potencia, la matriz de admitancia nodal **Ybus** se construye a partir de las impedancias de las líneas de transmisión y las admitancias shunt. Además, cuando existen **transformadores con taps**, la matriz debe modificarse para reflejar el efecto de la relación de transformación en las admitancias de las líneas.

Este proyecto utiliza datos de líneas y nodos almacenados en archivos **CSV** y los procesa mediante **Julia**, aplicando principios de análisis de redes eléctricas.

**Marco Teórico**

La matriz de admitancia nodal **Ybus** se define como:
\[ Ybus = [Y_{ij}] \]
Donde:
- \( Y_{ii} \) representa la admitancia total del nodo \( i \) hacia tierra.
- \( Y_{ij} \) representa la admitancia mutua entre los nodos \( i \) y \( j \).
- Cuando hay **transformadores con taps**, la admitancia de la línea se modifica mediante la relación de transformación \( t \), afectando los términos diagonales y fuera de la diagonal.

\[ y' = \frac{1}{(R + jX)} \]
\[ Y' = t \cdot y' \]

**Funciones Implementadas**

`calcular_ybus(lines, nodes)`

Esta función calcula la matriz de admitancia nodal \( Ybus \) a partir de la información de las líneas de transmisión y los nodos.

**Parámetros:**
- `lines`: DataFrame con los datos de las líneas de transmisión (resistencia, reactancia, admitancia shunt, y taps de transformadores).
- `nodes`: DataFrame con los datos de los nodos del sistema.

**Salida:**
- `Ybus`: Matriz de admitancia nodal compleja.
**Archivos de Entrada***

- **`lines.csv`**: Contiene información sobre las líneas de transmisión.
    - `FROM`: Nodo de envío
    - `TO`: Nodo de recepción
    - `R`: Resistencia de la línea
    - `X`: Reactancia de la línea
    - `TAP`: Relación de transformación (si existe transformador)

- **`nodes.csv`**: Contiene información sobre los nodos del sistema.
    -

**Librerías Utilizadas***

El código hace uso de las siguientes librerías en **Julia**:

```julia
using Pkg
using LinearAlgebra  # Operaciones matriciales
using Plots          # Gráficos (opcional)
using DataFrames     # Manejo de tablas de datos
using CSV            # Lectura de archivos CSV
```

**Uso del Código**

Para ejecutar el código, asegúrate de tener instaladas las dependencias necesarias en Julia.

1. Cargar los datos de los archivos CSV:
   ```julia
   lines = DataFrame(CSV.File("lines.csv"))
   nodes = DataFrame(CSV.File("nodes.csv"))
   ```

2. Calcular la matriz de admitancia nodal:
   ```julia
   Ybus = calcular_ybus(lines, nodes)
   ```

3. (Opcional) Visualizar la matriz `Ybus`:
   ```julia
   display(Ybus)
   ```

**Licencia**

Hecho por: **Andrés Felipe Martínez Rodríguez**  
Correo: **felipe.martinez1@utp.edu.co**






