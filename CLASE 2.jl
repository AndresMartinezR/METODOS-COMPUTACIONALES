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
    Ybus[n1,n1] += yL + Bs#diagonal 
    Ybus[n1,n2] -= yL #Fuera diagonal 
    Ybus[n2,n1] -= yL #Fuera diagonal 
    Ybus[n2,n2] += yL  + Bs#diagonal 
end
return Ybus #Se retorna Ybus para que dicha matriz exista
end

# Funcion principal
lines= DataFrame(CSV.File("lines.csv"))
nodes= DataFrame(CSV.File("nodes.csv"))
Ybus = calcular_ybus(lines,nodes)
#Ybus = sparse(Ybus)



