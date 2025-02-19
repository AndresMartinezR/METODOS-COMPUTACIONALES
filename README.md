**TAREA: Cálculo de la Matriz de Admitancia Nodal**  
*Cálculo de Ybus para Sistemas de Potencia*

---

**Descripción del Proyecto**
Este proyecto desarrolla una función en Julia para calcular la matriz de admitancia nodal (*Ybus*) de un sistema de potencia a partir de los datos de líneas de transmisión y nodos. Se utilizan estructuras de datos en *DataFrames* para gestionar la información del sistema, y se implementa un algoritmo que computa la matriz *Ybus* a partir de la impedancia de las líneas y la admitancia de sus elementos π. Este proceso fue guiado por el docente para garantizar su correcta implementación.

---

**Introducción**
La matriz de admitancia nodal (*Ybus*) es una representación matricial de la red eléctrica utilizada en análisis de flujo de potencia y estabilidad de sistemas de potencia. Se construye a partir de los datos de impedancia de línea y admitancia de shunt, permitiendo determinar el comportamiento eléctrico del sistema.

En este proyecto, se implementa un algoritmo en Julia para calcular *Ybus* de manera automática a partir de archivos CSV con la información del sistema.

---
**Marco Teórico**
La matriz de admitancia nodal *Ybus* se define como:

\[ Y_{bus} = [y_{ij}] \]

Donde:
- **y_{ii}** es la suma de todas las admitancias conectadas al nodo *i* (incluyendo la admitancia de shunt).
- **y_{ij}** es la admitancia negativa entre los nodos *i* y *j* si existe una línea de transmisión que los conecta.

La admitancia de línea se calcula como:
\[ y_L = \frac{1}{R + jX} \]
Donde *R* y *X* son la resistencia y la reactancia de la línea respectivamente. Adicionalmente, si la línea tiene una admitancia de shunt *B*, se distribuye en ambos extremos como:
\[ B_s = \frac{B}{2} \]
Estas admitancias se suman a la diagonal de *Ybus*, mientras que los términos fuera de la diagonal se calculan restando la admitancia mutua entre los nodos conectados.

---

**Funciones Implementadas**

**Librerías Usadas**
El código utiliza las siguientes librerías:
```julia
using Pkg
using LinearAlgebra  # Operaciones matriciales
using DataFrames      # Manipulación de datos en formato tabular
using CSV             # Lectura de archivos CSV
```

**Descripción de la Funcionalidad**

1. **calcular_ybus(lines, nodes)**:
   - Entrada:
     - *lines*: DataFrame con información de las líneas de transmisión (nodos de inicio y fin, impedancias y admitancia shunt).
     - *nodes*: DataFrame con información de los nodos del sistema.
   - Salida:
     - Matriz *Ybus* de admitancia nodal.
   - Algoritmo:
     - Se inicializa una matriz de ceros imaginarios.
     - Se recorren todas las líneas y se calcula la admitancia *y_L*.
     - Se actualizan los términos de la diagonal y fuera de la diagonal en *Ybus*.

---

**Ejemplo de Uso**
```julia
# Cargar datos del sistema
lines = DataFrame(CSV.File("lines.csv"))  # Datos de líneas
nodes = DataFrame(CSV.File("nodes.csv"))  # Datos de nodos

# Calcular la matriz de admitancia nodal
Ybus = calcular_ybus(lines, nodes)
#Ybus = sparse(Ybus)  # Convertir a matriz dispersa si es necesario
```

---

**Licencia**
Hecho por: **Andrés Felipe Martínez**  
Email: **felipe.martinez1@utp.edu.co**  
Proceso guiado por el docente en el curso de Sistemas de Potencia.

