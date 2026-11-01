# ADR 0003: Selección y Estado del Stack de Backend

## Estado

**Aceptado y Vigente** · Sincronizado con el código productivo el **2026-10-31** (`HU-INT-22-dev`).

## Contexto

Drivique requiere una API REST centralizada para los clientes web (`front-end_web`) y móvil (`front-end_movil`) que gobierne identidad, control de acceso por rol y sede (RBAC), catálogo de flota, reservas con bloqueo temporal, pagos en línea con Wompi y en efectivo, contratos digitales, inspecciones, reportes y auditoría. Ambos clientes se comunican exclusivamente por HTTPS REST (`/api/v1`) y nunca acceden de forma directa a PostgreSQL.

## Decisión

Se adopta **Java 21 con Spring Boot 4.0.8** construido con Maven Wrapper (`./mvnw`), persistencia en **PostgreSQL 17** validada mediante **Spring Data JPA (`ddl-auto: validate`)** y migraciones de esquema gobernadas exclusivamente con **Liquibase** desde el repositorio `database` (`changelog/db.changelog-master.yaml`).

## Implementación Verificada en el Repositorio `Back-end`

- **53 controladores REST** bajo `/api/v1` y **73 entidades JPA** congruentes con las **78 tablas** del esquema PostgreSQL 17 (las 5 tablas restantes corresponden a tablas de unión `@ManyToMany` gestionadas por JPA: `iam.user_roles`, `iam.role_permissions`, `fleet.vehicle_features`, `fleet.user_favorite_vehicles` y `contract.contract_clause_assignments`).
- **Seguridad activa (`SecurityConfig.java`):**
  - Autenticación stateless con JWT (`accessToken` + rotación de `refreshToken`), contraseñas con `BCrypt` de costo 12 y bloqueo automático por intentos fallidos.
  - Autorización declarativa con `@PreAuthorize` por rol (`SUPER_ADMIN`, `ADMIN`, `BRANCH_ADMIN`, `CUSTOMER`) y aislamiento por sucursal (`branchId`).
  - Cifrado en reposo AES-GCM para documentos KYC (`DocumentEncryptionService`) con bloqueo de acceso público a `/uploads/kyc/**`.
  - CORS restringido a la lista blanca explícita de orígenes (`https://drivique.tech`, `https://app.drivique.tech`, `https://www.drivique.tech` y orígenes locales en desarrollo), rechazando orígenes no autorizados con `403 Forbidden`.
  - Arranque protegido por `SecretConfigurationGuard` (`require-secrets: true` por defecto).
- **Pagos Wompi en servidor:** `POST /api/v1/payments/wompi/initiate` registra el pago `PENDING` en `billing.payments` y genera la firma SHA-256 en el servidor; `POST /api/v1/payments/wompi/webhook` valida la firma del evento en tiempo constante (`WompiSignatureService`).
- **Pruebas y Contenedor:** Más de 550 pruebas ejecutadas en CI con **Testcontainers PostgreSQL 17** aplicando los changelogs de **Liquibase**, cobertura JaCoCo $\ge 75\%$ y `Dockerfile` multi-etapa con usuario no-root (`drivique:10001`) y `HEALTHCHECK`.
- **Contrato OpenAPI 3.0:** Exportado y versionado en `Back-end/docs/openapi.json` y `Documentation/docs/07-backend/contracts/openapi/openapi.json`.
