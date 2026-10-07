# Backlog priorizado de Drivique

**Responsable:** Danna Valentina Barrios Penagos · **HU:** HU-DOC-002 · **Fecha:** 2026-10-06
**Estado:** propuesta MoSCoW para revisión del equipo. Prioridad no significa funcionalidad implementada, probada o aprobada.

## 1. Base y reglas de priorización

Este backlog agrupa todos los requisitos RF1 a RF54 de las [fichas funcionales](../01-srs/functional-requirements.md). Usa la misma numeración detallada que la matriz y el [SRS](../01-srs/srs.md); las observaciones de cobertura de implementación permanecen registradas. Cada RF pertenece a un grupo principal; las dependencias entre grupos no duplican su asignación.

- **Must:** imprescindible para completar y controlar el alquiler de forma segura.
- **Should:** importante para la operación o experiencia; admite entrega posterior al núcleo, sin suprimirlo del alcance total.
- **Could:** mejora que puede posponerse sin impedir el recorrido principal.
- **Won't en esta entrega:** exclusión explícita de la entrega actual, revisable mediante acuerdo de alcance.

La propuesta se basa en riesgo, valor y dependencias. No convierte automáticamente las prioridades antiguas Alta/Media/Baja en MoSCoW ni asigna fechas, puntos o sprints sin estimación del equipo.

## 2. Módulos funcionales

| ID | Módulo / resultado | MoSCoW | RF de origen | Dependencias | Justificación |
| --- | --- | --- | --- | --- | --- |
| BL-01 | Identidad y acceso | Must | RF2–RF7, RF30–RF31 | Acceso seguro y autorización para los demás módulos. | Sin autenticación y permisos no se pueden proteger operaciones ni datos. |
| BL-02 | Presencia pública y navegación | Should | RF1, RF8, RF14 | BL-01 para acciones protegidas. | Facilita descubrimiento y acceso; puede entregarse después del núcleo transaccional. |
| BL-03 | Catálogo y selección de vehículo | Must | RF9–RF13 | BL-11: ciudades, sedes y flota. | Permite elegir un vehículo disponible antes de reservar. |
| BL-04 | Reserva y cotización | Must | RF19–RF22 | BL-01, BL-03, BL-11; reglas comerciales de BL-13. | Define fechas, coberturas, datos de conductor, cupón y total de la reserva. |
| BL-05 | Pagos digitales y recaudo presencial | Must | RF23–RF24, RF47 | BL-04; Wompi y autorización de caja. | La reserva necesita pago confirmado o vencimiento controlado de efectivo. |
| BL-06 | Documentación y contratos | Must | RF25–RF26, RF42 | BL-01, BL-04, BL-05. | La entrega exige documentación revisada y contrato firmado. |
| BL-07 | Entrega, PIN e inspección | Must | RF27, RF50, RF52 | BL-05, BL-06; disponibilidad operativa de la sede. | Controla la autorización y evidencia de entrega del vehículo. |
| BL-08 | Devolución e incidencias | Must | RF41, RF53 | BL-07 y tarifas autorizadas. | Cierra el alquiler, registra novedades y restablece disponibilidad. |
| BL-09 | Reservas y perfil del cliente | Must | RF15, RF28–RF29 | BL-01, BL-04. | El cliente necesita seguimiento de sus reservas y datos de contacto vigentes. |
| BL-10 | Favoritos, notificaciones y ayuda | Should | RF16–RF18, RF32–RF33 | BL-01 y canales externos de soporte. | Mejora seguimiento y asistencia; las confirmaciones transaccionales permanecen en los módulos Must. |
| BL-11 | Administración de cobertura y operación | Must | RF35–RF40 | BL-01; configuración inicial de sedes y flota. | Provee datos y permisos necesarios para operar y reservar. |
| BL-12 | Indicadores y reportes | Should | RF34, RF44 | BL-05, BL-08 y datos de operación consistentes. | Apoya decisiones; no sustituye registros de pago y auditoría obligatorios. |
| BL-13 | Promociones y cupones | Should | RF43, RF54 | BL-11 y reglas de BL-04. | Permite campañas generales y locales; validación de cupones sigue siendo obligatoria cuando se habiliten. |
| BL-14 | Marca y ficha operativa de sucursal | Could | RF45, RF51 | BL-11. | La configuración avanzada puede posponerse usando información básica validada de la sede. |
| BL-15 | Auditoría y notificaciones de sede | Must | RF46, RF48 | BL-01 y eventos de los módulos operativos. | Conserva evidencia de acciones críticas y avisa al personal sobre eventos de operación. |
| BL-16 | Reseñas y respuesta oficial | Should | RF49 | BL-09, BL-11; requisitos de publicación del cliente. | Gestiona reputación; el detalle de reseñas con fotos necesita reconciliación en los RF. |

Las funciones del cliente se presentan en la app y en el portal cliente web. La app no tiene panel administrativo; la web sí incluye dicho panel. Las funciones de administración y operación corresponden al panel web, con separación entre administración general y sucursal. El alcance por rol prevalece sobre la simple agrupación por número de RF.

## 3. Calidad y plataforma

| ID | Requisito transversal | MoSCoW propuesto | Referencia | Evidencia requerida |
| --- | --- | --- | --- | --- |
| BL-17 | Rendimiento y capacidad | Must | RNF1, RNF10 | Pruebas de tiempos y carga con entorno y umbrales acordados. |
| BL-18 | Usabilidad, accesibilidad y compatibilidad | Must | RNF2, RNF5 | Revisión de recorridos, navegadores y dispositivos definidos. |
| BL-19 | Internacionalización en cinco variantes | Must | RNF3 | Español, inglés, francés, portugués y portugués de Brasil; validar correspondencia `br` / `pt-BR`. |
| BL-20 | Temas claro y oscuro | Should | RNF4 | Contraste, legibilidad y persistencia de preferencia. |
| BL-21 | Seguridad y autorización | Must | RNF6 | Control de usuario/sucursal, protección de datos y validación de pagos. |
| BL-22 | Persistencia y migraciones | Must | RNF7 | Migraciones versionadas y procedimiento de recuperación validado. |
| BL-23 | Disponibilidad y resiliencia | Must | RNF8, RNF12 | Recuperación de fallos sin duplicar cobros; objetivos sujetos a pruebas. |
| BL-24 | Mantenibilidad y documentación | Must | RNF9, RNF11 | Revisión de calidad, SRS, API, diagramas y manuales correspondientes. |

## 4. Exclusiones de esta entrega (Won't)

| ID | Función excluida | Motivo |
| --- | --- | --- |
| BL-25 | App administrativa móvil y entrega nativa iOS | La entrega definida es cliente Android y administración web; un script iOS no compromete una entrega. |
| BL-26 | Contabilidad avanzada y facturación electrónica fiscal | Excluidas por las restricciones del producto; reportes operativos sí están incluidos. |
| BL-27 | Confirmación de reservas, pagos y entregas sin servidor | Requieren disponibilidad y validación central; recuperación de borradores de RNF12 sí se incluye. |
| BL-28 | GPS, telemática y aplicación independiente de conductores | No cuentan con especificación de alcance comprometida en las fuentes revisadas. |

## 5. Orden sugerido y condiciones de entrada

1. Acordar las diferencias de requisitos y aprovisionar identidad, autorización, ciudades, sucursales y flota (BL-01, BL-11).
2. Integrar catálogo, reserva y seguimiento del cliente (BL-03, BL-04, BL-09).
3. Integrar pagos, vencimiento de efectivo y documentación/contratos (BL-05, BL-06).
4. Integrar entrega, PIN, devolución e incidencias (BL-07, BL-08).
5. Completar funcionalidades Should/Could según capacidad y validación de negocio.

Seguridad, auditoría, calidad, idiomas, migraciones y pruebas se trabajan durante las fases correspondientes. No se dejan para después de la operación del flujo principal.

## 6. Desglose en historias y criterio de cierre

Cada grupo se divide en HU pequeñas con la [plantilla oficial](user-stories/HU-001-plantilla.md). Se registra actor, valor, RF/RNF, prioridad, dependencias y escenarios Gherkin de éxito, error y autorización cuando corresponda. No hay historias individuales creadas o estimadas automáticamente por esta tabla.

Un elemento se cierra cuando cumple sus criterios, tiene evidencia de validación y revisión del equipo según la [Definition of Done](../08-development/definition-of-done.md). El cierre de una HU documental no implica cierre de funcionalidades del software.

## 7. Decisiones antes de aprobar la línea base

- Numeración de fichas, resumen, rangos de módulos y matriz sincronizada. Falta completar las relaciones UML y cobertura de capacidades señaladas en la matriz.
- Alcance confirmado: app solo cliente y web cliente/administración. PIN de entrega definido en exactamente 4 dígitos. El detalle de domicilios/reseñas con fotos y la implementación del PIN requieren sus HU correspondientes.
- El equipo debe validar las prioridades MoSCoW y registrar ajustes antes de comprometer una entrega.
- Los objetivos RNF necesitan condiciones y evidencia de pruebas; no se consideran satisfechos por estar escritos.

Fuentes: [visión y alcance](vision-y-alcance.md), [RF](../01-srs/functional-requirements.md), [RNF](../01-srs/non-functional-requirements.md) y SRS_Drivique_Consolidado_2026.pdf aportado por Danna.
