"""
Análisis de contingencias para un sistema de potencia.  
Este código evalúa el impacto de la pérdida de líneas de transmisión en la operación del sistema eléctrico,  
calculando los flujos de potencia en cada contingencia.  

Autor: Andres Felipe Martinez Rodriguez  
CC: 1110592058  
"""

# Importación de librerías necesarias
using Pkg          # Administración de paquetes en Julia
using LinearAlgebra # Operaciones con matrices y álgebra lineal
using DataFrames   # Manipulación de datos en formato tabular
using CSV          # Lectura y escritura de archivos CSV


function Susceptancia(lines, nodes)
    """
    Función para calcular la matriz de susceptancia B del sistema.  
    Se obtiene a partir de los datos de las líneas de transmisión y los nodos del sistema.
    
    Entradas:
    - lines: DataFrame con los datos de las líneas de transmisión.
    - nodes: DataFrame con los datos de los nodos del sistema.
    
    Salida:
    - B_reducida::Matrix{Float64}: Matriz de susceptancia reducida (sin el nodo de referencia)
    """
    numero_lineas = nrow(lines)  # Número total de líneas
    numero_nodos = nrow(nodes)   # Número total de nodos

    B = zeros(numero_nodos, numero_nodos)  # Inicialización de la matriz de susceptancia

    # Cálculo de la matriz B a partir de las reactancias de línea
    for k = 1:numero_lineas
        envio = lines.FROM[k]   # Nodo de envío de la línea
        recibo = lines.TO[k]    # Nodo de recepción de la línea
        BL = 1 / lines.X[k]     # Susceptancia de la línea k (1/X)

        # Se actualizan las posiciones correspondientes en la matriz B
        B[envio, envio] += BL  
        B[envio, recibo] -= BL 
        B[recibo, envio] -= BL 
        B[recibo, recibo] += BL 
    end

    nodo_referencia = 1  # Se toma el nodo 1 como referencia
    # Se elimina la fila y columna del nodo de referencia para obtener B reducida
    B_reducida = B[1:end .!= nodo_referencia, 1:end .!= nodo_referencia]

    return B_reducida
end


function Potencias_iny(nodes)
    """
    Función para calcular el vector de potencias inyectadas en cada nodo del sistema.  
    Se obtiene como la diferencia entre la generación de potencia y la carga en cada nodo.
    Entradas:
    - nodes: DataFrame con los datos de los nodos.
    
    Salida:
    - P_reducido::Vector{Float64}: Vector de potencias inyectadas (sin el nodo de referencia).
    """
    cantidad_nodos = nrow(nodes)  # Número total de nodos
    Potencias_iny = zeros(cantidad_nodos)  # Vector de potencias inicializado en ceros
    
    # Cálculo de la potencia inyectada en cada nodo
    for k = 1:cantidad_nodos
        Pgen = nodes.PGEN[k]   # Potencia generada en el nodo k
        Pload = nodes.PLOAD[k] # Potencia demandada en el nodo k
        Potencias_iny[k] = Pgen - Pload  # Potencia neta inyectada (PGEN - PLOAD)
    end

    P_reducido = Potencias_iny[2:end]  # Se excluye el nodo de referencia
    return P_reducido
end


function vector_angulos(B, P)
    """
    Función para calcular el vector de ángulos de fase en los nodos del sistema  
    utilizando la matriz de susceptancia reducida y el vector de potencias inyectadas.
    
    Entrada:
    - B::Matrix{Float64}: Matriz de susceptancia reducida.
    - P::Vector{Float64}: Vector de potencias inyectadas.
    Salida:
    - vector_angulos::Vector{Float64}: Vector de ángulos nodales (con nodo de referencia).
    """
    vector_angulos = pinv(B) * P  # Resolviendo el sistema de ecuaciones B * θ = P
    insert!(vector_angulos, 1, 0.0)  # Se agrega el nodo de referencia con ángulo 0
    return vector_angulos
end


function flujo_dc(lines, nodes, c)
    """
    Función para calcular los flujos de potencia en cada línea del sistema  
    usando el modelo de flujo de potencia DC.

    Entradas:
    - lines: DataFrame con los datos de las líneas de transmisión.
    - nodes: DataFrame con los datos de los nodos.
    - vector_ang::Vector{Float64}: Vector de ángulos nodales.
    
    Salida:
    - P_flujos::Vector{Float64}: Vector con los flujos de potencia por línea.
    
    """
    num_nodos = nrow(nodes)  # Número total de nodos
    num_lineas = nrow(lines)  # Número total de líneas
    P_flujos = zeros(num_lineas)  # Vector para almacenar los flujos calculados
    vector_ang = c  # Vector de ángulos nodales

    # Cálculo del flujo de potencia en cada línea
    for k in 2:num_lineas
        envio = lines.FROM[k]   # Nodo de envío de la línea
        recibo = lines.TO[k]    # Nodo de recepción de la línea
        Xpq = lines.X[k]        # Reactancia de la línea

        # Diferencia de ángulos entre los nodos de la línea
        Angulo_envio = vector_ang[envio]
        Angulo_recibo = vector_ang[recibo]

        # Cálculo del flujo de potencia por la línea
        P_flujos[k] = (Angulo_envio - Angulo_recibo) / Xpq
    end

    return P_flujos
end


function eliminar_fila(df::DataFrame, fila_a_eliminar::Int)
    """
    Función auxiliar para eliminar una fila de un DataFrame.
    """
    df_filtrado = df[1:end .!= fila_a_eliminar, :]  # Se excluye la fila especificada
    return df_filtrado
end


function analisis_contingencias(lines::DataFrame, nodes::DataFrame)
    """
    Función principal para realizar el análisis de contingencias.  
    Se eliminan líneas del sistema una por una, y se recalculan los flujos y ángulos.
    Entradas:
    - lines: DataFrame con los datos de las líneas.
    - nodes: DataFrame con los datos de los nodos.
    
    Salidas:
    - resultados_flujos_potencia::Vector{Vector{Float64}}: Lista de flujos de potencia para cada contingencia.
    - resultados_angulos::Vector{Vector{Float64}}: Lista de ángulos nodales para cada contingencia.
    """
    num_lineas = nrow(lines)  # Número total de líneas
    resultados_flujos_potencia = []
    resultados_angulos = []

    # Se evalúa el sistema ante la pérdida de cada línea
    for i in 1:num_lineas
        println("Eliminando la línea ", i, " y recalculando los flujos de potencia.")

        # Se elimina la línea i y se recalcula el sistema
        lines_filtrado = eliminar_fila(lines, i)
        B_filtrado = Susceptancia(lines_filtrado, nodes)
        Potencias = Potencias_iny(nodes)
        angulos = vector_angulos(B_filtrado, Potencias)
        flujos = flujo_dc(lines_filtrado, nodes, angulos)

        # Se almacenan los resultados
        push!(resultados_flujos_potencia, flujos)
        push!(resultados_angulos, angulos)

        println("Flujos calculados para la contingencia ", i, ": ", length(flujos))
        println("Ángulos calculados: ", length(angulos))
    end

    return resultados_flujos_potencia, resultados_angulos
end

function graficar_cajas_bigotes(flujos, angulos)
    
    """
    Función para graficar diagramas de caja y bigotes de los flujos de potencia y ángulos nodales  
    en cada contingencia analizada.
    
    Entrada:
    - flujos::Vector{Vector{Float64}}: Lista de vectores con los flujos de potencia en cada contingencia.
    - angulos::Vector{Vector{Float64}}: Lista de vectores con los ángulos nodales en cada contingencia.
    
    Salida:
    - Muestra dos gráficos de caja y bigotes:
      1. Distribución de los flujos de potencia por contingencia.
      2. Distribución de los ángulos nodales por contingencia.
    """
    
    num_contingencias = length(flujos)  # Número total de contingencias

    # Etiquetas para el eje X
    labels = ["Cont. $i" for i in 1:num_contingencias]

    # Gráfica de flujos de potencia
    grafica1 = boxplot(flujos, labels=labels, title="Distribución de Flujos por Contingencia",
            ylabel="Flujo de Potencia", xlabel="Contingencia", legend=false, xticks=(1:10:num_contingencias))
    display(grafica1)

    # Gráfica de ángulos nodales
    grafica2 = boxplot(angulos, labels=labels, title="Distribución de Ángulos por Contingencia",
            ylabel="Ángulo (rad)", xlabel="Contingencia", legend=false, xticks=(1:10:num_contingencias))
    display(grafica2)
end

# Función principal
# Cargar los datos de líneas y nodos
lines = DataFrame(CSV.File("lines.csv"))
nodes = DataFrame(CSV.File("nodes.csv"))

# Calcular la matriz de susceptancia para los dos casos
B_ind= Susceptancia(lines, nodes)

angulos = vector_angulos(B_ind, Potencias)

flujos = flujo_dc(lines, nodes, angulos)

# Ejecutar el análisis de contingencias
resultados_flujos = analisis_contingencias(lines, nodes)


flujos, angulos = analisis_contingencias(lines, nodes)
graficar_cajas_bigotes(flujos, angulos)



