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

# ╔═╡ d6392586-cf04-11f1-b8a2-df9d5df985af
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

# ╔═╡ d63922fc-cf04-11f1-9fc0-c1a20816f875
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

# ╔═╡ d6392342-cf04-11f1-9ed7-e79e911d9991
TableOfContents(title = "Contenido")

# ╔═╡ d6392356-cf04-11f1-bad0-a1454c462c34
md"""
## 0. ¿Funciona el entorno?
"""

# ╔═╡ d6392360-cf04-11f1-aa73-1305ac45970d
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

# ╔═╡ d639236c-cf04-11f1-bf53-e36b17204d02
md"""
## 1. Julia en cinco minutos

Una **función de una línea** se define como en papel. Ésta es el producto
marginal de una región con productividad ``a`` cuando ya recibió ``x``:
"""

# ╔═╡ d639236c-cf04-11f1-88b3-8524eb0d8428
producto_marginal(a, x) = a / (1 + x)

# ╔═╡ d6392374-cf04-11f1-834d-4918e4321208
producto_marginal(2.0, 3.0)

# ╔═╡ d639237e-cf04-11f1-87c2-5780f81ceab1
md"""
Un **rango** es una sucesión de números igualmente espaciados, y el **punto**
aplica una función a cada elemento (*broadcasting*):
"""

# ╔═╡ d6392388-cf04-11f1-b8aa-e7a3d0c76efa
inversiones = 0:0.5:3

# ╔═╡ d6392392-cf04-11f1-80db-f38d09840aa3
producto_marginal.(2.0, inversiones)

# ╔═╡ d639239e-cf04-11f1-ad0e-4d90f50af017
md"""
Sin el punto, `producto_marginal(2.0, inversiones)` da error, porque dentro
de la función se calcula `1 + inversiones`, y sumar un número a un rango no
está definido: hay que escribir `1 .+ inversiones`. El punto en la llamada
aplica la función a cada elemento y evita el problema. Una **comprensión** construye un vector con una
regla, y puede filtrar:
"""

# ╔═╡ d63923a6-cf04-11f1-8100-57ac13ab4972
[producto_marginal(2.0, x) for x in inversiones if x >= 1]

# ╔═╡ d63923a6-cf04-11f1-9e1e-ebc32900c58b
md"""
Una **matriz** se escribe por filas, separadas con `;`. El operador `\`
resuelve el sistema lineal ``Ax = b``, el mismo que en la sesión 3 se
resolvía con la regla de Cramer:
"""

# ╔═╡ d63923b0-cf04-11f1-916d-77048d6a2a0d
A = [2 1; 1 3]

# ╔═╡ d63923ba-cf04-11f1-a017-7b2c88e5ae3e
A \ [5, 5]

# ╔═╡ d63923ba-cf04-11f1-bbb1-3bb35e8f5e64
md"""
Una **tupla con nombres** agrupa los parámetros de un modelo. Las letras con
subíndice se escriben como en LaTeX: `a\_1` y Tab da `a₁`.
"""

# ╔═╡ d63923c4-cf04-11f1-820f-cfadf2678c80
parametros = (a₁ = 2.0, a₂ = 1.0, B = 4.0)

# ╔═╡ d63923cc-cf04-11f1-93da-179127c74a9f
parametros.a₁ / parametros.a₂ - 1

# ╔═╡ d63923d8-cf04-11f1-a972-3791932fb80d
md"""
### Tu turno

**1.** Escribe `producto_total(x1, x2, a1, a2)`, el producto de las dos
regiones: ``a_1\ln(1 + x_1) + a_2\ln(1 + x_2)``. En Julia, el logaritmo
natural es `log`.
"""

# ╔═╡ d63923ec-cf04-11f1-b27d-c1c8276e1341
producto_total(x1, x2, a1, a2) = missing  # reemplaza missing

# ╔═╡ d63923f6-cf04-11f1-bfd9-53550a44a0a7
md"""
**2.** Con ``a_1 = 2``, ``a_2 = 1`` y ``B = 4``, la región 1 recibe
``x_1 = 0, 1, 2, 3, 4`` y la región 2 recibe el resto, ``4 - x_1``. Calcula
el producto total de los cinco repartos **en una sola línea**, con
broadcasting o con una comprensión, y guárdalo en `productos`. ¿Cuál es el
mejor de los cinco?
"""

# ╔═╡ d63923fe-cf04-11f1-b88c-991778f475f3
productos = missing  # reemplaza missing

# ╔═╡ d6392414-cf04-11f1-b32c-519ec28a4b4f
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

# ╔═╡ d639241e-cf04-11f1-befa-1b02e6dd7688
md"El primer peso invertido en la región 1 rinde $(producto_marginal(a1, 0)); en la región 2, $(producto_marginal(a2, 0))."

# ╔═╡ d639241e-cf04-11f1-b63c-e9e4f2fd64a9
md"""
La celda anterior es Markdown con valores interpolados con `$( … )`. Así se
escriben los textos que cambian con los deslizadores.
"""

# ╔═╡ d6392428-cf04-11f1-9309-6367d9072191
md"""
## 3. Gráficas con Plots.jl

`plot` crea una gráfica y `plot!` agrega otra curva a la misma. Las opciones
van después de `;`. Ésta compara los productos marginales de las dos
regiones, con los deslizadores de la sección 2:
"""

# ╔═╡ d639243c-cf04-11f1-9bee-bf5c633ca623
md"""
**Tu turno** (sin verificador). En la celda anterior:
- agrega una línea horizontal en ``\lambda = 0.5`` con
  `hline!([0.5]; label = "λ", color = GRIS, ls = :dash)`;
- con ``a_1 = 2`` y ``a_2 = 1``, lee en la gráfica cuánto recibe cada región
  si el último peso debe rendir ``\lambda = 0.5`` en las dos. ¿Cuánto suman?
  (Compara con la sesión 2: con ``B = 4``, el reparto es ``(3, 1)``.)
"""

# ╔═╡ d6392446-cf04-11f1-9d2c-919fbeaa5528
md"""
## 4. Punto flotante

La computadora guarda los números con unos 16 dígitos, y casi ningún decimal
es exacto (N.B4):
"""

# ╔═╡ d6392446-cf04-11f1-aaef-5ff5260bc863
0.1 + 0.2 == 0.3

# ╔═╡ d6392450-cf04-11f1-baca-372a7076a5cb
0.1 + 0.2 ≈ 0.3

# ╔═╡ d639245a-cf04-11f1-a9e0-7918ff296670
md"""
`≈` (se escribe `\approx` y Tab) compara con una tolerancia. **Nunca**
compares números reales con `==`. Los verificadores de este cuaderno
comparan con tolerancia por esa razón.
"""

# ╔═╡ d6392464-cf04-11f1-87c0-f30fb85b37c3
md"""
## 5. Symbolics.jl: las condiciones de primer orden

Symbolics.jl hace con letras lo que se hace a mano: derivar, despejar y
sustituir (N.I2). Primero se declaran las variables simbólicas. Las
productividades se llaman ``\alpha_i`` y el fondo ``b`` para no chocar con
los deslizadores `a1`, `a2` y `B` (regla 1 de Pluto).
"""

# ╔═╡ d6392464-cf04-11f1-bd8d-4fb68db6756c
@variables x₁ x₂ λ μ α₁ α₂ b

# ╔═╡ d639246e-cf04-11f1-a959-1d0d0e3b0f46
lagrangiano = α₁ * log(1 + x₁) + α₂ * log(1 + x₂) + λ * (b - x₁ - x₂)

# ╔═╡ d6392478-cf04-11f1-a7c8-455946b8f29c
md"""
Las condiciones de primer orden son el gradiente del lagrangiano respecto de
``(x_1, x_2, \lambda)``, y la hessiana respecto de ``(x_1, x_2)`` da la
condición de segundo orden:
"""

# ╔═╡ d6392482-cf04-11f1-9375-7768b095f598
cpo = Symbolics.gradient(lagrangiano, [x₁, x₂, λ])

# ╔═╡ d639248c-cf04-11f1-a8a9-8f7a90f4c4f6
Symbolics.hessian(lagrangiano, [x₁, x₂])

# ╔═╡ d6392496-cf04-11f1-bc6c-4511964bd0ad
md"""
La hessiana es diagonal con entradas negativas: el producto es estrictamente
cóncavo, como en la sesión 2.

**Despejar.** `symbolic_solve(ecuacion, variable)` despeja una ecuación. El
signo `~` escribe una ecuación simbólica. Las dos primeras condiciones dan
cada inversión en función de ``\lambda``:
"""

# ╔═╡ d6392496-cf04-11f1-bd58-f10f839f8860
despejes = (symbolic_solve(cpo[1] ~ 0, x₁)[1], symbolic_solve(cpo[2] ~ 0, x₂)[1])

# ╔═╡ d63924a2-cf04-11f1-85d4-01f96a4e0670
md"""
Al sustituirlas en la tercera condición, el presupuesto, queda una ecuación
sólo en ``\lambda``:
"""

# ╔═╡ d63924aa-cf04-11f1-8bc2-0115b260dedc
presupuesto = substitute(cpo[3], Dict(x₁ => despejes[1], x₂ => despejes[2]))

# ╔═╡ d63924b4-cf04-11f1-8dfd-7d702b2827e3
md"""
`symbolic_solve` no despeja ``\lambda`` de esta ecuación, porque ``\lambda``
aparece en el denominador. Un cambio de variable lo arregla: con
``\mu = 1/\lambda`` la ecuación es **lineal** en ``\mu``, y
`symbolic_linear_solve` la resuelve. Es un truco que se hace igual a mano:
"""

# ╔═╡ d63924b4-cf04-11f1-80e3-a70ad09a9618
λ_interior = simplify(1 / symbolic_linear_solve(substitute(presupuesto, Dict(λ => 1 / μ)) ~ 0, μ))

# ╔═╡ d63924be-cf04-11f1-aeae-1d4ca5da7c01
x_interior = [simplify(substitute(d, Dict(λ => λ_interior))) for d in despejes]

# ╔═╡ d63924c8-cf04-11f1-964c-433101df1bb2
md"""
Es la solución interior de la sesión 2:
``\lambda = (a_1 + a_2)/(B + 2)`` y ``x_i = a_i(B + 2)/(a_1 + a_2) - 1``.
Sustituida en el producto, da la función de valor del régimen interior, y
su derivada respecto del fondo es… el multiplicador. Es el teorema de la
envolvente de la sesión 3, comprobado por la computadora:
"""

# ╔═╡ d63924d4-cf04-11f1-98d0-212461aa1d16
V_interior = substitute(α₁ * log(1 + x₁) + α₂ * log(1 + x₂),
                        Dict(x₁ => x_interior[1], x₂ => x_interior[2]))

# ╔═╡ d63924d4-cf04-11f1-8565-23d7f28baae0
simplify(Symbolics.derivative(V_interior, b))

# ╔═╡ d63924dc-cf04-11f1-afa5-cb1d5b0d5000
md"""
**De la fórmula al número.** `substitute` evalúa una expresión en valores
concretos, y `build_function` la convierte en una función de Julia, mucho
más rápida para graficar:
"""

# ╔═╡ d63924e6-cf04-11f1-9dad-8339b82bfe88
substitute(λ_interior, Dict(α₁ => 2, α₂ => 1, b => 4))

# ╔═╡ d63924e6-cf04-11f1-b65c-b35eb04a3977
λ_numerica = build_function(λ_interior, α₁, α₂, b; expression = Val(false))

# ╔═╡ d63924f0-cf04-11f1-b02c-4d3258734002
λ_numerica(2.0, 1.0, 4.0)

# ╔═╡ d63924fa-cf04-11f1-85a6-99dde8ecd079
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

# ╔═╡ d63924fa-cf04-11f1-92f2-c52a6ecc88d9
function reparto(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ d639250e-cf04-11f1-bf4c-09e9f664d3db
md"""
**4.** Escribe `valor(a1, a2, B)`, el producto total con el reparto óptimo.
Usa `reparto` y `producto_total`.
"""

# ╔═╡ d6392518-cf04-11f1-b12e-616345d74f79
function valor(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ d639252c-cf04-11f1-8b7c-8d434cef01de
md"""
### Las gráficas

Con los ejercicios 3 y 4 resueltos, la celda siguiente grafica ``V(B)`` y
``\lambda(B)`` con **tus** funciones. Lee el código: usa comprensiones, el
operador `&&` para dibujar el umbral sólo si cae en la gráfica, y `layout`
para poner dos gráficas lado a lado.

Fondo ``B``: $(@bind B Slider(0.1:0.1:10.0, default = 4.0, show_value = true))
"""

# ╔═╡ d6392534-cf04-11f1-9f3d-7bcfc4c75739
md"""
La línea punteada es el umbral ``\bar B``; la naranja, el ``B`` del
deslizador. ``V`` es creciente y cóncava, y ``\lambda`` es decreciente y
continua, también en el umbral.

**5.** La pendiente de ``V`` debe ser ``\lambda``. Para comprobarlo hace falta
una derivada numérica. Escribe `derivada_centrada(g, x; h = 1e-5)`, que
aproxime ``g'(x)`` con ``\big(g(x + h) - g(x - h)\big)/2h``.
"""

# ╔═╡ d6392540-cf04-11f1-a495-fd505c811dbf
function derivada_centrada(g, x; h = 1e-5)
    missing  # reemplaza esta línea
end

# ╔═╡ d639255e-cf04-11f1-9756-bb3a49f0c8a3
md"""
## 7. [Avanzado] ¿Qué tan pequeño debe ser ``h``?

Una diferencia finita tiene dos errores (N.A4). El de **truncamiento** baja
con ``h``: es del orden de ``h`` en la diferencia hacia adelante,
``\big(g(x + h) - g(x)\big)/h``, y de ``h^2`` en la centrada. El de
**redondeo** sube cuando ``h`` baja, porque se restan dos números casi
iguales (sección 4). La gráfica muestra el error al estimar ``V'(B) = \lambda``
con cada fórmula, en escala logarítmica.
"""

# ╔═╡ d6392566-cf04-11f1-8c82-c18c3b0e770b
md"""
El mejor ``h`` está cerca de ``10^{-8}`` para la diferencia hacia adelante y
de ``10^{-5}`` para la centrada; por eso el ejercicio 5 usa ``h = 10^{-5}``.
Con ``h`` más pequeño, el error **crece**.
"""

# ╔═╡ d6392572-cf04-11f1-8bd2-db9ef481ae97
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

# ╔═╡ d639257c-cf04-11f1-b75a-43c44a0a7c52
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir el laboratorio.
"""

# ╔═╡ d6392590-cf04-11f1-b78a-43afae4085fa
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # segunda serie, valor elegido
    const GRIS    = "#52514e"   # referencias
end;

# ╔═╡ d6392432-cf04-11f1-9ecc-3ff3a05fc9ff
let
    x = range(0, 6, length = 200)
    plot(x, producto_marginal.(a1, x); label = "región 1", lw = 2, color = AZUL,
         xlabel = "inversión x", ylabel = "producto marginal", legend = :topright)
    plot!(x, producto_marginal.(a2, x); label = "región 2", lw = 2, color = NARANJA)
end

# ╔═╡ d639259a-cf04-11f1-922d-2d59c5b61e7c
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto_ref(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

# ╔═╡ d639259a-cf04-11f1-9636-abec761919d5
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

# ╔═╡ d63925a4-cf04-11f1-8cf6-77a2f3e7fcf7
"Valor óptimo V(a₁, a₂, B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto_ref(x1, x2, a1, a2)
end

# ╔═╡ d6392566-cf04-11f1-ad2d-0df9e917ffe4
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

# ╔═╡ d63925ae-cf04-11f1-9635-5b9e9d497e9a
begin
    # Casos de prueba: (x₁, x₂, a₁, a₂) para el producto; (a₁, a₂, B) con
    # esquina, umbral e interior para el reparto.
    const CASOS_PRODUCTO = [(0.0, 0.0, 2.0, 1.0), (3.0, 1.0, 2.0, 1.0), (0.5, 2.5, 1.5, 0.7)]
    const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]
end;

# ╔═╡ d63925b8-cf04-11f1-87aa-9f2b45ad10d8
"¿La función ya está escrita? Verdadero si corre sin error y no devuelve missing."
function completo(f)
    r = try
        f()
    catch
        return false
    end
    !(r === missing || (r isa AbstractArray && any(ismissing, r)))
end

# ╔═╡ d6392534-cf04-11f1-a844-110445820092
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

# ╔═╡ d6392554-cf04-11f1-ade8-2bcb94fb2ccc
if completo(() -> derivada_centrada(exp, 1.0)) && completo(() -> valor(2.0, 1.0, 4.0))
    md"""
    Con ``B`` = $(B): la derivada numérica de ``V`` es
    $(round(derivada_centrada(v -> valor(a1, a2, v), B), digits = 6)) y el
    multiplicador vale $(round(reparto(a1, a2, B)[3], digits = 6)).
    """
else
    md"Completa los ejercicios 4 y 5 para comparar ``V'(B)`` con ``\lambda``."
end

# ╔═╡ d63925b8-cf04-11f1-ac8c-4537dade072f
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

# ╔═╡ d63923ec-cf04-11f1-bfa6-5980fa6a745a
verificar(() -> [producto_total(c...) for c in CASOS_PRODUCTO],
          [producto_ref(c...) for c in CASOS_PRODUCTO];
          pista = md"`producto_total(x1, x2, a1, a2) = a1 * log(1 + x1) + a2 * log(1 + x2)`")

# ╔═╡ d639240a-cf04-11f1-ba9d-cd458e8d380e
verificar(() -> productos, producto_ref.(0:4, 4 .- (0:4), 2.0, 1.0);
          pista = md"Con broadcasting: `producto_total.(0:4, 4 .- (0:4), 2.0, 1.0)`. Con una comprensión: `[producto_total(x, 4 - x, 2.0, 1.0) for x in 0:4]`.")

# ╔═╡ d6392502-cf04-11f1-9333-8b965938e690
verificar(() -> [reparto(c...) for c in CASOS],
          [collect(reparto_ref(c...)) for c in CASOS];
          pista = md"Calcula `B̄ = a1 / a2 - 1`. Si `B <= B̄`, devuelve `[B, 0.0, a1 / (1 + B)]`. Si no, `λ = λ_numerica(a1, a2, B)` y devuelve `[a1 / λ - 1, a2 / λ - 1, λ]`.")

# ╔═╡ d6392522-cf04-11f1-a98f-cf3fb4962374
verificar(() -> [valor(c...) for c in CASOS], [valor_ref(c...) for c in CASOS];
          pista = md"`x1, x2, _ = reparto(a1, a2, B)` y después `producto_total(x1, x2, a1, a2)`.")

# ╔═╡ d639254a-cf04-11f1-a08b-ab08aaec3dfb
verificar(() -> [derivada_centrada(exp, 1.0), derivada_centrada(sin, 0.0), derivada_centrada(x -> x^3, 2.0)],
          [exp(1.0), 1.0, 12.0];
          rtol = 1e-8,
          pista = md"`(g(x + h) - g(x - h)) / (2h)`")

# ╔═╡ Cell order:
# ╟─d63922fc-cf04-11f1-9fc0-c1a20816f875
# ╟─d6392342-cf04-11f1-9ed7-e79e911d9991
# ╟─d6392356-cf04-11f1-bad0-a1454c462c34
# ╟─d6392360-cf04-11f1-aa73-1305ac45970d
# ╟─d639236c-cf04-11f1-bf53-e36b17204d02
# ╠═d639236c-cf04-11f1-88b3-8524eb0d8428
# ╠═d6392374-cf04-11f1-834d-4918e4321208
# ╟─d639237e-cf04-11f1-87c2-5780f81ceab1
# ╠═d6392388-cf04-11f1-b8aa-e7a3d0c76efa
# ╠═d6392392-cf04-11f1-80db-f38d09840aa3
# ╟─d639239e-cf04-11f1-ad0e-4d90f50af017
# ╠═d63923a6-cf04-11f1-8100-57ac13ab4972
# ╟─d63923a6-cf04-11f1-9e1e-ebc32900c58b
# ╠═d63923b0-cf04-11f1-916d-77048d6a2a0d
# ╠═d63923ba-cf04-11f1-a017-7b2c88e5ae3e
# ╟─d63923ba-cf04-11f1-bbb1-3bb35e8f5e64
# ╠═d63923c4-cf04-11f1-820f-cfadf2678c80
# ╠═d63923cc-cf04-11f1-93da-179127c74a9f
# ╟─d63923d8-cf04-11f1-a972-3791932fb80d
# ╠═d63923ec-cf04-11f1-b27d-c1c8276e1341
# ╟─d63923ec-cf04-11f1-bfa6-5980fa6a745a
# ╟─d63923f6-cf04-11f1-bfd9-53550a44a0a7
# ╠═d63923fe-cf04-11f1-b88c-991778f475f3
# ╟─d639240a-cf04-11f1-ba9d-cd458e8d380e
# ╟─d6392414-cf04-11f1-b32c-519ec28a4b4f
# ╠═d639241e-cf04-11f1-befa-1b02e6dd7688
# ╟─d639241e-cf04-11f1-b63c-e9e4f2fd64a9
# ╟─d6392428-cf04-11f1-9309-6367d9072191
# ╠═d6392432-cf04-11f1-9ecc-3ff3a05fc9ff
# ╟─d639243c-cf04-11f1-9bee-bf5c633ca623
# ╟─d6392446-cf04-11f1-9d2c-919fbeaa5528
# ╠═d6392446-cf04-11f1-aaef-5ff5260bc863
# ╠═d6392450-cf04-11f1-baca-372a7076a5cb
# ╟─d639245a-cf04-11f1-a9e0-7918ff296670
# ╟─d6392464-cf04-11f1-87c0-f30fb85b37c3
# ╠═d6392464-cf04-11f1-bd8d-4fb68db6756c
# ╠═d639246e-cf04-11f1-a959-1d0d0e3b0f46
# ╟─d6392478-cf04-11f1-a7c8-455946b8f29c
# ╠═d6392482-cf04-11f1-9375-7768b095f598
# ╠═d639248c-cf04-11f1-a8a9-8f7a90f4c4f6
# ╟─d6392496-cf04-11f1-bc6c-4511964bd0ad
# ╠═d6392496-cf04-11f1-bd58-f10f839f8860
# ╟─d63924a2-cf04-11f1-85d4-01f96a4e0670
# ╠═d63924aa-cf04-11f1-8bc2-0115b260dedc
# ╟─d63924b4-cf04-11f1-8dfd-7d702b2827e3
# ╠═d63924b4-cf04-11f1-80e3-a70ad09a9618
# ╠═d63924be-cf04-11f1-aeae-1d4ca5da7c01
# ╟─d63924c8-cf04-11f1-964c-433101df1bb2
# ╠═d63924d4-cf04-11f1-98d0-212461aa1d16
# ╠═d63924d4-cf04-11f1-8565-23d7f28baae0
# ╟─d63924dc-cf04-11f1-afa5-cb1d5b0d5000
# ╠═d63924e6-cf04-11f1-9dad-8339b82bfe88
# ╠═d63924e6-cf04-11f1-b65c-b35eb04a3977
# ╠═d63924f0-cf04-11f1-b02c-4d3258734002
# ╟─d63924fa-cf04-11f1-85a6-99dde8ecd079
# ╠═d63924fa-cf04-11f1-92f2-c52a6ecc88d9
# ╟─d6392502-cf04-11f1-9333-8b965938e690
# ╟─d639250e-cf04-11f1-bf4c-09e9f664d3db
# ╠═d6392518-cf04-11f1-b12e-616345d74f79
# ╟─d6392522-cf04-11f1-a98f-cf3fb4962374
# ╟─d639252c-cf04-11f1-8b7c-8d434cef01de
# ╠═d6392534-cf04-11f1-a844-110445820092
# ╟─d6392534-cf04-11f1-9f3d-7bcfc4c75739
# ╠═d6392540-cf04-11f1-a495-fd505c811dbf
# ╟─d639254a-cf04-11f1-a08b-ab08aaec3dfb
# ╠═d6392554-cf04-11f1-ade8-2bcb94fb2ccc
# ╟─d639255e-cf04-11f1-9756-bb3a49f0c8a3
# ╠═d6392566-cf04-11f1-ad2d-0df9e917ffe4
# ╟─d6392566-cf04-11f1-8c82-c18c3b0e770b
# ╟─d6392572-cf04-11f1-8bd2-db9ef481ae97
# ╟─d639257c-cf04-11f1-b75a-43c44a0a7c52
# ╠═d6392586-cf04-11f1-b8a2-df9d5df985af
# ╠═d6392590-cf04-11f1-b78a-43afae4085fa
# ╠═d639259a-cf04-11f1-922d-2d59c5b61e7c
# ╠═d639259a-cf04-11f1-9636-abec761919d5
# ╠═d63925a4-cf04-11f1-8cf6-77a2f3e7fcf7
# ╠═d63925ae-cf04-11f1-9635-5b9e9d497e9a
# ╠═d63925b8-cf04-11f1-87aa-9f2b45ad10d8
# ╠═d63925b8-cf04-11f1-ac8c-4537dade072f
