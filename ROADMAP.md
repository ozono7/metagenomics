# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio metagenomics — Ruta de aprendizaje (ROADMAP)

# Ruta de aprendizaje: del metagenoma a las interacciones

Esta es la ruta completa del curso, en orden. Cada lección usa lo aprendido en las anteriores, por lo que se siguen de la 01 a la 14 sin saltarse ninguna.

La guía de uso del repositorio, los requisitos y la forma de correr las lecciones están en [README.md](README.md).

## Datos públicos en todo el curso

Cada lección parte de datos de repositorios públicos, con su acceso y su forma de descarga indicados al inicio del script. La lección 01 usa el metagenoma público Tara Oceans (ENA PRJEB1787), y las lecciones 02 a 04 usan esas mismas lecturas públicas. Las lecciones 05 a 14 usan datos públicos del mismo proyecto o de otros repositorios públicos; cada lección indica su acceso. Los flujos de trabajo son los del laboratorio, pero los datos son públicos: primero se replica el flujo con datos públicos y después se aplica a datos propios.

## Estado de las lecciones

- **Lista:** lección 01.
- **En preparación:** lecciones 02 a 14.

## Bloque 1. Fundamentos

Requisito previo: ninguno. Solo se necesita R con los paquetes indicados en el README.

### 01. Qué es un metagenoma y cómo se ve un ensamblaje — Lista

Qué es un metagenoma, qué es un contig, qué significan N50 y L50, y cómo se comparan nueve ensambladores (SPAdes, MEGAHIT, metaSPAdes, IDBA-UD y otros) sobre el metagenoma público Tara Oceans (ENA PRJEB1787; van der Walt y colaboradores, 2017), con gráficos.

Al terminar, el alumno sabrá explicar qué es un metagenoma, leer una tabla de MetaQUAST, calcular qué fracción de contigs queda al subir el umbral de longitud y comparar ensambladores con N50, L50, tamaño total, mapeo de lecturas, tiempo y memoria.

### 02. Control de calidad y limpieza de lecturas — En preparación

Control de calidad con FastQC y MultiQC, limpieza con Trimmomatic y fastp, y qué cambia en las lecturas después de limpiarlas. Se usan las lecturas públicas de Tara Oceans (ENA PRJEB1787).

Al terminar, el alumno sabrá leer un reporte de FastQC, decidir qué lecturas se descartan y limpiar un conjunto de lecturas antes de ensamblar.

### 03. Ensamblaje con MEGAHIT — En preparación

Cómo funciona el ensamblaje de metagenomas, qué es un grafo de Bruijn, qué opciones principales tiene MEGAHIT y cómo se corre sobre las lecturas públicas de Tara Oceans ya limpias.

Al terminar, el alumno sabrá ensamblar un metagenoma con MEGAHIT y obtener sus contigs.

### 04. metaQUAST: evaluar el ensamblaje — En preparación

Evaluar un ensamblaje con metaQUAST: contigs por umbral, N50, N90, auN, L50 y L90, y cómo se comparan dos ensamblajes. Se evalúa el ensamblaje propio de Tara Oceans y se compara con la tabla publicada de la lección 01.

Al terminar, el alumno sabrá evaluar un ensamblaje con metaQUAST y decidir si está listo para seguir o si hay que reensamblar.

## Bloque 2. Taxonomía

Requisito previo: lecciones 01 a 04.

### 05. Clasificación con Kraken2 — En preparación

Qué es la clasificación taxonómica, cómo funciona Kraken2 con k-mers, qué es una base de datos de referencia y cómo se lee un reporte de Kraken2. Se clasifican las lecturas públicas de Tara Oceans.

Al terminar, el alumno sabrá clasificar las lecturas de un metagenoma con Kraken2 y leer qué taxones aparecen y en qué proporción.

### 06. Abundancia con Bracken y visualización con Krona — En preparación

Reestimar abundancias con Bracken, visualizar la composición con Krona y comparar la composición de dos metagenomas públicos con gráficos.

Al terminar, el alumno sabrá estimar la abundancia de cada taxón y mostrar la composición de un metagenoma en un gráfico claro.

### 07. Cuando el alga no se clasifica a su especie — En preparación

Qué pasa cuando el organismo de interés no está en la base de datos de referencia: el caso de *Chlorella vulgaris* que se clasifica como *Chlamydomonas reinhardtii* y de *Scenedesmus acutus* que se clasifica como *Parachlorella kessleri*, y cómo se interpreta ese resultado sin forzarlo. El caso del laboratorio se reproduce con lecturas públicas de microalgas; el acceso y la descarga se dan en la lección.

Al terminar, el alumno sabrá reconocer cuándo una clasificación está limitada por la base de datos y qué se puede decir y qué no se puede decir a partir de ella.

## Bloque 3. Binning y MAGs

Requisito previo: lecciones 01 a 07.

### 08. Binning: MaxBin2 y MetaBAT2 — En preparación

Qué es el binning, cómo se agrupan los contigs por composición y cobertura, qué son los bins y cómo se corre MaxBin2 y MetaBAT2. Se agrupan los contigs públicos del ensamblaje de Tara Oceans.

Al terminar, el alumno sabrá agrupar los contigs de un metagenoma en bins y obtener los primeros genomas candidatos.

### 09. CheckM2: completitud y contaminación — En preparación

Qué son la completitud y la contaminación de un bin, cómo las estima CheckM2 con genes marcadores y qué umbrales se usan para filtrar bins. Se evalúan bins públicos obtenidos de Tara Oceans.

Al terminar, el alumno sabrá evaluar cada bin con CheckM2 y quedarse solo con los que pasan el filtro de calidad.

### 10. Estándares MIMAG: qué es un MAG de calidad — En preparación

Qué es un MAG (genoma ensamblado a partir de un metagenoma), qué piden los estándares MIMAG para hablar de calidad alta, media o baja, y por qué un filtro de menos de 20 por ciento de contaminación no equivale a calidad alta. Se clasifican MAGs públicos según MIMAG.

Al terminar, el alumno sabrá decir si un bin es un MAG y de qué calidad, según los estándares MIMAG.

## Bloque 4. Función

Requisito previo: lecciones 01 a 10.

### 11. Anotación con Prokka y eggNOG-mapper — En preparación

Predecir genes con Prokka, anotarlos con eggNOG-mapper, leer COG, GO y KO, y comparar la anotación funcional de dos metagenomas. Se anotan MAGs públicos.

Al terminar, el alumno sabrá anotar los genes de un MAG y decir qué funciones aparecen en cada metagenoma.

### 12. Rutas KEGG — En preparación

Qué es una ruta KEGG, cómo se asignan los KO a una ruta y cómo se lee un mapa. Esta lección enlaza con el bloque 5 del curso de genómica, donde se enseña KAAS, KEGG Mapper y pathview; aquí se aplica a MAGs públicos sin repetir ese material.

Al terminar, el alumno sabrá leer en qué rutas KEGG participan los genes de un MAG y remitirse al curso de genómica para reconstruir los mapas.

## Bloque 5. Resistencia, transferencia, redes y aprendizaje automático

Requisito previo: lecciones 01 a 12.

### 13. Resistoma y transferencia horizontal — En preparación

Buscar genes de resistencia con RGI y CARD y con ABRicate, buscar relaxasas y plásmidos con MOB-suite, y qué distingue una evidencia de transferencia de una prueba de integración. Se trabaja con MAGs públicos; el acceso se da en la lección.

Al terminar, el alumno sabrá buscar genes de resistencia en los MAGs y buscar evidencia de transferencia horizontal entre bins.

### 14. Redes bipartitas y Random Forest — En preparación

Construir redes bipartitas microalga-bacteria, leer centralidad (grado, intermediación, cercanía, vector propio) y priorizar interacciones con Random Forest. Se trabaja con tablas de abundancia públicas; el acceso se da en la lección. Los modelos de esta lección son exploratorios: sirven para ordenar qué interacciones mirar primero, no para predecir fuera de los datos con los que se entrenaron.

Al terminar, el alumno sabrá construir una red bipartita, leer sus medidas de centralidad y usar Random Forest para priorizar interacciones entre la microalga y sus bacterias.

## Qué se podrá hacer al terminar el curso

Al terminar las 14 lecciones, el alumno podrá:

- Pasar de lecturas a ensamblaje: controlar la calidad, limpiar, ensamblar con MEGAHIT y evaluar con metaQUAST.
- Clasificar y cuantificar una comunidad: usar Kraken2, Bracken y Krona, y reconocer los límites de la base de datos.
- Obtener y evaluar MAGs: agrupar contigs en bins, evaluarlos con CheckM2 y clasificarlos según los estándares MIMAG.
- Anotar y leer funciones: usar Prokka y eggNOG-mapper, y leer rutas KEGG con el apoyo del curso de genómica.
- Buscar resistencia y transferencia: usar RGI, CARD, ABRicate y MOB-suite, y distinguir evidencia de prueba.
- Priorizar interacciones: construir redes bipartitas y usar Random Forest como herramienta exploratoria.
