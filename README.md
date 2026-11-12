# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio metagenomics — Presentación y guía de uso (README)

# metagenomics

Curso de metagenómica en R, desde cero, en español: del control de calidad de las lecturas al ensamblaje, la clasificación taxonómica, los genomas ensamblados a partir de metagenomas (MAGs), la anotación funcional, el resistoma y el análisis de redes y aprendizaje automático.

## Qué es este repositorio

La metagenómica estudia el ADN de una comunidad completa, no de un solo organismo. Cuando se secuencia un cultivo de microalga, en el tubo hay también bacterias que viven con ella, y las lecturas mezclan el ADN de todos. Este curso enseña a trabajar con esos datos: limpiar lecturas, ensamblarlas, clasificarlas, agruparlas en genomas (MAGs), anotarlas y buscar en ellas funciones, resistencia a antibióticos y transferencia de genes.

Los ejemplos del curso usan los flujos de trabajo reales del laboratorio con *Chlorella vulgaris* y *Scenedesmus acutus*: MEGAHIT para ensamblar, Kraken2 para clasificar, MaxBin2 para agrupar en bins, CheckM2 para evaluarlos, Prokka y eggNOG-mapper para anotar, RGI y CARD para el resistoma, MOB-suite para transferencia y Random Forest para priorizar interacciones.

### Datos públicos, desde cero

Los temas del curso son los del laboratorio, pero los datos no son los datos del laboratorio: todas las lecciones parten de datos de repositorios públicos (SRA, ENA, MG-RAST y otros), con su acceso y su forma de descarga indicados al inicio de cada lección. El curso empieza desde cero y es para quienes entran a estos temas por primera vez: primero se aprende cómo se empieza y con qué datos, se replica el flujo de trabajo del laboratorio con datos públicos, y después cada quien lo aplica a sus propios datos en privado. La lección 01 usa el metagenoma público Tara Oceans (ENA PRJEB1787; van der Walt y colaboradores, 2017, BMC Genomics 18:521), y las lecciones 02 a 04 usan esas mismas lecturas públicas.

Cada lección explica un tema con definiciones y ejemplos, y termina con gráficos y con lo aprendido. Los gráficos se hacen en R con ggplot2 y se guardan en PNG a 300 dpi.

### Para quién es

Para estudiantes de ciencias químicas, biología y bioinformática que ya manejan lo básico de R (o que lo están aprendiendo en paralelo con los cursos de Introducción a R y Aprende R) y quieren analizar datos de secuenciación de comunidades.

No se necesita experiencia previa en metagenómica. Se necesita una computadora con R instalado y disposición para correr cada ejemplo y leer sus resultados.

## Requisitos

- R (versión 4.3 o posterior) y RStudio, o la terminal con Rscript.
- Paquetes de R: ggplot2, dplyr, readr, scales y tidyr. Se instalan con:
  `install.packages(c("ggplot2", "dplyr", "readr", "scales", "tidyr"))`
- Para las lecciones que usan herramientas de línea de comandos (FastQC, Trimmomatic, MEGAHIT, Kraken2, MaxBin2, CheckM2, Prokka, RGI), se recomienda instalarlas con conda en un ambiente aparte. Cada lección indica qué herramienta usa y cómo se instala. Los análisis de ejemplo de las lecciones 01 a 03 se pueden seguir solo con R y los CSV de cada lección.

## Cómo usar las lecciones

### Orden recomendado

Las lecciones se siguen en orden, de la 01 a la 14, porque cada una usa lo aprendido en las anteriores. La ruta completa, lección por lección, está en [ROADMAP.md](ROADMAP.md).

### Organización de cada lección

Cada lección es un script `.R` con su nombre y su número, por ejemplo `01-que-es-un-metagenoma.R`. Junto al script van los archivos CSV con los datos de ejemplo de esa lección, por ejemplo `datos_ensamblaje.csv`.

El script se corre completo en RStudio (botón Source) o desde la terminal con:

```bash
Rscript 01-que-es-un-metagenoma.R
```

Al correrlo, el script imprime en la consola las tablas y los valores calculados, y guarda las figuras en archivos PNG en la misma carpeta. Cada figura lleva su sección de Interpretación dentro del script: qué muestra, qué es cada eje con sus unidades, qué patrón se ve y qué significa.

### Cómo practicar

Cada ejemplo está pensado para correrse y leerse, no para copiarse y pegarse sin mirar. Después de correr un script, conviene revisar lo que imprimió en la consola y abrir las figuras que generó, y comparar lo que se ve con lo que dice la Interpretación del script. Si algo no coincide, se revisa el código antes de seguir adelante.

## Resumen de la ruta

La ruta completa tiene 14 lecciones, en 5 bloques:

1. Fundamentos (01–04): qué es un metagenoma, control de calidad y limpieza, ensamblaje con MEGAHIT, metaQUAST.
2. Taxonomía (05–07): Kraken2, Bracken y Krona, y qué hacer cuando el alga no se clasifica a su especie.
3. Binning y MAGs (08–10): MaxBin2 y MetaBAT2, CheckM2, estándares MIMAG.
4. Función (11–12): Prokka y eggNOG-mapper, rutas KEGG.
5. Resistencia, transferencia, redes y aprendizaje automático (13–14): RGI y CARD, MOB-suite, redes bipartitas y Random Forest.

El detalle de cada lección, qué enseña y qué sabrá hacer el alumno al terminarla está en [ROADMAP.md](ROADMAP.md).

## Relación con los otros cursos

Este curso forma parte de la serie de ómicas del laboratorio, junto con el curso de [RNA-seq](https://github.com/ozono7/RNA-seq) (transcriptómica) y el curso de [genomics](https://github.com/ozono7/genomics) (genómica).

Dos temas se enseñan en un solo lugar para no repetirlos en los tres cursos: las bases de datos locales (makeblastdb, Diamond) y KEGG (KAAS, KEGG Mapper, pathview) se enseñan en el curso de genómica, y desde aquí se enlazan en las lecciones 11 y 12. El curso de RNA-seq también enlaza a esos módulos desde su módulo 10.

## Estado de las lecciones

- **Lista:** lección 01.
- **En preparación:** lecciones 02 a 14.
