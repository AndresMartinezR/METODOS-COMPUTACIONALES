# **Métodos Computacionales para Sistemas Eléctricos de Potencia**  

##  **Descripción del Proyecto**  
Este repositorio contiene análisis avanzados sobre problemas en **sistemas eléctricos de potencia**, aplicando metodologías computacionales para evaluar el comportamiento de la red en distintos escenarios.  

###  **Principales Estudios**  
- **Flujo de carga en condiciones normales y de contingencia (N-1):** Análisis del desempeño de la red ante la desconexión de una línea.  
- **Análisis de sensibilidad lineal:** Evaluación del impacto de cambios en la generación sobre determinadas líneas del sistema.  
- **Flujo cuasi-estático y cuasi-dinámico:** Estudio de voltajes bajo demanda variable y generación solar intermitente, con simulaciones de hasta **1440 flujos de carga diarios**.  
- **Pérdidas del sistema y generación slack:** Cálculo de la energía que debe suplir el nodo slack en función de la variabilidad de la demanda y generación.  

Los estudios se basan en **bases de datos proporcionadas por tutores y operadores de red** en diversas regiones del mundo, incluyendo **Inglaterra**. En Colombia, la falta de acceso a datos públicos impide su inclusión en este análisis.  

---

##  **Introducción**  
Los **sistemas eléctricos de potencia** son esenciales para la operación y estabilidad de la red. La creciente complejidad de la generación, transmisión y distribución de energía requiere herramientas computacionales avanzadas para optimizar su desempeño.  

Este proyecto explora distintos **métodos computacionales** para el análisis de sistemas eléctricos, con especial enfoque en **Julia** debido a su alto rendimiento en cálculos intensivos y su sintaxis optimizada para simulaciones complejas.  

 **¿Por qué Julia?**  
- Mayor velocidad de ejecución que Python y MATLAB.  
- Excelente manejo de cálculos matriciales y numéricos.  
- Optimizado para simulaciones en ingeniería eléctrica.  

---

##  **Estructura del Repositorio**  
Cada carpeta contiene un análisis específico dentro del campo de la ingeniería eléctrica:  

📂 `Flujo_DC/` → Análisis de flujo de carga en corriente continua.  
📂 `Sensibilidad/` → Evaluación de sensibilidad de la red.  
📂 `Flujo_CuasiEstatico/` → Análisis de voltajes considerando generación solar variable.  
📂 `Estudio_Conexion/` → Evaluación de la conexión de paneles solares según normativas regulatorias.  

---

##  **Lenguajes y Herramientas**  
- **Lenguaje:** Julia  
- **Principales paquetes de Julia:**  
  - `CSV.jl` → Manejo de archivos CSV.  
  - `DataFrames.jl` → Procesamiento y análisis de datos tabulares.  
- **Formatos de datos:** `.csv`  

---

##  **Licencia**  
Este proyecto se distribuye bajo la licencia **MIT**, permitiendo su uso, modificación y distribución con atribución adecuada.  

## **Contacto**  
👤 **Autor:** Andrés Felipe Martínez  



