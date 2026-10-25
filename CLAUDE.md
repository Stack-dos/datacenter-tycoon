# Datacenter Tycoon (nombre de trabajo) — Resumen del proyecto

## Idea
Juego idle/tycoon 2D donde el jugador construye y escala un datacenter: arranca con una
PC vieja y crece hacia racks, clusters y datacenters completos. Proyecto de equipo (dos
personas, dentro de stack-dos) de aprendizaje y portfolio. Referencia de diseño: Revolution
Idle. El plan completo está en `docs/PRD.md`.

## Decisiones tomadas
- **Lenguaje base:** C puro. El juego base se hace completo y pulido en C antes de sumar
  cualquier otra cosa. Objetivo: practicar lógica, arquitectura y manejo de memoria.
- **Extensiones posteriores:** solo C++, para agregar "chiches" y mejoras sobre la base
  ya terminada (no Go).
- **Distribución con CI/CD:**
  - Ejecutable + instalador para Windows y Linux, publicados en GitHub Releases.
  - Versión web jugable en GitHub Pages **e** itch.io (desde v0.2).
- **Modelo:** juego gratuito con donaciones opcionales (itch.io, Ko-fi). Sin anuncios en
  v1.0; después, solo con recompensa en un portal web y en Android (v2.x). Escritorio nunca
  lleva anuncios. **Steam descartado.**
- **Idioma del juego:** español (textos en `data/strings_es.json`); otros idiomas en v1.x.
- **Nombre:** "Datacenter Tycoon" ya existe; el definitivo se decide antes de v0.1 (ADR-P06,
  candidato recomendado: Five Nines).

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
- Windows: compilación cruzada con MinGW + instalador (Inno Setup, pendiente de confirmar).
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
- req/s como recurso central; PCs y servidores producen, los racks dan slots, la
  infraestructura por niveles (sala, energía, frío, incendio) limita.
- Upgrades que multiplican la producción; hitos de cantidad (×2 a 25, 50, 100…).
- Costos exponenciales: `costo = base × crecimiento^cantidad`.
- Contratos con SLA y slots que se desbloquean, eventos (picos e incidentes), logros con
  bonus, prestigio "Nueva sede" con reputación y automatización.
- Desbloqueo progresivo de sistemas y tutorial integrado.
- Todo definido en JSON (data-driven).
- Guardado versionado con backups, autoguardado y progreso offline (tope 12 h).
- Números grandes con `double` y formateo (1.2K, 3.4M, 5e20).
- Se libera de a una versión: v0.1 … v0.8 (feature freeze) → v1.0.

## Calidad
- Tests unitarios e integración del core (Unity de ThrowTheSwitch), corridos con CTest.
- Sanitizers (ASan + UBSan) en los tests y en CI; Valgrind para revisar leaks.
- Warnings estrictos en el core: `-Wall -Wextra -Wpedantic -Werror`.
- Convenciones: prefijo por módulo (`game_`, `gen_`, `save_`), funciones `static` para lo
  interno, pares `x_create()`/`x_destroy()` con ownership documentado, structs opacos
  para encapsular.

## Workflows de CI/CD
- `ci.yml`: build + tests + sanitizers en cada push/PR.
- `release.yml`: con tag `v*`, builds Windows/Linux + instalador → GitHub Releases e itch.io
  (butler).
- `pages.yml`: con tag `v*`, build web → GitHub Pages.

## Preparación para C++ (más adelante)
- Headers envueltos en `extern "C"` (se agrega al final, sin tocar lógica).
- Evitar palabras reservadas de C++ (`new`, `class`, `delete`, `this`) y castear `malloc`.
- Las extensiones van en `src/ext/` como `.cpp` que incluyen los headers del core.
- Ideas: panel de debug con Dear ImGui, ECS, pathfinding A*, mapa tycoon visual.

## Pendiente de definir
- Nombre definitivo del juego (antes de v0.1).
- Nombres de las marcas ficticias (antes de v0.3).
- Herramienta de instalador para Windows (Inno Setup vs NSIS, antes de v1.0).
- Portal web con anuncios (después de v1.0).
