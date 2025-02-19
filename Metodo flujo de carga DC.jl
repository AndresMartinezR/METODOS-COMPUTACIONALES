using Pkg
using LinearAlgebra
using Plots 
using DataFrames
using CSV
using Statistics
using Plots
using StatsPlots  



function B(lines, nodes)
    """
    Función para calcular la matriz de susceptancias B.
    Se asume que la reactancia es mucho mayor que la resistencia, por lo que la resistencia es despreciable.
    """
    numero_lineas= nrow(lines) 
    numero_nodos = nrow(nodes)  # Número de nodos
    B = zeros(numero_nodos, numero_nodos)  # Crear matriz de ceros de dimensiones n x n

    # Llenar la matriz B con los valores de 1/X
    for k in 1:numero_lineas
        envio = lines.FROM[k]  # Nodo de envío
        recibo = lines.TO[k]    # Nodo de recepción
        BL = 1 / lines.X[k]     # Susceptancia de la línea k

        # Llenar la matriz B
        B[envio, envio] += BL  # Diagonal de la susceptancia
        B[envio, recibo] -= BL # Fuera de la diagonal
        B[recibo, envio] -= BL # Fuera de la diagonal
        B[recibo, recibo] += BL # Diagonal de la susceptancia
    end
    nodo_referencia = 1  # Nodo de referencia (Slack)
    nodos_independientes = setdiff(1:numero_nodos, nodo_referencia)  # Nodos independientes, quita el nodod de referencia
    
    # Calcular la matriz de susceptancias B
     # Matriz de susceptancias singular
    B_independiente = B[nodos_independientes, nodos_independientes]  # Matriz de susceptancias independientes

    return B_independiente
end

function P_inyectadas(nodes, referencia)
    """
    Función para calcular el vector de potencias netas inyectadas.

    entradas, datos de nodos y nodo de referencia
    """
    numero_nodos = nrow(nodes)  # Número de nodos
    P_inyectadas = zeros(numero_nodos - 1)  # Vector de potencias inyectadas (excluyendo el nodo 1 de referencia)

    for k in 1:numero_nodos # k va desde 1 hasta el nuero de nodos
        if k != referencia #si k es diferente del nodo de referencia, haciendo que el vector P_inyectadas quede completo sin mas ni menos elementos
            Pgen = nodes.PGEN[k]  # Generación en el nodo k
            Pload = nodes.PLOAD[k]  # Carga en el nodo k
            Ptotal = Pgen - Pload  # Potencia neta inyectada PGEN - PLOAD

            # Ajustar el índice para excluir el nodo de referencia
            if k < referencia
                P_inyectadas[k] = Ptotal
            else
                P_inyectadas[k - 1] = Ptotal
            end
        end
    end

    return P_inyectadas
end


function Flujo_potencias(lines, nodes,B)
    """
    Función para calcular los flujos de potencia y los ángulos nodales.
    """
    numero_nodos = nrow(nodes)  # Número de nodos
    numero_lineas = nrow(lines) 
    nodo_referencia = 1  # Nodo de referencia (Slack)

    B_independiente = B
    # Calcular el vector de potencias inyectadas
    P_inyectadas_vec = P_inyectadas(nodes, nodo_referencia)
    nodos_independientes = setdiff(1:numero_nodos, nodo_referencia)  # Nodos independientes, quita el nodod de referencia


    # Calcular los ángulos nodales
    Vector_angulos = zeros(numero_nodos)
    Vector_angulos[nodos_independientes] = B_independiente \ P_inyectadas_vec  # Resolver el sistema lineal

    # Calcular los flujos de potencia
    P_flujos = zeros(numero_lineas)  # Vector de flujos de potencia

    for k in 1:numero_lineas
        envio = lines.FROM[k]  # Nodo de envío
        recibo = lines.TO[k]   # Nodo de recepción
        Xpq = lines.X[k]       # Reactancia de la línea k

        # Obtener los ángulos de los nodos de envío y recepción
        Angulo_envio = (envio == nodo_referencia) ? 0 : Vector_angulos[envio]
        Angulo_recibo = (recibo == nodo_referencia) ? 0 : Vector_angulos[recibo]

        # Calcular el flujo de potencia en la línea k
        P_flujos[k] = (Angulo_envio - Angulo_recibo) / Xpq
    end

    return P_flujos, Vector_angulos
end


function Analisis_contingencia(lines, nodes)

    B_indenpendiente = B(lines, nodes)

    numero_lineas = nrow(lines)
    resultados_flujos_potencia = [] # se crean listas vacias de los resultados a obtener en cada co ntingencia
    resultados_angulos_nodales = []

    for k = 1 : numero_lineas

        lineas_sin_falla = filter(row -> row.FROM != lines.FROM[k] || row.TO != lines.TO[k], lines)

        P_flujos, Angulos_nodales = Flujo_potencias(lineas_sin_falla, nodes, B_indenpendiente)

        # La función push! agrega el resultado de Flujos_dc al final de la lista 'resultados'.
        push!(resultados_flujos_potencia, P_flujos)
        push!(resultados_angulos_nodales, Angulos_nodales)
    end



end



# Función principal
# Cargar los datos de líneas y nodos
lines = DataFrame(CSV.File("lines.csv"))
nodes = DataFrame(CSV.File("nodes.csv"))

BL = B(lines, nodes)

# Calcular los flujos de potencia en el sistema original
FLUJO = Flujo_potencias(lines, nodes, BL)
resultados = Analisis_contingencia(lines, nodes)
