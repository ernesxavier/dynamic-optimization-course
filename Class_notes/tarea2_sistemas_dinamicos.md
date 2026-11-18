# Tarea 2: Sistemas dinámicos (Unidad II)

> **Entrega:** al inicio de la sesión 10, a mano o en LaTeX, en PDF. Es una
> tarea de ejercicios: no se pide código. Puedes usar calculadora y
> comprobar tus resultados con los cuadernos de la unidad, pero se califica
> el desarrollo.
>
> **Cubre** las sesiones 5 a 9. Repaso útil: [D.I1](repaso/ecuaciones_diferenciales.md#di1),
> [D.I3](repaso/ecuaciones_diferenciales.md#di3),
> [D.I4](repaso/ecuaciones_diferenciales.md#di4),
> [D.I5](repaso/ecuaciones_diferenciales.md#di5),
> [D.I6](repaso/ecuaciones_diferenciales.md#di6),
> [D.A5](repaso/ecuaciones_diferenciales.md#da5) y
> [L.B1–B3](repaso/algebra_lineal.md#lb1).
>
> **Reglas.** Puedes discutir con tus compañeros y usar herramientas de IA,
> pero cada quien escribe su solución. En la entrega se puede pedir a
> cualquier estudiante que explique en 5 minutos una parte de su solución;
> lo que no pueda explicar no cuenta (programa, sección Evaluación). En cada
> problema, los pasos intermedios valen tanto como el resultado.

| Problema | Tema | Sesiones | Puntos |
|---|---|---|---|
| A1 | Una brecha que se cierra y un programa temporal | 5 | 25 |
| A2 | Un bosque con tala fija | 6 | 25 |
| A3 | Empleo y salarios en una región | 7 | 25 |
| A4 | Turismo y calidad ambiental | 8, 9 | 25 |
| A5 **[Avanzado]** | No hay ciclos en el modelo de turismo | 8 | Hasta 10 extra (sin pasar de 100) |

---

### A1. Una brecha que se cierra y un programa temporal (25 puntos)

Sea $y(t)$ el PIB per cápita de una entidad, $y^\ast$ el de su estado
estacionario y $x(t) = \ln y(t) - \ln y^\ast$ la brecha en logaritmos. Como
en la sesión 5, $\dot x = -\beta x$, con $t$ en años.

- **(a)** En 2003 la entidad tenía el 60% de $y^\ast$ y en 2023, el 70%.
  Calcula $\beta$ y la vida media de la brecha. (Pista: ¿cuánto vale $x$ en
  cada año?)
- **(b)** Si nada cambia, ¿en qué año llega al 90% de $y^\ast$?
- **(c)** Un programa federal suma un punto porcentual de crecimiento al año
  de 2023 a 2033: en esos diez años $\dot x = -\beta x + m$, con
  $m = 0.01$, y después vuelve a ser $\dot x = -\beta x$. Encuentra el
  equilibrio de la ecuación con el programa, resuelve para $x(t)$ entre 2023
  y 2033 y calcula qué fracción de $y^\ast$ tiene la entidad en 2033, con el
  programa y sin él.
- **(d)** ¿En qué año llega la entidad al 90% de $y^\ast$ con el programa?
  ¿Cuántos años adelanta el programa?
- **(e)** Muestra que, a partir de 2033, la diferencia entre las dos
  trayectorias (con y sin programa) se reduce a la mitad cada $\ln 2/\beta$
  años. ¿Cambia el programa el destino de largo plazo de la entidad? ¿Qué
  tendría que cambiar el programa para que sí lo cambiara? (Pista:
  convergencia condicional, sesión 5, sección 3.3.)

### A2. Un bosque con tala fija (25 puntos)

El acervo de madera de un bosque comunal, $x$ (en miles de m³), crece de
forma logística, y la comunidad tala una cantidad fija $h$ al año:

$$
\dot x = f(x) = g\thinspace x\Big(1 - \frac{x}{K}\Big) - h,
\qquad g = 0.5,\quad K = 100.
$$

- **(a)** Con $h = 8$, encuentra los equilibrios, dibuja la recta de fase y
  clasifícalos con el signo de $f'(x^\ast)$. Uno de ellos es un umbral:
  ¿qué separa?
- **(b)** Calcula la vida media de una desviación pequeña alrededor del
  equilibrio estable.
- **(c)** ¿Cuál es la tala más grande que el bosque puede sostener? Dibuja
  $f(x)$ con $h = 8$, con esa tala y con $h = 13$. ¿Qué pasa con los
  equilibrios cuando $h$ la rebasa, y qué le pasa al bosque?
- **(d)** Con $h = 8$, un incendio deja el acervo en $x = 15$. ¿Qué pasa si
  la tala sigue igual? ¿Cuál es la tala más grande con la que el bosque
  empieza a recuperarse desde $x = 15$?
- **(e)** Supón ahora que la comunidad tala una fracción fija del acervo,
  $h = qx$, con $0 < q < g$. Encuentra los equilibrios y clasifícalos.
  Muestra que el bosque se recupera desde cualquier $x_0 > 0$. ¿Por qué es
  más robusta esta regla que la tala fija de (d)?
- **(f)** Si la tala y el crecimiento se cuentan una vez al año, el modelo
  es $x_{t+1} = x_t + f(x_t)$. Muestra que un punto fijo $x^\ast$ es estable
  si $-2 < f'(x^\ast) < 0$, y que la convergencia oscila si
  $f'(x^\ast) < -1$. Con $g = 2.5$ y $h = 40$, y con $g = 4$ y $h = 64$,
  comprueba que los equilibrios son los mismos que en (a) y clasifica el
  equilibrio de arriba en tiempo continuo y en tiempo discreto. Compara con
  la sesión 6, sección 2.6.

### A3. Empleo y salarios en una región (25 puntos)

Sean $e$ el empleo y $w$ el salario de una región, medidos como desviaciones
respecto de su tendencia. Las empresas llegan cuando el salario está bajo, y
el salario sube cuando hay mucho empleo y vuelve a su nivel normal:

$$
\dot e = -aw,
\qquad
\dot w = be - cw,
\qquad a, b, c > 0.
$$

- **(a)** Escribe la matriz del sistema, su traza y su determinante. Muestra
  que el origen es estable para cualesquiera $a, b, c > 0$. ¿Cuándo es un
  foco y cuándo un nodo?
- **(b)** Con $a = 0.5$, $b = 0.4$ y $c = 0.3$, calcula los eigenvalores y di
  qué tipo de equilibrio es. Calcula el periodo de las oscilaciones y la
  vida media de su amplitud.
- **(c)** Escribe el sistema como una ecuación de segundo orden en $e$ y
  comprueba que sus raíces características son los eigenvalores de (b)
  (sesión 7, sección 3).
- **(d)** ¿Desde qué valor de $c$ desaparecen los ciclos, con $a$ y $b$ de
  (b)? Interpreta: ¿qué clase de mercado laboral regional no tiene ciclos de
  empleo?
- **(e)** Si los ajustes son anuales,
  $e_{t+1} - e_t = -aw_t$ y $w_{t+1} - w_t = be_t - cw_t$. Escribe la matriz
  de $(e_{t+1}, w_{t+1})$ en términos de $(e_t, w_t)$ y decide su
  estabilidad con la traza y el determinante
  ([D.A5](repaso/ecuaciones_diferenciales.md#da5)), con los valores de (b)
  y con $b = 0.8$. ¿Desde qué $b$ el sistema anual es inestable? ¿Pasa lo
  mismo en tiempo continuo?

### A4. Turismo y calidad ambiental (25 puntos)

En una región costera, $E$ es la calidad ambiental (como fracción de la
máxima) y $T$ el número de turistas (en una escala conveniente). El ambiente
se regenera de forma logística y los turistas lo deterioran; los turistas
llegan si la calidad supera un nivel mínimo y se van si no:

$$
\dot E = rE(1 - E) - aTE,
\qquad
\dot T = T(bE - c),
\qquad r, a, b, c > 0.
$$

- **(a)** Encuentra las isoclinas y los equilibrios con $E \ge 0$ y
  $T \ge 0$. ¿Qué condición hace falta para que haya un equilibrio con
  turistas?
- **(b)** Con $r = a = c = 1$ y $b = 2$, calcula los equilibrios, el
  jacobiano en cada uno y clasifícalos.
- **(c)** Dibuja el diagrama de fase: isoclinas, equilibrios y dirección del
  flujo en cada región. Describe la trayectoria que empieza en
  $(E, T) = (1, 0.1)$, una costa limpia a la que llegan los primeros
  turistas. ¿Cada cuánto tiempo, aproximadamente, se repiten los altibajos
  del turismo cerca del equilibrio?
- **(d)** Una cuota de entrada reduce el atractivo de la región: baja $b$.
  Calcula el equilibrio con $b = 1.5$. ¿Qué pasa si la cuota es tan alta que
  $b < c$? ¿Qué equilibrio atrae entonces a las trayectorias? Interpreta el
  dilema entre calidad ambiental y turismo.
- **(e)** Con $a = c = 1$ y $b = 2$, ¿desde qué valor de $r$ el equilibrio
  con turistas es un nodo y no un foco? Interpreta: ¿qué clase de ambiente
  evita los altibajos?

### A5. [Avanzado] No hay ciclos en el modelo de turismo (hasta 10 puntos extra)

En el modelo de A4 con un equilibrio interior $(E^\ast, T^\ast)$, sea

$$
V(E, T) = b\Big(E - E^\ast - E^\ast\ln\frac{E}{E^\ast}\Big) +
a\Big(T - T^\ast - T^\ast\ln\frac{T}{T^\ast}\Big),
\qquad E, T > 0.
$$

Muestra que $V \ge 0$, con igualdad sólo en el equilibrio, y que a lo largo
de las trayectorias $\dot V = -br(E - E^\ast)^2 \le 0$
([D.A4](repaso/ecuaciones_diferenciales.md#da4)). Concluye que el sistema no
tiene órbitas periódicas con $E, T > 0$. (Pista: en una órbita periódica,
$V$ vuelve a su valor inicial.) ¿Qué dice esto sobre los altibajos de
A4(c)?
