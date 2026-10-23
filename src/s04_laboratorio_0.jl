#%% hide
md"""
# Sesión 4: Laboratorio 0. Julia, Pluto.jl y Symbolics.jl

**Pregunta de la unidad.** Un gobierno tiene un fondo ``B`` para invertir en
dos regiones. ¿Cómo debe repartirlo?

En las sesiones 2 y 3 la respuesta se obtuvo a mano. En este laboratorio la
computadora hace el álgebra y las gráficas: es el primer paso de todo el
trabajo en código del curso.

**Objetivos del laboratorio**
1. Moverse en un cuaderno de Pluto: celdas reactivas y deslizadores.
2. Escribir funciones, vectores y comprensiones en Julia, y graficar con
   Plots.jl.
3. Derivar y despejar las condiciones de primer orden con Symbolics.jl.
4. Resolver el problema de las dos regiones en código y graficar ``V(B)`` y
   ``\lambda(B)``.
5. Comprobar numéricamente que ``V'(B) = \lambda``.

**Cómo usar este cuaderno.** Para editar una celda, haz clic en ella; para
ejecutarla, ``Shift + Enter``. Para ver el código de una celda oculta, haz
clic en el ojo que aparece a su izquierda. Los ejercicios con verificador
dicen **Pendiente** hasta que reemplazas `missing` por tu código. Las
secciones marcadas **[Avanzado]** son opcionales.

**Plan del laboratorio** (120 minutos). Cada bloque empieza con 3 a 5
minutos de demostración en el proyector; después cada quien trabaja en su
cuaderno.

| Minutos | Qué | Sección |
|---|---|---|
| 0–10 | Verificar que el entorno funciona; resolver lo que falte | 0 |
| 10–30 | Julia en cinco minutos y «Tu turno» | 1 |
| 30–40 | Celdas reactivas de Pluto | 2 |
| 40–50 | Gráficas con Plots.jl | 3 |
| 50–55 | Punto flotante | 4 |
| 55–60 | Pausa | |
| 60–85 | Symbolics.jl: las condiciones de primer orden | 5 |
| 85–115 | El reparto óptimo, ``V(B)`` y ``\lambda(B)`` | 6 |
| 115–120 | Cierre y tarea de la semana | Para la próxima sesión |
| Después | La sección [Avanzado] y las preguntas | 7, Preguntas |

**Antes de la sesión.** Instala el entorno siguiendo el `README.md` del
repositorio. Si el cuaderno abrió y la sección 0 muestra la tabla de
versiones, todo funciona.

**Repaso recomendado** (en `Class_notes/repaso/`): N.B1 (Julia), N.B2
(gráficas), N.B3 (Pluto), N.B4 (punto flotante) y N.I2 (Symbolics.jl). Para
los puntos [Avanzado]: N.A4 (diferencias finitas).
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 0. ¿Funciona el entorno?
"""

#%% hide
md"""
| Componente | Versión |
|:---|:---|
| Julia | $(string(VERSION)) |
| PlutoUI | $(string(pkgversion(PlutoUI))) |
| Plots | $(string(pkgversion(Plots))) |
| Symbolics | $(string(pkgversion(Symbolics))) |

Si ves esta tabla, el entorno del curso está instalado y los paquetes cargan.
La primera vez tarda varios minutos; las siguientes, mucho menos.
"""

#%% hide
md"""
## 1. Julia en cinco minutos

Una **función de una línea** se define como en papel. Ésta es el producto
marginal de una región con productividad ``a`` cuando ya recibió ``x``:
"""

#%%
producto_marginal(a, x) = a / (1 + x)

#%%
producto_marginal(2.0, 3.0)

#%% hide
md"""
Un **rango** es una sucesión de números igualmente espaciados, y el **punto**
aplica una función a cada elemento (*broadcasting*):
"""

#%%
inversiones = 0:0.5:3

#%%
producto_marginal.(2.0, inversiones)

#%% hide
md"""
Sin el punto, `producto_marginal(2.0, inversiones)` da error, porque dentro
de la función se calcula `1 + inversiones`, y sumar un número a un rango no
está definido: hay que escribir `1 .+ inversiones`. El punto en la llamada
aplica la función a cada elemento y evita el problema. Una **comprensión** construye un vector con una
regla, y puede filtrar:
"""

#%%
[producto_marginal(2.0, x) for x in inversiones if x >= 1]

#%% hide
md"""
Una **matriz** se escribe por filas, separadas con `;`. El operador `\`
resuelve el sistema lineal ``Ax = b``, el mismo que en la sesión 3 se
resolvía con la regla de Cramer:
"""

#%%
A = [2 1; 1 3]

#%%
A \ [5, 5]

#%% hide
md"""
Una **tupla con nombres** agrupa los parámetros de un modelo. Las letras con
subíndice se escriben como en LaTeX: `a\_1` y Tab da `a₁`.
"""

#%%
parametros = (a₁ = 2.0, a₂ = 1.0, B = 4.0)

#%%
parametros.a₁ / parametros.a₂ - 1

#%% hide
md"""
### Tu turno

**1.** Escribe `producto_total(x1, x2, a1, a2)`, el producto de las dos
regiones: ``a_1\ln(1 + x_1) + a_2\ln(1 + x_2)``. En Julia, el logaritmo
natural es `log`.
"""

#%%
producto_total(x1, x2, a1, a2) = missing  # reemplaza missing

#%% hide
verificar(() -> [producto_total(c...) for c in CASOS_PRODUCTO],
          [producto_ref(c...) for c in CASOS_PRODUCTO];
          pista = md"`producto_total(x1, x2, a1, a2) = a1 * log(1 + x1) + a2 * log(1 + x2)`")

#%% hide
md"""
**2.** Con ``a_1 = 2``, ``a_2 = 1`` y ``B = 4``, la región 1 recibe
``x_1 = 0, 1, 2, 3, 4`` y la región 2 recibe el resto, ``4 - x_1``. Calcula
el producto total de los cinco repartos **en una sola línea**, con
broadcasting o con una comprensión, y guárdalo en `productos`. ¿Cuál es el
mejor de los cinco?
"""

#%%
productos = missing  # reemplaza missing

#%% hide
verificar(() -> productos, producto_ref.(0:4, 4 .- (0:4), 2.0, 1.0);
          pista = md"Con broadcasting: `producto_total.(0:4, 4 .- (0:4), 2.0, 1.0)`. Con una comprensión: `[producto_total(x, 4 - x, 2.0, 1.0) for x in 0:4]`.")

#%% hide
md"""
## 2. Pluto: celdas reactivas

Pluto tiene tres reglas (N.B3):

1. **Cada variable se define en una sola celda.** Si dos celdas definen la
   misma variable, Pluto marca error en las dos.
2. **Una celda es una expresión.** Para varias líneas se usa `begin … end`
   (las variables quedan disponibles para todo el cuaderno) o `let … end`
   (quedan locales a la celda).
3. **El orden de las celdas no importa.** Al cambiar una celda, Pluto
   recalcula todas las que dependen de ella, estén donde estén.

**Pruébalo.**
- Cambia `0:0.5:3` por `0:1:10` en la celda de `inversiones` de la sección 1
  y ejecútala: la celda del broadcasting se recalcula sola.
- Agrega una celda nueva (el **+** que aparece entre celdas) con
  `inversiones = 1`. Las dos celdas marcan error por la regla 1. Borra la
  celda nueva.

Los **deslizadores** conectan un control con una variable. Al moverlos,
todo lo que depende de ella se recalcula:

``a_1`` (productividad de la región 1): $(@bind a1 Slider(1.0:0.1:4.0, default = 2.0, show_value = true))

``a_2`` (productividad de la región 2): $(@bind a2 Slider(0.2:0.1:1.0, default = 1.0, show_value = true))
"""

#%%
md"El primer peso invertido en la región 1 rinde $(producto_marginal(a1, 0)); en la región 2, $(producto_marginal(a2, 0))."

#%% hide
md"""
La celda anterior es Markdown con valores interpolados con `$( … )`. Así se
escriben los textos que cambian con los deslizadores.
"""

#%% hide
md"""
## 3. Gráficas con Plots.jl

`plot` crea una gráfica y `plot!` agrega otra curva a la misma. Las opciones
van después de `;`. Ésta compara los productos marginales de las dos
regiones, con los deslizadores de la sección 2:
"""

#%%
let
    x = range(0, 6, length = 200)
    plot(x, producto_marginal.(a1, x); label = "región 1", lw = 2, color = AZUL,
         xlabel = "inversión x", ylabel = "producto marginal", legend = :topright)
    plot!(x, producto_marginal.(a2, x); label = "región 2", lw = 2, color = NARANJA)
end

#%% hide
md"""
**Tu turno** (sin verificador). En la celda anterior:
- agrega una línea horizontal en ``\lambda = 0.5`` con
  `hline!([0.5]; label = "λ", color = GRIS, ls = :dash)`;
- con ``a_1 = 2`` y ``a_2 = 1``, lee en la gráfica cuánto recibe cada región
  si el último peso debe rendir ``\lambda = 0.5`` en las dos. ¿Cuánto suman?
  (Compara con la sesión 2: con ``B = 4``, el reparto es ``(3, 1)``.)
"""

#%% hide
md"""
## 4. Punto flotante

La computadora guarda los números con unos 16 dígitos, y casi ningún decimal
es exacto (N.B4):
"""

#%%
0.1 + 0.2 == 0.3

#%%
0.1 + 0.2 ≈ 0.3

#%% hide
md"""
`≈` (se escribe `\approx` y Tab) compara con una tolerancia. **Nunca**
compares números reales con `==`. Los verificadores de este cuaderno
comparan con tolerancia por esa razón.
"""

#%% hide
md"""
## 5. Symbolics.jl: las condiciones de primer orden

Symbolics.jl hace con letras lo que se hace a mano: derivar, despejar y
sustituir (N.I2). Primero se declaran las variables simbólicas. Las
productividades se llaman ``\alpha_i`` y el fondo ``b`` para no chocar con
los deslizadores `a1`, `a2` y `B` (regla 1 de Pluto).
"""

#%%
@variables x₁ x₂ λ μ α₁ α₂ b

#%%
lagrangiano = α₁ * log(1 + x₁) + α₂ * log(1 + x₂) + λ * (b - x₁ - x₂)

#%% hide
md"""
Las condiciones de primer orden son el gradiente del lagrangiano respecto de
``(x_1, x_2, \lambda)``, y la hessiana respecto de ``(x_1, x_2)`` da la
condición de segundo orden:
"""

#%%
cpo = Symbolics.gradient(lagrangiano, [x₁, x₂, λ])

#%%
Symbolics.hessian(lagrangiano, [x₁, x₂])

#%% hide
md"""
La hessiana es diagonal con entradas negativas: el producto es estrictamente
cóncavo, como en la sesión 2.

**Despejar.** `symbolic_solve(ecuacion, variable)` despeja una ecuación. El
signo `~` escribe una ecuación simbólica. Las dos primeras condiciones dan
cada inversión en función de ``\lambda``:
"""

#%%
despejes = (symbolic_solve(cpo[1] ~ 0, x₁)[1], symbolic_solve(cpo[2] ~ 0, x₂)[1])

#%% hide
md"""
Al sustituirlas en la tercera condición, el presupuesto, queda una ecuación
sólo en ``\lambda``:
"""

#%%
presupuesto = substitute(cpo[3], Dict(x₁ => despejes[1], x₂ => despejes[2]))

#%% hide
md"""
`symbolic_solve` no despeja ``\lambda`` de esta ecuación, porque ``\lambda``
aparece en el denominador. Un cambio de variable lo arregla: con
``\mu = 1/\lambda`` la ecuación es **lineal** en ``\mu``, y
`symbolic_linear_solve` la resuelve. Es un truco que se hace igual a mano:
"""

#%%
λ_interior = simplify(1 / symbolic_linear_solve(substitute(presupuesto, Dict(λ => 1 / μ)) ~ 0, μ))

#%%
x_interior = [simplify(substitute(d, Dict(λ => λ_interior))) for d in despejes]

#%% hide
md"""
Es la solución interior de la sesión 2:
``\lambda = (a_1 + a_2)/(B + 2)`` y ``x_i = a_i(B + 2)/(a_1 + a_2) - 1``.
Sustituida en el producto, da la función de valor del régimen interior, y
su derivada respecto del fondo es… el multiplicador. Es el teorema de la
envolvente de la sesión 3, comprobado por la computadora:
"""

#%%
V_interior = substitute(α₁ * log(1 + x₁) + α₂ * log(1 + x₂),
                        Dict(x₁ => x_interior[1], x₂ => x_interior[2]))

#%%
simplify(Symbolics.derivative(V_interior, b))

#%% hide
md"""
**De la fórmula al número.** `substitute` evalúa una expresión en valores
concretos, y `build_function` la convierte en una función de Julia, mucho
más rápida para graficar:
"""

#%%
substitute(λ_interior, Dict(α₁ => 2, α₂ => 1, b => 4))

#%%
λ_numerica = build_function(λ_interior, α₁, α₂, b; expression = Val(false))

#%%
λ_numerica(2.0, 1.0, 4.0)

#%% hide
md"""
## 6. Laboratorio: el reparto óptimo, ``V(B)`` y ``\lambda(B)``

Symbolics dio el régimen interior. Falta la esquina: con ``a_1 \ge a_2`` y
``\bar B = a_1/a_2 - 1``, si ``B \le \bar B`` todo va a la región 1,
``x = (B, 0)`` y ``\lambda = a_1/(1 + B)`` (sesión 2, sección 4.4).

**3.** Escribe `reparto(a1, a2, B)`, que devuelva el vector `[x1, x2, λ]`
en los dos regímenes, suponiendo ``a_1 \ge a_2``. Para el régimen interior
puedes usar `λ_numerica(a1, a2, B)`. Un `if … else … end` o el operador
`condicion ? si : no` deciden el régimen.
"""

#%%
function reparto(a1, a2, B)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [reparto(c...) for c in CASOS],
          [collect(reparto_ref(c...)) for c in CASOS];
          pista = md"Calcula `B̄ = a1 / a2 - 1`. Si `B <= B̄`, devuelve `[B, 0.0, a1 / (1 + B)]`. Si no, `λ = λ_numerica(a1, a2, B)` y devuelve `[a1 / λ - 1, a2 / λ - 1, λ]`.")

#%% hide
md"""
**4.** Escribe `valor(a1, a2, B)`, el producto total con el reparto óptimo.
Usa `reparto` y `producto_total`.
"""

#%%
function valor(a1, a2, B)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [valor(c...) for c in CASOS], [valor_ref(c...) for c in CASOS];
          pista = md"`x1, x2, _ = reparto(a1, a2, B)` y después `producto_total(x1, x2, a1, a2)`.")

#%% hide
md"""
### Las gráficas

Con los ejercicios 3 y 4 resueltos, la celda siguiente grafica ``V(B)`` y
``\lambda(B)`` con **tus** funciones. Lee el código: usa comprensiones, el
operador `&&` para dibujar el umbral sólo si cae en la gráfica, y `layout`
para poner dos gráficas lado a lado.

Fondo ``B``: $(@bind B Slider(0.1:0.1:10.0, default = 4.0, show_value = true))
"""

#%%
if completo(() -> valor(2.0, 1.0, 4.0)) && completo(() -> reparto(2.0, 1.0, 4.0))
    let
        Bs = range(0.01, 10, length = 300)
        g1 = plot(Bs, [valor(a1, a2, b) for b in Bs]; color = AZUL, lw = 2,
                  xlabel = "fondo B", ylabel = "V(B)", title = "Valor óptimo")
        g2 = plot(Bs, [reparto(a1, a2, b)[3] for b in Bs]; color = AZUL, lw = 2,
                  xlabel = "fondo B", ylabel = "λ(B)", title = "Precio sombra del fondo")
        B̄ = a1 / a2 - 1
        for g in (g1, g2)
            B̄ <= 10 && vline!(g, [B̄]; color = GRIS, ls = :dash, lw = 1)
            vline!(g, [B]; color = NARANJA, lw = 1.5)
        end
        plot(g1, g2; layout = (1, 2), size = (760, 320))
    end
else
    md"Completa los ejercicios 3 y 4 para ver las gráficas."
end

#%% hide
md"""
La línea punteada es el umbral ``\bar B``; la naranja, el ``B`` del
deslizador. ``V`` es creciente y cóncava, y ``\lambda`` es decreciente y
continua, también en el umbral.

**5.** La pendiente de ``V`` debe ser ``\lambda``. Para comprobarlo hace falta
una derivada numérica. Escribe `derivada_centrada(g, x; h = 1e-5)`, que
aproxime ``g'(x)`` con ``\big(g(x + h) - g(x - h)\big)/2h``.
"""

#%%
function derivada_centrada(g, x; h = 1e-5)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [derivada_centrada(exp, 1.0), derivada_centrada(sin, 0.0), derivada_centrada(x -> x^3, 2.0)],
          [exp(1.0), 1.0, 12.0];
          rtol = 1e-8,
          pista = md"`(g(x + h) - g(x - h)) / (2h)`")

#%%
if completo(() -> derivada_centrada(exp, 1.0)) && completo(() -> valor(2.0, 1.0, 4.0))
    md"""
    Con ``B`` = $(B): la derivada numérica de ``V`` es
    $(round(derivada_centrada(v -> valor(a1, a2, v), B), digits = 6)) y el
    multiplicador vale $(round(reparto(a1, a2, B)[3], digits = 6)).
    """
else
    md"Completa los ejercicios 4 y 5 para comparar ``V'(B)`` con ``\lambda``."
end

#%% hide
md"""
## 7. [Avanzado] ¿Qué tan pequeño debe ser ``h``?

Una diferencia finita tiene dos errores (N.A4). El de **truncamiento** baja
con ``h``: es del orden de ``h`` en la diferencia hacia adelante,
``\big(g(x + h) - g(x)\big)/h``, y de ``h^2`` en la centrada. El de
**redondeo** sube cuando ``h`` baja, porque se restan dos números casi
iguales (sección 4). La gráfica muestra el error al estimar ``V'(B) = \lambda``
con cada fórmula, en escala logarítmica.
"""

#%%
let
    hs = 10.0 .^ (-1:-0.25:-13)
    V(b) = valor_ref(a1, a2, b)
    λ = reparto_ref(a1, a2, B)[3]
    adelante = [abs((V(B + h) - V(B)) / h - λ) for h in hs]
    centrada = [abs((V(B + h) - V(B - h)) / 2h - λ) for h in hs]
    plot(hs, max.(adelante, 1e-17); xscale = :log10, yscale = :log10, lw = 2,
         color = AZUL, label = "hacia adelante", legend = :bottomleft,
         xlabel = "h", ylabel = "error", title = "Error de la derivada numérica de V en B = $B")
    plot!(hs, max.(centrada, 1e-17); lw = 2, color = NARANJA, label = "centrada")
end

#%% hide
md"""
El mejor ``h`` está cerca de ``10^{-8}`` para la diferencia hacia adelante y
de ``10^{-5}`` para la centrada; por eso el ejercicio 5 usa ``h = 10^{-5}``.
Con ``h`` más pequeño, el error **crece**.
"""

#%% hide
md"""
## Resumen

| Herramienta | Para qué | En este laboratorio |
|---|---|---|
| Funciones y broadcasting | Evaluar un modelo en muchos valores | `producto_marginal.(a, x)` |
| Comprensiones | Construir vectores con una regla | `[valor(a1, a2, b) for b in Bs]` |
| Pluto | Cuadernos reactivos, sin estado oculto | Deslizadores de ``a_1``, ``a_2`` y ``B`` |
| Plots.jl | Gráficas | ``V(B)`` y ``\lambda(B)`` |
| Symbolics.jl | Derivar, despejar y sustituir | Condiciones de primer orden y solución interior |
| Diferencias finitas | Derivar numéricamente | ``V'(B) \approx \lambda`` |

## Preguntas

1. ¿Por qué hubo que llamar ``\alpha_i`` y ``b`` a los símbolos de la
   sección 5?
2. En el ejercicio 2, ¿cuál de los cinco repartos es el mejor? ¿Es el
   óptimo exacto? ¿Por qué no hace falta probar más repartos para saberlo?
3. `symbolic_solve` no despejó ``\lambda`` directamente. ¿Qué otros
   problemas del curso crees que no tendrán solución simbólica? (Pista: la
   sesión 14.)
4. ¿Por qué ``0.1 + 0.2 == 0.3`` da `false`? ¿Qué usaste en lugar de `==`?
5. **[Avanzado]** En la sección 7, ¿por qué el error de la diferencia
   centrada vuelve a crecer cuando ``h < 10^{-5}``?

## Para la próxima sesión

- **Sesión 5: ecuaciones diferenciales lineales de primer orden.** Empieza
  la Unidad II: ¿convergen los estados de México? Se usan los datos del
  PIB por entidad (`Data/entidades.csv`).
- **Tarea de esta semana:** los ejercicios de código de los cuadernos de
  las sesiones 1, 2 y 3, que quedaron pendientes porque todavía no tenías
  Julia (siete ejercicios, más tres [Avanzado] opcionales). Se revisan con
  el verificador de cada cuaderno.
- **Entrega de la Tarea 1** (Unidad I).
- Repaso: C.B3 (exponencial), D.B1 a D.B4 (ecuaciones diferenciales) y
  N.I7 (datos en Julia).
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
    using PlutoUI, Plots, Symbolics, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # segunda serie, valor elegido
    const GRIS    = "#52514e"   # referencias
end;

#%%
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto_ref(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

#%%
"Reparto óptimo con Kuhn-Tucker: (x₁, x₂, λ). Funciona con cualquier orden de a₁ y a₂."
function reparto_ref(a1, a2, B)
    if a1 < a2
        r = reparto_ref(a2, a1, B)
        return (r[2], r[1], r[3])
    end
    B <= a1 / a2 - 1 && return (B, 0.0, a1 / (1 + B))
    λ = (a1 + a2) / (B + 2)
    (a1 / λ - 1, a2 / λ - 1, λ)
end

#%%
"Valor óptimo V(a₁, a₂, B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto_ref(x1, x2, a1, a2)
end

#%%
begin
    # Casos de prueba: (x₁, x₂, a₁, a₂) para el producto; (a₁, a₂, B) con
    # esquina, umbral e interior para el reparto.
    const CASOS_PRODUCTO = [(0.0, 0.0, 2.0, 1.0), (3.0, 1.0, 2.0, 1.0), (0.5, 2.5, 1.5, 0.7)]
    const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]
end;

#%%
"¿La función ya está escrita? Verdadero si corre sin error y no devuelve missing."
function completo(f)
    r = try
        f()
    catch
        return false
    end
    !(r === missing || (r isa AbstractArray && any(ismissing, r)))
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
                  (a isa AbstractArray && b isa AbstractArray && size(a) == size(b) && all(cerca.(a, b)))
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end
