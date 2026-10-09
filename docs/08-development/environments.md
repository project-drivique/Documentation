# Entornos de Despliegue (Environments)

Drivique cuenta con una arquitectura de despliegue separada por entornos para garantizar la estabilidad operativa, la calidad del software y una entrega continua segura.

## 1. Entorno de Desarrollo (Development - DEV)
* **Objetivo:** Pruebas internas del equipo de desarrollo, integración de nuevas características y validación temprana.
* **Estabilidad:** Baja-Media. El código puede cambiar rápidamente.
* **Infraestructura:** 
  * Backend: Contenedores Docker (VPS económico) o servicios Serverless de pruebas.
  * Web: Netlify (URL de pre-visualización de rama `dev`).
  * Móvil: Expo Go (Canal de desarrollo).
* **Datos:** Bases de datos de desarrollo, enmascaradas y purgadas frecuentemente.

## 2. Entorno de Calidad (Quality Assurance - QA)
* **Objetivo:** Validación por parte de los Analistas QA, pruebas automatizadas E2E y pruebas de aceptación de usuario (UAT) controladas.
* **Estabilidad:** Alta. Solo ingresa código que ya pasó pruebas unitarias y revisión de pares (Code Review).
* **Infraestructura:** Réplica exacta o muy cercana a Producción.
* **Datos:** Base de datos con volúmenes similares a producción pero con datos ficticios o ofuscados.

## 3. Entorno de Producción (Production - PROD)
* **Objetivo:** Entorno final utilizado por clientes reales, administradores de sucursal y conductores.
* **Estabilidad:** Crítica (SLA 99.9%).
* **Infraestructura:**
  * Base de Datos: Clúster principal con respaldos y alta disponibilidad.
  * Backend: Servidores de alto rendimiento (VPS Dedicado / Cloud Auto-scaling).
  * Web: Netlify (Producción, dominio oficial).
  * Móvil: Google Play Store / Apple App Store vía Expo EAS Build.
* **Datos:** Datos reales sensibles con estrictas políticas de acceso y seguridad.
