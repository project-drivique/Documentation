# ADR 0004: Selección del Motor y Arquitectura de Base de Datos

## Estado
**Aceptado**

## Contexto
El sistema **Drivique** requiere un motor de base de datos robusto para soportar la plataforma Web, la aplicación Móvil y el Backend central. El sistema maneja información transaccional sensible, reservas de vehículos en tiempo real, autenticación de usuarios, roles de acceso y cálculo de tarifas.

Se evaluaron dos paradigmas principales:
1. **Bases de Datos NoSQL / Documentales (MongoDB):** Alta flexibilidad de esquemas, pero menor consistencia relacional estricta y mayor complejidad para garantizar transacciones ACID distribuidas entre entidades fuertemente acopladas (viajes, pagos, usuarios).
2. **Bases de Datos Relacionales (PostgreSQL / MySQL):** Cumplimiento ACID garantizado, integridad referencial mediante llaves foráneas y soporte para operaciones complejas.

## Decisión
Se decide adoptar **PostgreSQL 16 (LTS)** como el motor de base de datos principal del proyecto Drivique, organizado bajo una arquitectura modular de sub-lenguajes SQL (`01_ddl`, `02_dml`, `03_dcl`, `04_tcl`, `05_rollbacks`) y control de cambios mediante Changelogs (`Liquibase`).

## Justificación
1. **Consistencia Transaccional ACID:** Protección contra estados inconsistentes en reservas y pagos simultáneos.
2. **Ecosistema de Extensiones:** Soporte nativo para criptografía (`pgcrypto`), identificadores UUID (`uuid-ossp`) y capacidades geoespaciales (PostGIS).
3. **Escalabilidad y Seguridad:** Soporte para esquemas lógicos, roles granulares y políticas de seguridad a nivel de fila (Row Level Security).
4. **Facilidad de Integración CI/CD:** Compatibilidad con herramientas de versionamiento de esquemas y migraciones idempotentes.

## Consecuencias
* **Positivas:**
  * Estructura de datos altamente consistente y normalizada.
  * Trazabilidad completa y reversibilidad garantizada de todos los cambios de base de datos mediante scripts de rollback.
  * Separación clara de responsabilidades entre definición de datos (DDL), manipulación (DML) y seguridad (DCL).
* **Mitigaciones:**
  * Se requiere seguir rigurosamente el orden de dependencias secuenciales definido en el árbol de carpetas de base de datos y evitar la ejecución manual de cambios no versionados.
