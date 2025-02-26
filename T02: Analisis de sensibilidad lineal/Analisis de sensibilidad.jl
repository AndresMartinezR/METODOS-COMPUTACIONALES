"""
CLASE 3. 19 / FEBRERO / 2025
ANALISIS DE SENSIBILIDAD
ANDRES FELIPE MARTINEZ RODRIGUEZ
CC 1110592058
"""

#Importar librerias
using Pkg
using LinearAlgebra
using DataFrames
using CSV
using Plots

# FUNCIONES
function Susceptancia(lines, nodes)
    """
    Calcula la matriz de susceptancia B reducida y su inversa, agregando una fila y columna de ceros.

    Entradas:
    - lines: DataFrame con las líneas del sistema (FROM, TO, X).
    - nodes: DataFrame con los nodos del sistema.

    Salidas:
    - Matriz W: Matriz de susceptancia B reducida, invertida y con una fila y columna de ceros agregadas.
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

    w = inv(B_reducida) # invertir matriz B independiente

    # Agregar columan y fila de ceros ambas en la primera posiciones
    columna_ceros = zeros(size(w,1))
    w_columna_ceros= hcat(columna_ceros,w)
    @info(w_columna_ceros)
    fila_ceros = zeros(1, size(w_columna_ceros, 2))

    w_con_fila_y_columna = vcat(fila_ceros, w_columna_ceros)
    printstyled("W CONFILA Y COLUMNA", w_con_fila_y_columna, color = :blue)

    return w_con_fila_y_columna
end

function Factor_cambio_generacional(lines, nodes, w)
    """
    Calcula la matriz de factores de distribución de generación (alpha Li).

    Entradas:
    - lines: DataFrame con las líneas del sistema (FROM, TO, X).
    - nodes: DataFrame con los nodos del sistema.
    - w: Matriz de susceptancia B reducida, invertida y con fila y columna de ceros agregadas.

    Salidas:
    - Matriz alphali: Matriz de factores de distribución de generación (líneas x nodos).
    """
    numero_lineas = nrow(lines)
    numero_nodos = nrow(nodes)
    W = w

    # crear matriz alpha Li lineas*nodos
    alphali = zeros(numero_lineas, numero_nodos)

    for k = 1: numero_lineas
        envio = lines.FROM[k]
        recibo = lines.TO[k]
        XL = lines.X[k]

        for j = 1:numero_nodos
            alphali[k, j] = (1/XL)*(W[envio, j]- W[recibo, j])
        end

    end
    return alphali
end

function δ_il(lines, nodes, w)
    """
    Calcula la matriz de factores de distribución de flujos (delta_il).

    Entradas:
    - lines: DataFrame con las líneas del sistema (FROM, TO, X).
    - nodes: DataFrame con los nodos del sistema.
    - w: Matriz de susceptancia B reducida, invertida y con fila y columna de ceros agregadas.

    Salidas:
    - Matriz δ_il: Matriz de factores de distribución de flujos (nodos x líneas).
    """
    cantidad_lineas = nrow(lines)
    cantidad_nodos = nrow(nodes)
    
    W= w
    # crear matriz alpha Li lineas*nodos
    δ_il = zeros(cantidad_nodos, cantidad_lineas)

    for k =1: cantidad_lineas

        envio = lines.FROM[k]
        recibo = lines.TO[k]
        reactancia = lines.X[k]
        
        for j=1:cantidad_nodos
            numerador = reactancia*(W[j,envio] - W[j,recibo])
            denominador = reactancia - (W[envio,envio]+W[recibo,recibo]-2*W[recibo, envio])
            δ_il[j, k]= numerador/denominador
        end
    end
    
    return δ_il

end

function betha_lh(lines, delta)
    """
    Calcula la matriz de sensibilidad Betha (L*L) a partir de la matriz de factores de distribución de flujos (delta).

    Entradas:
    - lines: DataFrame con las líneas del sistema (FROM, TO, X).
    - delta: Matriz de factores de distribución de flujos (nodos x líneas).

    Salidas:
    - Matriz betha: Matriz de sensibilidad Betha (líneas x líneas), con la diagonal en cero y redondeada a 2 decimales.
    """
    cantidad_ramas = nrow(lines)
    Delta = delta
    
    betha = zeros(cantidad_ramas, cantidad_ramas)
    for k = 1:cantidad_ramas
        envio = lines.FROM[k]
        recibo = lines.TO[k]
        XL = lines.X[k]
    
        for j = 1:cantidad_ramas
            # Calcular la sensibilidad
            betha[k, j] = (1 / XL) * (Delta[envio, j] - Delta[recibo, j])
        end
    end
    
        # Establecer la diagonal en cero
    for i = 1:cantidad_ramas
        betha[i, i] = 0.0
    end
    
    # Redondear la matriz betha a 2 decimales
    betha_redondeada = round.(betha, digits=2)
    
    return betha_redondeada
end

function grafica_resultados(BETHA, Factor_generacion, delta)
    """
    Grafica los factores de sensibilidad en un sistema de potencia.

    Argumentos:
    - BETHA: Matriz de factores de distribución de flujos (β).
    - Factor_generacion: Matriz de factores de cambio generacional (α).
    - delta: Matriz de factores de distribución de ángulos (δ).

    Retorna:
    - Tres gráficas: heatmaps(Mapas de calor) de δ, β y α.
    """

    # Graficar δ
    x = heatmap(abs.(delta), xlabel="Líneas (k)", ylabel="Nodos (i)",
                title="Factores de Distribución de Ángulos (δ)", color=:viridis)
    display(x)  # Mostrar la gráfica

    # Graficar β
    y = heatmap(abs.(BETHA), xlabel="Línea Desconectada (j)", ylabel="Línea Monitoreada (i)",
                title="Factores de Distribución de Flujos (β)", color=:viridis)
    display(y)  # Mostrar la gráfica

    # Graficar α
    z = heatmap(abs.(Factor_generacion), xlabel="Nodos (i)", ylabel="Líneas (ℓ)",
                title="Factores de Cambio Generacional (α)", color=:viridis)
    display(z)  # Mostrar la gráfica

    return x, y, z  # Retornar las gráficas 
end

# Cargar los datos de líneas y nodos
lines = DataFrame(CSV.File("lines.csv"))
nodes = DataFrame(CSV.File("nodes.csv"))

#EJECUTAR FUNCIONES
B_ind = Susceptancia(lines, nodes) #Funcion Susceptancia
Factor_gen = Factor_cambio_generacional(lines, nodes, B_ind) #Fucnion factor cambio generacional
println("FACTOR GEN", Factor_gen)
δ = δ_il(lines, nodes, B_ind) 
@info("δ iL =", δ)
BETHA = betha_lh(lines, δ)
println("BETHA = ", BETHA)

#GRAFICAR RESULTADOS OBTENIDOS
grafica = grafica_resultados(BETHA, Factor_gen, δ)

