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

# Para iniciar se hace una funcion para calcular la matriz B

function Susceptancia(lines, nodes)
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


function Factor_cambio_generacional(lines, B)
    """
    Entradas: lineas, nodos, Matriz B(Ybus)
    Salidas: Vector sensibilidad respecto a una generacion

    """
  
    numero_lineas = nrow(lines)
    w = inv(B)
    #agregar columna y fila de ceros
    alphali = zeros(numero_lineas)
    for k = 1: numero_lineas
        envio = lines.FROM[k]
        recibo = lines.TO[k]
        alpha = (1/lines.X[k])*(w[envio], w[recibo])

    end
    return alphali
end


function phi_il(lines, B)
    """
    Entradas: Datos linea, Matriz Susceptancia(Ybus)
    Salidas: Vectro phi_il
    """
    w = inv(B)
    cantidad_lineas = nrow(lines)
    phi_il = zeros(cantidad_lineas)

    for k =1: cantidad_lineas

        envio = lines.FROM[k]
        recibo = lines.TO[k]
        reactancia = lines.X[k]
        numerador = reactancia*(w[i][envio] - w[i][recibo])
        denominador = reactancia + (w[envio][envio]-w[recibo][recibo]-2*w[recibo][envio])
        phi_il[k]= numerador/denominador
    end
    
    return phi_il

end


function Sensibilidad_B(lines, ph)
    """
    Entradas: Datos linea, phi_il


    Salidas: matriz de sensibilidad Betha
    """
    cantidad_ramas = nrow(lines)
   
    phi = ph
    betha = zeros(cantidad_ramas, cantidad_ramas)
    for k = 1: cantidad_ramas
        envio = lines.FROM[k]
        recibo = lines.TO[k]
        reactancia = lines.X[k]

        betha[k] = (1/reactancia)*(phi[envio][recibo]- phi[envio][recibo])
    end

    return betha
end

# Función principal
# Cargar los datos de líneas y nodos
lines = DataFrame(CSV.File("lines.csv"))
nodes = DataFrame(CSV.File("nodes.csv"))

B_ind = Susceptancia(lines, nodes)
Factor_gen = Factor_cambio_generacional(lines, B_ind)
phi = phi_il(lines, B_ind)
betha = Sensibilidad_B(lines, phi)

println("Betha", betha)



