# Estrategia de Ramas (Git Branching Strategy)

Drivique sigue una estrategia de ramificación estructurada diseñada para soportar despliegues continuos en múltiples entornos (DEV, QA, MAIN).

## Ramas Principales (Protegidas)
1. **`main`**: Código de producción. Cualquier cambio aquí se despliega directamente a los usuarios finales. No acepta commits directos.
2. **`qa`**: Entorno de validación. Sirve como entorno de "staging" donde el equipo de QA aprueba las historias de usuario.
3. **`develop` / `dev`**: Rama base de integración de desarrollo. Todo el nuevo código nace de aquí.

## Flujo de Promoción de Ramas (Branching Flow)

Cada nueva característica o corrección atraviesa este flujo exacto:

1. **Nacimiento (Desarrollo):** 
   Se crea una rama desde `dev` con el sufijo `-dev` (ej. `feat/HU-009-dev` o `fix/login-dev`).
2. **Promoción a QA:**
   Una vez listo, los cambios se portan hacia una nueva rama con el sufijo `-qa` (ej. `feat/HU-009-qa` o `fix/login-qa`) la cual se fusiona contra la rama `qa` mediante un Pull Request.
3. **Promoción a MAIN:**
   Al ser aprobado en QA, se porta hacia una rama con el sufijo `-main` (ej. `feat/HU-009-main` o `fix/login-main`) para su fusión definitiva contra `main`.

**Flujo en resumen:** `develop` ➔ `fix/*-qa` ➔ `fix/*-main` ➔ `main`
