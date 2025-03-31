"""
Cálculo de la matriz de admitancia nodal Ybus considerando transformadores con taps.

Nombre: Andres Felipe Martinez Rodriguez
"""

using Pkg
using LinearAlgebra
using Plots 
using DataFrames
using CSV

# Función para calcular la matriz de admitancia nodal (Ybus)
function calcular_ybus(lines, nodes)
    """
    Entrada:
    - lines: DataFrame que contiene la información de las líneas de transmisión.
    - nodes: DataFrame que contiene la información de los nodos del sistema.
    
    Salida:
    - Ybus: Matriz de admitancia nodal.
    """
    num_nodes = nrow(nodes)  # Número total de nodos en el sistema
    num_lines = nrow(lines)  # Número total de líneas en el sistema
    Ybus = zeros(num_nodes, num_nodes) * 1im  # Inicialización de la matriz Ybus con ceros complejos
    
    for k = 1:num_lines  # Iteración sobre todas las líneas para construir la matriz Ybus
        n1 = lines.FROM[k]  # Nodo de envío de la línea
        n2 = lines.TO[k]    # Nodo de recepción de la línea
        yL = 1 / (lines.R[k] + lines.X[k] * 1im)  # Cálculo de la admitancia de la línea (inversa de la impedancia)
        Bs = lines.B[k] * 1im / 2  # Admitancia shunt (modelo pi), dividida entre 2 para cada extremo de la línea
        
        y_m = 0  # Inicialización de la admitancia shunt en el nodo de envío
        y_p = 0  # Inicialización de la admitancia shunt en el nodo de recepción
        
        if lines.TAP[k] != 0.0  # Verificación de la presencia de un tap en el transformador
            t = lines.TAP[k]  # Relación de transformación del tap
            yL = t * yL  # Ajuste de la admitancia según la relación de tap
            y_m = (t^2 - t) * yL  # Admitancia shunt en el nodo de envío
            y_p = (1 - t) * yL  # Admitancia shunt en el nodo de recepción
        end
        
        # Actualización de los elementos de la matriz Ybus
        Ybus[n1, n1] += yL + y_m + Bs  # Elemento diagonal del nodo de envío
        Ybus[n1, n2] -= yL  # Elemento fuera de la diagonal (acoplamiento entre nodos)
        Ybus[n2, n1] -= yL  # Elemento fuera de la diagonal (acoplamiento entre nodos)
        Ybus[n2, n2] += yL + y_p + Bs  # Elemento diagonal del nodo de recepción
    end
    
    return Ybus  # Retorno de la matriz Ybus calculada
end

# Carga de datos desde archivos CSV
lines = DataFrame(CSV.File("lines.csv"))  # Carga del archivo de líneas de transmisión
nodes = DataFrame(CSV.File("nodes.csv"))  # Carga del archivo de nodos

# Cálculo de la matriz de admitancia nodal
Ybus = calcular_ybus(lines, nodes)



