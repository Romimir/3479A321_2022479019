# Solitario Inglés (Peg Solitaire)

## Alcance
Aplicación móvil desarrollada en Flutter orientada a la resolución del clásico juego de mesa de estrategia "Solitario Inglés", incorporando una arquitectura limpia, navegación centralizada, gestión de historial de partidas y componentes interactivos basados en grillas matriciales.

## Requerimientos Funcionales
* **RF01 - Menú Principal:** Pantalla de acceso centralizado con navegación fluida hacia el juego, el historial y las reglas.
* **RF02 - Interacción del Tablero:** Selección y deselección de fichas mediante un sistema de toques con respuesta visual en tiempo real.
* **RF03 - Historial de Partidas:** Visualización en formato de lista optimizada (`ListView.builder`) del registro de las últimas partidas disputadas.

## Restricciones Técnicas
* Desarrollado utilizando el framework Flutter y lenguaje Dart.
* Uso estricto de la herramienta de análisis estático `flutter analyze` para garantizar la calidad del código.
* Gestión de versiones mediante control de Git y ramas de trabajo estructuradas.

## Requerimientos No Funcionales
* **RNF01 - Rendimiento:** Renderización eficiente de listas extensas en memoria mediante constructores lazy (`ListView.builder`).
* **RNF02 - Coherencia Visual:** Aplicación de una paleta de colores personalizada en formato ARGB y diseño adaptativo con componentes estándar (`Card`, `ListTile`).