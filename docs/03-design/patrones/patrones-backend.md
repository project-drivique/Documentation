# Patrones y principios de diseño del backend

## Contexto y estado

Lineamientos del proyecto `Analisis Backend Proyecto Drivique`, recogidos en `Propuesta-seleccion-backend-Drivique.md` y su conversación de análisis del 2026-09-02. Complementan el [ADR 0003](../../04-architecture/decisions/0003-stack-backend.md). Son criterios de diseño para el desarrollo; no certifican funcionalidades implementadas.

## Arquitectura por capas

`Controller -> Service -> Repository -> PostgreSQL`

Los controladores reciben solicitudes HTTP; los servicios aplican reglas de negocio; los repositorios acceden a datos. Las entidades JPA representan la persistencia y los DTO/mappers delimitan el contrato de la API. Web y app consumen la misma API.

## Principios SOLID

| Principio | Aplicación en Drivique |
| --- | --- |
| Responsabilidad única | Separar reservas, generación de documentos y envío de notificaciones en componentes con responsabilidades específicas. |
| Abierto/cerrado | Ampliar reglas de tarifas o descuentos mediante estrategias cuando existan variantes reales. |
| Sustitución de Liskov | Las implementaciones de una interfaz de integración deben respetar el mismo contrato, incluidos resultados y errores. |
| Segregación de interfaces | Definir interfaces pequeñas ajustadas a las operaciones que necesitan sus consumidores. |
| Inversión de dependencias | Un servicio de pagos depende de una abstracción de pasarela; el adaptador de Wompi implementa esa abstracción. |

## Patrones previstos

| Patrón | Uso |
| --- | --- |
| Repository | Encapsular persistencia con Spring Data JPA. |
| Service Layer | Centralizar reglas y límites transaccionales de reservas, contratos y pagos. |
| DTO / Mapper | Controlar datos de entrada y salida sin exponer entidades ni campos sensibles. |
| Strategy | Representar variantes de reglas de tarifas o descuentos cuando lo exija una HU. |
| Factory Method | Crear implementaciones de notificación según el canal requerido. Los ejemplos de email, SMS y WhatsApp del análisis no autorizan agregar canales fuera del alcance funcional. |
| Adapter | Aislar la API de Wompi del resto del dominio. |
| Observer / eventos | Desacoplar notificaciones y auditoría de eventos de negocio; coordinar el registro con la transacción para evitar eventos de operaciones fallidas. |
| Singleton gestionado por Spring | Usar servicios sin estado compartido de usuario. No almacenar sesiones ni tokens de clientes en campos mutables de servicios compartidos. |

Factory Method se implementa en Java; la base conserva la información de notificaciones. Los triggers de base de datos y los eventos de aplicación deben coordinarse para evitar duplicar el mismo evento de auditoría.

## Autenticación y errores

Un `AuthService` del frontend puede organizar la experiencia de sesión, pero no reemplaza la seguridad del servidor. El diseño contempla filtros de Spring Security que validen JWT y permisos en cada solicitud, access tokens breves y refresh tokens revocables almacenados como hash.

El contrato de errores previsto debe incluir estado HTTP, código interno, mensaje seguro y fecha. Ejemplos: `400` para datos inválidos, `401` para autenticación ausente o inválida, `403` para permisos insuficientes, `404` para recursos inexistentes y `409` para conflictos de disponibilidad. No se devolverán trazas, SQL ni tokens al consumidor. Los detalles técnicos pertenecen a logs del servidor y los eventos funcionales o de seguridad a la auditoría centralizada.

## Antipatrones que se deben evitar

| Antipatrón | Criterio de prevención |
| --- | --- |
| Controladores o servicios gigantes | Separar HTTP, reglas de negocio, persistencia e integraciones. |
| Entidades JPA expuestas por la API | Utilizar DTO y mappers. |
| Reglas críticas duplicadas en web y app | Centralizarlas y validarlas en la API. |
| Conexión directa del frontend a PostgreSQL | Acceder exclusivamente mediante el backend. |
| Seguridad basada en ocultar pantallas | Comprobar autenticación y permisos en cada endpoint. |
| Singleton con estado mutable de usuario | Mantener servicios sin estado de sesión compartido. |
| Cambios automáticos de esquema en producción | Mantener `ddl-auto: validate` y migraciones versionadas; resolver Flyway/Liquibase conforme al ADR. |
| Patrones sin una necesidad concreta | Aplicarlos cuando resuelvan una variación o responsabilidad real. |

## Verificación al implementar

Cada HU deberá probar las reglas que incorpore: autorización por rol, validaciones, errores, transacciones y conflictos de reserva, según corresponda. La prueba inicial de contexto con H2 no sustituye pruebas de integración con PostgreSQL ni demuestra el cumplimiento de estos lineamientos.
