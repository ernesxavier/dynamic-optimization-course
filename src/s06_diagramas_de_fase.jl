#%% hide
md"""
# Sesión 6: Equilibrio, diagramas de fase y ecuaciones en diferencias

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

**Objetivos de la sesión**
1. Encontrar los equilibrios de ``\dot x = f(x)`` y decidir, con la recta de
   fase y el signo de ``f'(x^\ast)``, cuáles son estables.
2. Reconocer equilibrios múltiples y umbrales, y lo que implican para la
   política regional.
3. Resolver ``y_{t+1} = ay_t + b`` y saber cuándo converge y cuándo oscila.
4. Leer un diagrama de telaraña y aplicar el criterio ``|g'(x^\ast)| < 1``.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s06_diagramas_de_fase.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s06_diagramas_de_fase.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): D.B1 y D.B2 (ecuaciones
diferenciales y en diferencias), A.B2 (sucesiones), D.I1 (lineales de
primer orden) y D.I4 (puntos fijos y diagramas de fase). Para los puntos
[Avanzado]: A.I5 (contracciones).
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 0. La pregunta: ¿a dónde va una región?

En la sesión 5, la brecha de una región cumplía una ecuación lineal y se
podía resolver. Los modelos económicos casi nunca son lineales. La buena
noticia: para saber **a dónde va** el sistema no hace falta resolverlo.
Basta el **diagrama de fase**: dibujar ``\dot x = f(x)`` contra ``x``.
Donde ``f > 0``, ``x`` crece; donde ``f < 0``, decrece; donde ``f = 0``,
está en equilibrio.

En las gráficas de este cuaderno, un **punto lleno** es un equilibrio estable
y un **punto vacío**, uno inestable.
"""

#%% hide
md"""
## 1. Solow: un equilibrio estable

El capital por trabajador de una región cumple

```math
\dot k = s k^\alpha - (n + \delta) k .
```

Tasa de ahorro ``s``: $(@bind s Slider(0.05:0.05:0.5, default = 0.2, show_value = true))

Participación del capital ``\alpha``: $(@bind α Slider(0.2:0.05:0.6, default = 0.3, show_value = true))

Crecimiento de la población más depreciación, ``n + \delta``: $(@bind nδ Slider(0.02:0.01:0.12, default = 0.06, show_value = true))
"""

#%% hide
let
    f(k) = s * k^α - nδ * k
    kstar = (s / nδ)^(1 / (1 - α))
    kmax = 2.2kstar
    g1 = recta_de_fase(f, [0.0, kstar], [false, true], 0, kmax;
                       titulo = "Recta de fase", etiqueta = "k")
    g2 = plot(; xlabel = "años", ylabel = "k(t)", title = "Trayectorias desde varios k₀")
    for k0 in (0.05, 0.3, 0.7, 1.4, 2.0) .* kstar
        ts, ks = simular((k, t) -> f(k), k0, 120)
        plot!(g2, ts, ks; color = AZUL, lw = 1.5)
    end
    hline!(g2, [kstar]; color = GRIS, ls = :dash, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (760, 320))
end

#%% hide
let
    kstar = (s / nδ)^(1 / (1 - α))
    fp = -(1 - α) * nδ
    r(v) = round(v, digits = 3)
    md"""
    | | Valor |
    |:---|---:|
    | Estado estacionario ``k^\ast = (s/(n + \delta))^{1/(1-\alpha)}`` | $(r(kstar)) |
    | Pendiente ``f'(k^\ast) = -(1 - \alpha)(n + \delta)`` | $(r(fp)) |
    | Vida media de una desviación pequeña, ``\ln 2/|f'(k^\ast)|`` | $(round(log(2) / abs(fp), digits = 1)) años |

    Todas las trayectorias con ``k_0 > 0`` van a ``k^\ast``: las que empiezan
    abajo crecen y las que empiezan arriba bajan, **sin cruzarse ni
    oscilar**. En una dimensión y en tiempo continuo, las soluciones son
    monótonas.

    Sube ``s``: ``k^\ast`` sube, pero la velocidad no cambia. Sube ``\alpha``:
    la convergencia se vuelve más lenta. Es la razón por la que la regla del
    2% de la sesión 5 pide un ``\alpha`` alto.
    """
end

#%% hide
md"""
## 2. Aglomeración: dos equilibrios estables y un umbral

Una región atrae población según cuánto mejor se vive ahí que en el resto
del país. Con aglomeración, la ventaja ``u(L)`` sube con el tamaño de la
región al principio y baja después, por congestión:

```math
\dot L = L\,u(L), \qquad u(L) = a + 2L - 1.5L^2 .
```

Con ``a < 0``, una región pequeña no tiene la masa crítica para atraer a
nadie.

Ventaja de partida ``a``: $(@bind a_agl Slider(-0.6:0.05:0.1, default = -0.3, show_value = true))
"""

#%% hide
let
    u(L) = a_agl + 2L - 1.5L^2
    f(L) = L * u(L)
    eqs, estables = equilibrios_aglomeracion(a_agl)
    g1 = recta_de_fase(f, eqs, estables, 0, 1.6; titulo = "Recta de fase", etiqueta = "L")
    g2 = plot(; xlabel = "años", ylabel = "L(t)", title = "Trayectorias desde varios L₀",
              ylims = (0, 1.6))
    for L0 in (0.05, 0.12, 0.16, 0.19, 0.25, 0.6, 1.5)
        ts, Ls = simular((L, t) -> f(L), L0, 30)
        plot!(g2, ts, Ls; color = AZUL, lw = 1.5)
    end
    plot(g1, g2; layout = (1, 2), size = (760, 320))
end

#%% hide
let
    eqs, estables = equilibrios_aglomeracion(a_agl)
    r(v) = round(v, digits = 3)
    if length(eqs) == 3
        md"""
        Hay tres equilibrios: ``L = 0`` (estable: la región se vacía),
        ``L_1`` = $(r(eqs[2])) (**inestable**: el umbral) y ``L_2`` = $(r(eqs[3]))
        (estable: la región consolidada). **La historia decide**: dos regiones
        idénticas terminan en lugares distintos según de qué lado del umbral
        empiecen.

        Sube ``a``: el umbral baja y la región consolidada crece. Con ``a > 0``,
        el equilibrio ``L = 0`` se vuelve inestable y toda región crece.
        """
    elseif length(eqs) == 2
        md"""
        Con ``a`` = $(a_agl) > 0, ``L = 0`` es **inestable**: cualquier región
        con algo de población crece hasta ``L_2`` = $(r(eqs[2])). Ya no hay
        umbral.
        """
    else
        md"""
        Con ``a`` = $(a_agl), la ventaja nunca es positiva: toda región se
        vacía. El único equilibrio es ``L = 0``.
        """
    end
end

#%% hide
md"""
### Un gran impulso

Una región empieza con ``L_0 = 0.1``, debajo del umbral. El gobierno le da un
subsidio ``\sigma`` que sube su ventaja, ``u(L) + \sigma``, durante los
primeros ``T_s`` años, y después lo retira. ¿Cuánto subsidio y por cuánto
tiempo hacen falta para que la región se consolide?

Subsidio ``\sigma``: $(@bind σ_sub Slider(0.0:0.05:0.6, default = 0.3, show_value = true))

Duración ``T_s`` (años): $(@bind T_sub Slider(0:1:20, default = 5, show_value = true))
"""

#%% hide
let
    eqs, _ = equilibrios_aglomeracion(a_agl)
    u(L) = a_agl + 2L - 1.5L^2
    ts, Ls = simular((L, t) -> L * (u(L) + (t < T_sub ? σ_sub : 0.0)), 0.1, 40)
    p = plot(ts, Ls; color = AZUL, lw = 2, xlabel = "años", ylabel = "L(t)", ylims = (0, 1.6),
             title = "Subsidio de $σ_sub durante $T_sub años")
    T_sub > 0 && vspan!(p, [0, T_sub]; color = NARANJA, alpha = 0.12)
    length(eqs) == 3 && hline!(p, [eqs[2]]; color = GRIS, ls = :dash, lw = 1)
    p
end

#%% hide
let
    u(L) = a_agl + 2L - 1.5L^2
    _, Ls = simular((L, t) -> L * (u(L) + (t < T_sub ? σ_sub : 0.0)), 0.1, 40)
    Ls[end] > 0.5 ?
        md"**La región se consolida**: el subsidio (franja naranja) la llevó por encima del umbral (línea punteada) y, una vez retirado, siguió creciendo sola." :
        md"**La región se vacía**: el subsidio no bastó para cruzar el umbral, y al retirarlo la región vuelve a perder población. Lo gastado se pierde."
end

#%% hide
md"""
## 3. Ecuaciones en diferencias lineales

En tiempo discreto, ``y_{t+1} = a y_t + b``. El punto fijo es
``y^\ast = b/(1 - a)`` y la solución es

```math
y_t = y^\ast + a^t (y_0 - y^\ast):
```

la desviación se multiplica por ``a`` cada periodo.

``a``: $(@bind a_d Slider(-1.5:0.1:1.5, default = -0.5, show_value = true))

``b``: $(@bind b_d Slider(0.0:0.5:5.0, default = 3.0, show_value = true))

``y_0``: $(@bind y0_d Slider(0.0:0.5:10.0, default = 0.0, show_value = true))
"""

#%% hide
let
    ys = iterar_ref(y -> a_d * y + b_d, y0_d, 20)
    p = scatter(0:20, ys; color = AZUL, ms = 4, msw = 0, xlabel = "t", ylabel = "yₜ",
                title = "yₜ₊₁ = $(a_d) yₜ + $(b_d)", ylims = (-10, 20))
    plot!(p, 0:20, ys; color = AZUL, lw = 0.8, alpha = 0.5)
    !(a_d ≈ 1) && hline!(p, [b_d / (1 - a_d)]; color = GRIS, ls = :dash, lw = 1)
    p
end

#%% hide
let
    regimen = a_d ≈ 1 ? "crece en línea recta, porque no hay punto fijo" :
              abs(a_d) ≈ 1 ? "oscila para siempre entre dos valores" :
              abs(a_d) < 1 ? (a_d < -1e-9 ? "converge oscilando" : a_d > 1e-9 ? "converge monótonamente" : "llega al punto fijo en un paso") :
              (a_d < 0 ? "se aleja oscilando" : "se aleja monótonamente")
    md"""
    Con ``a`` = $(a_d), la trayectoria $(regimen). El punto fijo es estable si y sólo si
    ``|a| < 1``, y la trayectoria oscila si y sólo si ``a < 0``. En tiempo
    continuo, una ecuación de primer orden nunca oscila; en discreto, el
    estado puede brincar al otro lado del equilibrio.
    """
end

#%% hide
md"""
## 4. Ecuaciones no lineales: el diagrama de telaraña

Para ``x_{t+1} = g(x_t)``, los puntos fijos son los cruces de ``y = g(x)``
con la diagonal. La telaraña sube a la curva (aplicar ``g``) y va a la
diagonal (pasar el resultado al eje horizontal), una y otra vez. Cerca de un
punto fijo, la desviación se multiplica por ``g'(x^\ast)``.

Mapa: $(@bind mapa Select(["mercado" => "Telaraña de un mercado regional", "solow" => "Solow discreto (sesión 1)", "logistico" => "Mapa logístico"]))

Respuesta de la oferta al precio, ``D`` (mercado, con ``B = 1``): $(@bind D_oferta Slider(0.2:0.1:1.5, default = 0.8, show_value = true))

Parámetro ``r`` (logístico): $(@bind r_log Slider(0.5:0.1:3.9, default = 2.8, show_value = true))

Punto de partida (fracción del rango): $(@bind x0_frac Slider(0.05:0.05:0.95, default = 0.15, show_value = true))
"""

#%% hide
let
    m = mapa_ref(mapa, D_oferta, r_log)
    x0 = m.rango[1] + x0_frac * (m.rango[2] - m.rango[1])
    xs = iterar_ref(m.g, x0, 40)
    g1 = telarana(m.g, xs, m.rango; titulo = m.nombre)
    g2 = plot(0:40, xs; color = AZUL, lw = 1, marker = :circle, ms = 3, msw = 0,
              xlabel = "t", ylabel = "xₜ", title = "Trayectoria", ylims = m.rango)
    hline!(g2, [m.xstar]; color = GRIS, ls = :dash, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (760, 340))
end

#%% hide
let
    m = mapa_ref(mapa, D_oferta, r_log)
    gp = m.gprima
    lectura = abs(gp) < 1 ? (gp >= 0 ? "estable, con convergencia monótona" : "estable, con convergencia oscilante") :
              abs(gp) > 1 ? "inestable" : "en el límite: el criterio no decide"
    md"""
    Punto fijo ``x^\ast`` = $(round(m.xstar, digits = 3)), con
    ``g'(x^\ast)`` = $(round(gp, digits = 3)): $(lectura).

    - **Mercado.** ``g'(p^\ast) = -D/B``: el precio siempre oscila. Con
      ``D > B`` (la oferta responde más que la demanda), las oscilaciones
      crecen.
    - **Solow discreto.** ``g'(K^\ast) = 1 - (1 - \alpha)\delta = 0.965``: cada
      año queda el 96.5% de la brecha. Por eso, en la sesión 1, el capital
      sólo llegó a 5.4 de 7.25 en 40 años. La curva casi coincide con la
      diagonal, y la telaraña es una escalera de peldaños diminutos.
    - **Logístico.** ``g'(x^\ast) = 2 - r``. Prueba ``r = 2.8`` (oscila y
      converge), ``r = 3.2`` (ciclo de periodo 2) y ``r = 3.9`` (caos).
    """
end

#%% hide
md"""
## 5. El método de Euler es una ecuación en diferencias

En la sesión 5, el método de Euler oscilaba con pasos grandes. La razón: al
aplicarlo a ``\dot y = -a(y - y^\ast)`` con paso ``\Delta t`` se obtiene

```math
y_{k+1} - y^\ast = (1 - a\,\Delta t)(y_k - y^\ast),
```

una ecuación lineal en diferencias con coeficiente ``1 - a\,\Delta t``.

``a\,\Delta t``: $(@bind aΔt Slider(0.1:0.1:2.5, default = 0.5, show_value = true))
"""

#%% hide
let
    t = range(0, 12, length = 300)
    k = 0:round(Int, 12 / aΔt)
    p = plot(t, exp.(-t); color = AZUL, lw = 2, label = "solución exacta",
             xlabel = "t", ylabel = "y − y*", ylims = (-2, 2), legend = :topright,
             title = "Euler con a Δt = $aΔt (a = 1)")
    plot!(p, k .* aΔt, (1 - aΔt) .^ k; color = NARANJA, lw = 1, marker = :circle, ms = 3,
          msw = 0, label = "Euler")
end

#%% hide
let
    regimen = aΔt ≈ 1 ? "exacta en el equilibrio: llega en un paso" : aΔt < 1 ? "monótona y cercana a la solución exacta" :
              aΔt ≈ 2 ? "oscilante sin converger" : aΔt < 2 ? "oscilante, aunque la ecuación no oscila" :
              "divergente, aunque la ecuación es estable"
    md"""
    El coeficiente es ``1 - a\,\Delta t`` = $(round(1 - aΔt, digits = 2)):
    la aproximación es $(regimen). El paso debe ser pequeño respecto de
    ``1/a``, el tiempo característico del sistema.
    """
end

#%% hide
md"""
## 6. [Avanzado] Contracciones: convergencia desde cualquier punto

El criterio ``|g'(x^\ast)| < 1`` es local. Si ``|g'(x)| \le \rho < 1`` en
todo un intervalo que ``g`` manda en sí mismo, la iteración converge desde
cualquier punto del intervalo, con error ``|x_t - x^\ast| \le \rho^t |x_0 - x^\ast|``
(notas, sección 2.3). Con ``g(x) = 1 + 0.5\cos x``, ``|g'(x)| = 0.5|\sin x| \le 0.5``.

Punto de partida ``x_0``: $(@bind x0_c Slider(-10.0:1.0:10.0, default = 5.0, show_value = true))
"""

#%% hide
let
    g(x) = 1 + 0.5cos(x)
    xstar = iterar_ref(g, 1.0, 200)[end]
    xs = iterar_ref(g, x0_c, 30)
    err = abs.(xs .- xstar)
    p = plot(0:30, max.(err, 1e-17); yscale = :log10, color = AZUL, lw = 2, marker = :circle,
             ms = 3, msw = 0, label = "error |xₜ − x*|", xlabel = "t", ylabel = "error",
             title = "Iteración de g(x) = 1 + 0.5 cos x", legend = :topright)
    plot!(p, 0:30, err[1] .* 0.5 .^ (0:30); color = NARANJA, ls = :dash, lw = 1.5,
          label = "cota ρᵗ |x₀ − x*|")
end

#%% hide
md"""
Desde cualquier ``x_0`` el error cae al menos a la mitad en cada iteración,
y en la práctica más rápido: cerca del punto fijo, ``|g'(x^\ast)| \approx 0.46``.
La iteración de la función valor de la sesión 16 es este mismo argumento con
funciones en lugar de números, y con el factor de descuento ``\beta`` en el
papel de ``\rho``.
"""

#%% hide
md"""
## Resumen

| | Tiempo continuo, ``\dot x = f(x)`` | Tiempo discreto, ``x_{t+1} = g(x_t)`` |
|---|---|---|
| Equilibrio | ``f(x^\ast) = 0`` | ``g(x^\ast) = x^\ast`` |
| Estable si | ``f'(x^\ast) < 0`` | ``|g'(x^\ast)| < 1`` |
| Oscila | Nunca, en una dimensión | Si ``g'(x^\ast) < 0`` |
| Diagrama | Recta de fase | Telaraña |
| En este cuaderno | Solow; aglomeración con umbral | Solow discreto, mercado, logístico, Euler |

## Ejercicios

### Completa el código

**1.** Escribe `clasificar_continuo(fp)`, que reciba ``f'(x^\ast)`` y devuelva
`:estable`, `:inestable` o `:no_decide`.
"""

#%%
function clasificar_continuo(fp)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> clasificar_continuo.([-0.042, 0.255, 0.0, -1.72]),
          [:estable, :inestable, :no_decide, :estable];
          pista = md"Usa `fp < 0 ? :estable : fp > 0 ? :inestable : :no_decide`.")

#%% hide
md"""
**2.** Escribe `clasificar_discreto(gp)`, que reciba ``g'(x^\ast)`` y devuelva
`:monotona` (estable sin oscilar), `:oscilante` (estable oscilando),
`:inestable` o `:no_decide` (si ``|g'(x^\ast)| = 1``).
"""

#%%
function clasificar_discreto(gp)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> clasificar_discreto.([0.965, -0.8, 1.5, -1.2, 1.0, -1.0, 0.0]),
          [:monotona, :oscilante, :inestable, :inestable, :no_decide, :no_decide, :monotona];
          pista = md"Primero compara `abs(gp)` con 1; si es menor, decide por el signo de `gp` (con `gp >= 0` monótona).")

#%% hide
md"""
**3.** Escribe `iterar(g, x0, n)`, que devuelva el vector
``[x_0, x_1, \dots, x_n]`` con ``x_{t+1} = g(x_t)``.
"""

#%%
function iterar(g, x0, n)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [iterar(y -> -0.5y + 3, 0.0, 4); iterar(cos, 1.0, 3)],
          [iterar_ref(y -> -0.5y + 3, 0.0, 4); iterar_ref(cos, 1.0, 3)];
          pista = md"Crea `x = [x0]` y en un ciclo `for t in 1:n` agrega `push!(x, g(x[end]))`; devuelve `x`.")

#%% hide
md"""
**4.** Escribe `umbral(a, b, c)`, el umbral ``L_1`` del modelo de
aglomeración con ``u(L) = a + bL - cL^2``: la raíz menor de ``u``. Supón
``a < 0`` y ``b^2 > 4|a|c``.
"""

#%%
function umbral(a, b, c)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [umbral(-0.3, 2.0, 1.5), umbral(-0.1, 2.0, 1.5), umbral(-0.5, 3.0, 2.0)],
          [umbral_ref(-0.3, 2.0, 1.5), umbral_ref(-0.1, 2.0, 1.5), umbral_ref(-0.5, 3.0, 2.0)];
          pista = md"Las raíces de ``-cL^2 + bL + a = 0`` son ``\big(b \mp \sqrt{b^2 + 4ac}\big)/(2c)``; la menor lleva el signo menos.")

#%% hide
md"""
### Interpretación

5. En el modelo de Solow, ¿por qué subir la tasa de ahorro sube ``k^\ast``
   pero no cambia la velocidad de convergencia? ¿Qué parámetro la cambia?
6. En el modelo de aglomeración, ¿por qué no se observan regiones
   exactamente en el umbral ``L_1``? Con el gran impulso, encuentra dos
   combinaciones de ``\sigma`` y ``T_s`` que consoliden la región. ¿Cuál es
   más barata, si el costo es ``\sigma \times T_s``?
7. En la telaraña del mercado, ¿qué política reduciría las oscilaciones del
   precio? Piensa en qué cambia ``D/B``.
8. ¿Por qué una ecuación diferencial de primer orden no puede oscilar y una
   ecuación en diferencias sí?

### Tu tesis

9. ¿Puede tener tu problema de tesis más de un equilibrio? Si sí, ¿qué
   determinaría a cuál llega una región? Si no, ¿qué supuesto lo impide?

### [Avanzado]

10. En el mapa logístico, encuentra el valor de ``r`` a partir del cual el
    punto fijo deja de ser estable. ¿Qué aparece en su lugar?
11. Con la sección 6, ¿cuántas iteraciones bastan para que el error sea
    menor que ``10^{-6}`` desde ``x_0 = 10``, según la cota? ¿Cuántas hacen
    falta en realidad?

## Para la próxima sesión

- **Sesión 7: sistemas de ecuaciones diferenciales y linealización.** Dos
  variables a la vez: el diagrama de fase pasa de la recta al plano, y la
  estabilidad se decide con los eigenvalores del jacobiano.
- Repaso: L.I1 a L.I3 (eigenvalores), D.I3 (lineales de segundo orden) y
  D.I5 (sistemas lineales de dos dimensiones).
"""

#%% hide
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
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
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # flechas, telaraña, subsidio
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # equilibrios
end;

#%%
"Simula ẋ = f(x, t) con Runge-Kutta de cuarto orden y paso dt; devuelve tiempos y valores."
function simular(f, x0, T; dt = 0.02)
    n = round(Int, T / dt)
    x = zeros(n + 1)
    x[1] = x0
    for i in 1:n
        t = (i - 1) * dt
        k1 = f(x[i], t)
        k2 = f(x[i] + dt / 2 * k1, t + dt / 2)
        k3 = f(x[i] + dt / 2 * k2, t + dt / 2)
        k4 = f(x[i] + dt * k3, t + dt)
        x[i + 1] = x[i] + dt / 6 * (k1 + 2k2 + 2k3 + k4)
    end
    (0:n) .* dt, x
end

#%%
"""
Recta de fase de ẋ = f(x) en [xmin, xmax]: la curva f, flechas sobre el eje
según el signo de f y los equilibrios (llenos si son estables, vacíos si no).
"""
function recta_de_fase(f, eqs, estables, xmin, xmax; titulo = "", etiqueta = "x")
    xs = range(xmin, xmax, length = 400)
    p = plot(xs, f.(xs); color = AZUL, lw = 2, xlabel = etiqueta, ylabel = "ẋ = f(x)",
             title = titulo)
    hline!(p, [0]; color = GRIS, lw = 1)
    bordes = sort(unique([xmin; filter(e -> xmin < e < xmax, eqs); xmax]))
    largo = 0.06 * (xmax - xmin)
    for (izq, der) in zip(bordes[1:end-1], bordes[2:end])
        medio = (izq + der) / 2
        dir = sign(f(medio)) * min(largo, 0.5 * (der - izq))
        plot!(p, [medio - dir / 2, medio + dir / 2], [0, 0]; arrow = true, color = NARANJA, lw = 2)
    end
    for (e, est) in zip(eqs, estables)
        scatter!(p, [e], [0]; color = est ? TINTA : :white, markerstrokecolor = TINTA,
                 ms = 6, msw = 1.5)
    end
    p
end

#%%
"Equilibrios de L̇ = L(a + 2L − 1.5L²) en L ≥ 0 y si son estables."
function equilibrios_aglomeracion(a; b = 2.0, c = 1.5)
    disc = b^2 + 4a * c
    if disc < 0
        return [0.0], [true]
    end
    L1, L2 = (b - sqrt(disc)) / (2c), (b + sqrt(disc)) / (2c)
    a < 0 ? ([0.0, L1, L2], [true, false, true]) : ([0.0, L2], [false, true])
end

#%%
"Umbral de masa crítica: la raíz menor de a + bL − cL²."
umbral_ref(a, b, c) = (b - sqrt(b^2 + 4a * c)) / (2c)

#%%
"Iteraciones x₀, x₁, …, xₙ de x_{t+1} = g(x_t)."
function iterar_ref(g, x0, n)
    x = [float(x0)]
    for _ in 1:n
        push!(x, g(x[end]))
    end
    x
end

#%%
"Los tres mapas de la sección 4: función, rango, punto fijo y g′ en el punto fijo."
function mapa_ref(nombre, D, r)
    if nombre == "solow"
        s, α, δ = 0.2, 0.3, 0.05
        Kstar = (s / δ)^(1 / (1 - α))
        (g = K -> (1 - δ) * K + s * max(K, 0)^α, rango = (0.0, 12.0), xstar = Kstar,
         gprima = 1 - (1 - α) * δ, nombre = "Solow: Kₜ₊₁ = 0.95Kₜ + 0.2Kₜ^0.3")
    elseif nombre == "mercado"
        A, B, C = 10.0, 1.0, 1.0
        (g = p -> (A - C) / B - D / B * p, rango = (0.0, 12.0), xstar = (A - C) / (B + D),
         gprima = -D / B, nombre = "Mercado: pₜ = 9 − $(D) pₜ₋₁")
    else
        (g = x -> r * x * (1 - x), rango = (0.0, 1.0), xstar = max(1 - 1 / r, 0.0),
         gprima = r > 1 ? 2 - r : r, nombre = "Logístico: xₜ₊₁ = $(r) xₜ(1 − xₜ)")
    end
end

#%%
"Diagrama de telaraña de g para la trayectoria xs en el rango dado."
function telarana(g, xs, rango; titulo = "")
    grid = range(rango..., length = 300)
    p = plot(grid, g.(grid); color = AZUL, lw = 2, xlims = rango, ylims = rango,
             xlabel = "xₜ", ylabel = "xₜ₊₁", title = titulo, aspect_ratio = :equal)
    plot!(p, collect(rango), collect(rango); color = GRIS, ls = :dash, lw = 1)
    px, py = [xs[1]], [rango[1]]
    for t in 1:length(xs) - 1
        push!(px, xs[t]); push!(py, xs[t + 1])        # vertical: aplicar g
        push!(px, xs[t + 1]); push!(py, xs[t + 1])    # horizontal: a la diagonal
    end
    plot!(p, px, clamp.(py, rango...); color = NARANJA, lw = 1)
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
    pendiente(x) = x === missing || (x isa AbstractArray && any(pendiente, x))
    cerca(a, b) = (a isa Number && b isa Number && isapprox(a, b; rtol, atol = 1e-12)) ||
                  (a isa Symbol && b isa Symbol && a == b) ||
                  (a isa AbstractArray && b isa AbstractArray && size(a) == size(b) && all(cerca.(a, b)))
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end
