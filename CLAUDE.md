# Datacenter Tycoon — Resumen del proyecto

## Idea
Juego idle/tycoon 2D donde el jugador construye y escala un datacenter: arranca con un
servidor viejo y crece hacia racks, clusters y datacenters completos. Proyecto personal
de aprendizaje y portfolio.

## Decisiones tomadas
- **Lenguaje base:** C puro. El juego base se hace completo y pulido en C antes de sumar
  cualquier otra cosa. Objetivo: practicar lógica, arquitectura y manejo de memoria.
- **Extensiones posteriores:** solo C++, para agregar "chiches" y mejoras sobre la base
  ya terminada (no Go).
- **Distribución con CI/CD:**
  - Ejecutable + instalador para Windows y Linux, publicados en GitHub Releases.
  - Versión web jugable en GitHub Pages y/o itch.io.

## Stack propuesto
- **raylib 6.2** (ventana, dibujo, input) + **raygui 5.0** (UI: botones, paneles).
- **cJSON 1.7.18** para datos de balance y guardado.
- **Unity 2.6.0** para tests (se agrega en US-103).
- Dependencias como submódulos git en `lib/`, fijados a tags.
- **CMake (≥ 3.29) + Ninja** como sistema de build (targets: escritorio, web con Emscripten,
  tests). `Makefile` raíz como atajo: `make dependencias`, `make`, `make run`, `make clean`.
- Desarrollo en Linux o WSL (Ubuntu). Finales de línea LF (`.gitattributes`).
- **Emscripten** para compilar a WebAssembly.
- **GitHub Actions** para CI/CD.
- Windows: compilación cruzada con MinGW + instalador (Inno Setup o NSIS).
- Linux: AppImage.

## Arquitectura propuesta
Capas con dependencias en un solo sentido: `app → ui → core`.
- **core/** (Model): estado del juego, generadores, upgrades, economía, progreso offline,
  guardado y formateo de números. Solo C estándar, **nunca incluye raylib**. Se compila
  como librería estática que linkean el juego y los tests.
- **ui/view/** (View): solo dibuja, lee el estado sin modificarlo.
- **ui/input/** (Controller): lee mouse/teclado y genera **acciones** (enum, ej.
  `ACTION_BUY_GENERATOR` + id) que aplica `game_apply()`.
- **platform/**: lo que cambia entre web y escritorio (guardado en archivo vs IndexedDB,
  timestamps).
- **main.c**: game loop (input → apply → update → draw), con `#ifdef __EMSCRIPTEN__`
  para el loop web.
- Simulación con paso de tiempo fijo (fixed timestep), independiente de los FPS.

## Estructura de carpetas
include/{core,ui}/  src/{core,ui/view,ui/input,platform}/  tests/{unit,integration,fixtures}/
data/ (JSON de generadores/upgrades)  assets/  lib/ (raylib, raygui, cjson)
web/shell.html  cmake/ (toolchain MinGW, sanitizers)  scripts/  docs/  .github/workflows/

## Mecánicas base (v1.0)
- Generadores (servidores, racks, etc.) que producen recursos por segundo.
- Upgrades que multiplican la producción.
- Costos exponenciales: `costo = base × crecimiento^cantidad`.
- Generadores y upgrades definidos en JSON (data-driven).
- Guardado con campo de versión y autoguardado periódico.
- Progreso offline: `tiempo_ausente × producción`.
- Números grandes con `double` y formateo (1.2K, 3.4M, 5e20).

## Calidad
- Tests unitarios e integración del core (framework Unity de ThrowTheSwitch o macros
  propias), corridos con CTest.
- Sanitizers (ASan + UBSan) en los tests y en CI; Valgrind para revisar leaks.
- Warnings estrictos en el core: `-Wall -Wextra -Wpedantic -Werror`.
- Convenciones: prefijo por módulo (`game_`, `gen_`, `save_`), funciones `static` para lo
  interno, pares `x_create()`/`x_destroy()` con ownership documentado, structs opacos
  para encapsular.

## Workflows de CI/CD
- `ci.yml`: build + tests + sanitizers en cada push/PR.
- `release.yml`: con tag `v*`, builds Windows/Linux + instalador → GitHub Releases.
- `pages.yml`: build web → GitHub Pages (y opcionalmente itch.io con butler).

## Preparación para C++ (más adelante)
- Headers envueltos en `extern "C"` (se agrega al final, sin tocar lógica).
- Evitar palabras reservadas de C++ (`new`, `class`, `delete`, `this`) y castear `malloc`.
- Las extensiones van en `src/ext/` como `.cpp` que incluyen los headers del core.
- Ideas: panel de debug con Dear ImGui, ECS, pathfinding A*, mapa tycoon visual.

## Pendiente de definir
- GitHub Pages, itch.io o ambos para la versión web.
- Lista concreta de generadores, upgrades y recursos del datacenter.
- Herramienta de instalador para Windows (Inno Setup vs NSIS).
