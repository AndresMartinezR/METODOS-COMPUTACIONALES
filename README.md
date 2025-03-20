# Métodos Computacionales para Sistemas Eléctricos de Potencia  

## **Descripción del Proyecto**  
Este repositorio contiene diversos análisis relacionados con problemas en sistemas eléctricos de potencia. Se estudian diferentes metodologías para evaluar el comportamiento de la red en distintos escenarios, tales como:  

- **Flujo de carga en condiciones normales y de contingencia (N-1):** Evaluación de cómo funciona la red cuando se desconecta una línea.  
- **Análisis de sensibilidad lineal:** Determinación de cómo afecta la inyección de generación en un nodo a ciertas líneas del sistema.  
- **Flujo cuasi-estático y cuasi-dinámico:** Evaluación de los voltajes bajo demanda variable por minuto y generación solar intermitente, analizando el comportamiento de los voltajes en 1440 flujos de carga diarios.  
- **Pérdidas del sistema y generación slack:** Cálculo de la energía que debe suplir el nodo slack en cada instante de tiempo debido a la variabilidad en la generación y la demanda.  

Para estos estudios, se utilizan bases de datos proporcionadas por el tutor y operadores de red en distintas regiones del mundo (incluyendo Inglaterra). Debido a la confidencialidad de los datos en Colombia, no se cuenta con bases de datos locales.  

---

## **Introducción**  
Los sistemas eléctricos de potencia desempeñan un papel fundamental en la operación y estabilidad de la red eléctrica. La necesidad de optimizar la generación, transmisión y distribución de la energía ha impulsado el desarrollo de herramientas computacionales avanzadas para el análisis y solución de problemas en estos sistemas.  

Este proyecto tiene como objetivo implementar diferentes métodos computacionales en el estudio de sistemas eléctricos de potencia, utilizando herramientas de programación como **Julia**. A través de este enfoque, se busca mejorar la eficiencia en el análisis de flujos de carga, estudios de sensibilidad, evaluación de pérdidas y simulaciones de generación y demanda dinámicas.  

El lenguaje de programación **Julia** ha sido seleccionado debido a su alto rendimiento y facilidad de uso en comparación con otros lenguajes como Python y MATLAB. Su velocidad de compilación y ejecución lo convierten en una opción ideal para simulaciones y cálculos intensivos en el ámbito de la ingeniería eléctrica.  

---

## **Estructura del Repositorio**  
**Carpetas del Proyecto**  
Cada carpeta contiene un análisis diferente dentro del amplio campo de la ingeniería eléctrica.  

- `Flujo_DC/` → Análisis de flujo de carga en corriente continua.  
- `Sensibilidad/` → Estudio de sensibilidad de la red.  
- `Flujo_CuasiEstatico/` → Análisis de carga considerando generación solar variable.  
- `Estudio_Conexion/` → Evaluación de la conexión de un panel solar según la normativa de la comisión reguladora.  

---

## **Requisitos y Tecnologías Utilizadas**  
**Lenguajes y herramientas:**  
- **Julia:** Lenguaje de programación de alto rendimiento con una sintaxis amigable.  
- **Paquetes de Julia:**  
  - CSV.jl  
  - DataFrames.jl  
- **Formatos de datos:** `.csv`  

---

## **Licencia y Contacto**  
📌 **Hecho por:** Andrés Felipe Martínez  
📧 **Email:** felipe.martinez1@utp.edu.co  


