#%% hide
md"""
# Sesión 17: Laboratorio 2. Iteración de la función valor

**Pregunta de la unidad.** ¿Cómo debe crecer una región que decide cada año
cuánto invertir?

**Pregunta del laboratorio.** Si una región con los parámetros de México
decide cada año cuánto ahorrar, ¿qué fracción ahorra y en cuánto tiempo
cierra la mitad de una brecha de capital? ¿Coincide con lo que dio el
principio del máximo en la sesión 12?

**Objetivos del laboratorio**
1. Programar el operador de Bellman con un estado continuo: interpolación
   lineal entre los puntos de la malla y sección dorada para el control.
2. Programar la iteración de la función valor con la regla de paro de la
   sesión 16.
3. Verificar el código con la solución exacta de la torta, y elegir la
   malla según dónde se curva la función valor.
4. Resolver el crecimiento de una región calibrado para México y
   verificarlo sin solución exacta: estado estacionario y errores de Euler.

**Cómo usar este cuaderno.** Los ejercicios con verificador dicen
**Pendiente** hasta que reemplazas `missing` por tu código. Mientras un
ejercicio está pendiente, las secciones que lo usan corren con una función
de referencia, así que todo el cuaderno funciona desde el principio. La
sección marcada **[Avanzado]** es opcional. La teoría está en las notas de
las sesiones 15, 16 y 18.

**Plan del laboratorio** (120 minutos). Cada bloque empieza con 3 a 5
minutos de demostración en el proyector; después cada quien trabaja en su
cuaderno.

| Minutos | Qué | Sección |
|---|---|---|
| 0–5 | Las dos herramientas: interpolar y maximizar | 0 |
| 5–30 | El operador de Bellman; la prueba ``TV = V`` con la torta | 1 |
| 30–55 | La iteración con regla de paro; la malla uniforme contra la logarítmica | 2 |
| 55–60 | Pausa | |
| 60–80 | El crecimiento calibrado: la regla de ahorro | 3 |
| 80–105 | Verificar sin solución exacta; la vida media contra la sesión 12 | 3 |
| 105–120 | Cierre: preguntas 2 y 4, en voz alta | Preguntas |
| Después | La búsqueda de empleo [Avanzado] y las demás preguntas | 4, Preguntas |

**Repaso recomendado** (en `Class_notes/repaso/`): N.B1 a N.B3 (Julia,
gráficas y Pluto), A.I4 (norma del supremo), N.I4 (mallas e
interpolación), N.I5 (sección dorada) y N.I6 (medir el error). Para los
puntos [Avanzado]: A.A2 (Banach y la regla de paro).
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 0. Las dos herramientas

En la sesión 16, el estado siguiente era un punto de la malla. Eso no
sirve para la torta (notas de la sesión 16, sección 4): ahora el control es
continuo, y la función valor se evalúa **entre** los puntos de la malla
interpolando. Las dos funciones son las del repaso: `interp_lineal`
(N.I4) y `seccion_dorada` (N.I5).
"""

#%%
function interp_lineal(xs, ys, x)
    i = clamp(searchsortedlast(xs, x), 1, length(xs) - 1)
    t = (x - xs[i]) / (xs[i+1] - xs[i])
    (1 - t) * ys[i] + t * ys[i+1]
end

#%%
function seccion_dorada(f, a, b; tol = 1e-8)
    φ = (sqrt(5) - 1) / 2
    c, d = b - φ * (b - a), a + φ * (b - a)
    fc, fd = f(c), f(d)
    while b - a > tol
        if fc > fd                     # el máximo está en [a, d]
            b, d, fd = d, c, fc
            c = b - φ * (b - a); fc = f(c)
        else                           # el máximo está en [c, b]
            a, c, fc = c, d, fd
            d = a + φ * (b - a); fd = f(d)
        end
    end
    (a + b) / 2
end

#%%
interp_lineal([1.0, 2.0, 4.0], [0.0, 1.0, 3.0], 3.0), seccion_dorada(c -> log(c) + 0.9 * log(10 - c), 0.01, 9.99)

#%% hide
md"""
La primera da 2 (a la mitad entre 1 y 3); la segunda, ``10/1.9 \approx 5.263``,
la torta de dos periodos de la sesión 15.

## 1. El operador de Bellman

Un problema queda descrito por cuatro cosas: la malla de estados, la
recompensa `u(c)`, el estado siguiente `siguiente(x, c)` y el intervalo de
controles permitidos `cotas(x)`, que devuelve ``(a, b)``. El operador de
Bellman, para cada punto ``x_i`` de la malla, es

```math
(Tv)(x_i) = \max_{a \le c \le b}\Big\lbrace u(c) + \beta\, v\big(\text{siguiente}(x_i, c)\big)\Big\rbrace,
```

con ``v`` interpolada.

**1.** Escribe `bellman(v, malla, β, u, siguiente, cotas)`, que devuelva
el vector ``Tv`` y el vector de controles óptimos ``\sigma``, en ese orden.
Para cada punto de la malla: define el objetivo como función de ``c``,
maximízalo con `seccion_dorada` en las cotas y guarda el máximo y el
maximizador.
"""

#%%
function bellman(v, malla, β, u, siguiente, cotas)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> (r = bellman(log.(MALLA_PRUEBA), MALLA_PRUEBA, 0.9, log, (x, c) -> x - c,
                             x -> (1e-10, x - MALLA_PRUEBA[1])); r === missing ? missing : collect(r)),
          collect(bellman_ref(log.(MALLA_PRUEBA), MALLA_PRUEBA, 0.9, log, (x, c) -> x - c,
                              x -> (1e-10, x - MALLA_PRUEBA[1])));
          rtol = 1e-6,
          pista = md"`Tv, σ = similar(v), similar(v)`; en `for (i, x) in enumerate(malla)`: `objetivo(c) = u(c) + β * interp_lineal(malla, v, siguiente(x, c))`, `a, b = cotas(x)`, `σ[i] = seccion_dorada(objetivo, a, b)` y `Tv[i] = objetivo(σ[i])`. Al final, `return Tv, σ`.")

#%% hide
md"""
### La prueba: ``TV = V`` con la torta

La torta sin final, ``r = \ln c`` y ``x' = x - c``, tiene función valor
exacta ``V(x) = a + \ln x/(1 - \beta)`` (notas de la sesión 16, sección 3).
Si el operador está bien escrito, aplicarlo a la ``V`` exacta debe devolver
casi la misma ``V``: es su punto fijo. Lo que sobre es el error de la
interpolación. La malla tiene 200 puntos entre 0.001 y 100, y el fondo
siguiente no puede bajar del primero.
"""

#%%
torta = (u = log, siguiente = (x, c) -> x - c)

#%%
let
    malla = MALLA_UNIFORME
    cotas(x) = (1e-10, x - malla[1])
    V = valor_torta.(malla, 0.95)
    TV, σ = usar(:bellman)(V, malla, 0.95, torta.u, torta.siguiente, cotas)
    dentro = malla .>= 1
    (error_valor = maximum(abs.(TV[dentro] .- V[dentro])),
     error_politica = maximum(abs.(σ[dentro] .- 0.05 .* malla[dentro])))
end

#%% hide
md"""
Con ``\beta = 0.95``, se mide en los fondos de 1 a 100. El error de la
política es la diferencia con ``c = (1 - \beta)x``. ¿Es pequeño? La sección
2 dice si basta.

## 2. La iteración de la función valor

**2.** Escribe `iterar_valor(T, v0, β; ε = 1e-6)`: empieza en `v0`, aplica
`T` (una función que recibe un vector y devuelve otro) y se detiene cuando
``\lVert v_n - v_{n-1}\rVert \le \varepsilon(1 - \beta)/\beta``, la regla de
paro de la sesión 16 (sección 2.3). Devuelve la última ``v`` y el número de
iteraciones, como `(; v, n)`.
"""

#%%
function iterar_valor(T, v0, β; ε = 1e-6)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> (r = iterar_valor(v -> 1 .+ 0.9 .* v, [0.0, 5.0], 0.9); r === missing ? missing : [r.v; r.n]),
          (r = iterar_valor_ref(v -> 1 .+ 0.9 .* v, [0.0, 5.0], 0.9); [r.v; r.n]);
          pista = md"`v = v0`; `for n in 1:10_000`: `v_nuevo = T(v)`, `dif = maximum(abs.(v_nuevo .- v))`, `v = v_nuevo` y `dif ≤ ε * (1 - β) / β && return (; v, n)`.")

#%% hide
md"""
Con tu función, la torta se resuelve desde ``v_0 = 0``. Mueve los
deslizadores.

Factor de descuento, ``\beta``: $(@bind β Slider(0.90:0.01:0.98, default = 0.95, show_value = true))

Puntos de la malla: $(@bind N Select([50, 100, 200, 400], default = 200))

Malla: $(@bind tipo_malla Select(["uniforme", "logarítmica"]))
"""

#%%
malla = tipo_malla == "uniforme" ? collect(range(0.001, 100, length = N)) :
                                   exp.(range(log(0.001), log(100), length = N))

#%%
solucion_torta = let
    cotas(x) = (1e-10, x - malla[1])
    T(v) = usar(:bellman)(v, malla, β, torta.u, torta.siguiente, cotas)[1]
    tiempo = @elapsed r = usar(:iterar_valor)(T, zeros(length(malla)), β)
    _, σ = usar(:bellman)(r.v, malla, β, torta.u, torta.siguiente, cotas)
    (; r.v, r.n, σ, tiempo)
end;

#%% hide
let
    dentro = malla .>= 1
    xs = malla[dentro]
    V = valor_torta.(xs, β)
    err_v = abs.(solucion_torta.v[dentro] .- V)
    err_c = abs.(solucion_torta.σ[dentro] .- (1 - β) .* xs)
    g1 = plot(xs, V; color = GRIS, lw = 3, alpha = 0.5, label = "V exacta", xlabel = "fondo x",
              ylabel = "valor", title = "Función valor", legend = :bottomright)
    plot!(g1, xs, solucion_torta.v[dentro]; color = AZUL, lw = 1.5, label = "iteración")
    g2 = plot(xs, max.(err_v, 1e-10); yscale = :log10, xscale = :log10, color = AZUL, lw = 2,
              label = "valor", xlabel = "fondo x", title = "Error en cada fondo", legend = :bottomleft)
    plot!(g2, xs, max.(err_c, 1e-10); color = NARANJA, lw = 2, label = "gasto")
    plot(g1, g2; layout = (1, 2), size = (800, 330))
end

#%% hide
let
    dentro = malla .>= 1
    err_v = maximum(abs.(solucion_torta.v[dentro] .- valor_torta.(malla[dentro], β)))
    err_c = maximum(abs.(solucion_torta.σ[dentro] .- (1 - β) .* malla[dentro]))
    Markdown.parse("""
    | Iteraciones | Segundos | Error máximo del valor | Error máximo del gasto |
    |---:|---:|---:|---:|
    | $(solucion_torta.n) | $(round(solucion_torta.tiempo, sigdigits = 2)) | $(round(err_v, sigdigits = 3)) | $(round(err_c, sigdigits = 3)) |

    1. Con la malla **uniforme**, ¿dónde es grande el error? ¿Por qué un
       error en los fondos pequeños contamina a los grandes? (Pista: ¿a
       dónde llega el fondo con el tiempo?)
    2. **Cambia** a la malla **logarítmica** con los mismos 200 puntos.
       ¿Cuánto baja el error? ¿Por qué? (Repaso N.I4: el error de
       interpolar es proporcional a ``h^2 \\lvert V''\\rvert``.)
    3. **Sube** ``\\beta`` a 0.98: ¿cuántas iteraciones más? Compáralo con la
       tabla de la sección 2.3 de las notas de la sesión 16.
    4. Con la malla logarítmica, **duplica** los puntos: ¿por qué factor baja
       el error del valor?
    """)
end

#%% hide
md"""
## 3. Crecimiento de una región calibrado para México

La región de la sesión 12, ahora en tiempo discreto, con periodos de un
año. El capital por trabajador cumple

```math
k_{t+1} = \frac{f(k_t) + (1 - \delta)k_t - c_t}{1 + n},
\qquad f(k) = Ak^\alpha,
\qquad u(c) = \frac{c^{1-\theta}}{1-\theta},
```

y el descuento por trabajador es ``\hat\beta = (1 + n)/(1 + \rho)``. Con ese
``\hat\beta``, la ecuación de Euler es
``u'(c_t) = \frac{1 + f'(k_{t+1}) - \delta}{1 + \rho}\,u'(c_{t+1})`` y el estado
estacionario cumple ``f'(k^\ast) = \delta + \rho``, como en la sesión 12.

La calibración es la de la sesión 12 (notas, sección 5.2): ``\delta = 0.035``,
``n = 0.023``, ``K/Y = 3.66`` y ``\rho = \alpha/(K/Y) - \delta``; ``A``
normaliza el producto de estado estacionario a 1, así que ``k^\ast = 3.66``.
La malla tiene 200 puntos entre ``0.3k^\ast`` y ``1.6k^\ast``.

Participación del capital, ``\alpha``: $(@bind α Select([1/3 => "1/3 (convencional)", 0.646 => "0.646 (PWT)"]))

Aversión a la fluctuación del consumo, ``\theta``: $(@bind θ Slider(1.0:0.5:4.0, default = 2.0, show_value = true))
"""

#%%
p = calibrar(α, θ)

#%%
crecimiento = let
    u(c) = p.θ == 1 ? log(c) : c^(1 - p.θ) / (1 - p.θ)
    recursos(k) = p.A * k^p.α + (1 - p.δ) * k
    siguiente(k, c) = (recursos(k) - c) / (1 + p.n)
    cotas(k) = (max(1e-8, recursos(k) - (1 + p.n) * MALLA_K[end]), recursos(k) - (1 + p.n) * MALLA_K[1])
    T(v) = usar(:bellman)(v, MALLA_K, p.β̂, u, siguiente, cotas)[1]
    tiempo = @elapsed r = usar(:iterar_valor)(T, zeros(length(MALLA_K)), p.β̂)
    _, σ = usar(:bellman)(r.v, MALLA_K, p.β̂, u, siguiente, cotas)
    politica(k) = interp_lineal(MALLA_K, σ, k)
    (; r.v, r.n, σ, politica, siguiente, tiempo)
end;

#%% hide
let
    ks = MALLA_K
    y = p.A .* ks .^ p.α
    ahorro = 1 .- crecimiento.σ ./ y
    g1 = plot(ks ./ p.kstar, 100 .* ahorro; color = AZUL, lw = 2, xlabel = "capital / k*",
              ylabel = "% del producto", title = "Tasa de ahorro según el capital", label = "")
    hline!(g1, [100 * p.sstar]; color = GRIS, ls = :dash, lw = 1, label = "")
    hline!(g1, [19.2]; color = NARANJA, ls = :dot, lw = 1.5, label = "")
    annotate!(g1, 1.45, 100 * p.sstar + 0.6, text("s* del modelo", 7, GRIS))
    annotate!(g1, 1.45, 19.2 - 0.6, text("inversión observada", 7, NARANJA))
    tr = trayectoria(crecimiento, 0.5 * p.kstar, 60)
    g2 = plot(0:60, tr ./ p.kstar; color = AZUL, lw = 2, xlabel = "años", ylabel = "capital / k*",
              title = "Transición desde la mitad de k*", label = "", ylims = (0.45, 1.05))
    hline!(g2, [1.0]; color = GRIS, ls = :dash, lw = 1, label = "")
    plot(g1, g2; layout = (1, 2), size = (800, 330))
end

#%% hide
md"""
**Observa:** ¿ahorra más una región con poco capital? ¿Por qué? ¿Qué pasa
con ``\theta`` alto? ¿Y con ``\theta = 1``? Compara con la sesión 16, donde
el ahorro era constante: ¿qué supuesto de aquel modelo cambió?

### Verificar sin solución exacta

Este problema no tiene solución cerrada. Hay tres pruebas:

1. **El estado estacionario.** La trayectoria debe acercarse a
   ``k^\ast = 3.66``, que sale de ``f'(k^\ast) = \delta + \rho``.
2. **La tasa de ahorro de largo plazo** debe ser
   ``s^\ast = (\delta + n)k^\ast/f(k^\ast)``, la de la sesión 12.
3. **La ecuación de Euler** (sesión 18) debe cumplirse con un error
   pequeño en toda la malla.

**3.** Escribe `error_euler(c, c′, k′, p)`: el error relativo de la
ecuación de Euler, medido en consumo. Despejando ``c_t``, la ecuación dice
``c_t = \big((1 + f'(k_{t+1}) - \delta)/(1 + \rho)\big)^{-1/\theta}c_{t+1}``;
devuelve ``\lvert c_t^{\text{Euler}}/c_t - 1\rvert``, con
``f'(k) = \alpha Ak^{\alpha - 1}`` y los parámetros en `p.α`, `p.A`, `p.δ`,
`p.ρ` y `p.θ`.
"""

#%%
error_euler(c, c′, k′, p) = missing  # reemplaza missing

#%% hide
verificar(() -> [error_euler(0.8, 0.81, 3.5, P_PRUEBA), error_euler(0.7, 0.7, 3.66, P_PRUEBA),
                 error_euler(1.0, 0.99, 4.0, merge(P_PRUEBA, (θ = 1.0,)))],
          [error_euler_ref(0.8, 0.81, 3.5, P_PRUEBA), error_euler_ref(0.7, 0.7, 3.66, P_PRUEBA),
           error_euler_ref(1.0, 0.99, 4.0, merge(P_PRUEBA, (θ = 1.0,)))];
          pista = md"`R = 1 + p.α * p.A * k′^(p.α - 1) - p.δ`; `abs((R / (1 + p.ρ))^(-1 / p.θ) * c′ / c - 1)`.")

#%% hide
md"""
**4.** Escribe `semivida(tr, kstar)`: el primer periodo ``t`` (contando
desde 0, que es `tr[1]`) en que la brecha en logaritmos,
``\lvert\ln(k_t/k^\ast)\rvert``, es a lo más la mitad de la inicial.
"""

#%%
semivida(tr, kstar) = missing  # reemplaza missing

#%% hide
verificar(() -> [semivida(exp.(log(0.5) .* 0.9 .^ (0:50)), 1.0), semivida(1.0 .- 0.5 .* 0.8 .^ (0:50), 1.0),
                 semivida([2.0, 1.5, 1.2, 1.1], 1.0)],
          [semivida_ref(exp.(log(0.5) .* 0.9 .^ (0:50)), 1.0), semivida_ref(1.0 .- 0.5 .* 0.8 .^ (0:50), 1.0),
           semivida_ref([2.0, 1.5, 1.2, 1.1], 1.0)];
          pista = md"`brecha = abs.(log.(tr ./ kstar))`; `findfirst(≤(brecha[1] / 2), brecha) - 1`.")

#%% hide
let
    ks = MALLA_K[11:end-10]
    errores = map(ks) do k
        c = crecimiento.politica(k)
        k′ = crecimiento.siguiente(k, c)
        usar(:error_euler)(c, crecimiento.politica(k′), k′, p)
    end
    plot(ks ./ p.kstar, log10.(max.(errores, 1e-12)); color = AZUL, lw = 1.5, xlabel = "capital / k*",
         ylabel = "log₁₀ del error", title = "Error de la ecuación de Euler", label = "", size = (720, 280))
end

#%% hide
let
    tr = trayectoria(crecimiento, 0.5 * p.kstar, 200)
    tr95 = trayectoria(crecimiento, 0.95 * p.kstar, 200)
    kfin = tr[end]
    ahorro_fin = 1 - crecimiento.politica(kfin) / (p.A * kfin^p.α)
    sv = usar(:semivida)
    Markdown.parse("""
    | | Este laboratorio | Sesión 12 |
    |---|---:|---:|
    | ``\\rho`` calibrado | $(round(100p.ρ, digits = 1))% | $(round(100p.ρ, digits = 1))% |
    | Iteraciones (segundos) | $(crecimiento.n) ($(round(crecimiento.tiempo, sigdigits = 2))) | |
    | Capital de largo plazo / ``k^\\ast`` | $(round(kfin / p.kstar, digits = 4)) | 1 |
    | Ahorro de largo plazo | $(round(100ahorro_fin, digits = 1))% | $(round(100p.sstar, digits = 1))% |
    | Vida media desde ``0.5k^\\ast`` (años) | $(sv(tr, p.kstar)) | |
    | Vida media desde ``0.95k^\\ast`` (años) | $(sv(tr95, p.kstar)) | $(round(p.semivida_continua, digits = 1)) |

    La última columna es el resultado de la sesión 12, en tiempo continuo y
    linealizado alrededor del estado estacionario.

    1. ¿Pasan las tres pruebas? ¿De qué tamaño es el error de Euler, en
       porcentaje del consumo? ¿Dónde es mayor?
    2. ¿Por qué el capital de largo plazo no es exactamente ``k^\\ast``?
       (Pista: ¿qué pasa con la política entre los puntos de la malla?)
    3. **Compara** la vida media cerca del estado estacionario con la de la
       sesión 12. Usar periodos de un año en lugar de tiempo continuo la
       alarga medio año con ``\\alpha = 1/3`` y unos dos años con
       ``\\alpha = 0.646`` (11.0 y 18.7 años en el modelo discreto
       linealizado): ¿por qué pesa más con un ``\\rho`` más alto? Con
       ``\\alpha = 0.646`` el cuaderno da todavía más (unos 23 años con ``\\theta = 2``): ¿qué
       parte es error de la malla? (Pista: cerca de ``k^\\ast`` la brecha es
       pequeña y la convergencia es lenta, así que un error pequeño de la
       política pesa mucho.)
    4. ¿Por qué la vida media desde ``0.5k^\\ast`` no es igual a la de
       ``0.95k^\\ast``? ¿Cuál es la que linealiza la sesión 12?
    """)
end

#%% hide
md"""
## 4. [Avanzado] Buscar empleo en una región

*Fuera de clase.* La búsqueda de empleo de McCall de las notas de la sesión
15 (P.2), ahora **sin final** (Sargent y Stachurski, sec. 1.3). Cada periodo
llega una oferta ``w`` de la lista ``10, 15, \dots, 60``, todas con la misma
probabilidad. Quien acepta gana ``w`` para siempre, con valor
``w/(1 - \beta)``; quien rechaza cobra el seguro de desempleo ``c`` y espera:

```math
v(w) = \max\Big\lbrace\frac{w}{1 - \beta},\ c + \beta\sum_{w'} v(w')\,\varphi(w')\Big\rbrace.
```

El estado es la oferta, que toma pocos valores: no hace falta interpolar.

**5.** Escribe `operador_mccall(v, w, φ, c, β)`, que devuelva el vector
``Tv`` con un valor por oferta.
"""

#%%
operador_mccall(v, w, φ, c, β) = missing  # reemplaza missing

#%% hide
verificar(() -> operador_mccall(collect(1.0:11.0), OFERTAS, PROB, 20.0, 0.95),
          operador_mccall_ref(collect(1.0:11.0), OFERTAS, PROB, 20.0, 0.95);
          pista = md"`max.(w ./ (1 - β), c + β * sum(v .* φ))`.")

#%% hide
md"""
Seguro de desempleo, ``c``: $(@bind c_seguro Slider(0:5:40, default = 20, show_value = true))

Factor de descuento, ``\beta``: $(@bind β_mccall Slider(0.90:0.01:0.99, default = 0.96, show_value = true))
"""

#%%
mccall = let
    r = usar(:iterar_valor)(v -> usar(:operador_mccall)(v, OFERTAS, PROB, c_seguro, β_mccall),
                            zeros(length(OFERTAS)), β_mccall)
    espera = c_seguro + β_mccall * sum(r.v .* PROB)
    w_reserva = (1 - β_mccall) * espera
    (; r.v, r.n, espera, w_reserva, p_acepta = sum(PROB[OFERTAS .>= w_reserva]))
end;

#%% hide
let
    (; v, espera, w_reserva) = mccall
    g = scatter(OFERTAS, v; color = AZUL, ms = 4, msw = 0, xlabel = "oferta w", ylabel = "valor",
                title = "Valor de cada oferta", label = "v(w)", legend = :bottomright)
    plot!(g, OFERTAS, OFERTAS ./ (1 - β_mccall); color = GRIS, lw = 1, label = "aceptar: w/(1 − β)")
    hline!(g, [espera]; color = NARANJA, ls = :dash, lw = 1.5, label = "rechazar y esperar")
    vline!(g, [w_reserva]; color = NARANJA, lw = 1, label = "")
end

#%% hide
let
    (; n, w_reserva, p_acepta) = mccall
    md"""
    Salario de reserva: $(round(w_reserva, digits = 1)). Se acepta una oferta con
    probabilidad $(round(p_acepta, digits = 2)), así que el desempleo dura en
    promedio $(round(1 / p_acepta, digits = 1)) periodos. Iteraciones: $(n).

    **Mueve** el seguro de desempleo: ¿cómo cambian el salario de reserva y
    la duración del desempleo? ¿Y con más paciencia? Una región con seguro
    más generoso, ¿tendría más desempleo, o mejores empleos?
    """
end

#%% hide
md"""
## Preguntas

1. En la sección 1, ¿qué tan lejos queda ``TV`` de ``V`` con la malla
   uniforme? ¿Por qué esa prueba detecta errores de código aunque la malla
   no sea perfecta?
2. En la sección 2, explica con tus palabras por qué la malla logarítmica es
   mucho mejor para la torta. ¿Qué malla elegirías para el crecimiento, y
   por qué ahí la uniforme funciona bien?
3. Con la regla de paro, ¿cuántas iteraciones hicieron falta en la torta y
   en el crecimiento? ¿Por qué tan distintas? (Pista: ``\hat\beta``.)
4. **La pregunta del laboratorio.** Con los parámetros de México, ¿qué
   fracción ahorra la región y en cuánto tiempo cierra la mitad de una
   brecha de capital? ¿Coincide con la sesión 12? ¿Qué método te parece más
   confiable para esa pregunta, y por qué?
5. **[Avanzado]** En la sección 4, ¿por qué el salario de reserva sube con
   ``\beta``?

## Para la próxima sesión

- **Sesión 18: control óptimo frente a programación dinámica.** La
  ecuación de Euler a partir de la ecuación de Bellman (la que usaste para
  verificar en la sección 3), el precio sombra como derivada de la función
  valor y un recurso renovable por los dos caminos.
- Repaso: C.B3 (exponencial y logaritmo). Para los puntos [Avanzado]: C.A2
  (envolvente) y D.A5 (sistemas lineales en tiempo discreto).
"""

#%% hide
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir el laboratorio.
"""

#%%
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"
    const NARANJA = "#eb6834"
    const GRIS    = "#52514e"
    const TINTA   = "#0b0b0b"
end;

#%%
begin
    "Malla uniforme de la torta: 200 puntos entre 0.001 y 100."
    const MALLA_UNIFORME = collect(range(0.001, 100, length = 200))
    "Malla pequeña para el ejercicio 1."
    const MALLA_PRUEBA = exp.(range(log(0.01), log(10), length = 30))
    "Malla del capital: 200 puntos entre 0.3k* y 1.6k*, con k* = 3.66."
    const MALLA_K = collect(range(0.3 * 3.66, 1.6 * 3.66, length = 200))
    "Ofertas de salario y sus probabilidades (sección 4)."
    const OFERTAS = collect(10.0:5.0:60.0)
    const PROB = fill(1 / length(OFERTAS), length(OFERTAS))
end;

#%%
"Valor exacto de la torta sin final con fondo x y r = ln c."
valor_torta(x, β) = log(1 - β) / (1 - β) + β * log(β) / (1 - β)^2 + log(x) / (1 - β)

#%%
"Operador de Bellman con interpolación lineal y sección dorada (referencia)."
function bellman_ref(v, malla, β, u, siguiente, cotas)
    Tv, σ = similar(v), similar(v)
    for (i, x) in enumerate(malla)
        objetivo(c) = u(c) + β * interp_lineal(malla, v, siguiente(x, c))
        a, b = cotas(x)
        σ[i] = seccion_dorada(objetivo, a, b)
        Tv[i] = objetivo(σ[i])
    end
    Tv, σ
end

#%%
"Iteración de la función valor con la regla de paro ‖vₙ − vₙ₋₁‖ ≤ ε(1 − β)/β (referencia)."
function iterar_valor_ref(T, v0, β; ε = 1e-6)
    v = v0
    for n in 1:10_000
        v_nuevo = T(v)
        dif = maximum(abs.(v_nuevo .- v))
        v = v_nuevo
        dif ≤ ε * (1 - β) / β && return (; v, n)
    end
    (; v, n = 10_000)
end

#%%
"Error relativo de la ecuación de Euler, medido en consumo (referencia)."
function error_euler_ref(c, c′, k′, p)
    R = 1 + p.α * p.A * k′^(p.α - 1) - p.δ
    abs((R / (1 + p.ρ))^(-1 / p.θ) * c′ / c - 1)
end

#%%
"Primer periodo en que la brecha en logaritmos es a lo más la mitad de la inicial (referencia)."
function semivida_ref(tr, kstar)
    brecha = abs.(log.(tr ./ kstar))
    findfirst(≤(brecha[1] / 2), brecha) - 1
end

#%%
"Operador de Bellman de la búsqueda de empleo sin final (referencia)."
operador_mccall_ref(v, w, φ, c, β) = max.(w ./ (1 - β), c + β * sum(v .* φ))

#%%
"""
Calibración de la sesión 12 en tiempo discreto: ρ reproduce K/Y = 3.66 y A
normaliza el producto de estado estacionario a 1. Incluye la vida media del
modelo continuo linealizado de la sesión 12.
"""
function calibrar(α, θ; δ = 0.035, n = 0.023, KY = 3.66)
    ρ = α / KY - δ
    kstar = KY
    A = kstar^(-α)
    sstar = (δ + n) * kstar                  # con y* = 1
    cstar = 1 - sstar
    fpp = α * (α - 1) * A * kstar^(α - 2)
    ν = ((ρ - n) - sqrt((ρ - n)^2 - 4 * cstar * fpp / θ)) / 2
    (; α, θ, δ, n, ρ, A, kstar, sstar, β̂ = (1 + n) / (1 + ρ), semivida_continua = log(2) / -ν)
end

#%%
"Parámetros de prueba del ejercicio 3."
const P_PRUEBA = calibrar(1 / 3, 2.0)

#%%
"Trayectoria del capital durante T años desde k0 con la política calculada."
function trayectoria(sol, k0, T)
    tr = [k0]
    for _ in 1:T
        push!(tr, sol.siguiente(tr[end], sol.politica(tr[end])))
    end
    tr
end

#%%
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

#%%
"""
La función del estudiante si ya está escrita, o la de referencia si no. Las
secciones del cuaderno la usan para correr desde el principio.
"""
function usar(nombre::Symbol)
    pruebas = Dict(
        :bellman => () -> bellman([0.0, 0.0], [1.0, 2.0], 0.9, log, (x, c) -> x - c, x -> (0.1, 0.5)),
        :iterar_valor => () -> iterar_valor(v -> 0.5 .* v, [1.0], 0.5).v,
        :error_euler => () -> error_euler(1.0, 1.0, 3.66, P_PRUEBA),
        :semivida => () -> semivida([0.5, 0.8, 1.0], 1.0),
        :operador_mccall => () -> operador_mccall(zeros(2), [1.0, 2.0], [0.5, 0.5], 1.0, 0.9))
    propias = Dict(:bellman => bellman, :iterar_valor => iterar_valor, :error_euler => error_euler,
                   :semivida => semivida, :operador_mccall => operador_mccall)
    referencias = Dict(:bellman => bellman_ref, :iterar_valor => iterar_valor_ref,
                       :error_euler => error_euler_ref, :semivida => semivida_ref,
                       :operador_mccall => operador_mccall_ref)
    completo(pruebas[nombre]) ? propias[nombre] : referencias[nombre]
end

#%%
"Muestra si la respuesta de un ejercicio es correcta."
function verificar(f, esperado; rtol = 1e-8, pista = md"")
    caja(tipo, titulo, texto) = Markdown.MD(Markdown.Admonition(tipo, titulo, [texto]))
    resultado = try
        f()
    catch e
        return caja("danger", "Tu código produce un error", md"$(sprint(showerror, e))")
    end
    pendiente(x) = x === missing || (x isa Union{AbstractArray, Tuple} && any(pendiente, x))
    cerca(a, b) = (a isa Number && b isa Number && isapprox(a, b; rtol, atol = 1e-12)) ||
                  (a isa AbstractArray && b isa AbstractArray && size(a) == size(b) && all(cerca.(a, b)))
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end
