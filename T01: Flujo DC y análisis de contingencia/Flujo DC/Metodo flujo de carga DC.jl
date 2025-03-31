"""
Este codigo aplica el metodo de Flujo de carga DC para un sistema de terminado, a partir de sus datos de linea y datos nodales

Autor: Andres Felipe Martinez Rodriguez  
"""

using Pkg
using LinearAlgebra
using DataFrames
using CSV

function Susceptancia(lines, nodes)
    """Se crean funcion de matriz de susceptancia independiente
    Entradas:
    -lines::DataFrame: DataFrame con información de las líneas de transmisión
    -nodes::DataFrame: DataFrame con información de los nodos.

    Salida:
    -B_reducida::Matrix{Float64}: Matriz de susceptancia reducida del sistema sin el nodo de referencia. Esta matriz es de dimensión (n-1) 
    x (n-1), donde n es el número total de nodos y el nodo de referencia (usualmente el nodo 1) se elimina.
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
    -nodes::DataFrame: DataFrame con información de los nodos.

    Salida: 
    - Vector de potencias inyectadas
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


# Función principal
# Cargar los datos de líneas y nodos
lines = DataFrame(CSV.File("lines.csv"))
nodes = DataFrame(CSV.File("nodes.csv"))

# Calcular la matriz de susceptancia para los dos casos
B_ind= Susceptancia(lines, nodes)

angulos = vector_angulos(B_ind, Potencias)

flujos = flujo_dc(lines, nodes, angulos)

