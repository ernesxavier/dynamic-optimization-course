# Diagnóstico de matemáticas (sesión 1)

Diez preguntas cortas para saber qué conviene repasar antes de empezar. **No
cuenta para la calificación**: sirve para que tú (y el profesor) sepan qué
claves de repaso necesitas. Resuélvelo sin calculadora en unos 30 minutos;
donde haga falta un número, basta una aproximación ($\ln 2 \approx 0.69$,
$e^{-1} \approx 0.37$). Las respuestas están plegadas debajo de cada
pregunta.

Todas las preguntas usan sólo el nivel básico: las claves B de las [notas de
repaso](./README.md). Al final hay dos preguntas abiertas, sin respuesta
correcta, que el profesor usa para planear el curso.

---

**1. Máximo en un intervalo.** Una región puede invertir $x \in [0, 3]$ y
obtiene un beneficio neto $f(x) = 10x - x^2$.

- (a) ¿Dónde se anula $f'(x)$? ¿Está ese punto en el intervalo?
- (b) ¿Cuál es la inversión óptima y cuánto vale el beneficio?

<details>
<summary>Respuesta</summary>

(a) $f'(x) = 10 - 2x = 0$ en $x = 5$, fuera de $[0, 3]$.
(b) En todo el intervalo $f'(x) > 0$: el beneficio crece, así que el óptimo
es la esquina $x^\ast = 3$, con $f(3) = 21$. Es una **solución de esquina**:
el máximo está en el borde sin que la derivada se anule.
</details>

**2. Crecimiento y logaritmos.** El PIB per cápita de una entidad se duplicó
en 35 años.

- (a) ¿A qué tasa de crecimiento anual, aproximadamente?
- (b) Si $y(t) = y_0e^{gt}$, ¿cuánto vale $\frac{d}{dt}\ln y(t)$?

<details>
<summary>Respuesta</summary>

(a) $g = \ln 2/35 \approx 0.69/35 \approx 0.02$, un 2% anual.
(b) $\ln y(t) = \ln y_0 + gt$, así que la derivada es $g$: la derivada del
logaritmo es la tasa de crecimiento.
</details>

**3. Derivadas parciales.** La producción es $Y = K^{0.3}L^{0.7}$.

- (a) Calcula $\partial Y/\partial K$ y escríbela en términos de $Y/K$.
- (b) Si $K$ sube 1% y $L$ no cambia, ¿cuánto sube $Y$, aproximadamente?

<details>
<summary>Respuesta</summary>

(a) $\partial Y/\partial K = 0.3K^{-0.7}L^{0.7} = 0.3\thinspace Y/K$.
(b) Alrededor de 0.3%: el exponente 0.3 es la elasticidad de $Y$ respecto
de $K$.
</details>

**4. Descuento.** Un proyecto paga 1 cada año para siempre.

- (a) Con factor de descuento $\beta = 0.95$ y el primer pago hoy, ¿cuánto
  vale hoy, $\sum_{t=0}^{\infty} \beta^t$?
- (b) En tiempo continuo, con tasa $\rho = 0.05$, ¿cuánto vale
  $\int_0^\infty e^{-\rho t}\thinspace dt$?

<details>
<summary>Respuesta</summary>

(a) $1/(1 - 0.95) = 20$ (serie geométrica).
(b) $1/\rho = 20$. Los dos valores coinciden (aproximadamente) porque
$\beta \approx e^{-\rho}$.
</details>

**5. Matrices.** Sea

$$
A = \begin{pmatrix} 2 & 1 \cr 1 & 3 \end{pmatrix}.
$$

- (a) Calcula $A(1, 1)^\top$ y el determinante de
  $A$.
- (b) Resuelve $A(x, y)^\top = (5, 5)^\top$.

<details>
<summary>Respuesta</summary>

(a) $(3, 4)$ y $\det A = 2 \cdot 3 - 1 \cdot 1 = 5$.
(b) $2x + y = 5$ y $x + 3y = 5$ dan $x = 2$, $y = 1$. Como $\det A \neq 0$,
la solución es única.
</details>

**6. Una ecuación diferencial.** La brecha de ingreso de una entidad
respecto de su estado estacionario cumple $\dot{z} = -0.1\thinspace z$, con
$z(0) = 50$.

- (a) Escribe $z(t)$. ¿Cuánto vale $z(10)$?
- (b) ¿En cuántos años se cierra la mitad de la brecha?

<details>
<summary>Respuesta</summary>

(a) $z(t) = 50e^{-0.1t}$ y $z(10) = 50e^{-1} \approx 18.4$.
(b) $e^{-0.1t} = 1/2$ da $t = \ln 2/0.1 \approx 6.9$ años: la **vida
media** de la brecha.
</details>

**7. Iterar una regla.** El capital de una región evoluciona según
$k_{t+1} = 0.5\thinspace k_t + 2$, con $k_0 = 0$.

- (a) Calcula $k_1$, $k_2$ y $k_3$.
- (b) ¿A qué valor se acerca $k_t$? ¿Por qué se acerca?

<details>
<summary>Respuesta</summary>

(a) $k_1 = 2$, $k_2 = 3$, $k_3 = 3.5$.
(b) A $k^\ast = 4$, el punto fijo de $k = 0.5k + 2$. Se acerca porque cada
paso reduce la distancia a la mitad: $k_{t+1} - 4 = 0.5(k_t - 4)$.
</details>

**8. Integrales.** Calcula $\int_0^2 (3t^2 + 1)\thinspace dt$ y
$\frac{d}{dt}\int_0^t (3s^2 + 1)\thinspace ds$.

<details>
<summary>Respuesta</summary>

$\left[t^3 + t\right]_0^2 = 10$. La derivada de la integral con límite
superior variable es el integrando evaluado en el límite: $3t^2 + 1$
(teorema fundamental del cálculo).
</details>

**9. Valor esperado.** Una trabajadora gana 100 seguros en su región. En otra
región ganaría 150 con probabilidad 0.6 u 80 con probabilidad 0.4, y
mudarse cuesta 15.

- (a) ¿Cuál es el salario esperado en la otra región?
- (b) Si sólo le importa el promedio, ¿le conviene mudarse?

<details>
<summary>Respuesta</summary>

(a) $0.6 \times 150 + 0.4 \times 80 = 122$.
(b) Sí: $122 - 15 = 107 > 100$. Con aversión al riesgo la comparación
cambia, porque importa la incertidumbre y no sólo el promedio; el curso
retoma esta decisión en la sesión 19.
</details>

**10. Leer código.** ¿Qué devuelve este fragmento de Julia?

```julia
f(x) = 2x + 1
v = [1, 2, 3]
f.(v), sum(v .^ 2)
```

<details>
<summary>Respuesta</summary>

`([3, 5, 7], 14)`. El punto aplica la función, o la potencia, a cada
elemento del vector; `sum` suma $1 + 4 + 9$. Si nunca has programado, no
importa: el Laboratorio 0 empieza desde cero.
</details>

---

## Dos preguntas abiertas

No tienen respuesta correcta ni cuentan para la calificación.

**A. Experiencia en programación.** ¿Has usado alguno de estos? Para cada
uno, marca *nunca*, *un poco* o *con soltura*: Julia, Python, R, Stata,
MATLAB, Excel con fórmulas.

**B. Tu tesis.** Describe en tres a cinco líneas un problema de tu tesis en
el que una decisión de hoy cambie lo que se puede hacer después. Si puedes,
di qué se decide (el **control**), qué se acumula o cambia con esa decisión
(el **estado**) y qué se quiere lograr (el **objetivo**). Si no se te ocurre
ninguno, escribe el tema de tu tesis: lo buscamos juntos durante el curso.
Este problema es el punto de partida de la propuesta de proyecto
(sesión 12).

---

## Qué repasar según tus respuestas

| Si fallaste o dudaste en la pregunta | Repasa | Se usa en las sesiones |
|---|---|---|
| 1 | [C.B1–B2](calculo.md#cb1) (derivadas; máximos y soluciones de esquina) | 2, 3, 10, 11, 13, 14 |
| 2 | [C.B3](calculo.md#cb3) (exponencial y logaritmo), [E.B2](estadistica.md#eb2) (tasas de crecimiento) | 5, 10, 12, 14, 15, 18 |
| 3 | [C.B5](calculo.md#cb5) (derivadas parciales y gradiente) | 2, 3 |
| 4 | [A.B3](analisis.md#ab3) (series y descuento), [C.B4](calculo.md#cb4) (integrales) | 10, 11, 12, 15, 16 |
| 5 | [L.B1–B3](algebra_lineal.md#lb1) (vectores, matrices, sistemas y determinantes) | 2, 3, 7 |
| 6 | [D.B1–B2](ecuaciones_diferenciales.md#db1) (ecuaciones diferenciales; crecimiento y decaimiento) | 5, 6 |
| 7 | [D.B3](ecuaciones_diferenciales.md#db3) (simular e iterar), [A.B2](analisis.md#ab2) (sucesiones y límites) | 5, 6, 9, 16 |
| 8 | [C.B4](calculo.md#cb4) (integrales) | 10, 11, 12 |
| 9 | [E.B1](estadistica.md#eb1) (media, varianza y valor esperado) | 5, 19 |
| 10 | [N.B1](metodos_numericos.md#nb1) (Julia en cinco minutos), [N.B3](metodos_numericos.md#nb3) (cuadernos de Pluto) | 4 y todos los laboratorios |

Las preguntas no cubren los niveles intermedio y avanzado. Antes de cada
sesión, la tabla del [índice de repaso](./README.md) dice qué claves I conviene
leer, y cada área termina con un autodiagnóstico de 10 preguntas.

## Orientación según tu formación

Es una guía de lo que suele pasar, no una regla; manda el resultado del
diagnóstico.

- **Economía.** Las preguntas 2, 3, 4 y 9 suelen salir bien. Conviene
  revisar las matrices (L.B1–B3) y las ecuaciones diferenciales (D.B1–B3)
  antes de la sesión 5, y Julia (N.B1–B3) antes del Laboratorio 0.
- **Matemáticas, física o ingeniería.** Las preguntas de cálculo, matrices y
  ecuaciones diferenciales suelen salir bien. Conviene revisar la lectura
  económica: tasas de crecimiento (E.B2), elasticidades (pregunta 3) y
  descuento (A.B3).

Si fallaste tres preguntas o más, no te preocupes: las sesiones 1 a 4
repasan lo necesario y el curso está pensado para eso. Lee las claves de la
tabla poco a poco, en la semana anterior a la sesión que las usa.
