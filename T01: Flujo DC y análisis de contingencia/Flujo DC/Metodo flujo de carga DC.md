**TAREA nro.1: Flujo de Carga DC**

**Descripción**
En este proyecto se implementa un modelo de flujo de carga DC para analizar el comportamiento de un sistema eléctrico de potencia. Se calcula la matriz de susceptancia reducida (B), los ángulos de fase en cada nodo y los flujos de potencia en cada línea del sistema, utilizando datos extraídos de archivos CSV.

**Introducción**
El análisis de flujo de carga DC es una simplificación del flujo de potencia de corriente alterna (AC), en la cual se asumen condiciones ideales como la ausencia de pérdidas por resistencia y la consideración exclusiva de la componente reactiva. Esta metodología es ampliamente utilizada en estudios de estabilidad y despacho de generación.

**Marco Teórico**
El análisis de contingencias en sistemas de potencia permite evaluar la robustez del sistema ante la pérdida de elementos de la red, como líneas de transmisión o generadores.

El flujo de carga DC se basa en la solución del siguiente sistema de ecuaciones:

\[ B\theta = P \]

Donde:
- **B** es la matriz de susceptancia reducida del sistema.
- **\theta** es el vector de ángulos de fase en los nodos.
- **P** es el vector de potencias activas inyectadas.

Una vez obtenidos los ángulos, se calculan los flujos de potencia en las líneas mediante:

\[ P_{ij} = \frac{\theta_i - \theta_j}{X_{ij}} \]

Donde:
- **X_{ij}** es la reactancia de la línea entre los nodos \(i\) y \(j\).
- **P_{ij}** representa el flujo de potencia en la línea.

El proceso de análisis de contingencias consiste en eliminar una línea a la vez, recalcular la matriz de susceptancia *B* y obtener los nuevos flujos de potencia en la red.

![Diagrama Unifilar](Unifilar.png)

**Librerías Utilizadas**
El código está implementado en Julia y requiere las siguientes librerías:
```julia
using Pkg
using LinearAlgebra
using DataFrames
using CSV
```

**Funciones Implementadas**
**1. `Susceptancia(lines, nodes)`**
Calcula la matriz de susceptancia \( B \) reducida, eliminando el nodo de referencia.

**2. `Potencias_iny(nodes)`**
Calcula el vector de potencias inyectadas en cada nodo, considerando la diferencia entre la generación y la carga.

**3. `vector_angulos(B, P)`**
Resuelve el sistema de ecuaciones \( B \theta = P \) para encontrar el vector de ángulos nodales, estableciendo el nodo de referencia en \( 0^º \).

**4. `flujo_dc(lines, nodes, c)`**
Determina los flujos de potencia en cada línea utilizando el modelo de flujo de carga DC.

**Ejecución del Código**
El código principal carga los datos de nodos y líneas desde archivos CSV, y ejecuta los cálculos de flujo de carga DC:
```julia
# Cargar datos
lines = DataFrame(CSV.File("lines.csv"))
nodes = DataFrame(CSV.File("nodes.csv"))

# Calcular matriz de susceptancia
B_ind = Susceptancia(lines, nodes)

# Calcular ángulos nodales
angulos = vector_angulos(B_ind, Potencias_iny(nodes))

# Calcular flujos de potencia
flujos = flujo_dc(lines, nodes, angulos)
```

**Licencia**
Hecho por: **Andrés Felipe Martínez**  
Correo: **Felipe.martinez1@utp.edu.co**

