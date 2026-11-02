# Informe de remediación — Equipo 1 · Drivique

**Evaluación de origen:** informe de seguimiento del 2026-10-30 (puntaje 60/100, juicio D, 34 hallazgos).
**Estado de este informe:** 2026-11-01, rama `HU-INT-23`. Es una autoevaluación del equipo; la nota la asigna el instructor.

Este documento reemplaza la versión anterior, que declaraba los 34 hallazgos cerrados y una nota propia de 90/100. Esa versión no se podía sostener con el código: citaba Vitest, Jest y DOMPurify, que el proyecto no usa, y títulos de hallazgos que no coinciden con el informe oficial. Aquí cada estado se puede comprobar con un comando o con un archivo.

---

## 1. Resumen

| Estado | Cantidad | Hallazgos |
|---|---:|---|
| Cerrado y verificado | 29 | H-02, H-03, H-04, H-05, H-06, H-07, H-08, H-09, H-10, H-11, H-12, H-13, H-14, H-16, H-17, H-18, H-19, H-20, H-21, H-22, H-23, H-24, H-25, H-26, H-27, H-28, H-29, H-30, H-34 |
| Parcial | 1 | H-01 | Crítico | Contraseña de aplicación de Gmail, clave JWT y clave de cifrado publicadas en el historial | **Parcial** | **Hecho (2026-11-02):** el historial de las 201 ramas del Back-end se reescribió y los valores publicados ya no aparecen en ninguna rama; se comprobó con un clon nuevo desde GitHub. `.env.example` solo trae marcadores y `application.yml` exige las variables. **No hecho, por decisión del equipo:** la contraseña de aplicación de Gmail no se rotó y sigue siendo la misma que estuvo publicada; quien la copió antes de la limpieza podría usarla. No se verificó la rotación de la clave JWT ni de la de cifrado en el servidor. |
| Pendiente (configuración de GitHub) | 1 | H-15 |
| Decisión del equipo (se deja abierto) | 2 | H-31, H-33 |
| No remediable | 1 | H-32 |

---

## 2. Estado por hallazgo

| ID | Sev. | Hallazgo (título del informe oficial) | Estado | Evidencia o lo que falta |
|---|---|---|---|---|
| H-01 | Crítico | Contraseña de aplicación de Gmail, clave JWT y clave de cifrado publicadas en el historial | **Parcial** | `.env.example` solo trae marcadores y `application.yml` exige las variables. **Pendiente:** rotar la contraseña de Gmail, la clave JWT y la de cifrado, y reescribir el historial del Back-end. |
| H-02 | Alto | APK de 64 MB y node_modules/zip en el historial del repo web | **Cerrado** | El 2026-11-02 se reescribió el historial de las 239 ramas del web sin `.apk`, `.zip` ni `node_modules`. Un clon nuevo desde GitHub pesa 7.6 MB, no tiene archivos de más de 1 MB ni esas rutas, y `main`, `develop` y `qa` conservan el mismo contenido. |
| H-03 | Medio | Producto sin indicadores de éxito medibles y historias sin criterios de aceptación | **Cerrado** | 5 KPI con meta numérica en `docs/02-product/goals-and-objectives.md` y criterios en `docs/01-srs/acceptance-criteria.md`. |
| H-04 | Alto | Trazabilidad a UI y UML sin cerrar: la matriz nombra componentes inexistentes | **Cerrado** | Todos los componentes y diagramas que nombra `docs/01-srs/matriz-trazabilidad.md` existen en los repos. |
| H-05 | Alto | Pago Wompi: los clientes ignoran POST /payments/wompi/initiate y firman en el cliente | **Cerrado** | La web delega la firma en el servidor (`wompiService.js`). La app tiene prueba en `__tests__/wompiPayment.test.js`. |
| H-06 | Alto | El despliegue web apunta a un host de API que no responde | **Cerrado** | Web y app usan el mismo host y `VITE_API_URL` está documentada. |
| H-07 | Medio | Clases de 900-1000 líneas y lógica/HTML en un controlador | **Cerrado** | Ningún archivo `.java` supera 500 líneas, tests incluidos. |
| H-08 | Alto | Componentes monolíticos de ~2000 líneas en el web | **Cerrado** | Ningún archivo de código de la web supera 500 líneas (eran 21). |
| H-09 | Alto | CORS abierto a cualquier origen con credenciales | **Cerrado** | `SecurityConfig` usa solo los orígenes configurados. |
| H-10 | Alto | Web y móvil sin pruebas automatizadas y CI que solo busca datos simulados | **Cerrado** | El CI de cada cliente corre `npm test`. Web: 19 pruebas (login, sesión, cierre de sesión, reserva con idempotencia, conflicto 409, pago rechazado, pago fallido, renovación del token, traducciones). App: 16 pruebas, 6 de ellas ejecutan de verdad `apiClient`, `authStore` y `authService` (token, idioma, renovación en 401, cierre de sesión). |
| H-11 | Medio | README del Back-end desactualizado | **Cerrado** | El README describe las entidades actuales. |
| H-12 | Medio | Carpeta .idea y cachés de IDE versionados en la app móvil | **Cerrado** | Retirados y cubiertos por `.gitignore`. |
| H-13 | Medio | Accesibilidad casi ausente en la app móvil | **Cerrado** | 313 botones con `accessibilityRole`, 223 con etiqueta y 30 campos de texto etiquetados; claves `a11y.*` en los 5 idiomas. |
| H-14 | Medio | IP simulada aleatoria enviada en la auditoría del login social | **Cerrado** | Se eliminó la IP fija; el servidor guarda la IP real. |
| H-15 | Medio | PR fusionados sin ninguna revisión y cero issues | **Pendiente** | Es configuración de GitHub: exigir al menos una revisión por PR en `main` y abrir issues por trabajo. |
| H-16 | Medio | Backend y BD con funcionalidades sin pantalla que las use | **Cerrado** | `docs/07-backend/api-docs/endpoints-sin-pantalla.md` lista las rutas sin pantalla y las clasifica. Decidir pantallas nuevas queda para el equipo. |
| H-17 | Medio | El móvil inventa datos: apellido 'Drivique' y fecha de devolución +24 h | **Cerrado** | El desplazamiento de +24 h se reemplazó por un error explícito. |
| H-18 | Medio | Versión de Java contradictoria | **Cerrado** | `pom.xml`, Dockerfile, CI y README declaran Java 21. |
| H-19 | Medio | .env.example con valor de sandbox y correo real | **Cerrado** | Solo marcadores. |
| H-20 | Medio | README del web no menciona VITE_API_URL | **Cerrado** | Documentada como obligatoria. |
| H-21 | Medio | Documentación desfasada: 69 tablas documentadas frente a 78 | **Cerrado** | El diccionario de datos, los diagramas ER (dot, svg, png, mermaid) y `er-relationships.csv` se generaron aplicando los 274 changesets de Liquibase a una base vacía: 78 tablas, 704 columnas y 113 claves foráneas. |
| H-22 | Medio | Pantallas móviles de 1500 líneas y 12 catch vacíos | **Cerrado** | Ninguna pantalla supera 500 líneas y no hay `catch` vacíos. |
| H-23 | Medio | Un arranque sin variables cae al perfil dev con secretos efímeros | **Cerrado** | Sin `JWT_SECRET` ni `APP_DOCUMENT_ENCRYPTION_KEY` el Back-end no arranca y lo dice con un mensaje claro. |
| H-24 | Medio | Token en localStorage y 13 usos de dangerouslySetInnerHTML | **Cerrado** | El token vive en `sessionStorage`; queda un solo `dangerouslySetInnerHTML` y pasa por `sanitizeSafeHtml`. Al cerrar sesión el refresh token se revoca en el servidor. |
| H-25 | Medio | Imagen Docker corre como root, sin HEALTHCHECK | **Cerrado** | Usuario no root y `HEALTHCHECK` en el Dockerfile. |
| H-26 | Medio | El repositorio de base de datos no tiene CI | **Cerrado** | `.github/workflows/ci.yml` ejecuta las 50 pruebas SQL. |
| H-27 | Medio | Las pruebas del backend crean tablas con Hibernate create-drop | **Cerrado** | Las pruebas aplican las migraciones Liquibase; `DatabaseHealthTestSupport` conserva `ddl-auto=update` como respaldo. |
| H-28 | Medio | Seed de demostración huérfano con contraseña común | **Cerrado** | El seed se retiró. |
| H-29 | Medio | El contrato OpenAPI no está publicado ni versionado | **Cerrado** | `docs/openapi.json` en el Back-end. |
| H-30 | Bajo | swagger.md es plantilla y no hay OpenAPI exportado | **Cerrado** | `docs/07-backend/api-docs/swagger.md` y `contracts/openapi/openapi.json`. |
| H-31 | Bajo | Trabajo sin integrar en ramas hijas | **Decisión del equipo** | Las ramas adelantadas del Back-end son cambios antiguos que ya no aportan; se dejan sin integrar y no afectan a `main`. |
| H-32 | Bajo | Un integrante concentra 77.8 % de los commits del repo web | **No remediable** | Es historia del repositorio. |
| H-33 | Bajo | Ramas adelantadas sin integrar en main | **Decisión del equipo** | Igual que H-31: son cambios antiguos de la web y la app que se dejan sin integrar. |
| H-34 | Bajo | Secreto de integridad y llave pública de Wompi versionados en .env.example | **Cerrado** | Solo marcadores. |

---

## 3. Cómo comprobarlo

```bash
# Back-end: 749 pruebas, sin fallos (necesita Docker encendido)
./mvnw clean verify

# Web: 19 pruebas y compilación
cd front-end_web/web-drivique && npm ci && npm test && npm run build

# App móvil: tipos, lint y pruebas
cd front-end_movil/app-drivique && npm ci && npx tsc --noEmit && npx eslint . && npm test

# Base de datos: las 50 pruebas SQL corren en .github/workflows/ci.yml
```

Tamaño de archivos (criterio del informe: ninguno de código por encima de 500 líneas):

```bash
git ls-files | grep -E "\.(java|jsx?|tsx?)$" | xargs wc -l | awk '$1>500'
```

Solo deben aparecer los archivos de traducciones, que son datos.

---

## 4. Lo que el equipo debe hacer y el código no puede resolver

1. **Rotar** la contraseña de aplicación de Gmail (decisión actual: no hacerlo), la clave JWT y la clave de cifrado de documentos (H-01).
2. **Configurar GitHub:** al menos una revisión por PR en `main` y trabajo nuevo desde issues (H-15).
