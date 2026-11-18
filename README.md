# Optimización Dinámica

Material del curso de Optimización Dinámica (Doctorado en Economía Regional,
CISE, UAdeC), con cuadernos en Julia.

**Autor:** Ernesto X. Vera Gómez, Universidad Autónoma de Coahuila.

## Estructura

```
├── programa/
│   └── programa.md            → Programa del curso (24 sesiones)
├── Class_notes/
│   ├── sNN_tema.md            → Notas por sesión, con su plan de clase (ver tabla abajo)
│   ├── tareaN_tema.md         → Enunciado de la tarea de la unidad N (ejercicios; la 1 tiene además código)
│   └── repaso/                → Repaso de matemáticas por niveles (índice por sesión)
│       ├── diagnostico_inicial.md → Diagnóstico de matemáticas de la sesión 1
│       └── figuras/           → Figuras de las notas (generadas con Code/figuras_repaso.jl)
├── Data/                      → Datos de los casos aplicados, en CSV
│   ├── README.md              → Fuentes, columnas y licencias de los datos
│   ├── entidades.csv          → PIB (INEGI), población y empleo (OCDE) de las 32 entidades, 2003–2023
│   └── pwt_mexico.csv         → Penn World Table 11.0, México, 1950–2023
├── Code/                      → Todo el código Julia, un solo entorno
│   ├── sNN_tema.jl            → Cuadernos de Pluto (ver tabla abajo)
│   ├── tareaN_tema.jl         → Parte de código de la Tarea 1, con comprobaciones
│   ├── figuras_repaso.jl      → Regenera las figuras de Class_notes/repaso/figuras/
│   ├── descargar_datos.jl     → Regenera los CSV de Data/ (INEGI, OCDE y Penn World Table)
│   ├── Project.toml
│   └── Manifest.toml
├── src/                       → Fuentes de los cuadernos de Pluto (formato #%%)
│   ├── construir_cuaderno.jl  → Genera y ejecuta un cuaderno a partir de su fuente
│   ├── revisar_material.jl    → Revisa claves del repaso, enlaces y números de sesión
│   ├── revisar_formulas.jl    → Revisa que GitHub muestre bien las fórmulas de los .md
│   └── sNN_tema.jl            → Fuente de Code/sNN_tema.jl
├── CITATION.cff               → Cómo citar el curso (botón "Cite this repository" de GitHub)
├── LICENSE                    → Licencia MIT (código)
├── LICENSE-CC-BY-4.0          → Licencia CC BY 4.0 (notas, programa y demás material)
└── README.md
```

## Notas y cuadernos previstos

| Ses. | Tema | Notas (`Class_notes/`) | Cuaderno (`Code/`) |
|---|---|---|---|
| 1 | Por qué optimizar en el tiempo | `s01_optimizar_en_el_tiempo.md` | `s01_optimizar_en_el_tiempo.jl` |
| 2 | Lagrange y Kuhn-Tucker | `s02_lagrange_kuhn_tucker.md` | `s02_lagrange_kuhn_tucker.jl` |
| 3 | Envolvente y estática comparativa | `s03_envolvente.md` | `s03_envolvente.jl` |
| 4 | Laboratorio 0: Julia, Pluto.jl, Symbolics.jl | | `s04_laboratorio_0.jl` |
| 5 | Ecuaciones lineales | `s05_ecuaciones_lineales.md` | `s05_ecuaciones_lineales.jl` |
| 6 | Equilibrio y diagramas de fase | `s06_diagramas_de_fase.md` | `s06_diagramas_de_fase.jl` |
| 7 | Sistemas lineales y linealización | `s07_sistemas_lineales.md` | `s07_sistemas_lineales.jl` |
| 8 | Estabilidad no lineal | `s08_estabilidad_no_lineal.md` | `s08_estabilidad_no_lineal.jl` |
| 9 | Laboratorio 1: diagramas de fase | | `s09_laboratorio_1.jl` |
| 10 | Cálculo de variaciones | `s10_calculo_de_variaciones.md` | `s10_calculo_de_variaciones.jl` |
| 11 | Principio del máximo | `s11_principio_del_maximo.md` | `s11_principio_del_maximo.jl` |
| 12 | Horizonte infinito y Ramsey | `s12_horizonte_infinito.md` | `s12_ramsey.jl` |
| 13 | Varias variables, bang-bang | `s13_varias_variables.md` | `s13_varias_variables.jl` |
| 14 | Caso: inversión entre dos regiones | `s14_dos_regiones.md` | `s14_dos_regiones.jl` |
| 15 | Bellman en horizonte finito | `s15_bellman.md` | `s15_bellman.jl` |
| 16 | Bellman en horizonte infinito | `s16_bellman_infinito.md` | `s16_bellman_infinito.jl` |
| 17 | Laboratorio 2: iteración de función valor | | `s17_laboratorio_2.jl` |
| 18 | Control óptimo frente a programación dinámica | `s18_control_vs_pd.md` | |
| 19 | Laboratorio 3: comparación numérica | | `s19_laboratorio_3.jl` |
| 20–24 | Proyecto: avances, taller y presentaciones | `s20_proyecto.md` | |

| Tarea | Unidad | Se entrega | Enunciado (`Class_notes/`) | Cuaderno (`Code/`) |
|---|---|---|---|---|
| 1 | I: optimización estática | Sesión 5 | `tarea1_optimizacion_estatica.md` | `tarea1_optimizacion_estatica.jl` |
| 2 | II: sistemas dinámicos | Sesión 10 | `tarea2_sistemas_dinamicos.md` | |
| 3 | III: control óptimo | Sesión 15 | `tarea3_control_optimo.md` | |
| 4 | IV: programación dinámica | Sesión 21 | `tarea4_programacion_dinamica.md` | |

## Requisitos

- Julia 1.13 (cuadernos de Pluto probados con Pluto 1.0.4)

## Entorno de Julia

Todo el repositorio usa **un solo entorno**: `Code/Project.toml` +
`Code/Manifest.toml`. Incluye Pluto, así que no hace falta instalar nada en el
entorno global. Los cuadernos de Pluto activan este entorno en su primera
celda de paquetes (`Pkg.activate(@__DIR__)`).

## Uso

Desde la raíz del repositorio, la primera vez:

```
julia --project=Code -e 'using Pkg; Pkg.instantiate()'
```

**Cuadernos de Pluto:**

```
julia --project=Code -e 'using Pluto; Pluto.run()'
```

y en el navegador abrir el cuaderno de la sesión, por ejemplo
`Code/s02_lagrange_kuhn_tucker.jl`.

**Construir un cuaderno desde su fuente.** Cada cuaderno de Pluto tiene una
fuente en `src/` con marcadores `#%%` (celda visible) y `#%% hide` (código
oculto), más fácil de editar como texto. Este comando genera el cuaderno, lo
ejecuta sin interfaz, reporta las celdas con error y guarda las gráficas en
la carpeta de salidas para revisarlas:

```
julia --project=Code src/construir_cuaderno.jl src/s02_lagrange_kuhn_tucker.jl Code/s02_lagrange_kuhn_tucker.jl /tmp/salidas
```

La fuente y el cuaderno deben coincidir. Los cambios grandes se hacen en la
fuente y se regenera el cuaderno; si se edita el cuaderno en Pluto, hay que
pasar el cambio a la fuente antes de volver a generarlo.

**Regenerar las figuras del repaso:**

```
julia --project=Code Code/figuras_repaso.jl
```

**Volver a descargar los datos** (INEGI, OCDE y Penn World Table; tarda uno o
dos minutos):

```
julia --project=Code Code/descargar_datos.jl
```

**Revisar el material** antes de cada commit: la consistencia (claves del
repaso, enlaces y números de sesión) y las fórmulas tal como las muestra
GitHub. La segunda revisión usa `gh` con sesión iniciada y tarda unos
20 segundos; también acepta archivos sueltos.

```
julia src/revisar_material.jl
julia src/revisar_formulas.jl
julia src/revisar_formulas.jl Class_notes/s08_estabilidad_no_lineal.md
```

**Actualizar paquetes** (por ejemplo, al cambiar de versión de Julia):

```
julia -e 'using Pkg; Pkg.activate("Code"); Pkg.update()'
```

## Licencia

© 2026 Ernesto X. Vera Gómez, Universidad Autónoma de Coahuila.

- **Código**: los archivos `.jl` de `Code/` y `src/`, incluidos los cuadernos
  de Pluto, tienen licencia [MIT](LICENSE).
- **Material del curso**: las notas (`Class_notes/`), el programa
  (`programa/`), las figuras y el resto del texto tienen licencia
  [Creative Commons Atribución 4.0 Internacional (CC BY 4.0)](LICENSE-CC-BY-4.0).
  Se pueden copiar, adaptar y redistribuir con cualquier fin, siempre que se
  cite al autor y se indique si hubo cambios.
- **Datos**: los archivos de `Data/` conservan la licencia de su fuente
  (INEGI, OCDE y Penn World Table); ver [`Data/README.md`](Data/README.md).
