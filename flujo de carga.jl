"""
Cálculo de la matriz de admitancia nodal Ybus considerando transformadores con taps.

Nombre: Andres Felipe Martinez Rodriguez
CC: 1110592058
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
        
        
        # Actualización de los elementos de la matriz Ybus
        Ybus[n1, n1] += yL + Bs  # Elemento diagonal del nodo de envío
        Ybus[n1, n2] -= yL  # Elemento fuera de la diagonal (acoplamiento entre nodos)
        Ybus[n2, n1] -= yL  # Elemento fuera de la diagonal (acoplamiento entre nodos)
        Ybus[n2, n2] += yL + Bs  # Elemento diagonal del nodo de recepción
    end
    
    return Ybus  # Retorno de la matriz Ybus calculada
end



# Cargar los datos de líneas y nodos
lines = DataFrame(CSV.File("lines.csv"))
nodes = DataFrame(CSV.File("nodes.csv"))

# Función para eliminar la letra "N" de una cadena
remove_n(s) = replace(s, "N" => "")

# Procesar las columnas FROM y TO en lines
if :FROM in propertynames(lines) && :TO in propertynames(lines)
    # Aplicar la función a las columnas FROM y TO
    lines.FROM = remove_n.(lines.FROM)
    lines.TO = remove_n.(lines.TO)

    # Opcional: Convertir las columnas a tipo numérico (Int)
    lines.FROM = parse.(Int, lines.FROM)
    lines.TO = parse.(Int, lines.TO)

    # Guardar el archivo CSV modificado
    CSV.write("lines_modified.csv", lines)
    println("Archivo 'lines_modified.csv' guardado correctamente.")
else
    println("Las columnas 'FROM' y 'TO' no existen en el archivo 'lines.csv'.")
end

# Procesar la columna de nodos en nodes (asumiendo que la columna se llama "NODE")
if :NODE in propertynames(nodes)
    # Aplicar la función a la columna NODE
    nodes.NODE = remove_n.(nodes.NODE)

    # Opcional: Convertir la columna a tipo numérico (Int)
    nodes.NODE = parse.(Int, nodes.NODE)

    # Guardar el archivo CSV modificado
    CSV.write("nodes_modified.csv", nodes)
    println("Archivo 'nodes_modified.csv' guardado correctamente.")
else
    println("La columna 'NODE' no existe en el archivo 'nodes.csv'.")
end

# Cargar los archivos modificados
linesm = DataFrame(CSV.File("lines_modified.csv"))

# Calcular Ybus (asumiendo que tienes una función llamada `calcular_ybus`)
Ybus = calcular_ybus(linesm, nodes)