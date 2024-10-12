# Repositorio de Proyectos: PdeP - Programación Funcional, Objetos y Lógica

Este repositorio contiene tres trabajos prácticos realizados para la materia de **Paradigmas de Programación**. El primero es sobre **Programación Funcional** aplicado a un simulador de microprocesador. El segundo sobre **Programación Lógica** enfocado en el modelado de conocimiento para un mundo distópico. El tercero es sobre **Programación Orientada a Objetos** centrado en la simulación del comportamiento de hormigas y hormigueros. A continuación, se detallan los trabajos:

## 1. Programación Funcional - Simulador de Microprocesador

### Descripción
El trabajo consiste en desarrollar un simulador de un microprocesador simple, con el objetivo de modelar sus componentes (acumuladores, program counter, memoria, etc.) y su funcionamiento básico. Se trata de implementar las instrucciones necesarias para manipular estos componentes, como sumas, divisiones y operaciones de carga en memoria.

El proyecto fue desarrollado en **Haskell**, utilizando conceptos avanzados de programación funcional, como la composición de funciones, recursividad y abstracción.

### Tecnologías utilizadas
- **Lenguaje**: Haskell
- **Paradigma**: Programación funcional
- **Conceptos clave**: Composición de funciones, abstracción, manejo de errores, recursividad.

### Entrega 1
Se implementan las instrucciones básicas del microprocesador, tales como:
- **NOP**: No operation, simplemente avanza el program counter.
- **ADD**: Suma los valores de los acumuladores A y B.
- **DIV**: Divide el acumulador A por el valor en B, manejando el error de división por cero.
- **LOD**: Carga un valor de la memoria al acumulador A.
- **SWAP**: Intercambia los valores entre los acumuladores A y B.

### Entrega 2
En esta entrega se amplía el simulador con características como:
- **Carga de programas**: Capacidad de cargar un programa completo en memoria.
- **Ejecución**: Ejecución de un programa cargado en el microprocesador.
- **Instrucción IFNZ**: Ejecución condicional dependiendo del valor en el acumulador A.
- **Depuración de programas**: Identificación de instrucciones innecesarias que no modifican el estado del procesador.
- **Memoria infinita**: Modelado de un microprocesador con memoria infinita.


## 2. Programación Lógica - "Rebelde güey"

### Descripción
Este trabajo, basado en **Prolog**, se desarrolla en un futuro distópico donde un sistema de vigilancia masivo monitorea a la población. El objetivo es modelar las relaciones entre personas, sus viviendas, y determinar quiénes podrían ser disidentes potenciales.

El trabajo incluye la representación de conocimientos sobre personas, viviendas y actividades clandestinas. Además, se implementan funciones para detectar viviendas con actividad rebelde y posibles disidentes, y la lógica para crear batallones rebeldes.

### Tecnologías utilizadas
- **Lenguaje**: Prolog
- **Paradigma**: Programación lógica
- **Conceptos clave**: Modelado de conocimiento, lógica de predicados, inferencia lógica.

### Puntos principales del trabajo:
- **Modelado de personas**: Incluye información sobre habilidades, gustos y antecedentes criminales.
- **Viviendas**: Se modelan casas con túneles y cuartos secretos usados por rebeldes.
- **Detección de disidencia**: Identificación de personas que cumplen con ciertos criterios de disidencia.
- **Formación de batallones**: Algoritmo para seleccionar un grupo de rebeldes basándose en habilidades y antecedentes.

## 3. Programación Orientada a Objetos - BichOS

### Descripción
Este proyecto, denominado BichOS, consiste en el desarrollo de un software que modela el comportamiento de las hormigas y sus hormigueros. Es un programa orientado a ayudar a biólogos a estudiar y simular cómo las hormigas recolectan alimentos, interactúan con su entorno, y manejan los recursos del hormiguero. Se ha dividido en dos entregas principales, donde se introducen y expanden diversas funcionalidades.

### Tecnologías utilizadas
- **Lenguaje**: Wollok
- **Paradigma**: Programación orientada a objetos
- **Conceptos clave**: Encapsulamiento, herencia, polimorfismo, clases y objetos.

### Entrega 1
La primera entrega del proyecto aborda el modelado básico de las hormigas y los hormigueros. Las funcionalidades implementadas incluyen:
- **Hormigas**: Pueden transportar hasta 10mg de alimento y registrar su desplazamiento. Tienen límites de capacidad y pueden agotarse tras recorrer más de 10 metros.
- **Hormigueros**: Actúan como depósitos de alimento. Pueden reclamar el alimento de las hormigas y calcular la cantidad total de alimento en tránsito y en depósito.
- **Desplazamiento y registro de viajes**: Las hormigas registran los puntos por los que pasan y la distancia recorrida.
- **Extracción de alimentos**: Las hormigas pueden extraer alimento de objetos en el terreno, y los objetos pierden masa con cada extracción.

#### Algunos de los requerimientos clave fueron:
- Saber cuánto alimento lleva una hormiga, si está al límite de su capacidad y la distancia que ha recorrido.
- El hormiguero puede reclamar el alimento de todas las hormigas y calcular la cantidad total de alimento disponible​.

### Entrega 2
En esta entrega se expande el sistema con nuevas funcionalidades, como:

- **Tipos de hormigas**: Se introducen varios tipos de hormigas (obreras, soldados, zánganos y reina), cada una con características únicas. Por ejemplo, los soldados pueden atacar intrusos, mientras que los zánganos y la reina no recolectan alimento.
- **Defensa del hormiguero**: Las hormigas pueden defenderse de intrusos, y los distintos tipos de hormigas causan diferentes cantidades de daño.
- **Colonias y expediciones**: Se modelan colonias, que agrupan varios hormigueros, y se implementan expediciones para recolectar alimento de manera eficiente en equipo​.