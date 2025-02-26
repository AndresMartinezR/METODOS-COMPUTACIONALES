# **TAREA Nro. 2: Análisis de Sensibilidad en Sistemas de Potencia**

## **Descripción**
Este proyecto implementa un análisis de sensibilidad para evaluar el comportamiento de un sistema eléctrico de potencia ante cambios en la generación y la desconexión de líneas. Se calculan los factores de cambio generacional (\(\alpha\)), los factores de distribución de flujos (\(\beta\)) y los factores de distribución de ángulos (\(\delta\)), utilizando datos extraídos de archivos CSV. Estos factores permiten predecir cómo varían los flujos de potencia en las líneas ante contingencias o cambios en la generación.

---

## **Introducción**
El análisis de sensibilidad es una herramienta fundamental en la operación y planificación de sistemas de potencia. Permite evaluar cómo las modificaciones en la generación o la topología de la red afectan los flujos de potencia y los ángulos de fase en los nodos. Este proyecto se centra en calcular y visualizar los factores de sensibilidad para un sistema de potencia dado, utilizando un modelo linealizado de flujo de carga DC.

---

## **Marco Teórico**
El análisis de sensibilidad se basa en la linealización del flujo de carga DC, donde se asumen condiciones ideales, como la ausencia de pérdidas por resistencia y la consideración exclusiva de la componente reactiva. Los factores de sensibilidad se calculan a partir de la matriz de susceptancia reducida (\(B\)), permitiendo predecir los cambios en los flujos de potencia ante contingencias o modificaciones en la generación.

### **Factores de Sensibilidad**
1. **Factores de Cambio Generacional (\(\alpha\))**:
   - Miden la variación en el flujo de una línea ante un cambio en la generación en un nodo.
   - Se definen como:
     \[
     \alpha_{\ell i} = \frac{\Delta f_{\ell}}{\Delta P_i}
     \]
   - Donde:
     - \(\Delta f_{\ell}\): Cambio en el flujo de la línea \(\ell\).
     - \(\Delta P_i\): Cambio en la generación en el nodo \(i\).

2. **Factores de Distribución de Flujos (\(\beta\))**:
   - Miden la variación en el flujo de una línea ante la desconexión de otra línea.
   - Se expresan como:
     \[
     \beta_{\ell k} = \frac{\Delta f_{\ell}}{f_k^0}
     \]
   - Donde:
     - \(\Delta f_{\ell}\): Cambio en el flujo de la línea \(\ell\).
     - \(f_k^0\): Flujo de potencia en la línea \(k\) antes de su desconexión.

3. **Factores de Distribución de Ángulos (\(\delta\))**:
   - Miden la variación en los ángulos de fase en los nodos tras la desconexión de una línea.
   - Se calculan como:
     \[
     \delta_{i k} = \frac{\Delta \theta_i}{f_k^0}
     \]
   - Donde:
     - \(\Delta \theta_i\): Cambio en el ángulo de fase en el nodo \(i\).
     - \(f_k^0\): Flujo de potencia en la línea \(k\) antes de su desconexión.

---

## **Librerías Utilizadas**
El código está implementado en Julia y requiere las siguientes librerías:
```julia
using Pkg
using LinearAlgebra
using DataFrames
using CSV
using Plots
```

---

## **Funciones Implementadas**

1. **`Susceptancia(lines, nodes)`**:
   - Calcula la matriz de susceptancia reducida (\(W\)).
   - **Entradas**:
     - `lines`: DataFrame con las líneas del sistema (columnas: `FROM`, `TO`, `X`).
     - `nodes`: DataFrame con los nodos del sistema.
   - **Salida**:
     - Matriz de susceptancia reducida (\(W\)).

2. **`Factor_cambio_generacional(lines, nodes, w)`**:
   - Calcula la matriz de factores de cambio generacional (\(\alpha\)).
   - **Entradas**:
     - `lines`: DataFrame con las líneas del sistema.
     - `nodes`: DataFrame con los nodos del sistema.
     - `w`: Matriz de susceptancia reducida.
   - **Salida**:
     - Matriz de factores de cambio generacional (\(\alpha\)).

3. **`δ_il(lines, nodes, w)`**:
   - Calcula la matriz de factores de distribución de ángulos (\(\delta\)).
   - **Entradas**:
     - `lines`: DataFrame con las líneas del sistema.
     - `nodes`: DataFrame con los nodos del sistema.
     - `w`: Matriz de susceptancia reducida.
   - **Salida**:
     - Matriz de factores de distribución de ángulos (\(\delta\)).

4. **`betha_lh(lines, delta)`**:
   - Calcula la matriz de factores de distribución de flujos (\(\beta\)).
   - **Entradas**:
     - `lines`: DataFrame con las líneas del sistema.
     - `delta`: Matriz de factores de distribución de ángulos.
   - **Salida**:
     - Matriz de factores de distribución de flujos (\(\beta\)).

5. **`grafica_resultados(BETHA, Factor_generacion, delta)`**:
   - Genera mapas de calor para visualizar los factores de sensibilidad.
   - **Entradas**:
     - `BETHA`: Matriz de factores de distribución de flujos (\(\beta\)).
     - `Factor_generacion`: Matriz de factores de cambio generacional (\(\alpha\)).
     - `delta`: Matriz de factores de distribución de ángulos (\(\delta\)).
   - **Salida**:
     - Gráficos de los factores de sensibilidad.

---

## **Interpretación de los Resultados**
Los factores de sensibilidad se presentan en forma de mapas de calor para facilitar su interpretación:
- **Factores de Cambio Generacional (\(\alpha\))**:
  - Representan la sensibilidad del flujo de una línea ante una inyección de potencia en un nodo.
  - Valores altos(Tono de color amarillo), representan alta sensibilidad y por lo tanto aumento de flujo de potencia por la linea km frente a la inyeccion de potencia en el nodo i. Por ejemplo, en este proyecto la linea 2 representa gran sensibilidad frente a la inyeccion de potecnia en el nodo 4

- **Factores de Distribución de Flujos (\(\beta\))**:
  - Representan la redistribución de flujos cuando se desconecta una línea.
  - Valores altos(tono de color amarillo) representan gran sensibilidad de la linea monitoreada frente a la linea desconectada. En este proyecto la linea monitoreada 5, representa gran sesnibilidad frente a la desconexion de la linea 2 

---

## **Licencia y Contacto**
**Autor:** Andrés Felipe Martínez Rodríguez  
**Correo:** felipe.martinez1@utp.edu.co

