# Optimización Dinámica

**Nivel**: Doctorado en Economía Regional, Centro de Investigaciones
Socioeconómicas (CISE), Universidad Autónoma de Coahuila. Segundo trimestre,
generación 2024-2028.
**Requisitos**: Cálculo multivariable, álgebra lineal y ecuaciones
diferenciales básicas. Las primeras cuatro sesiones repasan lo necesario.
**Duración**: 44 horas en 22 sesiones de 2 h (11 semanas, 2 sesiones por
semana). Se planea para 20 sesiones efectivas: las sesiones 4 y 18 son
flexibles.
**Lenguaje**: Julia, con cuadernos de Pluto.jl. Se aceptan entregas en Python.
**Plan original**: Dra. Hada M. Sáenz Vela.

**Objetivo**: Que las y los estudiantes planteen y resuelvan problemas
económicos de decisión en el tiempo con las tres herramientas centrales de la
optimización dinámica: el análisis de sistemas dinámicos, el control óptimo y
la programación dinámica. Al finalizar, serán capaces de interpretar
económicamente las condiciones de optimalidad (en particular, el coestado como
precio sombra), de resolver un modelo de forma analítica y numérica en Julia,
y de aplicar estas herramientas a un problema de economía regional.

**Hilo conductor**: el reparto de la inversión entre dos regiones. El curso lo
plantea primero como un problema estático con Lagrange y Kuhn-Tucker
(sesión 2), lo resuelve en el tiempo con el principio del máximo en el modelo
de Rahman, Intriligator y Takayama (sesión 14) y lo vuelve a resolver en
tiempo discreto con programación dinámica (sesión 17, extensión opcional).

## Metodología

Cada sesión sigue el orden **problema económico → planteamiento →
condiciones de optimalidad → solución analítica → verificación numérica**. La
solución numérica no sustituye a la analítica: sirve para comprobarla y para
llegar a donde la analítica no alcanza.

**Contenido y [Avanzado].** Todo el contenido sin marca se ve en clase y se
evalúa. Los puntos marcados **[Avanzado]** son demostraciones completas y
extensiones: se desarrollan en las notas formales y se tratan en clase si el
tiempo lo permite.

- **Repaso**: al inicio de la sesión que lo requiere, 15 minutos de la
  herramienta matemática necesaria.
- **Cuadernos de Pluto.jl**: los laboratorios y el caso regional usan
  deslizadores para mover parámetros y ver cómo cambian las trayectorias, los
  diagramas de fase y las políticas óptimas.
- **Tareas**: una por bloque, cada una con una parte analítica y una parte en
  código.

> **Abreviaturas de lecturas.** CW: Chiang & Wainwright (2006) ·
> CH: Chiang (1992) · SS: Sargent & Stachurski · ST: Strogatz (2015) ·
> SE: Sethi (2021) · AL: Alexiadis (2018) · BF: Becerril Fonseca et al.
> (2002) · CR: Conrad & Rondeau (2020). Referencias completas al final. Los
> capítulos y secciones citados de CW y CH se verificaron en los PDF.

---

## Bloque I: Repaso de optimización estática (sesiones 1–4, semanas 1–2)

**Objetivo específico**: Recuperar las condiciones de optimalidad estática y
la interpretación del multiplicador como precio sombra, que el control óptimo
generaliza al tiempo.

- **Sesión 1: Diagnóstico y por qué optimizar en el tiempo**
	- *Diagnóstico*: cálculo multivariable, álgebra lineal, ecuaciones
	  diferenciales y experiencia en programación (cuestionario en clase, no
	  cuenta para la calificación).
	- Por qué optimizar en el tiempo: decisiones de hoy que cambian lo que se
	  puede hacer mañana. Variables de estado y de control.
	- Presentación del hilo conductor: invertir en una región o en otra.
	- Lecturas: BF.
- **Sesión 2: Lagrange, concavidad y Kuhn-Tucker**
	- *Repaso*: gradiente y matriz hessiana.
	- Condiciones de primer y segundo orden; hessiana orlada. Concavidad y
	  cuasiconcavidad como condiciones suficientes.
	- Lagrange: en el óptimo, ∇f = λ∇g. El multiplicador como precio sombra
	  de la restricción.
	- Kuhn-Tucker: holgura complementaria y soluciones de esquina.
	- **[Avanzado]** Calificación de las restricciones y por qué hace falta.
	- *Práctica*: inversión pública entre dos regiones, con producto
	  aᵢ ln(1 + xᵢ): reparto óptimo, multiplicador y caso de esquina.
	- Lecturas: CW 11–13.
- **Sesión 3: Envolvente y estática comparativa**
	- Diferencial total, teorema de la función implícita y regla de Cramer.
	- Teorema de la envolvente: dV/dα = ∂ℒ/∂α en el óptimo. Caso particular:
	  dV/dB = λ.
	- **[Avanzado]** Demostración del teorema de la envolvente.
	- *Práctica*: estática comparativa del reparto entre regiones; ejercicios
	  en clase.
	- Lecturas: CW 8, 13.
- **Sesión 4: Laboratorio 0 (flexible)**
	- Julia con Pluto.jl: celdas reactivas, deslizadores, gráficas.
	  Symbolics.jl para derivar y resolver condiciones de primer orden.
	- *Laboratorio*: el problema de las dos regiones con Symbolics.jl; gráficas
	  de V(B) y λ(B).
	- Instalación previa en casa.
	- Lecturas: cuaderno del curso.
	- **Entrega**: Tarea 1.

## Bloque II: Sistemas dinámicos (sesiones 5–9, semanas 3–5)

**Objetivo específico**: Resolver y analizar cualitativamente ecuaciones
diferenciales y en diferencias, porque las condiciones del control óptimo son
un sistema dinámico y su solución se lee en un diagrama de fase.

- **Sesión 5: Ecuaciones diferenciales y en diferencias lineales**
	- *Repaso*: la exponencial como solución de ẏ = ay.
	- Primer orden: ẏ + ay = b; solución y estabilidad (a > 0).
	- Segundo orden: raíces características reales, repetidas y complejas.
	- Ecuaciones en diferencias: yₜ₊₁ = ayₜ + b; estabilidad (|a| < 1) y
	  oscilación (a < 0).
	- *Práctica*: convergencia en crecimiento regional.
	- Lecturas: CW 15–18.
- **Sesión 6: Equilibrio, convergencia y diagramas de fase**
	- Puntos fijos y su estabilidad en una dimensión: el signo de f′(x*).
	- Diagrama de fase en la recta.
	- *Práctica*: tipos de equilibrio.
	- Lecturas: ST 2.
- **Sesión 7: Sistemas de ecuaciones diferenciales y linealización**
	- *Repaso*: eigenvalores, traza y determinante.
	- Sistema lineal ẋ = Ax: nodo, punto de silla, foco y centro según la
	  traza y el determinante. En tiempo discreto, estabilidad si los
	  eigenvalores tienen módulo menor que 1.
	- Linealización con el jacobiano en el equilibrio.
	- **[Avanzado]** Teorema de Hartman-Grobman y los casos no hiperbólicos.
	- *Práctica*: ejercicios en clase.
	- Lecturas: CW 19.5–19.6; ST 5–6.
- **Sesión 8: Estabilidad de sistemas no lineales**
	- Diagramas de fase en el plano: isoclinas, dirección del flujo y rama
	  estable del punto de silla.
	- Puente con el control óptimo: el diagrama de fase de Ramsey en (k, c).
	- **[Avanzado]** Variedad estable del punto de silla.
	- *Práctica*: diagramas de fase.
	- Lecturas: ST 6.
	- **Entrega**: Tarea 2.
- **Sesión 9: Laboratorio 1**
	- Trayectorias y diagramas de fase con DifferentialEquations.jl.
	- *Laboratorio*: isoclinas, campo de direcciones y trayectorias de un
	  sistema 2×2, con deslizadores para los parámetros; convergencia entre
	  regiones.
	- Lecturas: cuaderno del curso.

## Bloque III: Control óptimo (sesiones 10–14, semanas 5–7)

**Objetivo específico**: Plantear y resolver problemas de optimización en
tiempo continuo con el principio del máximo, e interpretar el coestado como
precio sombra del estado.

- **Sesión 10: Cálculo de variaciones**
	- El problema básico: maximizar ∫F(t, y, y′) dt.
	- Ecuación de Euler: F_y − (d/dt)F_y′ = 0. Condiciones terminales.
	- **[Avanzado]** Derivación de la ecuación de Euler.
	- *Práctica*: ahorro o consumo en el tiempo.
	- Lecturas: CH 1–2.
- **Sesión 11: Principio del máximo**
	- Hamiltoniano H = F + λf. Condiciones: u* maximiza H,
	  ẏ = ∂H/∂λ, λ̇ = −∂H/∂y.
	- Transversalidad: y(T) libre, y(T) ≥ 0, T libre.
	- El coestado λ(t) como precio sombra del estado.
	- **[Avanzado]** Derivación del principio del máximo; equivalencia con la
	  ecuación de Euler.
	- *Práctica*: precio sombra de un recurso.
	- Lecturas: CH 7, 8.1; CW 20.
- **Sesión 12: Horizonte infinito y descuento**
	- Hamiltoniano a valor presente: μ̇ = ρμ − ∂H_c/∂y.
	- Transversalidad en horizonte infinito.
	- Modelo de Ramsey: regla de Keynes-Ramsey con utilidad CRRA, estado
	  estacionario, punto de silla. La transversalidad selecciona la rama
	  estable.
	- **[Avanzado]** Cuándo la transversalidad en horizonte infinito es
	  necesaria.
	- *Práctica*: Ramsey (Accinelli y Brida).
	- Lecturas: CH 8.2, 9.
	- **Entrega**: propuesta de proyecto (1 página).
- **Sesión 13: Varias variables de estado y de control**
	- Sistemas de estado y coestado con varias variables.
	- Control acotado. Hamiltoniano lineal en el control: soluciones bang-bang
	  y singulares; la función de cambio ∂H/∂u.
	- Condiciones suficientes de Mangasarian y de Arrow.
	- **[Avanzado]** Demostración de la suficiencia de Mangasarian.
	- Lecturas: CH 8.3–8.4; SE.
	- **Entrega**: Tarea 3.
- **Sesión 14: Caso completo: inversión entre dos regiones**
	- Modelo de Rahman, Intriligator y Takayama: producto Yᵢ = vᵢKᵢ, ahorro
	  sᵢYᵢ; el control δ ∈ [0, 1] reparte la inversión total.
	- Hamiltoniano lineal en δ: solución bang-bang guiada por los precios
	  sombra de cada región.
	- Tiempo de cambio: primero se crece donde se ahorra más; al final se
	  produce donde rinde más.
	- Discusión: equidad frente a eficiencia en la política regional.
	- **[Avanzado]** Derivación del tiempo de cambio y su estática
	  comparativa.
	- *Cuaderno*: tiempo de cambio analítico, simulación de K₁ y K₂,
	  comparación con repartos fijos y deslizadores para los parámetros.
	- Lecturas: AL 2. Consulta: AL 3; Rahman (1963); Intriligator (1964);
	  Takayama (1967).

## Bloque IV: Programación dinámica (sesiones 15–19, semanas 8–10)

**Objetivo específico**: Formular problemas de decisión de forma recursiva con
la ecuación de Bellman, resolverlos numéricamente y relacionarlos con el
control óptimo. La incertidumbre queda como lectura opcional (SE 12).

- **Sesión 15: Ecuación de Bellman en horizonte finito**
	- Función valor y ecuación de Bellman.
	- Inducción hacia atrás.
	- *Práctica*: crecimiento óptimo; el problema de la torta con pocos
	  periodos.
	- Lecturas: SS 1.1; QuantEcon, *Cake Eating I*.
- **Sesión 16: Horizonte infinito**
	- El operador de Bellman y su punto fijo.
	- Iteración de función valor e iteración de política: costo por paso
	  contra número de pasos.
	- Solución exacta del problema de la torta con utilidad logarítmica, para
	  verificar el código.
	- **[Avanzado]** El operador de Bellman es una contracción (condiciones
	  de Blackwell); existencia y unicidad del punto fijo.
	- *Práctica*: convergencia numérica.
	- Lecturas: SS 1.2–1.3; QuantEcon, *Cake Eating II*.
- **Sesión 17: Laboratorio 2**
	- *Laboratorio*: iteración de función valor con un estado (torta o
	  crecimiento óptimo) sobre una malla; error contra la solución exacta y
	  contra el número de iteraciones.
	- Extensión opcional: el modelo de la sesión 14 en tiempo discreto.
	- Lecturas: SS 5.2.2.
- **Sesión 18: Control óptimo frente a programación dinámica (flexible)**
	- La ecuación de Euler en tiempo discreto, u′(cₜ) = βRu′(cₜ₊₁), y su
	  relación con el principio del máximo.
	- Segundo caso breve: recurso natural renovable en una región.
	- Lecturas: CR.
- **Sesión 19: Laboratorio 3**
	- *Laboratorio*: comparación numérica del mismo problema resuelto con el
	  principio del máximo (problema de valor en la frontera) y con iteración
	  de función valor.
	- Lecturas: cuaderno del curso.
	- **Entrega**: Tarea 4 (corta; su código alimenta el proyecto).

## Bloque V: Proyecto (sesiones 20–22, semanas 10–11)

- **Sesión 20: Taller de avances**
	- Revisión por pares.
	- **Entrega**: avance del proyecto.
- **Sesiones 21 y 22: Presentaciones y cierre**
	- Presentaciones finales.

---

## Evaluación

| Componente | Peso |
|---|---|
| Tareas (4), una por bloque, con parte analítica y parte en código | 50% |
| Ejercicios en sesión | 10% |
| Avance del proyecto (sesión 20; si se pierde el taller, se entrega por escrito) | 10% |
| Proyecto aplicado: reporte y presentación | 30% |

La propuesta de proyecto (sesión 12) es requisito, sin calificación. El
proyecto resuelve un caso del listado o de la tesis, de forma analítica y
numérica.

**Las tareas piden resolver e interpretar.** Ejemplos de preguntas:
- "Encuentra el reparto óptimo del presupuesto entre las dos regiones y el
  multiplicador. ¿Cuánto vale aumentar el presupuesto en una unidad?"
- "Clasifica el equilibrio de este sistema y dibuja su diagrama de fase.
  Comprueba tu dibujo con una simulación."
- "¿Cómo cambia el tiempo de cambio si la región 1 ahorra más? Justifica con
  la fórmula y con el cuaderno."

**Ideas para proyecto final**: el modelo de dos regiones con más regiones o
con producción no lineal; los casos de Pražák (2012), Ukhin & Achituev (2008),
Surkov (2013) o Desmet & Rossi-Hansberg (2010); manejo de un recurso natural
renovable en una región (Conrad & Rondeau, 2020); políticas basadas en el
lugar (Neumark & Simpson, 2015); un problema de la tesis de cada estudiante.

---

## Bibliografía

### Textos base
- Chiang, A. C., & Wainwright, K. (2006). *Métodos fundamentales de economía
  matemática* (4.ª ed.). McGraw-Hill.
- Chiang, A. C. (1992). *Elements of Dynamic Optimization*. McGraw-Hill.
- Sargent, T. J., & Stachurski, J. *Dynamic Programming, Vol. I: Finite
  States*. Versión en línea de agosto de 2026, https://dp.quantecon.org.
  Caps. 1 y 5.2; el Vol. II queda fuera del curso.
- Strogatz, S. H. (2015). *Nonlinear Dynamics and Chaos* (2.ª ed.). Westview
  Press.
- Alexiadis, S. (2018). *The Dilemma of Regional Policy*. Springer.
  https://doi.org/10.1007/978-3-319-68900-5

### Repaso
- Becerril Fonseca, Jardón Arcos y Reyes Victoria (2002). *Cálculo
  diferencial en varias variables*. UAM Iztapalapa.

### Textos complementarios
- Sethi, S. P. (2021). *Optimal Control Theory: Applications to Management
  Science and Economics* (4.ª ed.). Springer.
  https://doi.org/10.1007/978-3-030-91745-6
- Conrad, J. M., & Rondeau, D. (2020). *Natural Resource Economics: Analysis,
  Theory, and Applications*. Cambridge University Press.
  https://doi.org/10.1017/9781108588928
- Duranton, G., Henderson, J. V., & Strange, W. C. (Eds.) (2015). *Handbook of
  Regional and Urban Economics* (Vol. 5B). Elsevier.
- QuantEcon. Lecciones *Cake Eating I* y *Cake Eating II* (versión en
  Python). https://quantecon.org
- Del plan original: Intriligator (1971); Lomelí & Rumbos (2001); Simon &
  Blume (1994).
- Pendientes de revisar: Kamien & Schwartz, *Dynamic Optimization*; Weber
  (2011); Léonard & Van Long (1992).

### Artículos y capítulos
- Desmet, K., & Henderson, J. V. (2015). The geography of development within
  countries. En *Handbook of Regional and Urban Economics* (Vol. 5B,
  pp. 1457–1517). Elsevier.
  https://doi.org/10.1016/B978-0-444-59531-7.00022-3
- Desmet, K., & Rossi-Hansberg, E. (2010). On spatial dynamics. *Journal of
  Regional Science*, 50(1), 43–63.
  https://doi.org/10.1111/j.1467-9787.2009.00648.x
- Intriligator, M. D. (1964). Regional allocation of investment: Comment.
  *Quarterly Journal of Economics*, 78(4), 659–662.
  https://doi.org/10.2307/1879665
- Neumark, D., & Simpson, H. (2015). Place-based policies. En *Handbook of
  Regional and Urban Economics* (Vol. 5B, pp. 1197–1287). Elsevier.
  https://doi.org/10.1016/B978-0-444-59531-7.00018-1
- Rahman, M. A. (1963). Regional allocation of investment: An aggregative
  study in the theory of development programming. *Quarterly Journal of
  Economics*, 77(1), 26–39. https://doi.org/10.2307/1879370
- Redding, S. J., & Turner, M. A. (2015). Transportation costs and the spatial
  organization of economic activity. En *Handbook of Regional and Urban
  Economics* (Vol. 5B, pp. 1339–1398). Elsevier.
  https://doi.org/10.1016/B978-0-444-59531-7.00020-X
- Takayama, A. (1967). Regional allocation of investment: A further analysis.
  *Quarterly Journal of Economics*, 81(2), 330–336.
  https://doi.org/10.2307/1879591
- Ukhin, M. Yu., & Achituev, S. A. (2008). Multicomponent model-based
  optimization of the regional development strategies. *Automation and Remote
  Control*, 69(3), 514–524. https://doi.org/10.1134/S0005117908030168
- Fichas por completar: Pražák (2012); Surkov (2013).

### Complementaria aplicada (del plan original)
Accinelli y Brida; Espinosa y Ruiz; Sierra y Gualajara; Figueiredo y Pereira;
Wang. Fichas por completar.

### Recursos naturales
Conrad & Rondeau (2020); Karp & Traeger (2013, ficha por verificar).
