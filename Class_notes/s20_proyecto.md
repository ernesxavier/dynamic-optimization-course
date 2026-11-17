# Sesiones 20 a 24: El proyecto

> **Cómo usar esta guía.** Es la guía de la Unidad V para estudiantes y
> profesor: qué se entrega, qué se hace en cada sesión y con qué material
> del curso se resuelve cada tipo de problema. Los pesos, la rúbrica, los
> requisitos (datos y reproducibilidad) y las ideas de proyecto están en la
> sección **Evaluación** del [programa](../programa/programa.md) y no se
> repiten aquí.

**Pregunta de la unidad.** ¿Qué problema de tu tesis se puede plantear y
resolver como un problema de optimización dinámica, y qué dice la solución
sobre la región?

---

## 0. El calendario

| Sesión | Formato | Se entrega | Se trae |
|---|---|---|---|
| 12 | — | Propuesta (1 página), requisito sin calificación | |
| 20 | Taller de avances: revisión por pares | **Avance** (10%) | El avance impreso o en PDF y el cuaderno corriendo |
| 21 | Taller de proyecto (colchón) | Tarea 4 | El cuaderno y las dudas concretas |
| 22 | Taller de proyecto (colchón) | | El cuaderno con los datos cargados |
| 23 y 24 | Presentaciones y cierre | **Reporte y cuaderno** (30%, con la presentación) | La presentación |

Si el curso va atrasado, las sesiones 21 y 22 se usan primero para
recuperar la unidad pendiente, y el proyecto pasa a trabajo en casa con
asesoría. Las sesiones 23 y 24 no se recortan.

---

## 1. El avance (sesión 20)

El avance es el proyecto a medio camino, no un plan. Tiene cuatro partes,
en un documento de 3 a 5 páginas más el cuaderno:

1. **Planteamiento completo.** La pregunta económica; el estado, el
   control, el objetivo y las restricciones, con unidades; el horizonte y
   la tasa de descuento. Si cambió respecto de la propuesta, por qué (por
   ejemplo, si ahora conviene la programación dinámica).
2. **Condiciones de optimalidad.** Derivadas a mano: el Hamiltoniano y sus
   condiciones, o la ecuación de Bellman y la de Euler. Lo que ya se pudo
   resolver analíticamente (un estado estacionario, un caso particular).
3. **Un primer resultado numérico verificado.** El código resuelve al menos
   un caso con solución conocida: un caso particular con solución cerrada,
   el estado estacionario o un parámetro con el que el problema se reduce a
   uno visto en el curso.
4. **Plan de datos.** Qué parámetros se calibran, con qué fuente y qué
   supuestos se harán donde no hay datos.

### 1.1 Plan de la sesión 20 (120 minutos)

Cada proyecto tiene un revisor asignado de antemano, que lee el avance
antes de la sesión.

| Minutos | Qué |
|---|---|
| 0–10 | Instrucciones y orden de las rondas |
| 10–110 | Rondas de 15 minutos por proyecto (con más de 6 proyectos, 12 minutos): 5 de exposición, 5 del revisor con la lista de cotejo y 5 de discusión abierta |
| 110–120 | Cierre: cada quien escribe los tres cambios que hará |

### 1.2 Lista de cotejo para el revisor

El revisor marca cada punto (sí, a medias, no) y entrega por escrito **dos
fortalezas, dos riesgos y una pregunta**.

**Planteamiento**
- ¿Están definidos el estado, el control, el objetivo y las restricciones,
  con unidades y periodo (años, trimestres)?
- ¿Se entiende qué pregunta económica responde y por qué es regional?
- ¿Se justifica el método? (Tabla de la sección 4 de las notas de la
  sesión 18.)

**Solución analítica**
- ¿Las condiciones de primer orden y las del coestado (o la envolvente)
  están bien derivadas?
- ¿Están las condiciones terminales: valor de salvamento, estado final
  fijo o transversalidad?
- ¿Hay un estado estacionario o un caso particular resuelto a mano?

**Solución numérica**
- ¿Hay una verificación contra un caso conocido, con el error medido?
- En programación dinámica: ¿la malla cubre los estados que se alcanzan?
  ¿Hay regla de paro? En control óptimo: ¿el horizonte del problema de
  valor en la frontera es suficiente?

**Datos**
- ¿Cada parámetro tiene una fuente o un supuesto explícito?
- ¿Se prevé mostrar cómo cambian los resultados con los supuestos más
  dudosos?

**Reproducibilidad**
- ¿El cuaderno corre de principio a fin en el entorno del curso, sin pasos
  a mano?

---

## 2. El taller de proyecto (sesiones 21 y 22)

Asesoría por proyecto, en bloques de 15 a 20 minutos, mientras los demás
trabajan en su cuaderno. Conviene llegar con una pregunta concreta: "el
problema de valor en la frontera no converge con estos parámetros", no
"revisar el proyecto".

Lo que debe quedar al final de la sesión 22:

- La calibración hecha con datos (sección 3.2) y el análisis de
  sensibilidad de los dos o tres supuestos más dudosos.
- El cuaderno reproduce todas las figuras y tablas del reporte.
- Las tres respuestas de la revisión por pares atendidas, o una razón para
  no hacerlo.

La Tarea 4 se entrega en la sesión 21; su código alimenta el proyecto.

---

## 3. Herramientas del curso para el proyecto

### 3.1 Según el tipo de problema

No hace falta empezar de cero: cada tipo de problema ya se resolvió en el
curso con un cuaderno que se puede adaptar.

| Tipo de problema | Notas | Cuaderno con el código |
|---|---|---|
| Dinámica sin optimizar: estabilidad, diagrama de fase | Sesiones 6 a 8 | `s06` a `s08`; Laboratorio 1 (`s09`), con dos regiones |
| Control óptimo con horizonte finito | Sesiones 10 y 11 | `s11`; la rama estable con `BVProblem` del Laboratorio 3 (`s19`) |
| Horizonte infinito, punto de silla | Sesión 12 | `s12` (rama estable calculada hacia atrás) |
| Control acotado, bang-bang, varias regiones | Sesiones 13 y 14 | `s13`, `s14` (tiempo de cambio) |
| Programación dinámica, horizonte finito | Sesión 15 | `s15` (inducción hacia atrás en una malla) |
| Programación dinámica, horizonte infinito, estado continuo | Sesión 16 | Laboratorio 2 (`s17`): `bellman` con interpolación e `iterar_valor` |
| Decisiones con incertidumbre, estados discretos | Sesiones 15 (P.2) y 18 (sección 4) | Laboratorio 2 (`s17`, sección 4) y Laboratorio 3 (`s19`): cadena de Markov y política |
| Recurso natural renovable | Sesión 18, sección 5 | La ecuación de Bellman de la sección 5.3 con el código del Laboratorio 2 |

Los cuadernos están en `Code/` y sus fuentes en `src/`. Para empezar el
proyecto, se copia el cuaderno más cercano y se cambian el modelo y los
parámetros, conservando la verificación.

### 3.2 Datos

| Archivo | Contenido | Usado en |
|---|---|---|
| [`Data/entidades.csv`](../Data/entidades.csv) | PIB (total y petrolero), población y empleo de las 32 entidades, por año (INEGI y OCDE) | Sesiones 5 y 14 |
| [`Data/pwt_mexico.csv`](../Data/pwt_mexico.csv) | Penn World Table 11.0 para México: capital, producto, empleo, depreciación, participación del trabajo | Sesión 12 |

Las fuentes, las columnas y las licencias están en
[`Data/README.md`](../Data/README.md), y la forma de actualizarlos, en
[`Code/descargar_datos.jl`](../Code/descargar_datos.jl). Otros datos del
INEGI (por ejemplo, la ENOE o los censos económicos) se agregan a `Data/`
con su fuente y fecha de descarga en el cuaderno. Las tasas de ahorro por
entidad **no se publican**: si el modelo las necesita, son un supuesto
explícito, como en la sesión 14.

### 3.3 Errores frecuentes

- **Periodo y unidades.** Mezclar tasas anuales con periodos de otra
  duración. En tiempo discreto, $\beta$ y $\delta$ dependen de la
  duración del periodo (Laboratorio 3, sección 2).
- **Notación de las lecturas.** Algunos textos usan $\delta$ para la tasa
  de descuento (Conrad y Rondeau, 2020); en el curso es la depreciación.
- **Verificar sólo que "se ve bien".** Toda solución numérica se compara
  con un caso conocido y se reporta el error (Laboratorio 2).
- **La malla no cubre los estados alcanzables**, o el estado siguiente cae
  fuera de ella y se extrapola sin darse cuenta.
- **Una diferencia pequeña entre iteraciones** tomada como error pequeño:
  usar la regla de paro de la sesión 16 (sección 2.3).
- **Un horizonte corto** en un problema de valor en la frontera que
  aproxima uno de horizonte infinito: comprobar que la solución no cambia
  al alargarlo.
- **Calibrar y concluir con el mismo dato.** Un parámetro elegido para
  reproducir un dato no puede usarse después como evidencia a favor del
  modelo (sesión 12, sección 5.4).

---

## 4. El reporte y la presentación (sesiones 23 y 24)

### 4.1 El reporte

De 10 a 15 páginas más el cuaderno, con las secciones de la rúbrica del
programa:

1. **Pregunta y planteamiento.** Por qué el problema es dinámico y por qué
   es regional.
2. **Solución analítica.** Condiciones de optimalidad y lo que se pudo
   resolver a mano.
3. **Solución numérica y verificación.** El método, la verificación contra
   un caso conocido y el error.
4. **Datos y calibración.** Cada parámetro con su fuente o supuesto, y la
   sensibilidad a los supuestos dudosos.
5. **Resultados e interpretación.** La política o la trayectoria óptima, los
   precios sombra y lo que implican para la región.
6. **Limitaciones.** Lo que el modelo deja fuera y cómo podría cambiar la
   conclusión.

Cada figura y tabla del reporte sale del cuaderno, que corre de principio a
fin en el entorno del curso (`Code/Project.toml`).

### 4.2 La presentación

15 minutos de exposición y 10 de preguntas. Una estructura que funciona:

| Minutos | Qué |
|---|---|
| 0–2 | La pregunta y por qué importa para la región |
| 2–5 | El modelo: estado, control, objetivo y restricciones |
| 5–8 | La solución: condiciones de optimalidad y el resultado analítico clave |
| 8–11 | Los números: verificación, calibración y el resultado principal |
| 11–14 | Interpretación: qué haría distinto la región y qué precio sombra lo explica |
| 14–15 | Limitaciones y siguiente paso en la tesis |

Las preguntas pueden ser sobre cualquier parte del reporte o del código,
como en la defensa oral de las tareas: quien presenta debe poder explicar
lo que entrega.
