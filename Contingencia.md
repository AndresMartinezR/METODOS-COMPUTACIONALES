
**TAREA nro.1: Analisis de contingencias**  
*Flujo de carga DC y Análisis de Contingencias*

---

## Descripción del Proyecto
En este proyecto se desarrolla un modelo para el análisis de flujo de carga en corriente continua (DC) y el estudio de contingencias en un sistema eléctrico de potencia. Se utiliza la representación matricial de la red para calcular la matriz de susceptancia *B* y determinar los ángulos nodales y flujos de potencia en las líneas de transmisión bajo diferentes escenarios de falla.

---

**Introducción**
El flujo de carga en corriente continua es un método simplificado de análisis de sistemas de potencia en el que se consideran solo los flujos activos, despreciando las pérdidas y la componente reactiva. Este modelo permite obtener aproximaciones rápidas de los ángulos nodales y los flujos de potencia en las líneas, facilitando la evaluación del estado del sistema ante posibles contingencias.

En este trabajo, se implementa un algoritmo para calcular el flujo de potencia DC y evaluar el impacto de la pérdida de líneas de transmisión en la operación del sistema.

---

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

---
**Funciones Implementadas**

**Librerías Usadas**
El código utiliza las siguientes librerías:
```julia
using LinearAlgebra  # Operaciones matriciales
using DataFrames     # Manipulación de datos en formato tabular
using CSV            # Lectura y escritura de archivos CSV
```

**Descripción de las funciones principales**

1. **Susceptancia(lines, nodes)**:
   - Calcula la matriz de susceptancia *B* a partir de los datos de las líneas de transmisión.
   - Se obtiene la matriz reducida eliminando el nodo de referencia.

2. **Potencias_iny(nodes)**:
   - Calcula el vector de potencias inyectadas en cada nodo.
   - Se obtiene restando la carga de la generación en cada nodo.

3. **vector_angulos(B, P)**:
   - Resuelve el sistema de ecuaciones \( B\theta = P \) para obtener los ángulos de fase.
   - Agrega el nodo de referencia con ángulo 0.

4. **flujo_dc(lines, nodes, c)**:
   - Calcula los flujos de potencia en cada línea utilizando los ángulos nodales obtenidos.

5. **eliminar_fila(df::DataFrame, fila_a_eliminar::Int)**:
   - Elimina una fila de un DataFrame para simular la pérdida de una línea.

6. **analisis_contingencias(lines::DataFrame, nodes::DataFrame)**:
   - Itera sobre todas las líneas eliminándolas una por una.
   - Recalcula el flujo de potencia y los ángulos para cada contingencia.

7. **graficar_cajas_bigotes(flujos, angulos)**:
   - Genera diagramas de caja y bigotes para visualizar la distribución de flujos y ángulos bajo diferentes escenarios de contingencia.

**Ejemplo de Uso**
```julia
lines = DataFrame(CSV.File("lines.csv"))  # Carga de datos de líneas de transmisión
nodes = DataFrame(CSV.File("nodes.csv"))  # Carga de datos de nodos del sistema

B = Susceptancia(lines, nodes)  # Cálculo de la matriz de susceptancia
P = Potencias_iny(nodes)        # Obtención del vector de potencias inyectadas
angulos = vector_angulos(B, P)  # Cálculo de los ángulos nodales
flujos = flujo_dc(lines, nodes, angulos)  # Cálculo de flujos de potencia

# Análisis de contingencias
resultados_flujos, resultados_angulos = analisis_contingencias(lines, nodes)

# Graficar resultados
# graficar_cajas_bigotes(resultados_flujos, resultados_angulos)
```

---

**Licencia**
Hecho por: **Andrés Felipe Martínez**  
Email: **felipe.martinez1@utp.edu.co**  

Este código es de uso libre para fines académicos y de investigación.

---
