# Estrategia de Pruebas (Testing Strategy)

La calidad del software en Drivique se asegura mediante la implementación estricta de una **Pirámide de Pruebas**. Nuestro objetivo es atrapar los errores lo más temprano posible en el ciclo de vida del desarrollo.

## 1. Pruebas Unitarias (Base de la Pirámide)
* **Objetivo:** Probar funciones, clases y métodos de forma aislada sin dependencias externas (bases de datos, red).
* **Herramientas:**
  * **Frontend:** `Vitest`, `Jest`.
  * **Backend:** `JUnit 5`, `Mockito`.
* **Cobertura mínima exigida:** 80% en lógica de negocio pura.

## 2. Pruebas de Integración (Medio de la Pirámide)
* **Objetivo:** Verificar que los distintos módulos (ej. Servicios, Controladores, Repositorios) funcionen correctamente en conjunto, incluyendo llamadas a bases de datos en memoria o de prueba.
* **Herramientas:**
  * **Backend:** `@SpringBootTest`, `Testcontainers` (para PostgreSQL).
  * **Frontend:** `React Testing Library` (montando componentes con sus proveedores de estado/contexto).

## 3. Pruebas de Componentes / E2E (Cúspide de la Pirámide)
* **Objetivo:** Probar flujos completos del usuario desde la interfaz gráfica hasta la base de datos, simulando el comportamiento real en el navegador o dispositivo móvil.
* **Herramientas:**
  * **Frontend Web:** `Cypress` o `Playwright`.
  * **Móvil:** `Detox` (para Expo/React Native).

## Ejecución de Pruebas en CI/CD
Ningún Pull Request puede ser fusionado (Merged) si no pasa todas las pruebas automatizadas en los pipelines de GitHub Actions / GitLab CI.
