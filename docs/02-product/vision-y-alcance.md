# Visión y alcance de Drivique

| Campo | Valor |
| --- | --- |
| Historia documental | HU-DOC-002 |
| Responsable | Danna Valentina Barrios Penagos |
| Fecha | 2026-10-06 |
| Estado | Propuesta documentada para revisión del equipo |
| Base de requisitos | RF1 a RF54 y RNF1 a RNF12 |

## 1. Problema y oportunidad

Las reservas manuales, los contratos dispersos, los pagos sin integración y la falta de información compartida sobre la flota dificultan la operación de alquiler de vehículos. Drivique centraliza el recorrido del cliente y la gestión de las sucursales para reducir errores, facilitar el seguimiento de cada reserva y conservar evidencia de las operaciones.

## 2. Visión de producto

Para clientes que necesitan alquilar un vehículo y empresas que administran flotas y sucursales en Colombia, **Drivique** es una plataforma de alquiler que permite consultar disponibilidad, reservar, pagar, formalizar contratos y gestionar entregas y devoluciones desde un sistema compartido. La solución ofrece una app móvil para el cliente final y un panel web para la administración general y la operación de sucursal, conectados a una API y una base de datos comunes.

El SRS vigente también especifica un portal web para clientes. Se conserva como canal del cliente descrito por los requisitos; no se convierte la app móvil en una herramienta administrativa. Esta diferencia respecto del enfoque de dos plataformas del plan se registra en el [SRS consolidado](../01-srs/srs.md).

## 3. Usuarios y responsabilidades

| Actor | Necesidad | Ámbito |
| --- | --- | --- |
| Visitante | Conocer el servicio y consultar el catálogo sin reservar hasta autenticarse. | Accesos públicos; RF1, RF3 y RF8. |
| Cliente | Gestionar su cuenta, elegir un vehículo, reservar, pagar y consultar contrato y seguimiento. | App móvil y portal cliente descrito por RF1 a RF33. |
| Administrador general / Super Administrador | Administrar ciudades, sucursales, flota, usuarios, permisos, promociones, reportes y auditoría. | Panel web; acceso global sujeto a autorización. |
| Encargado de sucursal | Operar reservas, caja, documentación, entregas, devoluciones y reseñas de su sede. | Panel web; datos y acciones limitados a la sucursal asignada. |
| Conductor de entrega | Participar en la entrega asignada y en la validación operativa del PIN. | Actor operativo de RF27; no se presupone una app o rol administrativo independiente. |

Operador y supervisor aparecen en documentos generales y en el PDF. Su equivalencia con los permisos actuales debe validarse en RF40; aquí no se les asignan permisos nuevos.

## 4. Alcance incluido

### 4.1 App móvil del cliente final

- Registro, verificación de cuenta, autenticación y recuperación de acceso.
- Catálogo, búsqueda, filtros, detalle del vehículo y navegación del cliente.
- Configuración de fechas y sucursales, coberturas y adicionales, datos de conductor y cupones, resumen y selección de pago.
- Pago digital mediante Wompi y selección de pago presencial con seguimiento del vencimiento.
- Carga documental, contrato descargable y presentación del PIN de entrega.
- Historial de reservas, perfil, seguridad de cuenta, favoritos, notificaciones y soporte conforme a los RF correspondientes.
- Preferencias de idioma y tema claro/oscuro como requisitos transversales, no como RF nuevos.

### 4.2 Panel web de administración

- Indicadores y reportes para administración y sucursal (RF34 y RF44).
- Gestión de ciudades, sedes, vehículos, reservas, usuarios, administradores y permisos (RF35 a RF40).
- Incidencias, contratos, promociones, configuración de marca y auditoría (RF41 a RF46).
- Confirmación de efectivo, notificaciones de sede, reseñas con respuesta oficial inmutable, inspección de entrega, perfil de sede, validación de PIN, inspección de devolución y cupones locales (RF47 a RF54).
- Validación documental operativa descrita en RF25 y participación de sucursal en RF24, RF26 y RF27.

### 4.3 Servicios compartidos

La API de backend concentra autorización, reglas de negocio, persistencia y comunicación con servicios externos. La base de datos relacional y las migraciones Liquibase mantienen el modelo común. Los flujos de entrega a domicilio, asignación de conductor, reseñas con hasta tres fotos y contacto por WhatsApp forman parte del plan de actualización; su detalle debe reconciliarse con el SRS antes de cerrar su trazabilidad.

## 5. Límites de la entrega

- No se incluye una aplicación administrativa móvil ni una entrega nativa iOS comprometida.
- No se incluye contabilidad avanzada ni facturación electrónica con validez fiscal.
- No se incluye completar reservas, confirmar pagos o autorizar entregas sin comunicación con el servidor. RNF12 sí contempla recuperación de borradores y manejo de fallos de conexión.
- No se presume integración directa con una API Nequi por la denominación del PIN de entrega. Nequi como medio de pago pertenece al flujo Wompi de RF23.
- No se añaden funciones de GPS, telemática o aplicaciones independientes para conductores que no estén especificadas en los requisitos.

## 6. Objetivos y evidencia de éxito

| Objetivo | Evidencia para evaluar su cumplimiento |
| --- | --- |
| Permitir el recorrido completo del alquiler | Validar un flujo de catálogo, reserva, pago, contrato, entrega y devolución, con sus escenarios de error. |
| Centralizar la operación de las sedes | Verificar que el encargado opera únicamente su sucursal y el administrador utiliza los permisos autorizados. |
| Proteger pagos y disponibilidad | Verificar confirmación de pago en servidor, vencimiento de efectivo y ausencia de confirmaciones o asignaciones duplicadas. |
| Mantener trazabilidad | Relacionar RF, HU, diagramas y pruebas usando identificadores estables. |
| Ofrecer una experiencia accesible | Evaluar idiomas, temas, compatibilidad, accesibilidad y recuperación de errores contra los RNF. |

Estos son objetivos de aceptación; no certifican que el software ya los cumpla. Los umbrales técnicos se consultan en las fichas RNF y no se sustituyen por métricas inventadas.

## 7. Supuestos y dependencias

Los clientes disponen de conexión para operaciones confirmadas y documentación de conducción válida. La empresa mantiene flota, tarifas, sedes y disponibilidad actualizadas. La operación depende de la API, la base de datos, Wompi, el servicio de correo y los canales de soporte. El acceso a documentos y datos personales requiere autorización por usuario y ámbito de sucursal.

Las versiones de frameworks, el modelo físico y la infraestructura se justifican en las HU de arquitectura y desarrollo. Su presencia en un documento no acredita un despliegue productivo ni resultados de pruebas.

## 8. Priorización y control de cambios

El [backlog](backlog.md) propone una priorización MoSCoW y cubre todos los RF. Cualquier ampliación o cambio requiere identificar la necesidad, acordar el alcance y actualizar RF, criterios, HU y trazabilidad. Danna consolida el producto; Laura valida las fuentes de requisitos; el equipo revisa las prioridades y las decisiones pendientes.

## 9. Fuentes

- [Requisitos funcionales](../01-srs/functional-requirements.md): fichas detalladas RF1 a RF54.
- [Requisitos no funcionales](../01-srs/non-functional-requirements.md): RNF1 a RNF12.
- [Problema](problem-statement.md), [objetivos](goals-and-objectives.md) y [usuarios](users-and-personas.md).
- [Restricciones y supuestos existentes](constraints-and-assumptions.md), con diferencias registradas en el SRS consolidado.
- SRS_Drivique_Consolidado_2026.pdf, suministrado por Danna: propósito, alcance y fichas de requisitos. El PDF no está incorporado al repositorio en esta HU.
- Plan-Actualizacion-Documentacion-y-Drive-Drivique.md, suministrado por Danna: alcance de HU-DOC-002 y módulos de actualización.
