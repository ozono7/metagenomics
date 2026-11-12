# ==========================================================================
# Lección 01. Qué es un metagenoma y cómo se ve un ensamblaje
# ==========================================================================
# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Serie "Metagenómica" — Lección 01
#
# Descripción: primera lección del curso de metagenómica. Un metagenoma es
#   el conjunto de los genomas de todos los organismos que viven juntos en
#   una muestra: en el océano, en el suelo o en un cultivo, donde además
#   del organismo de interés viven bacterias acompañantes. Aquí no se
#   secuencia un solo organismo, se secuencia la comunidad completa, y el
#   primer paso es ensamblar esas lecturas en contigs. En esta lección se
#   aprende qué es un ensamblaje, qué significan N50 y L50, y cómo se
#   comparan nueve ensambladores sobre el mismo metagenoma público, con
#   gráficos hechos a partir de los datos.
#
# Objetivos de aprendizaje:
#   - Explicar qué es un metagenoma y qué es un contig.
#   - Leer una tabla de MetaQUAST (contigs por umbral de longitud).
#   - Calcular qué fracción de contigs queda al subir el umbral de longitud.
#   - Explicar qué significan N50 y L50, y por qué un N50 mayor indica
#     un ensamblaje menos fragmentado.
#   - Comparar ensambladores con gráficos y explicar por qué una sola
#     métrica no decide cuál es el mejor.
#
# Datos: datos_ensamblaje.csv y datos_metricas_ensamblaje.csv, en esta
#   misma carpeta. Son los resultados publicados por van der Walt y
#   colaboradores (2017) para el metagenoma Tara Oceans, evaluados con
#   MetaQUAST: nueve ensambladores sobre las mismas lecturas públicas.
#   Van der Walt AJ, van Goethem MW, Ramond JB, Makhalanyane TP, Reva O,
#   Cowan DA (2017). Assembling metagenomes, one community at a time.
#   BMC Genomics 18:521. doi:10.1186/s12864-017-3918-9. PMC5502489.
#   Tabla 1 del artículo.
#
#   El metagenoma es una muestra de Tara Oceans (océano, fracción
#   enriquecida en procariotas): 5.4 Gbp, más de 27 millones de pares de
#   lecturas, longitud media del par de 200.3 pb, Illumina HiSeq.
#   Proyecto Tara Oceans: ENA PRJEB1787 (también ERP001736),
#   MGnify MGYS00000410 (246 muestras, 4.29 TB).
#   Las lecturas del artículo están en el SRA con las accesiones
#   SRR351474, SRR958082, ERR598950, ERR526087, SRR341725 y ERR732914;
#   la correspondencia entre cada muestra y su accesión está en la
#   Tabla S1 del material suplementario del artículo.
#
#   Para descargar una muestra con SRA Toolkit (basta una muestra para
#   practicar; el proyecto completo es de 4.29 TB):
#     fasterq-dump --split-files ERR598950
#   La lista de archivos crudos de 93 muestras de Tara Oceans está en:
#     http://merenlab.org/data/tara-oceans-mags/files/ftp-links-for-raw-data-files.txt
#
#   Los nueve ensambladores evaluados en el artículo (con su versión):
#   Velvet 1.2.10, MetaVelvet 1.2.02, SPAdes 3.9.0, metaSPAdes 3.9.0,
#   Ray Meta 2.3.1, IDBA-UD 1.1.1, MEGAHIT 1.0.6, Omega 1.4 y CLC
#   Genomics Workbench 8.5.1. Los comandos para reproducir la tabla son:
#     megahit -1 lectura_1.fastq -2 lectura_2.fastq -o salida_megahit
#     metaquast.py contigs.fasta -o salida_metaquast
#   La muestra completa tiene 5.4 Gbp: para practicar conviene empezar
#   con MEGAHIT, que es el ensamblador que menos memoria pide de los
#   que dan un ensamblaje grande (10.58 GB y 2.90 horas en el artículo).
# ==========================================================================

# --------------------------------------------------------------------------
# 1. Cargar paquetes
# --------------------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(readr)
library(scales)

Sys.setlocale("LC_ALL", "C.UTF-8")

# Carpeta del script: los CSV y las figuras viven junto a este archivo.
args <- commandArgs(trailingOnly = FALSE)
archivo <- grep("--file=", args, value = TRUE)
if (length(archivo) > 0) {
  carpeta <- dirname(sub("--file=", "", archivo[1]))
} else {
  carpeta <- getwd()
}
setwd(carpeta)

# --------------------------------------------------------------------------
# 2. Qué es un metagenoma
# --------------------------------------------------------------------------
# Un metagenoma es todo el ADN de una comunidad. Cuando se toma una muestra
# de agua de mar, en el tubo no hay un solo organismo: hay miles de
# bacterias, arqueas y virus viviendo juntos. Al secuenciar, las lecturas
# mezclan el ADN de todos esos organismos, y no se sabe de antemano qué
# lectura pertenece a quién. Por eso el análisis se llama metagenómica:
# es genómica de una comunidad, no de un solo organismo.
#
# El ensamblaje es el paso que junta las lecturas que se solapan para
# formar piezas más largas, llamadas contigs. Un contig es una secuencia
# continua reconstruida a partir de muchas lecturas cortas. Si el
# ensamblaje sale bien, hay pocos contigs largos; si sale fragmentado,
# hay muchos contigs cortos.
#
# Para medir la calidad de un ensamblaje se usan, entre otras, dos
# medidas de MetaQUAST:
#   - N50: la longitud del contig que queda en la mitad del ensamblaje
#     cuando se ordenan los contigs de mayor a menor. Un N50 mayor
#     indica un ensamblaje menos fragmentado.
#   - L50: cuántos contigs hay que sumar, de mayor a menor, para llegar
#     a la mitad del ensamblaje. Un L50 menor indica un ensamblaje menos
#     fragmentado.
# MetaQUAST también reporta N90 (lo mismo que N50, pero en el 90 por
# ciento del ensamblaje) y auN (el promedio de la longitud de los
# contigs, pesado por su longitud), que se revisan en la lección 04.
# Además del N50 y del L50, en esta lección se miran el tamaño total del
# ensamblaje en megabases (Mb), el contig más largo, el porcentaje de
# lecturas que se mapean de vuelta al ensamblaje, el tiempo que tardó
# cada ensamblador y la memoria que usó: un solo número nunca decide
# cuál ensamblador conviene.

# --------------------------------------------------------------------------
# 3. Leer los datos
# --------------------------------------------------------------------------
# datos_ensamblaje.csv tiene, para cada ensamblador, cuántos contigs
# quedan al exigir una longitud mínima. El umbral 500 cuenta los contigs
# de 500 pares de bases o más; el umbral 50000 solo cuenta los contigs
# de 50000 pares de bases o más.
ens <- read_csv("datos_ensamblaje.csv", show_col_types = FALSE)
print(ens)

# datos_metricas_ensamblaje.csv tiene las métricas de MetaQUAST de cada
# ensamblador sobre el mismo metagenoma Tara Oceans: N50, L50, contig
# más largo, tamaño total en megabases (Mb), porcentaje de lecturas
# mapeadas, tiempo en horas y memoria en GB.
met <- read_csv("datos_metricas_ensamblaje.csv", show_col_types = FALSE)
print(met)

# --------------------------------------------------------------------------
# 4. Calcular valores a partir de los datos
# --------------------------------------------------------------------------
# Qué fracción de contigs queda al exigir 1000 pares de bases o más, y
# qué fracción al exigir 50000 o más, en porcentaje del total de contigs
# de cada ensamblador (umbral 500).
totales <- ens %>%
  filter(threshold_bp == 500) %>%
  select(ensamblador, contigs_totales = contigs)

retencion <- ens %>%
  filter(threshold_bp %in% c(1000, 50000)) %>%
  left_join(totales, by = "ensamblador") %>%
  mutate(porcentaje = round(100 * contigs / contigs_totales, 2)) %>%
  arrange(threshold_bp, desc(porcentaje))

print(retencion)

# El N50, el tamaño total en Mb y el porcentaje de lecturas mapeadas de
# cada ensamblador, ordenados de mayor a menor N50.
resumen <- met %>%
  filter(metrica %in% c("n50_bp", "span_Mb", "mapeo_pct")) %>%
  tidyr::pivot_wider(names_from = metrica, values_from = valor) %>%
  arrange(desc(n50_bp))

print(resumen)

# Cuántas veces es mayor el N50 de SPAdes que el de MEGAHIT, y cuántas
# veces es más largo su contig mayor.
n50_spades <- met %>% filter(ensamblador == "SPAdes", metrica == "n50_bp") %>% pull(valor)
n50_megahit <- met %>% filter(ensamblador == "MEGAHIT", metrica == "n50_bp") %>% pull(valor)
cat("N50 de SPAdes / N50 de MEGAHIT =", round(n50_spades / n50_megahit, 2), "\n")

mayor_spades <- met %>% filter(ensamblador == "SPAdes", metrica == "contig_mayor_bp") %>% pull(valor)
mayor_megahit <- met %>% filter(ensamblador == "MEGAHIT", metrica == "contig_mayor_bp") %>% pull(valor)
cat("Contig mayor de SPAdes / contig mayor de MEGAHIT =", round(mayor_spades / mayor_megahit, 2), "\n")

# Cuántas veces más tarda SPAdes que MEGAHIT y cuánta más memoria usa.
tiempo_spades <- met %>% filter(ensamblador == "SPAdes", metrica == "tiempo_h") %>% pull(valor)
tiempo_megahit <- met %>% filter(ensamblador == "MEGAHIT", metrica == "tiempo_h") %>% pull(valor)
cat("Tiempo de SPAdes / tiempo de MEGAHIT =", round(tiempo_spades / tiempo_megahit, 2), "\n")

mem_spades <- met %>% filter(ensamblador == "SPAdes", metrica == "memoria_GB") %>% pull(valor)
mem_megahit <- met %>% filter(ensamblador == "MEGAHIT", metrica == "memoria_GB") %>% pull(valor)
cat("Memoria de SPAdes / memoria de MEGAHIT =", round(mem_spades / mem_megahit, 2), "\n")

# --------------------------------------------------------------------------
# 5. Paleta y tema
# --------------------------------------------------------------------------
# Paleta Okabe-Ito (compatible con visión de color deficiente).
col_ensamblador <- c(
  "SPAdes" = "#0072B2",
  "MEGAHIT" = "#D55E00",
  "metaSPAdes" = "#009E73",
  "IDBA-UD" = "#CC79A7"
)

# Tema común: sin título dentro de la imagen, leyenda abajo, títulos de
# ejes en negrita.
tema_fig <- theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(size = 11),
    panel.grid.minor = element_blank()
  )

# --------------------------------------------------------------------------
# 6. Figura 1 — Contigs por umbral de longitud
# --------------------------------------------------------------------------
# Los cuatro ensambladores con el ensamblaje más grande (SPAdes, MEGAHIT,
# metaSPAdes e IDBA-UD). El eje horizontal es el umbral de longitud
# mínima en pares de bases (bp). El eje vertical es el número de contigs
# que alcanzan ese umbral. El eje vertical usa escala logarítmica (log10)
# porque el número de contigs cae de cientos de miles a unos pocos: en
# escala lineal solo se vería el primer punto y el resto quedaría pegado
# al cero.
ens_fig1 <- ens %>%
  filter(ensamblador %in% c("SPAdes", "MEGAHIT", "metaSPAdes", "IDBA-UD"))
ens_fig1$ensamblador <- factor(ens_fig1$ensamblador,
                               levels = c("SPAdes", "MEGAHIT", "metaSPAdes", "IDBA-UD"))

p1 <- ggplot(ens_fig1, aes(x = threshold_bp, y = contigs, color = ensamblador, group = ensamblador)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  scale_y_log10(labels = label_comma()) +
  scale_color_manual(values = col_ensamblador) +
  labs(x = "Minimum contig length (bp)", y = "Number of contigs (log scale)", color = "Assembler") +
  tema_fig

ggsave("figura1_contigs_umbral.png", p1, width = 9, height = 5, dpi = 300, bg = "white")

# Interpretación
# La Figura 1 muestra cuántos contigs quedan al exigir una longitud
# mínima cada vez mayor, para los cuatro ensambladores con el ensamblaje
# más grande sobre el metagenoma Tara Oceans. El eje horizontal es el
# umbral de longitud en pares de bases (bp), una unidad de longitud; el
# eje vertical es el número de contigs, en escala logarítmica, por eso
# cada marca multiplica por 10 y no suma una cantidad fija. Las cuatro
# curvas bajan de forma parecida: al subir el umbral, la mayoría de los
# contigs se descartan porque son cortos. Con un umbral de 1000 bp quedan
# 70711 contigs en SPAdes (32.12 por ciento del total), 56243 en MEGAHIT
# (25.93 por ciento), 48640 en metaSPAdes (26.23 por ciento) y 50498 en
# IDBA-UD (30.83 por ciento). Con un umbral de 50000 bp casi no queda
# nada: 54 contigs en SPAdes (0.02 por ciento), 37 en metaSPAdes
# (0.02 por ciento), 2 en IDBA-UD y 1 en MEGAHIT. Eso significa que en
# este metagenoma la mayor parte del ensamblaje está en contigs cortos,
# y solo una fracción pequeña alcanza 50000 pares de bases o más. SPAdes
# es el que más contigs largos produce: su contig mayor mide 197381 bp,
# 3.15 veces el contig mayor de MEGAHIT (62649 bp).

# --------------------------------------------------------------------------
# 7. Figura 2 — N50 por ensamblador
# --------------------------------------------------------------------------
# Comparamos el N50 de los nueve ensambladores sobre el mismo metagenoma.
# El eje horizontal es el ensamblador, ordenado de mayor a menor N50, y
# el eje vertical es el N50 en pares de bases (bp).
n50 <- met %>% filter(metrica == "n50_bp")
n50$ensamblador <- factor(n50$ensamblador,
                          levels = c("Omega", "SPAdes", "Ray Meta", "IDBA-UD",
                                     "metaSPAdes", "MEGAHIT", "CLC", "MetaVelvet",
                                     "Velvet"))

p2 <- ggplot(n50, aes(x = ensamblador, y = valor)) +
  geom_col(fill = "#0072B2") +
  geom_text(aes(label = comma(valor)), vjust = -0.4, size = 3.5) +
  scale_y_continuous(labels = label_comma(), expand = expansion(mult = c(0, 0.12))) +
  labs(x = NULL, y = "N50 (bp)") +
  tema_fig +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("figura2_metricas_n50.png", p2, width = 9, height = 5, dpi = 300, bg = "white")

# Interpretación
# La Figura 2 compara el N50 de los nueve ensambladores sobre el mismo
# metagenoma Tara Oceans. El eje horizontal es el ensamblador, ordenado
# de mayor a menor N50, y el eje vertical es el N50 en pares de bases
# (bp). Omega tiene el N50 mayor, 2691 bp, seguido de SPAdes con 1415 bp,
# Ray Meta con 1329 bp, IDBA-UD con 1166 bp y metaSPAdes con 1124 bp;
# MEGAHIT tiene 982 bp, CLC 880 bp, MetaVelvet 805 bp y Velvet 749 bp.
# El N50 de SPAdes es 1.44 veces el de MEGAHIT. Un N50 mayor indica un
# ensamblaje menos fragmentado, pero un solo número no decide: Omega
# tiene el N50 mayor y el L50 menor (2737 contigs para llegar a la mitad
# del ensamblaje), pero su ensamblaje es el segundo más chico (34.86 Mb)
# y solo el 13.64 por ciento de las lecturas se mapean a él, frente a
# 64.46 por ciento en SPAdes y 55.92 por ciento en MEGAHIT. SPAdes da el
# ensamblaje más grande (275.92 Mb) y el que más lecturas usa (64.46 por
# ciento), pero tarda 22.23 horas y usa 157.75 GB de memoria, mientras
# que MEGAHIT tarda 2.90 horas y usa 10.58 GB: SPAdes tarda 7.67 veces
# más y usa 14.91 veces más memoria que MEGAHIT. Por eso el artículo
# concluye que MEGAHIT es la alternativa barata a SPAdes: ensambla
# casi tanto (210.62 Mb) con mucho menos cómputo.

# --------------------------------------------------------------------------
# 8. Qué aprendimos
# --------------------------------------------------------------------------
# - Un metagenoma es el ADN de toda una comunidad, no de un solo
#   organismo: al secuenciar una muestra de agua de mar se secuencia
#   también el ADN de miles de bacterias, arqueas y virus.
# - El ensamblaje junta las lecturas en contigs. La mayoría de los
#   contigs son cortos: con un umbral de 1000 bp queda solo alrededor
#   de 1 de cada 4 contigs, y con 50000 bp casi ninguno.
# - N50 y L50 miden qué tan fragmentado está un ensamblaje. Un N50
#   mayor y un L50 menor indican contigs más largos y un ensamblaje
#   menos fragmentado.
# - Nueve ensambladores sobre las mismas lecturas públicas dan nueve
#   ensamblajes distintos: SPAdes da el más grande (275.92 Mb) y el
#   que más lecturas usa (64.46 por ciento); MEGAHIT da casi lo mismo
#   (210.62 Mb) con mucho menos tiempo y memoria; Omega tiene el N50
#   mayor pero el ensamblaje más chico y el mapeo más bajo.
# - Un solo número no decide: se miran juntos el N50, el L50, el
#   tamaño total, el porcentaje de lecturas mapeadas, el tiempo y la
#   memoria.
# - En la próxima lección se revisa el control de calidad de las
#   lecturas antes del ensamblaje, con FastQC y MultiQC, sobre estas
#   mismas lecturas públicas de Tara Oceans.
