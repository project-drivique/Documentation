# Documentación de la API REST (OpenAPI 3.0 & Swagger) — Drivique

## 1. Contrato OpenAPI 3.0 Versionado

El contrato completo y versionado de la API REST de **Drivique** (generado directamente desde los 53 controladores de `Back-end` mediante `springdoc-openapi` en `OpenApiIntegrationTests`) se encuentra disponible en:

- **Repositorio `Documentation`:** [`docs/07-backend/contracts/openapi/openapi.json`](../contracts/openapi/openapi.json)
- **Repositorio `Back-end`:** `docs/openapi.json`

## 2. URLs Base por Entorno

| Entorno | URL Base de la API (`/api/v1`) | Endpoint de Salud | Swagger UI / OpenAPI JSON |
| --- | --- | --- | --- |
| **Producción (Hostinger)** | `https://drivique.tech/api/v1` | `https://drivique.tech/api/actuator/health` | Deshabilitado en producción por seguridad (`APP_SWAGGER_ENABLED=false`); consultar `openapi.json` versionado |
| **Desarrollo Local** | `http://localhost:8080/api/v1` | `http://localhost:8080/api/actuator/health` | `http://localhost:8080/api/swagger-ui.html` · `http://localhost:8080/api/v3/api-docs` |

## 3. Autenticación, Autorización y Formato de Errores

- **Esquema de Autenticación:** `Bearer JWT` en la cabecera `Authorization: Bearer <accessToken>`.
- **Control de Acceso (RBAC):** Basado en roles (`CUSTOMER`, `BRANCH_ADMIN`, `ADMIN`, `SUPER_ADMIN`) y permisos granulares validados con `@PreAuthorize` en el servidor.
- **Idempotencia:** Las operaciones transaccionales de reserva y confirmación de pago aceptan la cabecera `Idempotency-Key`.
- **Internacionalización:** El servidor adapta correos y mensajes según la cabecera `X-App-Language` (`es`, `en`, `fr`, `pt`, `br`).
- **Errores Uniformes (RFC 7807 Problem Details):** Todas las respuestas de error devuelven `application/problem+json` (`ApiProblem`) con `type`, `title`, `status`, `detail`, `instance`, `code` y `timestamp`.

## 4. Flujos Críticos de Extremo a Extremo (End-to-End)

1. **Registro e Inicio de Sesión:**
   - `POST /api/v1/auth/register` -> `POST /api/v1/auth/verify-email` -> `POST /api/v1/auth/login` -> `POST /api/v1/auth/refresh`
2. **Catálogo y Búsqueda de Vehículos:**
   - `GET /api/v1/vehicles/search` -> `GET /api/v1/vehicles/{id}` -> `GET /api/v1/vehicles/{id}/features` -> `GET /api/v1/vehicles/{id}/reviews`
3. **Cotización y Creación de Reserva:**
   - `POST /api/v1/pricing/quote` -> `POST /api/v1/promotions/validate` -> `POST /api/v1/reservations/checkout/initiate` -> `POST /api/v1/reservations/{id}/delivery-points`
4. **Pago Digital con Wompi (Firmado en Servidor):**
   - `POST /api/v1/payments/wompi/initiate` (recibe `reservationReference` o `contractId`, crea la fila `PENDING` en `billing.payments` y retorna `integritySignature` calculada en el servidor) -> `POST /api/v1/payments/wompi/webhook` (verificación HMAC-SHA256 en tiempo constante) -> `POST /api/v1/reservations/checkout/confirm/{holdId}`
5. **Generación y Firma Electrónica del Contrato:**
   - `POST /api/v1/contracts/generate` -> `POST /api/v1/contracts/{id}/sign` -> `POST /api/v1/contracts/{contractId}/inspections`
