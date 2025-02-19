using Pkg
using LinearAlgebra
using Plots 
using DataFrames
using CSV

#Calcular la matriz de admitancia nodal

function calcular_ybus(lines,nodes)
"""
Entrada: lines: DataFrames
---------nodes : DataFrames
Salida: Ybus: matriz
"""
num_nodes = nrow(nodes) #Conjunto de nodos
num_lines = nrow(lines) #Conjunto de lineas
Ybus = zeros(num_nodes, num_nodes)*1im #Matriz Ybus llena de ceros
for k = 1:num_lines  #Numero de lineas para armar la Ybus
    n1 = lines.FROM[k]  #Nodo de envio. De lines Se llama el dato k de la columna FROM
    n2 = lines.TO[k]    #Nodo de recibo. De  lines Se llama el dato k de la columna TO
    yL = 1/(lines.R[k]+lines.X[k]*1im) # se invierte la impedancia para obtener la admitancia
    Bs =lines.B[k]*1im/2  # De  lines se llama el dato k de la columna B. se divide sobre dos porque es el modelo phi y la admitancia es Y/2 a cada extremo de la linea

    y_m = 0  # Inicializamos como cero, ya que será ajustado si hay tap
    y_p = 0  # Inicializamos como cero, ya que será ajustado si hay tap

    if lines.TAP[k] != 0.0
        # Si el valor de la columna TAPS es diferente de 0, aplica el ajuste de admitancia
        t = lines.TAP[k]  # Relación de tap
        yL = t*yL # Ajusta la admitancia según la relación de tap
        y_m = (t^2 -t)*yL # shunt nodo envio 
        y_p = (1-t)*yL # shunt nodo recibo

 
    end
    Ybus[n1,n1] += yL+ y_m + Bs#diagonal 
    Ybus[n1,n2] -= yL #Fuera diagonal 
    Ybus[n2,n1] -= yL #Fuera diagonal 
    Ybus[n2,n2] += yL+ y_p + Bs#diagonal 
end
return Ybus #Se retorna Ybus para que dicha matriz exista
end

# Funcion principal
lines= DataFrame(CSV.File("lines.csv"))
nodes= DataFrame(CSV.File("nodes.csv"))
Ybus = calcular_ybus(lines,nodes)
#Ybus = sparse(Ybus)

