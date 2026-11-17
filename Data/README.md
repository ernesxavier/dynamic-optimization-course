# Datos del curso

Los dos archivos se generan con `Code/descargar_datos.jl` (ver el README
principal). No son obra de este curso: conservan la licencia de su fuente, y
quien los use debe citarla.

## `entidades.csv`

Las 32 entidades federativas de México, 2003–2023. Se usa en las sesiones 5
y 14.

| Columna | Descripción | Fuente |
|---|---|---|
| `clave` | Clave de entidad del INEGI (1 = Aguascalientes, …, 32 = Zacatecas) | INEGI |
| `entidad` | Nombre de la entidad | INEGI |
| `año` | Año | |
| `pib` | PIB por entidad federativa, millones de pesos a precios de 2018 | INEGI, PIBE |
| `pib_petrolero` | Valor agregado de la minería petrolera (21-1), millones de pesos de 2018 | INEGI, PIBE |
| `poblacion` | Población total, personas | OCDE |
| `empleo` | Personas ocupadas de 15 a 64 años (vacío antes de 2005) | OCDE |

**Fuentes y licencias:**

- INEGI, *Producto Interno Bruto por Entidad Federativa* (PIBE), año base
  2018, datos abiertos:
  <https://www.inegi.org.mx/programas/pibent/2018/>. Se usa conforme a los
  [Términos de Libre Uso de la Información del INEGI](https://www.inegi.org.mx/inegi/terminos.html),
  que piden citar al INEGI como fuente.
- OCDE, *Regional Database* (regiones TL2), conjuntos `DSD_REG_DEMO@DF_POP_BROAD`
  (población) y `DSD_REG_LAB@DF_LEVELS` (empleo), en <https://data-explorer.oecd.org/>.
  Licencia [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), según los
  [términos de la OCDE](https://www.oecd.org/en/about/terms-conditions.html).

## `pwt_mexico.csv`

Serie de México de la Penn World Table 11.0, 1950–2023. Se usa en la
sesión 12.

| Columna | Descripción |
|---|---|
| `año` | Año |
| `rgdpna` | PIB real a precios nacionales constantes de 2021, millones de dólares |
| `rnna` | Acervo de capital a precios nacionales constantes de 2021, millones de dólares |
| `emp` | Personas ocupadas, millones |
| `pop` | Población, millones |
| `hc` | Índice de capital humano |
| `labsh` | Participación del trabajo en el ingreso |
| `delta` | Tasa de depreciación del capital |
| `csh_i` | Participación de la inversión en el PIB |
| `rtfpna` | Productividad total de los factores a precios nacionales constantes (2021 = 1) |

**Fuente y licencia:** Feenstra, R. C., Inklaar, R. y Timmer, M. P. (2015).
The Next Generation of the Penn World Table. *American Economic Review*,
105(10), 3150–3182. Datos: Penn World Table 11.0,
<https://doi.org/10.34894/FABVLR>, licencia
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
