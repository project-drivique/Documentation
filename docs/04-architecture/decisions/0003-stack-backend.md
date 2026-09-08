# ADR 0003: Selección del stack de Backend

## Estado

Selección de Spring Boot + Java + PostgreSQL basada en el análisis del proyecto; versiones contrastadas con la implementación inicial. Pendiente de revisión del equipo mediante el PR de `HU-008-backend-dev` hacia `dev`.

## Contexto

Drivique necesita una API compartida por los clientes web y móvil para centralizar usuarios, roles, vehículos, reservas, contratos, pagos, reportes y administración de flota. Ambos clientes consumen la API REST y nunca se conectan directamente a PostgreSQL. Se utiliza un backend y una base de datos comunes.

La app móvil está destinada exclusivamente al rol cliente. Administrador, operador y supervisor trabajan desde la web. La HU-45 de configuración de marca corresponde a la web y al backend cuando requiera persistencia; no implica implementar administración de marca en la app.

## Decisión

Se documenta **Java 21 con Spring Boot 4.0.8**, construido con **Maven Wrapper**, como stack de la base actual del backend. La API utiliza Spring Web MVC y el prefijo `/api`.

La base incluye Spring Data JPA para persistencia, Spring Security para configurar el acceso, Bean Validation para validaciones, springdoc OpenAPI para documentar la API y Actuator para consultar su salud. PostgreSQL 17 se configura para desarrollo mediante Docker Compose.

## Justificación técnica

- Una API común permite mantener las reglas de negocio en el servidor y compartirlas entre web y móvil.
- Java aporta tipado estático; Spring Boot reúne configuración e integración de los componentes utilizados por la API.
- Spring Data JPA permite organizar el acceso a PostgreSQL mediante repositorios y entidades cuando se implementen los módulos de negocio.
- Maven Wrapper permite ejecutar la compilación y las pruebas con la versión de Maven definida por el proyecto.
- OpenAPI facilita describir los contratos que consumirán ambos clientes; Actuator proporciona endpoints de salud.

## Alternativas consideradas en el análisis

| Alternativa | Evaluación para Drivique |
| --- | --- |
| Spring Boot + Java | Seleccionada por la experiencia previa del equipo, la estructura por capas y las herramientas para seguridad, persistencia y transacciones. |
| Node.js + NestJS + TypeScript | Alternativa válida que comparte lenguaje con parte del frontend; exige acordar las herramientas de persistencia y seguridad y no aporta una ventaja suficiente frente a la experiencia existente con Spring. |
| ASP.NET Core + C# + .NET | Alternativa válida; implica aprender un stack nuevo sin una ventaja identificada para los requisitos actuales. C# es el lenguaje, .NET la plataforma y ASP.NET Core el framework de API. |

La comparación recoge los criterios del análisis del proyecto; no constituye un benchmark ni una prueba de superioridad general de un framework.

## Arquitectura y compromisos de diseño

Se mantiene una API organizada por capas: `Controller -> Service -> Repository -> PostgreSQL`, con DTO y mappers para las entradas y salidas, e interfaces para integraciones externas como Wompi. Las reglas críticas de disponibilidad, reservas y pagos se centralizan en servicios con transacciones; su corrección debe comprobarse con pruebas de concurrencia.

Se aplicarán [principios SOLID, patrones y prevención de antipatrones](../../03-design/patrones/patrones-backend.md) de acuerdo con las necesidades de cada funcionalidad. La presencia de Spring Boot no significa que estas capas o controles estén implementados.

La seguridad prevista incluye Spring Security, contraseñas con hash, access tokens JWT de corta duración, refresh tokens revocables y almacenados como hash, autorización por roles y permisos, HTTPS y secretos fuera del repositorio. El backend validará cada solicitud; ocultar pantallas en el frontend no constituye autorización.

El manejo de errores tendrá un contrato uniforme con estado HTTP, código interno, mensaje seguro y fecha. Los errores técnicos se registrarán en el servidor sin exponer SQL, trazas ni tokens al cliente. Los eventos funcionales y de seguridad se conservarán en la auditoría centralizada. Son compromisos de implementación, no funciones terminadas.

## Consecuencias y límites actuales

- El desarrollo requiere JDK 21 y acceso a PostgreSQL. Docker Compose proporciona la base local.
- Se separan los perfiles `dev`, `qa` y `main`; las credenciales de QA y producción se suministran mediante variables de entorno.
- Hibernate tiene `ddl-auto: validate`: los cambios de esquema deben gestionarse mediante migraciones.
- La configuración de seguridad es sin sesión y exige autenticación salvo en salud, información y documentación de la API. **JWT todavía no está implementado** en la base revisada.
- Aún no hay controladores, servicios, entidades ni repositorios de negocio. La selección del stack no implica que los casos de uso estén implementados.
- Las pruebas iniciales utilizan H2 con Flyway desactivado; no acreditan la integración de migraciones con PostgreSQL.

## Pendiente: herramienta de migraciones

La propuesta inicial y la base del backend incluyen **Flyway**, pero el [ADR 0004](0004-motor-base-de-datos.md) establece **Liquibase**. La propuesta también conserva una referencia a Liquibase en sus antipatrones y la conversación posterior asigna las migraciones Liquibase al repositorio `database`. El equipo debe unificar la herramienta y el repositorio responsable antes de integrar cambios de esquema. Este documento registra la discrepancia y no sustituye el ADR de base de datos ni aprueba el uso simultáneo de ambas herramientas sobre el mismo esquema.

## Trazabilidad

- Historia/rama de documentación: `HU-008-backend-dev`.
- Fecha de revisión: 2026-09-08.
- Fuente principal de contexto: `Propuesta-seleccion-backend-Drivique.md` y conversación `Define backend architecture for Driv` del proyecto `Analisis Backend Proyecto Drivique` (2026-09-02). Se incorporan las correcciones posteriores: móvil solo para clientes y sin módulos ajenos al SRS.
- La propuesta mencionaba Spring Boot 3.x con versión exacta por definir al iniciar el repositorio; el código revisado fija 4.0.8. Se registra esta evolución sin presentar 3.x como versión implementada.
- Fuente: [backend, commit 5f26b74](https://github.com/project-drivique/Back-end/tree/5f26b74521c1506b4c06f720f03b6730b8785060), revisado en el clon local, rama `chore/bootstrap-structure-main`.
- Evidencia: `pom.xml`, `README.md`, `docker-compose.yml`, `application.yml`, `SecurityConfig.java` y `application-test.yml` de ese commit.
- Documentos relacionados: [stack técnico](../../07-backend/tech-stack.md) y [estructura del backend](../../07-backend/folder-structure.md).
