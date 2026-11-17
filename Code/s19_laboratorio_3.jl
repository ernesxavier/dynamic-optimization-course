### A Pluto.jl notebook ###
# v1.0.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 3b568984-cf11-11f1-92ad-ff74830b51e4
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, Markdown, BoundaryValueDiffEq
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ 3b56886c-cf11-11f1-af2e-d5b1da880424
md"""
# Sesión 19: Laboratorio 3. Dos métodos y una decisión con incertidumbre

**Pregunta de la unidad.** ¿Cómo debe crecer una región que decide cada año
cuánto invertir?

**Preguntas del laboratorio.**
1. El principio del máximo y la programación dinámica, ¿dan la misma regla
   de consumo para una región calibrada para México?
2. Una persona vive en una de dos regiones con salarios inciertos y mudarse
   le cuesta. ¿A partir de qué brecha salarial conviene mudarse? ¿Por qué
   hay quien no migra aunque la otra región pague más?

**Objetivos del laboratorio**
1. Resolver el principio del máximo como un problema de valor en la
   frontera con `BVProblem`.
2. Comparar la rama estable con la política de la iteración de la función
   valor, y ver cómo se acercan al acortar el periodo (sesión 18).
3. Escribir una ecuación de Bellman con incertidumbre: una cadena de
   Markov y un valor esperado.
4. Leer una política de migración y medir cómo depende del costo de
   mudarse y de la persistencia de los salarios.

**Cómo usar este cuaderno.** Los ejercicios con verificador dicen
**Pendiente** hasta que reemplazas `missing` por tu código. Mientras un
ejercicio está pendiente, las secciones que lo usan corren con una función
de referencia. La sección marcada **[Avanzado]** es opcional. La teoría
está en las notas de las sesiones 12, 16 y 18.

**Plan del laboratorio** (120 minutos). Cada bloque empieza con 3 a 5
minutos de demostración en el proyector; después cada quien trabaja en su
cuaderno.

| Minutos | Qué | Sección |
|---|---|---|
| 0–5 | Verificar que BoundaryValueDiffEq.jl funciona | 0 |
| 5–30 | El principio del máximo como problema de valor en la frontera | 1 |
| 30–55 | La iteración de la función valor con periodos más cortos; la comparación | 2 |
| 55–60 | Pausa | |
| 60–80 | ¿Migrar o quedarse?: la cadena de Markov y el operador de Bellman | 3 |
| 80–105 | La política; la brecha mínima según el costo y la persistencia | 3 |
| 105–120 | Cierre: preguntas 2 y 4, en voz alta | Preguntas |
| Después | ¿Dónde vive dentro de unos años? [Avanzado] y las demás preguntas | 4, Preguntas |

**Repaso recomendado** (en `Class_notes/repaso/`): N.B1 a N.B3 (Julia,
gráficas y Pluto), E.B1 (valor esperado), D.I7 (problemas de valor en la
frontera), N.I1 (bisección), N.I3 (DifferentialEquations.jl) y E.I1
(cadenas de dos estados). Para los puntos [Avanzado]: N.A1 (`BVProblem`) y
L.A4 (matrices estocásticas).
"""

# ╔═╡ 3b5688bc-cf11-11f1-8c5e-9bbee2946c57
TableOfContents(title = "Contenido")

# ╔═╡ 3b5688c6-cf11-11f1-99da-cd2e1b4c8f25
md"""
## 0. ¿Funciona BoundaryValueDiffEq.jl?

La primera vez que se resuelve un `BVProblem`, el paquete tarda un minuto o
más en compilarse. Si ves la versión, está listo.
"""

# ╔═╡ 3b5688c6-cf11-11f1-8890-9b3fa8ec5082
md"BoundaryValueDiffEq.jl, versión $(string(pkgversion(BoundaryValueDiffEq)))."

# ╔═╡ 3b5688d0-cf11-11f1-a9dc-9b398a068fc2
md"""
## Parte 1. El mismo problema por dos caminos

## 1. El principio del máximo como problema de valor en la frontera

La región de la sesión 12, calibrada para México: ``\delta = 0.035``,
``n = 0.023``, ``K/Y = 3.66``, ``\alpha = 1/3`` y ``\rho = \alpha/(K/Y) - \delta = 5.6\%``,
con ``A`` tal que el producto de estado estacionario vale 1 y
``k^\ast = 3.66``. El principio del máximo da el sistema

```math
k' = Ak^\alpha - (\delta + n)k - c,
\qquad
c' = \frac{c}{\theta}\big(\alpha Ak^{\alpha - 1} - \delta - \rho\big),
```

con ``k(0) = k_0`` y la transversalidad, que elige la rama estable. En la
computadora, la transversalidad se aproxima pidiendo que el capital llegue
a ``k^\ast`` en un horizonte largo, ``T = 100`` años: un **problema de valor
en la frontera** (D.I7), con una condición al principio y otra al final.

Aversión a la fluctuación del consumo, ``\theta``: $(@bind θ Slider(1.0:0.5:4.0, default = 2.0, show_value = true))
"""

# ╔═╡ 3b5688da-cf11-11f1-9439-0b77791a54d1
md"""
**1.** Escribe `ramsey!(du, u, p, t)`, que guarde en `du` las derivadas del
sistema, con `u = [k, c]`. Los parámetros están en `p.A`, `p.α`, `p.δ`,
`p.n`, `p.ρ` y `p.θ`.
"""

# ╔═╡ 3b5688e4-cf11-11f1-a914-8f650fcc45fb
function ramsey!(du, u, p, t)
    missing  # reemplaza esta línea
end

# ╔═╡ 3b5688ee-cf11-11f1-91a5-e9ac87366272
md"""
**2.** Escribe `condiciones!(res, u, p, t)`, las condiciones de frontera:
`res[1]` debe valer cero cuando ``k(0) = k_0`` y `res[2]` cuando
``k(T) = k^\ast``. Aquí `u` es la solución completa, así que `u(0.0)[1]` es
``k(0)``. Los datos están en `p.k0`, `p.T` y `p.kstar`.
"""

# ╔═╡ 3b5688ee-cf11-11f1-a62a-93d357242818
function condiciones!(res, u, p, t)
    missing  # reemplaza esta línea
end

# ╔═╡ 3b5688f8-cf11-11f1-aaa0-c39606ed6669
md"""
Con tus funciones, se resuelve dos veces: desde la mitad de ``k^\ast`` y
desde una vez y media. La conjetura inicial es una trayectoria que se acerca
a ``k^\ast`` con el consumo de estado estacionario.
"""

# ╔═╡ 3b56890c-cf11-11f1-be69-3de0b0f62349
md"""
**Observa:** cada trayectoria dibuja, en el plano ``(k, c)``, un tramo de la
rama estable. Juntos forman una **regla**: con este capital, consume tanto.
Es lo que la programación dinámica llama la política (notas de la sesión
18, sección 2.2). La conjetura inicial no tenía la forma correcta; ¿qué
pasa si la cambias por un consumo constante muy distinto de ``c^\ast``?

## 2. La iteración de la función valor, con periodos más cortos

El mismo problema en tiempo discreto, con periodos de ``\Delta`` años: la
utilidad del periodo es ``\Delta\,u(c)``, el capital cambia
``\Delta\big(f(k) - \delta k - c\big)`` y el descuento por trabajador es
``\hat\beta = (1 + n\Delta)/(1 + \rho\Delta)``. Con ``\Delta = 1`` es el
Laboratorio 2. Con ``\Delta \to 0`` es el modelo continuo (notas de la
sesión 18, sección 3). El operador es el del Laboratorio 2, con
interpolación y sección dorada.

Duración del periodo, ``\Delta`` (años): $(@bind Δ Select([1.0 => "1", 0.5 => "0.5", 0.25 => "0.25"]))
"""

# ╔═╡ 3b56892a-cf11-11f1-907f-b57d350e673c
md"""
## Parte 2. ¿Migrar o quedarse?

## 3. Una decisión con incertidumbre

Una persona vive en la región 1 o en la 2. Cada año, el salario de cada
región está **alto** o **bajo**: en la región 1 vale 1.2 o 0.8, y en la 2,
esos mismos valores multiplicados por una **brecha** ``b \ge 1``. Los dos
salarios cambian de forma independiente, con una cadena de Markov (E.I1)
que sigue en el mismo estado con probabilidad ``q``, la **persistencia**:

```math
P_1 = \begin{pmatrix} q & 1 - q \cr 1 - q & q \end{pmatrix}.
```

El estado conjunto de los salarios tiene cuatro valores (alto-alto,
alto-bajo, bajo-alto, bajo-bajo, con la región 1 primero), y su matriz de
transición es ``P = P_1 \otimes P_1`` (`kron`), de ``4 \times 4``. Cada año la
persona elige dónde vivir el año siguiente. Mudarse cuesta ``c``, medido en
utilidad:

```math
V(r, s) = \max_{r' \in \{1, 2\}}\Big\lbrace \ln w_{r'}(s) - c\,\mathbb{1}[r' \ne r] + \beta\,\mathbb{E}\big[V(r', s') \mid s\big]\Big\rbrace,
```

donde ``r`` es la región actual y ``s`` el estado de los salarios. El estado
completo tiene ``2 \times 4 = 8`` valores. ``V`` se guarda como una matriz de
``2 \times 4``: una fila por región, una columna por estado de los salarios.

**3.** Escribe `transicion(q)`, la matriz ``P`` de ``4 \times 4``.
"""

# ╔═╡ 3b56892a-cf11-11f1-9314-e93df1693088
transicion(q) = missing  # reemplaza missing

# ╔═╡ 3b568936-cf11-11f1-bdc8-33259f29a026
md"""
**El valor esperado.** Si ``V`` es la matriz de ``2 \times 4``, la fila ``r'``
de `V * P'` tiene, en la columna ``s``, el valor esperado
``\mathbb{E}[V(r', s') \mid s] = \sum_{s'} P_{ss'}V(r', s')``.

**4.** Escribe `operador_migracion(V, W, P, c, β)`, que devuelva la matriz
``TV`` de ``2 \times 4``. `W` es la matriz de salarios, del mismo tamaño que
``V``: `W[r, s]` es el salario de la región ``r`` en el estado ``s``.
"""

# ╔═╡ 3b56893e-cf11-11f1-869e-6755953d90b6
function operador_migracion(V, W, P, c, β)
    missing  # reemplaza esta línea
end

# ╔═╡ 3b568948-cf11-11f1-b400-6fb5fe1cce70
md"""
Brecha salarial, ``b``: $(@bind brecha Slider(1.0:0.05:1.6, default = 1.1, show_value = true))

Costo de mudarse, ``c``: $(@bind costo Slider(0.0:0.25:6.0, default = 2.0, show_value = true))

Persistencia de los salarios, ``q``: $(@bind q Slider(0.5:0.05:0.95, default = 0.9, show_value = true))

El factor de descuento es ``\beta = 0.95``.
"""

# ╔═╡ 3b568952-cf11-11f1-8008-672e808ce99c
md"""
### La brecha mínima para mudarse

¿Qué brecha ``b`` hace que una persona de la región 1 se mude cuando los dos
salarios están **altos**? La función auxiliar `se_muda(b, c, q)` resuelve el
problema y responde verdadero o falso.

**5.** Escribe `brecha_minima(c, q)`: con **bisección** (N.I1) en
``b \in [1, 3]``, la menor brecha con la que se muda, con tolerancia
``10^{-4}``. Si no se muda ni con ``b = 3``, devuelve `Inf`.
"""

# ╔═╡ 3b568952-cf11-11f1-b01b-d3d4254ecc44
brecha_minima(c, q) = missing  # reemplaza missing

# ╔═╡ 3b568968-cf11-11f1-936d-19def23b1cb2
md"""
Las líneas continuas son tu ejercicio (los dos salarios altos); las
punteadas, la misma cuenta cuando el salario de la región 1 está bajo y el
de la 2 alto.

**Observa:**
1. En alto-alto, ¿cambia mucho la brecha mínima con la persistencia? ¿Por
   qué no, si ``b`` es una diferencia **permanente**?
2. En bajo-alto hay además una diferencia **temporal**. Con salarios
   persistentes (azul), ¿por qué una persona se muda aunque la región 2
   pague menos en promedio (``b < 1``)? ¿Y con salarios poco persistentes?
3. El costo se paga **una vez**; la diferencia se cobra mientras dure. ¿Qué
   tipo de diferencia salarial mueve más a la gente?

## 4. [Avanzado] ¿Dónde vive dentro de unos años?

*Fuera de clase.* Con la política, la región y los salarios forman una
cadena de Markov de 8 estados (L.A4): los estados 1 a 4 son la región 1 con
cada estado de los salarios, y 5 a 8, la región 2. Su matriz `M` la
construye la función auxiliar `cadena_completa`. Si ``\psi_0`` es la
distribución de hoy (un vector fila), la de dentro de ``t`` años es
``\psi_0 M^t``.

**6.** Escribe `distribucion(M, ψ0, t)`, que devuelva ``\psi_0M^t`` como
vector. `ψ0` es un vector columna; usa `ψ0'` para la fila.
"""

# ╔═╡ 3b568968-cf11-11f1-832b-8d5b7cb23cde
distribucion(M, ψ0, t) = missing  # reemplaza missing

# ╔═╡ 3b568970-cf11-11f1-9298-2ff6b8c646df
md"""
Con los deslizadores de la sección 3.

**Observa:**
1. Con los valores iniciales, ¿cuántos años tarda en ser más probable que
   la persona viva en la región 2?
2. **Sube** el costo a 4: ¿se juntan las dos curvas? Si no, a largo plazo
   la región donde vive depende de dónde empezó: la cadena ya no tiene una
   sola distribución estacionaria.
3. **Baja** el costo a 0.5: ¿por qué la persona va y viene entre las dos
   regiones?

## Preguntas

1. En la sección 1, ¿por qué hay que fijar ``k(T) = k^\ast`` en lugar de
   imponer la transversalidad directamente? ¿Qué pasa con la solución si
   ``T`` es corto?
2. **Primera pregunta del laboratorio.** ¿Dan la misma regla los dos
   métodos? ¿De dónde viene la diferencia, y cómo se hace pequeña?
3. Con base en la tabla de la sección 4 de las notas de la sesión 18, ¿cuál
   método usarías para la migración? ¿Y para el modelo de dos regiones de la
   sesión 14?
4. **Segunda pregunta del laboratorio.** ¿Por qué hay quien no migra aunque
   la otra región pague más? Da al menos dos razones que el modelo captura
   y una que no.
5. **[Avanzado]** Kennan y Walker (2011) estiman un modelo como el de la
   sección 3 con datos de Estados Unidos. ¿Qué tendrías que medir para
   estimar el costo de mudarse entre dos estados de México?

## Para la próxima sesión

- **Unidad V: el proyecto.** Lleva tu problema escrito como un problema de
  optimización dinámica: estado, control, objetivo y restricciones, y cuál
  de los dos métodos piensas usar.
"""

# ╔═╡ 3b56897a-cf11-11f1-9b1b-cdd64bd3a9a8
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir el laboratorio.
"""

# ╔═╡ 3b56898e-cf11-11f1-bbc7-439180dcd8a0
begin
    const AZUL    = "#2a78d6"
    const NARANJA = "#eb6834"
    const GRIS    = "#52514e"
    const TINTA   = "#0b0b0b"
end;

# ╔═╡ 3b56898e-cf11-11f1-847e-d17f9c99d046
"Malla del capital: 200 puntos entre 0.3k* y 1.6k*, con k* = 3.66."
const MALLA_K = collect(range(0.3 * 3.66, 1.6 * 3.66, length = 200))

# ╔═╡ 3b56898e-cf11-11f1-be94-cbe6125ae851
"Calibración de la sesión 12 con α = 1/3: ρ reproduce K/Y = 3.66 y el producto de estado estacionario vale 1."
function calibrar(θ; α = 1 / 3, δ = 0.035, n = 0.023, KY = 3.66)
    kstar = KY
    (; α, θ, δ, n, ρ = α / KY - δ, A = kstar^(-α), kstar, cstar = 1 - (δ + n) * kstar)
end

# ╔═╡ 3b5688da-cf11-11f1-99aa-752901692fe2
p = calibrar(θ)

# ╔═╡ 3b56890c-cf11-11f1-89b1-59e14217d564
problema_discreto = let
    recursos(k) = k + Δ * (p.A * k^p.α - p.δ * k)
    siguiente(k, c) = (recursos(k) - Δ * c) / (1 + p.n * Δ)
    cotas(k) = (max(1e-8, (recursos(k) - (1 + p.n * Δ) * MALLA_K[end]) / Δ),
                (recursos(k) - (1 + p.n * Δ) * MALLA_K[1]) / Δ)
    u(c) = Δ * (p.θ == 1 ? log(c) : c^(1 - p.θ) / (1 - p.θ))
    β̂ = (1 + p.n * Δ) / (1 + p.ρ * Δ)
    (; recursos, siguiente, cotas, u, β̂)
end;

# ╔═╡ 3b568996-cf11-11f1-8fa8-b777f77d316b
"Parámetros de prueba de los ejercicios 1 y 2."
const P_PRUEBA = calibrar(2.0)

# ╔═╡ 3b568996-cf11-11f1-ad88-03e2bec2c222
"Sistema de Ramsey del principio del máximo (referencia)."
function ramsey_ref!(du, u, p, t)
    k, c = u
    du[1] = p.A * k^p.α - (p.δ + p.n) * k - c
    du[2] = c / p.θ * (p.α * p.A * k^(p.α - 1) - p.δ - p.ρ)
end

# ╔═╡ 3b5689a2-cf11-11f1-bf8c-2bab0d213043
"Condiciones de frontera k(0) = k0 y k(T) = k* (referencia)."
function condiciones_ref!(res, u, p, t)
    res[1] = u(0.0)[1] - p.k0
    res[2] = u(p.T)[1] - p.kstar
end

# ╔═╡ 3b5689a2-cf11-11f1-8eaf-fd852c87b555
"Interpolación lineal (repaso N.I4)."
function interp_lineal(xs, ys, x)
    i = clamp(searchsortedlast(xs, x), 1, length(xs) - 1)
    t = (x - xs[i]) / (xs[i+1] - xs[i])
    (1 - t) * ys[i] + t * ys[i+1]
end

# ╔═╡ 3b5689a2-cf11-11f1-a24e-436e5bec8bb5
"Consumo de la rama estable con capital k, interpolando en el tramo que corresponde."
function consumo_rama(ramas, k)
    sol = k < P_PRUEBA.kstar ? ramas.abajo : ramas.arriba
    ts = 0:0.1:100
    ks, cs = [sol(t)[1] for t in ts], [sol(t)[2] for t in ts]
    orden = sortperm(ks)
    interp_lineal(ks[orden], cs[orden], k)
end

# ╔═╡ 3b5689ac-cf11-11f1-8a30-abebb18f982b
"Sección dorada (repaso N.I5)."
function seccion_dorada(f, a, b; tol = 1e-8)
    φ = (sqrt(5) - 1) / 2
    c, d = b - φ * (b - a), a + φ * (b - a)
    fc, fd = f(c), f(d)
    while b - a > tol
        if fc > fd
            b, d, fd = d, c, fc
            c = b - φ * (b - a); fc = f(c)
        else
            a, c, fc = c, d, fd
            d = a + φ * (b - a); fd = f(d)
        end
    end
    (a + b) / 2
end

# ╔═╡ 3b5689ac-cf11-11f1-a109-47138203a772
"Operador de Bellman con interpolación y sección dorada (el del Laboratorio 2)."
function bellman(v, malla, β, u, siguiente, cotas)
    Tv, σ = similar(v), similar(v)
    for (i, x) in enumerate(malla)
        objetivo(c) = u(c) + β * interp_lineal(malla, v, siguiente(x, c))
        a, b = cotas(x)
        σ[i] = seccion_dorada(objetivo, a, b)
        Tv[i] = objetivo(σ[i])
    end
    Tv, σ
end

# ╔═╡ 3b5689ac-cf11-11f1-9e00-f5f1302d8934
"Iteración de la función valor con la regla de paro de la sesión 16 (la del Laboratorio 2)."
function iterar_valor(T, v0, β; ε = 1e-6)
    v = v0
    for n in 1:100_000
        v_nuevo = T(v)
        dif = maximum(abs.(v_nuevo .- v))
        v = v_nuevo
        dif ≤ ε * (1 - β) / β && return (; v, n)
    end
    (; v, n = 100_000)
end

# ╔═╡ 3b568916-cf11-11f1-b0a3-8b7a64cbbc2a
vfi = let
    (; u, siguiente, cotas, β̂) = problema_discreto
    v0 = fill(u(p.cstar) / (1 - β̂), length(MALLA_K))   # consumir c* para siempre
    tiempo = @elapsed r = iterar_valor(v -> bellman(v, MALLA_K, β̂, u, siguiente, cotas)[1], v0, β̂)
    _, σ = bellman(r.v, MALLA_K, β̂, u, siguiente, cotas)
    (; σ, r.n, tiempo)
end;

# ╔═╡ 3b5689b6-cf11-11f1-8537-d32ca61967e6
"Matriz de transición de los salarios de las dos regiones (referencia)."
transicion_ref(q) = (P1 = [q 1-q; 1-q q]; kron(P1, P1))

# ╔═╡ 3b5689b6-cf11-11f1-8302-9b21a110bec1
"Salarios: fila r = región, columna s = estado (alto-alto, alto-bajo, bajo-alto, bajo-bajo)."
salarios(brecha; alto = 1.2, bajo = 0.8) = [alto alto bajo bajo; brecha .* [alto bajo alto bajo]]

# ╔═╡ 3b5689c0-cf11-11f1-9d59-532c04645258
"Operador de Bellman de la migración (referencia)."
function operador_migracion_ref(V, W, P, c, β)
    EV = V * P'
    [maximum(log(W[r′, s]) - c * (r′ != r) + β * EV[r′, s] for r′ in 1:2) for r in 1:2, s in 1:4]
end

# ╔═╡ 3b5689c8-cf11-11f1-9eaf-e9954188a1e3
"""
Cadena de Markov de 8 estados (región, salarios) con la política: los
estados 1 a 4 son la región 1 con cada estado de los salarios; 5 a 8, la 2.
"""
function cadena_completa(sol)
    M = zeros(8, 8)
    for r in 1:2, s in 1:4
        r′ = sol.politica[r, s]
        for s′ in 1:4
            M[4(r - 1) + s, 4(r′ - 1) + s′] += sol.P[s, s′]
        end
    end
    M
end

# ╔═╡ 3b5689d4-cf11-11f1-b115-e765dcc79b4e
"Distribución dentro de t periodos, ψ0'Mᵗ (referencia)."
distribucion_ref(M, ψ0, t) = vec(ψ0' * M^t)

# ╔═╡ 3b5689d4-cf11-11f1-bf44-6b5af50ccbda
"¿La función ya está escrita? Verdadero si corre sin error y no devuelve missing."
function completo(f)
    r = try
        f()
    catch
        return false
    end
    pendiente(x) = x === missing || (x isa Union{AbstractArray, Tuple} && any(pendiente, x))
    !pendiente(r)
end

# ╔═╡ 3b5689de-cf11-11f1-b671-296a489292b6
"La función del estudiante si ya está escrita (si `prueba` corre sin missing), o la de referencia."
elegir(propia, referencia, prueba) = completo(prueba) ? propia : referencia

# ╔═╡ 3b5689de-cf11-11f1-9c8b-f579ac205ccb
usar_ramsey() = elegir(ramsey!, ramsey_ref!, () -> ramsey!(zeros(2), [2.0, 0.7], P_PRUEBA, 0.0))

# ╔═╡ 3b5689de-cf11-11f1-882f-ede0954622bf
usar_condiciones() = elegir(condiciones!, condiciones_ref!,
                            () -> condiciones!(zeros(2), t -> [1.0, 1.0], merge(P_PRUEBA, (k0 = 1.0, T = 1.0)), 0.0))

# ╔═╡ 3b5688f8-cf11-11f1-975a-0d45bee12f85
function rama_estable(p, k0; T = 100.0)
    q = merge(p, (; k0, T))
    conjetura(_, t) = [k0 + (q.kstar - k0) * (1 - exp(-0.1t)), q.cstar]
    prob = BVProblem(usar_ramsey(), usar_condiciones(), conjetura, (0.0, T), q)
    solve(prob, MIRK4(), dt = 0.5)
end

# ╔═╡ 3b568904-cf11-11f1-8eb8-89ba2cafb299
ramas = (abajo = rama_estable(p, 0.5 * p.kstar), arriba = rama_estable(p, 1.5 * p.kstar));

# ╔═╡ 3b568904-cf11-11f1-8f87-59dbaa5d4e1c
let
    ts = 0:0.5:60
    g1 = plot(; xlabel = "años", ylabel = "capital / k*", title = "Capital", legend = :top)
    g2 = plot(; xlabel = "capital / k*", ylabel = "consumo", title = "La rama estable: c(k)",
              legend = :topleft)
    for (nombre, sol, color) in (("desde 0.5k*", ramas.abajo, AZUL), ("desde 1.5k*", ramas.arriba, NARANJA))
        plot!(g1, ts, [sol(t)[1] for t in ts] ./ p.kstar; color, lw = 2, label = nombre)
        plot!(g2, [sol(t)[1] for t in ts] ./ p.kstar, [sol(t)[2] for t in ts]; color, lw = 2, label = nombre)
    end
    hline!(g1, [1.0]; color = GRIS, ls = :dash, lw = 1, label = "")
    scatter!(g2, [1.0], [p.cstar]; color = TINTA, ms = 4, msw = 0, label = "estado estacionario")
    plot(g1, g2; layout = (1, 2), size = (800, 330))
end

# ╔═╡ 3b568916-cf11-11f1-85a5-4b1aa0e92db2
let
    ks = range(0.5 * p.kstar, 1.5 * p.kstar, length = 200)
    c_bvp = consumo_rama.(Ref(ramas), ks)
    c_vfi = [interp_lineal(MALLA_K, vfi.σ, k) for k in ks]
    g1 = plot(ks ./ p.kstar, c_bvp; color = GRIS, lw = 3, alpha = 0.5, label = "principio del máximo",
              xlabel = "capital / k*", ylabel = "consumo", title = "Política de consumo",
              legend = :topleft)
    plot!(g1, ks ./ p.kstar, c_vfi; color = AZUL, lw = 1.5, label = "función valor, Δ = $Δ")
    g2 = plot(ks ./ p.kstar, 100 .* (c_vfi ./ c_bvp .- 1); color = AZUL, lw = 2, label = "",
              xlabel = "capital / k*", ylabel = "%", title = "Diferencia relativa")
    hline!(g2, [0.0]; color = GRIS, ls = :dash, lw = 1, label = "")
    plot(g1, g2; layout = (1, 2), size = (800, 330))
end

# ╔═╡ 3b568920-cf11-11f1-90ff-b37d598561fd
let
    ks = range(0.5 * p.kstar, 1.5 * p.kstar, length = 200)
    dif = maximum(abs.([interp_lineal(MALLA_K, vfi.σ, k) for k in ks] ./ consumo_rama.(Ref(ramas), ks) .- 1))
    t_bvp = @elapsed rama_estable(p, 0.5 * p.kstar)
    t_vfi = "$(round(vfi.tiempo, sigdigits = 2)) ($(vfi.n) iteraciones)"
    md"""
    | | Principio del máximo | Función valor, ``\Delta`` = $(Δ) |
    |---|---:|---:|
    | Segundos | $(round(2t_bvp, sigdigits = 2)) (dos tramos) | $(t_vfi) |
    | Diferencia máxima del consumo | | $(round(100dif, digits = 2))% |

    1. **Cambia** ``\Delta`` de 1 a 0.5 y a 0.25: ¿cómo baja la diferencia?
       ¿Es proporcional a ``\Delta``? ¿Cuánto sube el número de iteraciones,
       y por qué? (Pista: ``\hat\beta``.)
    2. ¿Dónde es mayor la diferencia: lejos o cerca del estado estacionario?
       ¿Por qué casi coinciden en ``k^\ast``? ¿De dónde salen los escalones
       de la gráfica de la derecha? (Pista: con interpolación lineal, ``v``
       tiene un quiebre en cada nodo de la malla, y para algunos capitales el
       ``k'`` óptimo cae justo en un nodo.)
    3. **Mueve** ``\theta``: ¿se mantiene la coincidencia?
    4. El principio del máximo resolvió dos trayectorias; la función valor,
       la regla para todos los capitales de la malla. Si mañana un choque
       destruye 20% del capital, ¿cuál de los dos resultados usarías sin
       volver a calcular?
    """
end

# ╔═╡ 3b5689e8-cf11-11f1-b012-3180d936e4cd
usar_transicion() = elegir(transicion, transicion_ref, () -> transicion(0.9))

# ╔═╡ 3b5689e8-cf11-11f1-bc7d-f51dea1ca1a4
usar_operador_migracion() = elegir(operador_migracion, operador_migracion_ref,
                                   () -> operador_migracion(zeros(2, 4), salarios(1.1), transicion_ref(0.9), 1.0, 0.9))

# ╔═╡ 3b5689c0-cf11-11f1-af50-c164538e22ab
"""
Resuelve la migración con brecha b, costo c y persistencia q (β = 0.95). Con
`usar_propias`, usa las funciones del estudiante si ya están escritas.
"""
function resolver_migracion(b, c, q; β = 0.95, usar_propias = false)
    P = (usar_propias ? usar_transicion() : transicion_ref)(q)
    T = usar_propias ? usar_operador_migracion() : operador_migracion_ref
    W = salarios(b)
    r = iterar_valor(V -> T(V, W, P, c, β), zeros(2, 4), β; ε = 1e-8)
    EV = r.v * P'
    politica = [argmax([log(W[r′, s]) - c * (r′ != r_) + β * EV[r′, s] for r′ in 1:2]) for r_ in 1:2, s in 1:4]
    (; r.v, r.n, politica, W, P)
end

# ╔═╡ 3b568948-cf11-11f1-b51b-9342ac3946dc
migracion = resolver_migracion(brecha, costo, q; usar_propias = true);

# ╔═╡ 3b568952-cf11-11f1-805c-05e11b55c20b
let
    (; politica, W) = migracion
    estados = ["alto-alto", "alto-bajo", "bajo-alto", "bajo-bajo"]
    fila(r) = join([politica[r, s] == r ? "se queda" : "**se muda**" for s in 1:4], " | ")
    Markdown.parse("""
    | Salarios (región 1-región 2) | $(join(estados, " | ")) |
    |---|---|---|---|---|
    | Salario en la región 1 | $(join(round.(W[1, :], digits = 2), " | ")) |
    | Salario en la región 2 | $(join(round.(W[2, :], digits = 2), " | ")) |
    | Quien vive en la región 1 | $(fila(1)) |
    | Quien vive en la región 2 | $(fila(2)) |

    Iteraciones: $(migracion.n).

    1. Con los valores iniciales, ¿en qué estados se muda quien vive en la
       región 1? En alto-alto la región 2 paga 10% más: ¿por qué no se muda?
    2. **Baja** el costo a 0: ¿qué pasa? ¿Y con un costo de 6?
    3. **Baja** la persistencia a 0.5: los salarios cambian como volados.
       ¿Por qué ya casi nadie se muda por un salario bajo de hoy?
    4. Con costos intermedios, quien vive en la región 2 se queda incluso
       en alto-bajo, cuando la región 1 paga más. ¿Por qué no hace la misma
       cuenta que quien vive en la 1? Es **histéresis**: dónde vives hoy
       depende de dónde vivías ayer.
    """)
end

# ╔═╡ 3b5689c8-cf11-11f1-8037-6d5512401f7a
"¿Se muda de la región 1 a la 2 en el estado de los salarios `estado` (1 = alto-alto)?"
se_muda(b, c, q; estado = 1) = resolver_migracion(b, c, q).politica[1, estado] == 2

# ╔═╡ 3b5689c8-cf11-11f1-99c9-d5295df35cf0
"Brecha mínima para mudarse, por bisección en [a, 3] (referencia; con `estado = 1`, alto-alto)."
function brecha_minima_ref(c, q; estado = 1, a = 1.0)
    se_muda(3.0, c, q; estado) || return Inf
    se_muda(a, c, q; estado) && return a
    b = 3.0
    while b - a > 1e-4
        m = (a + b) / 2
        se_muda(m, c, q; estado) ? (b = m) : (a = m)
    end
    b
end

# ╔═╡ 3b5689f2-cf11-11f1-9a71-79168b30a65f
usar_brecha_minima() = elegir(brecha_minima, brecha_minima_ref, () -> brecha_minima(100.0, 0.9))

# ╔═╡ 3b56895c-cf11-11f1-899c-b19b131b3d87
let
    costos = 0.0:0.25:6.0
    f = usar_brecha_minima()
    g = plot(; xlabel = "costo de mudarse c", ylabel = "brecha mínima b", title = "¿Cuánto más debe pagar la otra región?",
             legend = :topleft, ylims = (0.5, 1.6))
    for (qq, color) in ((0.6, NARANJA), (0.95, AZUL))
        plot!(g, costos, [min(f(c, qq), 3.0) for c in costos]; color, lw = 2, label = "alto-alto, q = $qq")
        plot!(g, costos, [min(brecha_minima_ref(c, qq; estado = 3, a = 0.5), 3.0) for c in costos];
              color, lw = 2, ls = :dash, label = "bajo-alto, q = $qq")
    end
    hline!(g, [1.0]; color = GRIS, lw = 1, ls = :dot, label = "")
    vline!(g, [costo]; color = TINTA, lw = 1, ls = :dot, label = "")
    g
end

# ╔═╡ 3b5689f2-cf11-11f1-975f-717257195fae
usar_distribucion() = elegir(distribucion, distribucion_ref, () -> distribucion([0.5 0.5; 0.5 0.5], [1.0, 0.0], 1))

# ╔═╡ 3b568970-cf11-11f1-8839-4ba50cf86c1e
let
    f = usar_distribucion()
    M = cadena_completa(migracion)
    años = 0:60
    desde1 = [sum(f(M, [fill(0.25, 4); zeros(4)], t)[5:8]) for t in años]
    desde2 = [sum(f(M, [zeros(4); fill(0.25, 4)], t)[5:8]) for t in años]
    g = plot(años, 100 .* desde1; color = AZUL, lw = 2, label = "empieza en la región 1",
             xlabel = "años", ylabel = "%", title = "Probabilidad de vivir en la región 2",
             legend = :right, ylims = (-3, 103))
    plot!(g, años, 100 .* desde2; color = NARANJA, lw = 2, label = "empieza en la región 2")
end

# ╔═╡ 3b5689f2-cf11-11f1-8520-ab5855cf824a
"Muestra si la respuesta de un ejercicio es correcta."
function verificar(f, esperado; rtol = 1e-8, pista = md"")
    caja(tipo, titulo, texto) = Markdown.MD(Markdown.Admonition(tipo, titulo, [texto]))
    resultado = try
        f()
    catch e
        return caja("danger", "Tu código produce un error", md"$(sprint(showerror, e))")
    end
    pendiente(x) = x === missing || (x isa Union{AbstractArray, Tuple} && any(pendiente, x))
    cerca(a, b) = (a isa Number && b isa Number && (a == b || isapprox(a, b; rtol, atol = 1e-12))) ||
                  (a isa AbstractArray && b isa AbstractArray && size(a) == size(b) && all(cerca.(a, b)))
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end

# ╔═╡ 3b5688e4-cf11-11f1-a610-c3c0de78bbdf
verificar(() -> (du = zeros(Union{Missing, Float64}, 2); r = ramsey!(du, [2.0, 0.7], P_PRUEBA, 0.0);
                 r === missing ? missing : du),
          (du = zeros(2); ramsey_ref!(du, [2.0, 0.7], P_PRUEBA, 0.0); du);
          pista = md"`k, c = u`; `du[1] = p.A * k^p.α - (p.δ + p.n) * k - c` y `du[2] = c / p.θ * (p.α * p.A * k^(p.α - 1) - p.δ - p.ρ)`.")

# ╔═╡ 3b5688ee-cf11-11f1-a546-f7c3085ae71c
verificar(() -> (res = zeros(Union{Missing, Float64}, 2); q = merge(P_PRUEBA, (k0 = 1.5, T = 10.0));
                 r = condiciones!(res, t -> [1.0 + 0.5t, 0.8], q, 0.0); r === missing ? missing : res),
          [1.0 - 1.5, 6.0 - P_PRUEBA.kstar];
          pista = md"`res[1] = u(0.0)[1] - p.k0` y `res[2] = u(p.T)[1] - p.kstar`.")

# ╔═╡ 3b568936-cf11-11f1-bdc6-39814d255be8
verificar(() -> transicion(0.9), transicion_ref(0.9);
          pista = md"`P1 = [q 1-q; 1-q q]` y después `kron(P1, P1)`.")

# ╔═╡ 3b568948-cf11-11f1-a1f6-a3bea20f4d09
verificar(() -> operador_migracion([1.0 2.0 3.0 4.0; 0.5 1.5 2.5 3.5], salarios(1.2), transicion_ref(0.8), 1.0, 0.9),
          operador_migracion_ref([1.0 2.0 3.0 4.0; 0.5 1.5 2.5 3.5], salarios(1.2), transicion_ref(0.8), 1.0, 0.9);
          pista = md"`EV = V * P'`; luego `[maximum(log(W[r′, s]) - c * (r′ != r) + β * EV[r′, s] for r′ in 1:2) for r in 1:2, s in 1:4]`.")

# ╔═╡ 3b56895c-cf11-11f1-b0b5-738a9ababd36
verificar(() -> [brecha_minima(1.0, 0.9), brecha_minima(3.0, 0.7), brecha_minima(100.0, 0.9)],
          [brecha_minima_ref(1.0, 0.9), brecha_minima_ref(3.0, 0.7), Inf];
          rtol = 1e-3,
          pista = md"Si `!se_muda(3.0, c, q)`, devuelve `Inf`. Si no, `a, b = 1.0, 3.0` y, mientras `b - a > 1e-4`, toma `m = (a + b) / 2` y cambia `b = m` si `se_muda(m, c, q)` o `a = m` si no. Devuelve `b`.")

# ╔═╡ 3b568970-cf11-11f1-8dfb-690aa03e6741
verificar(() -> distribucion([0.9 0.1; 0.4 0.6], [1.0, 0.0], 2), [0.85, 0.15];
          pista = md"`vec(ψ0' * M^t)`.")

# ╔═╡ Cell order:
# ╟─3b56886c-cf11-11f1-af2e-d5b1da880424
# ╟─3b5688bc-cf11-11f1-8c5e-9bbee2946c57
# ╟─3b5688c6-cf11-11f1-99da-cd2e1b4c8f25
# ╟─3b5688c6-cf11-11f1-8890-9b3fa8ec5082
# ╟─3b5688d0-cf11-11f1-a9dc-9b398a068fc2
# ╠═3b5688da-cf11-11f1-99aa-752901692fe2
# ╟─3b5688da-cf11-11f1-9439-0b77791a54d1
# ╠═3b5688e4-cf11-11f1-a914-8f650fcc45fb
# ╟─3b5688e4-cf11-11f1-a610-c3c0de78bbdf
# ╟─3b5688ee-cf11-11f1-91a5-e9ac87366272
# ╠═3b5688ee-cf11-11f1-a62a-93d357242818
# ╟─3b5688ee-cf11-11f1-a546-f7c3085ae71c
# ╟─3b5688f8-cf11-11f1-aaa0-c39606ed6669
# ╠═3b5688f8-cf11-11f1-975a-0d45bee12f85
# ╠═3b568904-cf11-11f1-8eb8-89ba2cafb299
# ╟─3b568904-cf11-11f1-8f87-59dbaa5d4e1c
# ╟─3b56890c-cf11-11f1-be69-3de0b0f62349
# ╠═3b56890c-cf11-11f1-89b1-59e14217d564
# ╠═3b568916-cf11-11f1-b0a3-8b7a64cbbc2a
# ╟─3b568916-cf11-11f1-85a5-4b1aa0e92db2
# ╟─3b568920-cf11-11f1-90ff-b37d598561fd
# ╟─3b56892a-cf11-11f1-907f-b57d350e673c
# ╠═3b56892a-cf11-11f1-9314-e93df1693088
# ╟─3b568936-cf11-11f1-bdc6-39814d255be8
# ╟─3b568936-cf11-11f1-bdc8-33259f29a026
# ╠═3b56893e-cf11-11f1-869e-6755953d90b6
# ╟─3b568948-cf11-11f1-a1f6-a3bea20f4d09
# ╟─3b568948-cf11-11f1-b400-6fb5fe1cce70
# ╠═3b568948-cf11-11f1-b51b-9342ac3946dc
# ╟─3b568952-cf11-11f1-805c-05e11b55c20b
# ╟─3b568952-cf11-11f1-8008-672e808ce99c
# ╠═3b568952-cf11-11f1-b01b-d3d4254ecc44
# ╟─3b56895c-cf11-11f1-b0b5-738a9ababd36
# ╟─3b56895c-cf11-11f1-899c-b19b131b3d87
# ╟─3b568968-cf11-11f1-936d-19def23b1cb2
# ╠═3b568968-cf11-11f1-832b-8d5b7cb23cde
# ╟─3b568970-cf11-11f1-8dfb-690aa03e6741
# ╟─3b568970-cf11-11f1-8839-4ba50cf86c1e
# ╟─3b568970-cf11-11f1-9298-2ff6b8c646df
# ╟─3b56897a-cf11-11f1-9b1b-cdd64bd3a9a8
# ╠═3b568984-cf11-11f1-92ad-ff74830b51e4
# ╠═3b56898e-cf11-11f1-bbc7-439180dcd8a0
# ╠═3b56898e-cf11-11f1-847e-d17f9c99d046
# ╠═3b56898e-cf11-11f1-be94-cbe6125ae851
# ╠═3b568996-cf11-11f1-8fa8-b777f77d316b
# ╠═3b568996-cf11-11f1-ad88-03e2bec2c222
# ╠═3b5689a2-cf11-11f1-bf8c-2bab0d213043
# ╠═3b5689a2-cf11-11f1-a24e-436e5bec8bb5
# ╠═3b5689a2-cf11-11f1-8eaf-fd852c87b555
# ╠═3b5689ac-cf11-11f1-8a30-abebb18f982b
# ╠═3b5689ac-cf11-11f1-a109-47138203a772
# ╠═3b5689ac-cf11-11f1-9e00-f5f1302d8934
# ╠═3b5689b6-cf11-11f1-8537-d32ca61967e6
# ╠═3b5689b6-cf11-11f1-8302-9b21a110bec1
# ╠═3b5689c0-cf11-11f1-9d59-532c04645258
# ╠═3b5689c0-cf11-11f1-af50-c164538e22ab
# ╠═3b5689c8-cf11-11f1-8037-6d5512401f7a
# ╠═3b5689c8-cf11-11f1-99c9-d5295df35cf0
# ╠═3b5689c8-cf11-11f1-9eaf-e9954188a1e3
# ╠═3b5689d4-cf11-11f1-b115-e765dcc79b4e
# ╠═3b5689d4-cf11-11f1-bf44-6b5af50ccbda
# ╠═3b5689de-cf11-11f1-b671-296a489292b6
# ╠═3b5689de-cf11-11f1-9c8b-f579ac205ccb
# ╠═3b5689de-cf11-11f1-882f-ede0954622bf
# ╠═3b5689e8-cf11-11f1-b012-3180d936e4cd
# ╠═3b5689e8-cf11-11f1-bc7d-f51dea1ca1a4
# ╠═3b5689f2-cf11-11f1-9a71-79168b30a65f
# ╠═3b5689f2-cf11-11f1-975f-717257195fae
# ╠═3b5689f2-cf11-11f1-8520-ab5855cf824a
