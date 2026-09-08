# Estructura de Carpetas del Backend

## Base actual

Estructura observada en el [backend, commit 5f26b74](https://github.com/project-drivique/Back-end/tree/5f26b74521c1506b4c06f720f03b6730b8785060). Actualmente contiene el arranque, configuración y manejo común de errores; los módulos de negocio todavía no están implementados.

```text
drivique-api/
├── .github/workflows/ci.yml
├── .mvn/wrapper/maven-wrapper.properties
├── src/
│   ├── main/
│   │   ├── java/com/drivique/api/
│   │   │   ├── DriviqueApiApplication.java
│   │   │   ├── config/SecurityConfig.java
│   │   │   └── common/exception/ApiExceptionHandler.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-qa.yml
│   │       ├── application-main.yml
│   │       └── db/migration/
│   └── test/
│       ├── java/com/drivique/api/DriviqueApiApplicationTests.java
│       └── resources/application-test.yml
├── .env.example
├── docker-compose.yml
├── Dockerfile
├── mvnw
├── mvnw.cmd
├── pom.xml
└── README.md
```

## Responsabilidades

| Ruta | Responsabilidad |
| --- | --- |
| `DriviqueApiApplication.java` | Punto de entrada de Spring Boot |
| `config/` | Configuración transversal; incluye las reglas iniciales de seguridad |
| `common/exception/` | Manejo centralizado de excepciones |
| `resources/application*.yml` | Configuración común y por entorno |
| `resources/db/migration/` | Directorio reservado para migraciones de Flyway; pendiente de alinear con Liquibase |
| `src/test/` | Prueba inicial de contexto y configuración de H2 |
| `.github/workflows/ci.yml` | Verificación de compilación y pruebas mediante Maven |
| `docker-compose.yml` | PostgreSQL para desarrollo local |
| `Dockerfile` | Construcción de la imagen de la API |

## Evolución propuesta

Al implementar funcionalidades, separar controladores HTTP, servicios de negocio, repositorios, entidades y DTO. Esta separación procede del análisis principal del proyecto: `Controller -> Service -> Repository -> PostgreSQL`, con DTO, mappers e integraciones externas. Dichas capas aún no existen en la base revisada. Aplicar los [patrones y principios SOLID](../03-design/patrones/patrones-backend.md) al desarrollar cada módulo.

Consultar el [stack técnico](tech-stack.md) y el [ADR 0003](../04-architecture/decisions/0003-stack-backend.md) para las decisiones y los pendientes de integración.
