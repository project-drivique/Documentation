# Stack Tecnológico: Backend

## Base documentada

API REST compartida por web y móvil. Versiones y componentes observados en la base inicial del [backend, commit 5f26b74](https://github.com/project-drivique/Back-end/tree/5f26b74521c1506b4c06f720f03b6730b8785060). La justificación y los pendientes se registran en el [ADR 0003](../04-architecture/decisions/0003-stack-backend.md).

| Componente | Tecnología | Uso |
| --- | --- | --- |
| Lenguaje | Java 21 | Implementación del servidor |
| Framework | Spring Boot 4.0.8 | Configuración y arranque de la aplicación |
| API HTTP | Spring Web MVC | Base para endpoints REST bajo `/api` |
| Construcción | Maven Wrapper | Compilación y ejecución de pruebas |
| Persistencia | Spring Data JPA y driver PostgreSQL | Acceso a datos relacionales |
| Base local | PostgreSQL 17 (`postgres:17-alpine`) | Servicio en Docker Compose |
| Seguridad | Spring Security | Reglas de acceso y política sin sesión |
| Validación | Spring Boot Starter Validation | Validación declarativa de datos |
| Documentación | springdoc OpenAPI 3.0.3 | OpenAPI y Swagger UI |
| Observabilidad | Spring Boot Actuator | Salud e información de la aplicación |
| Migraciones en el código | Flyway | Pendiente de conciliar con Liquibase del ADR 0004 |
| Pruebas | Starters de prueba de Spring Boot y H2 | Prueba inicial del contexto |

Las dependencias sin versión explícita utilizan la gestión del proyecto padre Spring Boot indicada en `pom.xml`.

## Diseño previsto en el análisis

La API y PostgreSQL son comunes para web y app; la app solo cubre al rol cliente y la web cubre también administrador, operador y supervisor. Las credenciales de PostgreSQL pertenecen al servidor.

El análisis selecciona Spring Boot por la experiencia del equipo y considera NestJS/TypeScript y ASP.NET Core/C# como alternativas válidas. La propuesta inicial indicaba Spring Boot 3.x con versión exacta por definir; el repositorio inicial utiliza 4.0.8.

Se prevén JWT con access token y refresh token, autorización por permisos, DTO/mappers, servicios transaccionales, integración con Wompi, auditoría y pruebas de reglas de negocio. Estos elementos deben desarrollarse y verificarse por historia de usuario. Los [patrones y SOLID](../03-design/patrones/patrones-backend.md) describen los criterios para implementarlos.

## Configuración y estado

- Perfiles: `dev` (predeterminado), `qa` y `main` (producción).
- Hibernate valida el esquema mediante `ddl-auto: validate`; `open-in-view` está desactivado.
- Salud: `/api/actuator/health`. Swagger UI: `/api/swagger-ui.html`.
- Spring Security configura acceso público a salud, información y documentación; el resto requiere autenticación. La base aún no implementa JWT ni un flujo de inicio de sesión.
- La prueba inicial usa H2 en modo PostgreSQL, con Flyway desactivado y sin generación de esquema. Es necesario validar migraciones e integración contra PostgreSQL al desarrollar persistencia.

## Migraciones pendientes de unificación

El [ADR 0004](../04-architecture/decisions/0004-motor-base-de-datos.md) establece Liquibase, mientras que el backend configura Flyway. La herramienta definitiva debe acordarse con el equipo de base de datos antes de integrar migraciones. Véase el [ADR 0003](../04-architecture/decisions/0003-stack-backend.md).
