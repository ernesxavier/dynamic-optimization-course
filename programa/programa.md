# Optimización Dinámica

**Nivel**: Doctorado en Economía Regional, Centro de Investigaciones
Socioeconómicas (CISE), Universidad Autónoma de Coahuila. Segundo trimestre,
generación 2024-2028.
**Requisitos**: Cálculo multivariable, álgebra lineal y ecuaciones
diferenciales básicas. Las primeras cuatro sesiones repasan lo necesario.
**Duración**: 48 horas en 24 sesiones de 2 h (12 semanas, 2 sesiones por
semana). La sesión 18 es flexible, y las sesiones 21 y 22 son de colchón:
se dedican al proyecto o a recuperar una unidad atrasada.
**Lenguaje**: Julia, con cuadernos de `Pluto.jl`. Se aceptan entregas en Python.

**Objetivo**: Que las y los estudiantes planteen y resuelvan problemas
económicos de decisión en el tiempo con las tres herramientas centrales de la
optimización dinámica: el análisis de sistemas dinámicos, el control óptimo y
la programación dinámica. Al finalizar, serán capaces de interpretar
económicamente las condiciones de optimalidad (en particular, el coestado como
precio sombra), de resolver un modelo de forma analítica y numérica en Julia,
y de aplicar estas herramientas a un problema de economía regional.

**Hilo conductor**: el reparto de la inversión entre dos regiones. El curso lo
plantea primero como un problema estático con Lagrange y Kuhn-Tucker
(sesión 2) y lo resuelve en el tiempo con el principio del máximo en el
modelo de Rahman, Intriligator y Takayama (sesión 14). En la Unidad IV, la
sesión 15 muestra por qué ese caso, con dos estados, conviene resolverlo con
control óptimo y no con programación dinámica.

**Datos de México**: tres sesiones trabajan con datos reales: la
convergencia entre estados con el PIB por entidad del INEGI (sesión 5), la
calibración del modelo de Ramsey con datos nacionales de la Penn World Table
(sesión 12) y la del caso de las dos regiones con PIB y empleo por entidad
(INEGI y OCDE, sesión 14). Donde no hay datos por entidad, como el ahorro, se usan
supuestos explícitos. El proyecto final también se contrasta o se calibra con datos.

## Metodología

Cada unidad abre con una **pregunta de economía regional**, y cada sesión sigue el orden:
**problema económico → planteamiento → condiciones de optimalidad → solución
analítica → verificación numérica → interpretación**. La solución numérica no
sustituye a la analítica: sirve para comprobarla y para llegar a donde la
analítica no alcanza.

**Contenido y [Avanzado].** Todo el contenido sin marca se ve en clase y se
evalúa. Los puntos marcados **[Avanzado]** son demostraciones completas y
extensiones: se desarrollan en las notas de cada sesión y se tratan en clase
si el tiempo lo permite.

**Formato de clase.** La clase se da en el pizarrón y sigue las notas de la
sesión, que abren con un plan de clase de 120 minutos: qué se escribe en el
pizarrón, cuándo se proyecta el cuaderno, qué se resuelve en parejas y qué
queda para leer. Las notas contienen todo lo que se escribe, con los pasos
intermedios, así que no hace falta copiar. El peso de cada medio depende del
contenido:

- **Sesiones teóricas** (1–3, 6–8, 10, 11, 13, 15, 16 y 18): el pizarrón
  conduce la clase; el cuaderno se proyecta en bloques cortos para lo que se
  entiende mejor en movimiento (diagramas de fase, trayectorias,
  comprobaciones numéricas). En las sesiones de diagramas de fase el
  cuaderno tiene más tiempo.
- **Sesiones con datos** (5, 12 y 14): el cuaderno conduce la clase, con
  pasos guiados; el pizarrón se usa para las derivaciones que el cuaderno
  necesita. En la 12 y la 14, que tienen más teoría, la primera mitad es de
  pizarrón (el modelo y su solución) y la segunda sigue el cuaderno (la
  calibración y los resultados).
- **Laboratorios** (4, 9, 17 y 19): se trabaja en el cuaderno de principio a
  fin, con una demostración breve al inicio de cada bloque.

- **Repaso**: al inicio de la sesión que lo requiere, 15 minutos de la
  herramienta matemática necesaria.
- **Cuadernos de Pluto.jl**: los laboratorios y el caso regional usan
  deslizadores para mover parámetros y ver cómo cambian las trayectorias, los
  diagramas de fase y las políticas óptimas.
- **Tareas**: una por unidad. La Tarea 1 tiene una parte analítica y una
  parte en código; las tareas 2 a 4 son de ejercicios para resolver a mano (el
  código se practica en los laboratorios y en el proyecto). Cada tarea se entrega en la sesión siguiente al cierre de su unidad
  (sesiones 5, 10, 15 y 21), para que cubra la unidad completa.
- **Proyecto ligado a la tesis**: desde la sesión 1, cada estudiante
  identifica un problema de su tesis con dimensión temporal; la propuesta
  (sesión 12) lo formaliza y el proyecto final lo resuelve.

> **Abreviaturas de lecturas.** CW: Chiang & Wainwright (2006) ·
> CH: Chiang (1992) · SS: Sargent & Stachurski · ST: Strogatz (2015) ·
> SE: Sethi (2021) · AL: Alexiadis (2018) · BF: Becerril Fonseca et al.
> (2002) · CR: Conrad & Rondeau (2020). Referencias completas al final. Los
> capítulos y secciones citados de CW y CH se verificaron en los PDF.

---

## Unidad I: Repaso de optimización estática (sesiones 1–4, semanas 1–2)

**Pregunta regional**: ¿cómo repartir un fondo de inversión entre dos
regiones?

**Objetivo específico**: Recuperar las condiciones de optimalidad estática y
la interpretación del multiplicador como precio sombra, que el control óptimo
generaliza al tiempo.

- **Sesión 1: Diagnóstico y por qué optimizar en el tiempo**
	- *Diagnóstico*: cálculo multivariable, álgebra lineal, ecuaciones
	  diferenciales y experiencia en programación (cuestionario en clase, no
	  cuenta para la calificación). Incluye una pregunta abierta: un problema
	  de la tesis de cada estudiante que tenga dimensión temporal.
	- Por qué optimizar en el tiempo: decisiones de hoy que cambian lo que se
	  puede hacer mañana. Variables de estado y de control.
	- Presentación del hilo conductor: invertir en una región o en otra.
	- Lecturas: BF.
- **Sesión 2: Lagrange, concavidad y Kuhn-Tucker**
	- *Repaso*: gradiente y matriz hessiana.
	- Condiciones de primer y segundo orden; hessiana orlada. Concavidad y
	  cuasiconcavidad como condiciones suficientes.
	- Lagrange: en el óptimo, $\nabla f = \lambda \nabla g$. El multiplicador como precio sombra
	  de la restricción.
	- Kuhn-Tucker: holgura complementaria y soluciones de esquina.
	- **[Avanzado]** Calificación de las restricciones y por qué hace falta.
	- *Práctica*: inversión pública entre dos regiones, con producto
	  $a_i \ln(1 + x_i)$: reparto óptimo, multiplicador y caso de esquina.
	- Lecturas: CW 11–13.
- **Sesión 3: Envolvente y estática comparativa**
	- Diferencial total, teorema de la función implícita y regla de Cramer.
	- Teorema de la envolvente: $dV/d\alpha = \partial \mathcal{L}/\partial \alpha$ en el óptimo. Caso particular:
	  $dV/dB = \lambda$.
	- **[Avanzado]** Demostración del teorema de la envolvente.
	- *Práctica*: estática comparativa del reparto entre regiones; ejercicios
	  en clase.
	- Lecturas: CW 8, 13.
- **Sesión 4: Laboratorio 0**
	- Julia con Pluto.jl: celdas reactivas, deslizadores, gráficas.
	  Symbolics.jl para derivar y resolver condiciones de primer orden.
	- *Laboratorio*: el problema de las dos regiones con Symbolics.jl; gráficas
	  de $V(B)$ y $\lambda(B)$.
	- Instalación antes de iniciar el curso, con una guía paso a paso; los
	  problemas se resuelven en asesoría antes de esta sesión.
	- Lecturas: cuaderno del curso.

## Unidad II: Sistemas dinámicos (sesiones 5–9, semanas 3–5)

**Pregunta regional**: ¿convergen los estados de México? ¿A qué velocidad?

**Objetivo específico**: Resolver y analizar cualitativamente ecuaciones
diferenciales y en diferencias, porque las condiciones del control óptimo son
un sistema dinámico y su solución se lee en un diagrama de fase.

**Alcance**: la unidad es cualitativa. No se ven métodos de solución exacta
(transformada de Laplace, ecuaciones exactas, coeficientes indeterminados),
teoremas de existencia y unicidad, bifurcaciones ni caos. Cada tema se vuelve
a usar más adelante:
- Primer orden → convergencia (sesión 5) y regla de Keynes-Ramsey
  (sesión 12).
- Segundo orden → ecuación de Euler del cálculo de variaciones (sesión 10).
- Sistemas y punto de silla → modelo de Ramsey (sesión 12).
- Ecuaciones en diferencias → ecuación de Bellman y Euler en tiempo discreto
  (sesiones 15–18).

- **Sesión 5: Ecuaciones diferenciales lineales de primer orden**
	- *Repaso*: la exponencial como solución de $\dot{y} = ay$.
	- Primer orden: $\dot{y} + ay = b$; solución y estabilidad ($a > 0$).
	- *Práctica con datos*: convergencia $\beta$ con el PIB per cápita de las
	  entidades federativas (INEGI). Velocidad de convergencia y vida media de
	  la brecha, interpretadas como la solución de $\dot{y} = -\beta (y - y^*)$.
	- Lecturas: CW 15; Barro & Sala-i-Martin (1992).
	- **Entrega**: Tarea 1.
- **Sesión 6: Equilibrio, diagramas de fase y ecuaciones en diferencias**
	- Puntos fijos y su estabilidad en una dimensión: el signo de $f'(x^*)$.
	- Diagrama de fase en la recta.
	- Ecuaciones en diferencias: $y_{t+1} = a y_t + b$; el punto fijo es
	  estable si $|a| < 1$ y la trayectoria oscila si $a < 0$.
	- *Práctica*: tipos de equilibrio, en tiempo continuo y discreto.
	- Lecturas: ST 2; CW 17.
- **Sesión 7: Sistemas de ecuaciones diferenciales y linealización**
	- *Repaso*: eigenvalores, traza y determinante.
	- Sistema lineal $\dot{x} = Ax$: nodo, punto de silla, foco y centro según la
	  traza y el determinante. El caso central en economía es el punto de
	  silla; foco y centro sólo se reconocen. En tiempo discreto, estabilidad
	  si los eigenvalores tienen módulo menor que 1.
	- Segundo orden como sistema: $\ddot{y} + a_1 \dot{y} + a_2 y = 0$ se escribe
	  como un sistema de $2 \times 2$, y sus raíces características (reales,
	  repetidas o complejas) son los eigenvalores.
	- Linealización con el jacobiano en el equilibrio.
	- **[Avanzado]** Teorema de Hartman-Grobman y los casos no hiperbólicos.
	- *Práctica*: ejercicios en clase.
	- Lecturas: CW 16, 19.5–19.6; ST 5–6.
- **Sesión 8: Estabilidad de sistemas no lineales**
	- Diagramas de fase en el plano: isoclinas, dirección del flujo y rama
	  estable del punto de silla.
	- Puente con el control óptimo: el diagrama de fase de Ramsey en $(k, c)$.
	- **[Avanzado]** Variedad estable del punto de silla.
	- *Práctica*: diagramas de fase.
	- Lecturas: ST 6.
- **Sesión 9: Laboratorio 1**
	- Trayectorias y diagramas de fase con DifferentialEquations.jl.
	- *Laboratorio*: modelo de Solow con dos regiones y movilidad de capital:
	  isoclinas, campo de direcciones y trayectorias, con deslizadores para los
	  parámetros. ¿Converge la región rezagada? ¿Qué parámetros lo deciden?
	- Lecturas: cuaderno del curso.

## Unidad III: Control óptimo (sesiones 10–14, semanas 5–7)

**Pregunta regional**: ¿conviene invertir primero donde se ahorra más o donde
se produce más?

**Objetivo específico**: Plantear y resolver problemas de optimización en
tiempo continuo con el principio del máximo, e interpretar el coestado como
precio sombra del estado.

- **Sesión 10: Del cálculo de variaciones al Hamiltoniano**
	- Primera hora: el problema básico, maximizar $\int_0^T F(t, y, y')\thinspace dt$
	  con extremos fijos. Ecuación de Euler: $F_y - \frac{d}{dt} F_{y'} = 0$,
	  y su lectura económica: el beneficio de consumir hoy contra el de
	  consumir mañana.
	- Segunda hora: el mismo problema como control óptimo, con $u = y'$.
	  Se escribe el Hamiltoniano $H = F + \lambda u$ y se comprueba que sus
	  condiciones dan la misma ecuación de Euler.
	- El cálculo de variaciones no admite restricciones sobre el control
	  (como $\theta \in [0, 1]$ en la sesión 14): por eso el resto del curso
	  usa el Hamiltoniano.
	- **[Avanzado]** Derivación de la ecuación de Euler por la primera
	  variación.
	- *Práctica*: ahorro o consumo en el tiempo, resuelto por los dos
	  caminos.
	- Lecturas: CH 1–2. Consulta: SE ejemplos 3.2–3.3 (el mismo problema de
	  consumo, con el Hamiltoniano).
	- **Entrega**: Tarea 2.
- **Sesión 11: Principio del máximo**
	- Hamiltoniano $H = F + \lambda f$. Condiciones: $u^*$ maximiza $H$,
	  $\dot{y} = \partial H/\partial \lambda$, $\dot{\lambda} = -\partial H/\partial y$.
	- Transversalidad: $y(T)$ libre, $y(T) \geq 0$, $T$ libre. Las
	  condiciones terminales se ven aquí una sola vez.
	- El coestado $\lambda(t)$ como precio sombra del estado.
	- **[Avanzado]** Derivación del principio del máximo.
	- *Práctica*: precio sombra de un recurso.
	- Lecturas: CH 7, 8.1; CW 20.
- **Sesión 12: Horizonte infinito y descuento**
	- Hamiltoniano a valor presente: $\dot{\mu} = \rho \mu - \partial H_c/\partial y$.
	- Transversalidad en horizonte infinito.
	- Modelo de Ramsey: regla de Keynes-Ramsey con utilidad CRRA, estado
	  estacionario, punto de silla. La transversalidad selecciona la rama
	  estable.
	- **[Avanzado]** Cuándo la transversalidad en horizonte infinito es
	  necesaria.
	- *Práctica con datos*: Ramsey calibrado para México con datos nacionales
	  de la Penn World Table (tasa de ahorro, depreciación, participación del
	  capital). El cuaderno llega con los datos cargados y la calibración
	  hecha: en clase se interpreta el estado estacionario, se compara con
	  los datos y se mueven los parámetros.
	- Lecturas: CH 8.2, 9. Consulta: SE 3.6 y ejemplo 3.7.
	- **Entrega**: propuesta de proyecto (1 página): el problema de la tesis
	  planteado con estado, control, objetivo y restricciones.
- **Sesión 13: Varias variables de estado y de control**
	- Sistemas de estado y coestado con varias variables.
	- Control acotado. Hamiltoniano lineal en el control: soluciones
	  bang-bang y la función de cambio $\partial H/\partial u$.
	- Condiciones suficientes de Mangasarian y de Arrow.
	- **[Avanzado]** Soluciones singulares. Demostración de la suficiencia de
	  Mangasarian.
	- *Práctica*: una región reparte su producto entre consumo (con utilidad
	  lineal) e inversión, con $u \in [0, 1]$ y horizonte finito: función de
	  cambio, tiempo de cambio y trayectoria del capital. Es el ensayo de un
	  solo estado del caso de la sesión 14.
	- Lecturas: CH 8.3–8.4; SE 2.3–2.4, 3.6.
- **Sesión 14: Caso completo: inversión entre dos regiones**
	- Modelo de Rahman, Intriligator y Takayama: producto $Y_i = v_i K_i$, ahorro
	  $s_i Y_i$; el control $\theta \in [0, 1]$ reparte la inversión total.
	- Hamiltoniano lineal en $\theta$: solución bang-bang guiada por los precios
	  sombra de cada región.
	- Tiempo de cambio: primero se crece donde se ahorra más; al final se
	  produce donde rinde más.
	- Discusión: equidad frente a eficiencia en la política regional.
	- **[Avanzado]** Derivación del tiempo de cambio y su estática
	  comparativa.
	- *Cuaderno con datos*: tiempo de cambio analítico, simulación de $K_1$ y $K_2$,
	  comparación con repartos fijos y deslizadores para los parámetros.
	  Calibración con dos regiones de México: las productividades $v_i$ se
	  aproximan con el PIB por trabajador de cada entidad (INEGI). Las tasas de
	  ahorro $s_i$ no se publican por entidad, así que se fijan con supuestos
	  explícitos y se discute cuánto cambia el resultado: ¿cuál es su tiempo
	  de cambio y qué tan sensible es a $s_i$?
	- Lecturas: AL 2. Consulta: AL 3; Rahman (1963); Intriligator (1964);
	  Takayama (1967).

## Unidad IV: Programación dinámica (sesiones 15–19, semanas 8–10)

**Pregunta regional**: ¿cómo debe crecer una región que decide cada año
cuánto invertir?

**Objetivo específico**: Formular problemas de decisión de forma recursiva con
la ecuación de Bellman, resolverlos numéricamente y relacionarlos con el
control óptimo. La incertidumbre se introduce con un ejemplo de migración
entre dos regiones (sesión 19); su tratamiento general queda como lectura
opcional (SE 12).

- **Sesión 15: Ecuación de Bellman en horizonte finito**
	- Función valor y ecuación de Bellman.
	- Inducción hacia atrás.
	- *Práctica*: crecimiento óptimo; el problema de la torta con pocos
	  periodos.
	- Lecturas: SS 1.1; QuantEcon, *Cake Eating I*.
	- **Entrega**: Tarea 3.
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
	- *Laboratorio*: iteración de función valor con un estado sobre una malla.
	  Primero el problema de la torta, que tiene solución exacta y sirve para
	  verificar el código (error contra la solución y contra el número de
	  iteraciones). Después, crecimiento óptimo de una región con los
	  parámetros calibrados en la sesión 12.
	- Extensión opcional: la búsqueda de empleo de McCall sin final, con un
	  estado discreto (salario de reserva y seguro de desempleo).
	- Lecturas: SS 1.3 y 5.2.2.
- **Sesión 18: Control óptimo frente a programación dinámica (flexible)**
	- La ecuación de Euler en tiempo discreto, $u'(c_t) = \beta R\thinspace u'(c_{t+1})$, y su
	  relación con el principio del máximo.
	- Segundo caso breve: recurso natural renovable en una región.
	- Lecturas: CR.
- **Sesión 19: Laboratorio 3**
	- *Laboratorio, parte 1*: comparación numérica del mismo problema resuelto
	  con el principio del máximo (problema de valor en la frontera) y con
	  iteración de función valor.
	- *Laboratorio, parte 2: ¿migrar o quedarse?* Una persona vive en una de
	  dos regiones. El salario de cada región sigue una cadena de Markov de
	  dos estados (alto y bajo), y mudarse tiene un costo fijo $c$. Cada
	  periodo elige dónde vivir:
	  $V(r, w) = \max_{r'} \lbrace u(w_{r'}) - c\thinspace \mathbb{1}[r' \neq r] + \beta\thinspace \mathbb{E}[V(r', w') \mid w] \rbrace$.
	  Se resuelve con iteración de función valor y se lee la política: ¿a
	  partir de qué brecha salarial conviene mudarse? Deslizadores para el
	  costo de mudanza y la persistencia de los salarios. Pregunta para la
	  discusión: ¿por qué hay quien no migra aunque la otra región pague más?
	- Lecturas: cuaderno del curso. Consulta: Kennan & Walker (2011).

## Unidad V: Proyecto (sesiones 20–24, semanas 10–12)

- **Sesión 20: Taller de avances**
	- Revisión por pares.
	- **Entrega**: avance del proyecto.
- **Sesiones 21 y 22: Taller de proyecto (colchón)**
	- Si el curso va al día: asesoría por proyecto, calibración con datos del
	  INEGI y revisión de que el cuaderno reproduzca todos los resultados.
	- Si hay atraso: se recupera primero la unidad pendiente y el resto del
	  tiempo se dedica al proyecto.
	- **Entrega** (sesión 21): Tarea 4 (corta; su último problema plantea
	  el proyecto en forma recursiva).
- **Sesiones 23 y 24: Presentaciones y cierre**
	- Presentaciones finales.

---

## Evaluación

| Componente | Peso |
|---|---|
| Tareas (4), una por unidad: ejercicios analíticos (la Tarea 1 incluye una parte en código) | 50% |
| Ejercicios en sesión | 10% |
| Avance del proyecto (sesión 20; si se pierde el taller, se entrega por escrito) | 10% |
| Proyecto aplicado: reporte y presentación | 30% |

**Defensa oral breve.** En cada tarea se puede pedir a cualquier estudiante
que explique en 5 minutos una parte de su solución, analítica o de código. La
parte que no pueda explicar no cuenta. Las herramientas de IA se pueden usar,
pero quien entrega debe entender y poder defender lo que entrega.

La propuesta de proyecto (sesión 12) es requisito, sin calificación. Se puede
reformular en la sesión 20, junto con el avance; por ejemplo, si el problema
se plantea mejor con programación dinámica, que se ve después de la
propuesta. El proyecto resuelve, de forma analítica y numérica, el problema
de la tesis planteado en la propuesta o, si no hay uno adecuado, un caso del
listado. Además:
- **Se contrasta o se calibra con datos**, aunque sea de forma simple: por
  ejemplo, fijar los parámetros con datos del INEGI o comparar una
  predicción del modelo con una serie observada.
- **Se entrega reproducible**: un cuaderno de Pluto (o de Jupyter, si se
  trabaja en Python) que genere todos los resultados del reporte.

**Rúbrica del proyecto** (sobre el 30% del proyecto):

| Criterio | Qué se evalúa | Peso |
|---|---|---|
| Planteamiento | Estado, control, objetivo y restricciones bien definidos y ligados a una pregunta económica | 20% |
| Solución analítica | Condiciones de optimalidad correctas, resueltas hasta donde se pueda | 25% |
| Solución numérica | Código correcto y verificado contra la solución analítica o un caso con solución conocida | 20% |
| Datos | Calibración o contraste con datos; supuestos explícitos y su efecto en los resultados | 15% |
| Interpretación | Lectura económica de los resultados: precios sombra, políticas, implicaciones regionales | 10% |
| Reproducibilidad y presentación | El cuaderno corre de principio a fin; exposición clara y respuestas a preguntas | 10% |

**Las tareas piden resolver e interpretar.** Ejemplos de preguntas:
- "Encuentra el reparto óptimo del presupuesto entre las dos regiones y el
  multiplicador. ¿Cuánto vale aumentar el presupuesto en una unidad?"
- "Clasifica el equilibrio de este sistema y dibuja su diagrama de fase:
  isoclinas, equilibrios y dirección del flujo."
- "¿Cómo cambia el tiempo de cambio si la región 1 ahorra más? Justifica con
  la fórmula del tiempo de cambio."
- "Con la velocidad de convergencia estimada para los estados de México,
  ¿cuántos años tarda en cerrarse la mitad de la brecha?"

**Ideas para proyecto final**: el modelo de dos regiones con más regiones o
con producción no lineal; los casos de Pražák (2012), Ukhin & Achituev (2008),
Surkov (2013) o Desmet & Rossi-Hansberg (2010); manejo de un recurso natural
renovable en una región (Conrad & Rondeau, 2020); políticas basadas en el
lugar (Neumark & Simpson, 2015). La opción preferida es un problema de la
tesis de cada estudiante.

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
- Karp, L. S., & Traeger, C. P. (2013). *Dynamic Methods in Environmental and
  Resource Economics* [Manuscrito inédito]. University of California,
  Berkeley. Hay un borrador más reciente con el título *Dynamic Environmental
  and Resource Economics* (2024).
- Pontryagin, L. S., Boltyanskii, V. G., Gamkrelidze, R. V., & Mishchenko,
  E. F. (1962). *The Mathematical Theory of Optimal Processes*.
  Interscience. (Consulta histórica, sesión 11.)
- QuantEcon. Lecciones *Cake Eating I* y *Cake Eating II* (versión en
  Python). https://quantecon.org

### Artículos y capítulos
- Barro, R. J., & Sala-i-Martin, X. (1992). Convergence. *Journal of
  Political Economy*, 100(2), 223–251. https://doi.org/10.1086/261816
- Desmet, K., & Henderson, J. V. (2015). The geography of development within
  countries. En *Handbook of Regional and Urban Economics* (Vol. 5B,
  pp. 1457–1517). Elsevier.
  https://doi.org/10.1016/B978-0-444-59531-7.00022-3
- Desmet, K., & Rossi-Hansberg, E. (2010). On spatial dynamics. *Journal of
  Regional Science*, 50(1), 43–63.
  https://doi.org/10.1111/j.1467-9787.2009.00648.x
- Halkin, H. (1974). Necessary conditions for optimal control problems with
  infinite horizons. *Econometrica*, 42(2), 267–272.
  https://doi.org/10.2307/1911976
- Hotelling, H. (1931). The economics of exhaustible resources. *Journal of
  Political Economy*, 39(2), 137–175. https://doi.org/10.1086/254195
- Intriligator, M. D. (1964). Regional allocation of investment: Comment.
  *Quarterly Journal of Economics*, 78(4), 659–662.
  https://doi.org/10.2307/1879665
- Kamihigashi, T. (2001). Necessity of transversality conditions for
  infinite horizon problems. *Econometrica*, 69(4), 995–1012.
  https://doi.org/10.1111/1468-0262.00227
- Kennan, J., & Walker, J. R. (2011). The effect of expected income on
  individual migration decisions. *Econometrica*, 79(1), 211–251.
  https://doi.org/10.3982/ECTA4657
- Michel, P. (1982). On the transversality condition in infinite horizon
  optimal problems. *Econometrica*, 50(4), 975–985.
  https://doi.org/10.2307/1912772
- Neumark, D., & Simpson, H. (2015). Place-based policies. En *Handbook of
  Regional and Urban Economics* (Vol. 5B, pp. 1197–1287). Elsevier.
  https://doi.org/10.1016/B978-0-444-59531-7.00018-1
- Pražák, P. (2012). Modely vzniku a eliminace ekonomických regionálních
  disparit jako úlohy optimálního řízení [Modelos de surgimiento y
  eliminación de disparidades económicas regionales como problemas de control
  óptimo]. *E+M Ekonomie a Management*, 15(2), 15–25.
  http://hdl.handle.net/11025/17437
- Rahman, M. A. (1963). Regional allocation of investment: An aggregative
  study in the theory of development programming. *Quarterly Journal of
  Economics*, 77(1), 26–39. https://doi.org/10.2307/1879370
- Redding, S. J., & Turner, M. A. (2015). Transportation costs and the spatial
  organization of economic activity. En *Handbook of Regional and Urban
  Economics* (Vol. 5B, pp. 1339–1398). Elsevier.
  https://doi.org/10.1016/B978-0-444-59531-7.00020-X
- Surkov, P. G. (2013). On an optimal control problem for a nonlinear system
  [en ruso]. *Trudy Instituta Matematiki i Mekhaniki UrO RAN*, 19(4),
  241–249. https://www.mathnet.ru/eng/timm1018
- Takayama, A. (1967). Regional allocation of investment: A further analysis.
  *Quarterly Journal of Economics*, 81(2), 330–336.
  https://doi.org/10.2307/1879591
- Ukhin, M. Yu., & Achituev, S. A. (2008). Multicomponent model-based
  optimization of the regional development strategies. *Automation and Remote
  Control*, 69(3), 514–524. https://doi.org/10.1134/S0005117908030168

### Datos
- Feenstra, R. C., Inklaar, R., & Timmer, M. P. (2015). The next generation
  of the Penn World Table. *American Economic Review*, 105(10), 3150–3182.
  https://doi.org/10.1257/aer.20130954. Se usa la versión 11.0,
  https://doi.org/10.34894/FABVLR: datos nacionales de México para la
  sesión 12.
- INEGI. *Producto Interno Bruto por Entidad Federativa* (PIBE), año base
  2018. Sistema de Cuentas Nacionales de México. Se usa en las sesiones 5 y
  14.
- OCDE. *Regional Database* (regiones TL2): población y empleo por entidad,
  para el PIB per cápita de la sesión 5 y el PIB por trabajador de la
  sesión 14.
- Las series concretas, sus columnas y sus licencias se documentan en
  `Data/README.md`; `Code/descargar_datos.jl` descarga los datos y genera los
  CSV de `Data/`.
