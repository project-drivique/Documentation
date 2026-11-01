# Stack Tecnológico: Backend — Drivique

## 1. Stack Productivo Vigente

API REST compartida por los clientes web (`front-end_web`) y móvil (`front-end_movil`), desplegada en producción en `https://drivique.tech/api/v1`. La justificación arquitectónica se registra en el [ADR 0003](../04-architecture/decisions/0003-stack-backend.md).

| Componente | Tecnología y Versión | Uso en el Sistema |
| --- | --- | --- |
| **Lenguaje** | **Java 21** (`maven.compiler.release=21`) | Implementación del servidor (alineado en `pom.xml`, `Dockerfile`, CI y documentación) |
| **Framework** | **Spring Boot 4.0.8** | Configuración, inyección de dependencias y arranque de la aplicación |
| **API HTTP** | Spring Web MVC (`/api/v1`) | **53 controladores REST** versionados y respuestas de error RFC 7807 (`ApiProblem`) |
| **Persistencia** | Spring Data JPA / Hibernate (`ddl-auto: validate`) | **73 entidades JPA** mapeadas 1:1 contra las **78 tablas** de PostgreSQL 17 |
| **Motor de Base de Datos** | **PostgreSQL 17** (`postgres:17-alpine`) | Persistencia relacional distribuida en 8 esquemas de dominio |
| **Migraciones de Esquema** | **Liquibase** (`changelog/db.changelog-master.yaml`) | Único gestor de migraciones en desarrollo, pruebas con Testcontainers y producción |
| **Seguridad** | Spring Security + JJWT (`0.12.6`) + BCrypt (costo 12) + AES-GCM | Autenticación JWT stateless, RBAC con `@PreAuthorize`, CORS restringido por origen y cifrado de documentos KYC |
| **Contrato API** | `springdoc-openapi` (`3.0.3`) | Exportación automatizada de contrato OpenAPI 3.0 (`docs/openapi.json`) |
| **Observabilidad** | Spring Boot Actuator | Endpoint de salud `/api/actuator/health` y `HEALTHCHECK` en contenedor Docker sin root |
| **Pruebas y Cobertura** | JUnit 5 + Testcontainers (`1.21.4`) + JaCoCo (`0.8.14`, umbral $\ge 75\%$) | Suite de más de 550 pruebas de integración y unitarias sobre PostgreSQL 17 + Liquibase |

## 2. Perfiles y Seguridad Operativa

- **Perfiles de ejecución:** `dev`, `qa` y `main` (producción).
- **Guardia de secretos (`require-secrets: true`):** El arranque falla inmediatamente con mensaje descriptivo si no se suministran las variables de entorno obligatorias (`DB_PASSWORD`, `JWT_SECRET`, `DOCUMENT_ENCRYPTION_KEY`, `MAIL_PASSWORD`).
- **Pasarela de pagos Wompi:** Iniciación firmada en el servidor (`POST /api/v1/payments/wompi/initiate`) y confirmación por webhook verificado en tiempo constante (`POST /api/v1/payments/wompi/webhook`).
