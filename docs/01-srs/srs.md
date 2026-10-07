# Especificación de Requisitos de Software (SRS) - Drivique

| Control del documento | Valor |
| --- | --- |
| Proyecto | Drivique - Sistema integral de alquiler de vehículos |
| Versión documental | 1.0 propuesta |
| Fecha de consolidación | 2026-10-06 |
| Responsable de consolidación | Danna Valentina Barrios Penagos |
| Historia de origen | HU-DOC-002 |
| Estado | Completo para revisión documental; línea base pendiente de aprobación |
| Estructura solicitada | IEEE 830-1998: introducción, descripción general y requisitos específicos |
| Inventario | 54 RF y 12 RNF |

Este documento consolida la especificación en Markdown. Las fichas RF/RNF enlazadas forman parte de la especificación y conservan el detalle de entradas, salidas, reglas, situaciones anormales y aceptación. Se evita duplicar ese contenido en varias fuentes con versiones diferentes. Esta consolidación no acredita que el software esté implementado, probado o desplegado.

## 1. Introducción

### 1.1 Propósito

Definir el comportamiento, alcance, interfaces y restricciones de Drivique para orientar desarrollo, diseño, pruebas y revisión. La audiencia incluye al equipo de producto, desarrollo web/móvil/backend, responsables de datos, QA y evaluadores del proyecto. El SRS es la referencia compartida para derivar historias, modelos y evidencia de aceptación.

### 1.2 Alcance y objetivos

Drivique digitaliza el alquiler de vehículos en Colombia: consulta de flota, reserva, pagos, documentación, contrato, entrega, devolución y seguimiento. Centraliza la operación de ciudades y sucursales, administración de usuarios y permisos, promociones, incidencias, indicadores y auditoría.

El alcance confirmado comprende una **app móvil exclusiva para el cliente final, sin panel administrativo**, y una **web con portal para clientes y panel administrativo** para Administrador general y Encargado de sucursal. Ambas plataformas consumen la misma API y base de datos.

La [visión y alcance](../02-product/vision-y-alcance.md) detalla actores, inclusiones, exclusiones y objetivos. No se incluyen contabilidad avanzada, facturación fiscal electrónica, operación transaccional sin servidor ni entrega nativa iOS comprometida.

### 1.3 Definiciones, acrónimos y abreviaturas

| Término | Significado en este documento |
| --- | --- |
| SRS | Especificación de Requisitos de Software. |
| RF / RNF | Requisito funcional / requisito no funcional. |
| HU | Historia de usuario con actor, necesidad, valor y aceptación. |
| MoSCoW | Priorización Must, Should, Could y Won't en esta entrega. |
| API REST | Interfaz de comunicación entre clientes y backend. |
| JWT | Token utilizado en el control de sesión y autorización. |
| OTP | Código temporal para verificación de cuenta. |
| PIN de entrega | Código numérico de exactamente 4 dígitos, conservando ceros iniciales; asociado a la reserva para autorizar entrega y distinto del OTP de correo y del código de efectivo. |
| COP | Peso colombiano, moneda de procesamiento de pagos del proyecto. |
| Wompi | Servicio externo de pagos digitales especificado en RF23. |
| Liquibase | Herramienta de versionamiento de cambios de base de datos. |

Complemento: [glosario del producto](../02-product/glossary.md).

### 1.4 Referencias y criterio de consolidación

| Fuente | Uso |
| --- | --- |
| [functional-requirements.md](functional-requirements.md) | Identificadores y fichas detalladas RF1 a RF54. |
| [non-functional-requirements.md](non-functional-requirements.md) | Fichas RNF1 a RNF12 y sus objetivos de calidad. |
| [acceptance-criteria.md](acceptance-criteria.md) | Criterios globales; sus marcas de completitud requieren evidencia. |
| [matriz-trazabilidad.md](matriz-trazabilidad.md) | Numeración sincronizada con las fichas; relaciones observadas y cobertura pendiente identificadas. |
| [Backlog](../02-product/backlog.md) y [plantilla de HU](../02-product/user-stories/HU-001-plantilla.md) | Priorización propuesta y formato de historias verificables. |
| SRS_Drivique_Consolidado_2026.pdf, aportado por Danna | Documento de 84 páginas: contexto, alcance, fichas RF/RNF y casos de uso. |
| Plan-Actualizacion-Documentacion-y-Drive-Drivique.md, aportado por Danna | Responsabilidades y cuatro entregables de HU-DOC-002. |

Los dos archivos aportados no están versionados en este repositorio por esta HU; sus nombres identifican las fuentes consultadas. En esta consolidación se usan las **fichas detalladas RF/RNF** para numeración y comportamiento. Cuando el resumen, el PDF, el plan o la matriz discrepan, se conserva la discrepancia en la sección 4 y se solicita su resolución en revisión; no se presenta una decisión provisional como aprobada.

### 1.5 Organización del documento

La sección 2 describe el producto y su entorno. La sección 3 especifica interfaces, inventario funcional, calidad, datos y reglas de verificación. La sección 4 registra diferencias y aprobación. El anexo A ofrece comprobación de los entregables documentales.

## 2. Descripción general

### 2.1 Perspectiva del producto

El producto integra clientes web/móvil, una API backend Spring Boot y persistencia relacional común. Presentación, lógica de negocio y acceso a datos tienen responsabilidades separadas. Wompi, correo y soporte son dependencias externas; las interfaces no deben decidir por sí solas si un pago fue confirmado o si un usuario tiene permiso sobre una sucursal.

El plan define PostgreSQL 17 y Liquibase. Las versiones y decisiones de stack se validan en los [ADRs](../04-architecture/decisions/0001-stack-web.md), el [ADR móvil](../04-architecture/decisions/0002-stack-mobile.md) y la [arquitectura](../04-architecture/overview.md), cuya actualización corresponde a HU-DOC-003. No se presupone que estos documentos estén completos.

### 2.2 Funciones del producto

El recorrido principal comprende acceso, consulta de disponibilidad, selección de fechas y condiciones, datos de conductor, precio/cupón, pago, documentación, contrato, entrega con PIN y devolución. El cliente puede consultar reservas y perfil; la empresa administra recursos, permisos, caja, contratos, incidencias y reportes. Las funciones complementarias incluyen ayuda, favoritos, notificaciones, promociones y reputación de sucursal.

### 2.3 Características de los usuarios

El cliente usa la app o el portal cliente para sus propios datos y reservas. El Administrador general opera el conjunto autorizado del negocio. El Encargado de sucursal realiza operaciones limitadas a su sede. El visitante consulta funciones públicas. El conductor de entrega participa en operaciones descritas por RF27, sin que esto defina una plataforma independiente.

Operador y supervisor aparecen en fuentes generales; no se les atribuyen permisos nuevos hasta reconciliar su relación con RF40. Consultar [usuarios existentes](../02-product/users-and-personas.md) y [visión](../02-product/vision-y-alcance.md).

### 2.4 Restricciones

- Confirmación central de disponibilidad, autorización, pagos y cambios de estado.
- Procesamiento monetario en COP según las reglas del proyecto y Wompi.
- App del cliente orientada a Android; administración en web.
- Protección de credenciales, documentos, datos personales y evidencia de operación conforme a RNF6.
- Evolución del esquema mediante migraciones versionadas y procedimientos de recuperación evaluados.
- Compatibilidad, accesibilidad y dispositivos sujetos a RNF2/RNF5 y a la matriz de pruebas acordada.

### 2.5 Suposiciones y dependencias

Se presupone documentación de conducción válida, flota y tarifas actualizadas y personal autorizado para operar cada sede. Se requiere disponibilidad de API, base de datos y servicios externos para completar transacciones. Fallos de red deben manejarse según RNF12 sin confirmar reservas o pagos localmente. Los datos de configuración y pruebas deben distinguirse de datos productivos.

### 2.6 Distribución y evolución de requisitos

El [backlog](../02-product/backlog.md) propone MoSCoW. Los grupos Must sustentan el alquiler y sus controles; los Should/Could se ordenan según capacidad. Won't identifica exclusiones de esta entrega. Los cambios de alcance deben actualizar RF, criterios, historias, diagramas y pruebas conservando identificadores y revisión del equipo.

## 3. Requisitos específicos

### 3.1 Interfaces externas

#### 3.1.1 Interfaces de usuario

La app presenta el recorrido del cliente: autenticación, catálogo, reserva, documentación, contrato, historial y perfil. El panel web presenta vistas de administración global y de sede, filtradas por permiso y sucursal. El portal cliente web conserva las funciones especificadas por las fichas RF. Las interfaces deben mostrar validaciones, estados de carga/vacío/error, plazos de pago y resultado de acciones. Idioma y tema son transversales RNF3/RNF4.

#### 3.1.2 Interfaces de hardware

Se utilizan dispositivos Android para la app y equipos con navegador para web. Pantalla táctil o puntero permiten capturar firma; la carga de archivos/fotos corresponde a flujos especificados. No se exige hardware biométrico, GPS vehicular ni terminal de recaudo integrado en esta línea documental. RNF5 contiene la compatibilidad propuesta; sus divergencias con fuentes anteriores requieren revisión.

#### 3.1.3 Interfaces de software

- API backend: solicitudes/respuestas de los módulos y autorización en servidor. Endpoints concretos se contrastan con la documentación API y el código; las rutas de la matriz no se certifican aquí.
- Wompi: inicio de pago y confirmación asíncrona validada por backend; el regreso del usuario a la interfaz no es evidencia suficiente de pago aprobado.
- Base relacional y Liquibase: persistencia y migraciones del esquema común.
- Correo: verificación de cuenta, recuperación de acceso y avisos definidos.
- Soporte: FAQ/contacto y widget descrito en RF18/RF33; WhatsApp de entregas se detalla mediante reconciliación del plan.
- Documentos: carga documental y generación/consulta de contratos PDF; exportaciones administrativas según RF44.

#### 3.1.4 Interfaces de comunicación

La comunicación con la API debe proteger datos y credenciales según RNF6. Los contratos deben definir autorización, formatos, errores y validaciones. RF48 describe notificaciones operativas por WebSocket; su contrato y evidencia se revisan con backend. Deben controlarse reintentos para evitar pagos duplicados y no exponer datos sensibles en mensajes de error.

### 3.2 Requisitos funcionales

Las 54 fichas de [functional-requirements.md](functional-requirements.md) se incorporan por referencia como parte normativa de esta propuesta. Cada ficha define actor, comportamiento, entrada, salida, acción, situaciones anormales y aceptación. El inventario siguiente permite comprobar completitud y localizar el grupo principal del backlog. No utiliza la numeración antigua del plan para identificar los flujos.

| ID | Nombre de la ficha detallada | Backlog |
| --- | --- | --- |
| RF1 | Página de inicio (visitante sin sesión) | BL-02 |
| RF2 | Redirección tras inicio de sesión | BL-01 |
| RF3 | Registro de usuario | BL-01 |
| RF4 | Verificación de identidad con doble factor (2FA / Código de Correo) | BL-01 |
| RF5 | Inicio de sesión | BL-01 |
| RF6 | Recuperar contraseña | BL-01 |
| RF7 | Inicio de sesión con rol (Administrador y Encargado de sucursal) | BL-01 |
| RF8 | Acceso modo invitado sin registro | BL-02 |
| RF9 | Encabezado y buscador del catálogo | BL-03 |
| RF10 | Filtros del catálogo | BL-03 |
| RF11 | Ordenar resultados del catálogo | BL-03 |
| RF12 | Tarjetas de vehículos | BL-03 |
| RF13 | Ver detalles de un vehículo | BL-03 |
| RF14 | Menú de navegación principal catálogo | BL-02 |
| RF15 | Sección menú Mis Reservas | BL-09 |
| RF16 | Sección menú Mis Favoritos | BL-10 |
| RF17 | Sección menú Notificaciones (Cliente) | BL-10 |
| RF18 | Sección menú Soporte | BL-10 |
| RF19 | Configuración de reserva, fechas, horarios y sucursales (Paso 1 del Wizard) | BL-04 |
| RF20 | Selección de coberturas de protección y servicios adicionales (Paso 2 del Wizard) | BL-04 |
| RF21 | Datos del conductor, comprobación de licencia y cupones de descuento (Paso 3 del Wizard) | BL-04 |
| RF22 | Resumen financiero final y selección de método de pago (Paso 4 del Wizard) | BL-04 |
| RF23 | Procesamiento de pago digital en línea (Pasarela Virtual Wompi) | BL-05 |
| RF24 | Cobro presencial en efectivo en sucursal con plazo de vencimiento dinámico | BL-05 |
| RF25 | Carga y verificación documental de identidad y licencia (Cédula y Licencia) | BL-06 |
| RF26 | Generación y firma electrónica del contrato digital de alquiler | BL-06 |
| RF27 | Generación y verificación del código PIN de seguridad para entrega y recogida | BL-07 |
| RF28 | Historial, consulta y seguimiento de reservas del cliente | BL-09 |
| RF29 | Ver y editar información personal | BL-09 |
| RF30 | Cambiar contraseña | BL-01 |
| RF31 | Cerrar sesión | BL-01 |
| RF32 | Onboarding para nuevos usuarios | BL-10 |
| RF33 | Chat flotante de soporte (Widget Tawk.to) | BL-10 |
| RF34 | Dashboard del administrador y sucursal | BL-12 |
| RF35 | Gestión de ciudades | BL-11 |
| RF36 | Gestión de Sucursales | BL-11 |
| RF37 | Gestión de vehículos (Flota) | BL-11 |
| RF38 | Gestión de reservas | BL-11 |
| RF39 | Gestión de usuarios y clientes | BL-11 |
| RF40 | Gestión de administradores, roles y permisos | BL-11 |
| RF41 | Gestión de reportes de incidencias de vehículos | BL-08 |
| RF42 | Gestión de contratos | BL-06 |
| RF43 | Gestión de promociones, cupones y ofertas destacadas | BL-13 |
| RF44 | Reportes administrativos | BL-12 |
| RF45 | Configuración de marca e identidad visual | BL-14 |
| RF46 | Auditoría y registro de actividad | BL-15 |
| RF47 | Confirmación de pago en efectivo (sucursal) | BL-05 |
| RF48 | Centro de notificaciones operativas de sucursal | BL-15 |
| RF49 | Moderación y respuesta a reseñas de sucursal | BL-16 |
| RF50 | Inspección y entrega del vehículo | BL-07 |
| RF51 | Perfil Público y Operativo de Sucursal | BL-14 |
| RF52 | Validación de Entrega con PIN Nequi | BL-07 |
| RF53 | Formulario de Inspección de Devolución | BL-08 |
| RF54 | Gestión de Cupones Promocionales por Sucursal | BL-13 |

RF25, RF26 y RF27 incluyen colaboración del cliente y la sucursal. La asignación de plataforma se determina por actor y acción, no mediante un corte automático de numeración. El rango administrativo detallado comienza en RF34. El PIN de entrega de RF27/RF52 tiene exactamente 4 dígitos numéricos y no altera el OTP de correo de 6 dígitos.

### 3.3 Requisitos no funcionales y rendimiento

Las fichas de [non-functional-requirements.md](non-functional-requirements.md) forman parte de la especificación. Sus cifras son objetivos, no resultados medidos. Las diferencias internas de umbrales se registran para acordar una única condición de aceptación antes de certificar cumplimiento.

| ID | Categoría | Verificación prevista |
| --- | --- | --- |
| RNF1 | Rendimiento | Medir latencia y carga con volumen de datos, entorno y percentiles definidos. |
| RNF2 | Usabilidad y accesibilidad | Evaluar tareas del usuario y accesibilidad con criterios acordados. |
| RNF3 | Internacionalización | Validar cinco variantes, fallback al español y conservación del formulario al cambiar idioma. |
| RNF4 | Temas visuales | Verificar contraste y preferencia clara/oscura en las vistas incluidas. |
| RNF5 | Compatibilidad | Ejecutar matriz de navegadores, tamaños y versiones Android acordada. |
| RNF6 | Seguridad | Evaluar autenticación, autorización por rol/sede, protección de datos y pagos. |
| RNF7 | Escalabilidad y migraciones | Aplicar migraciones en ambiente controlado y verificar recuperación documentada. |
| RNF8 | Disponibilidad | Medir servicio y recuperación durante un período definido. |
| RNF9 | Mantenibilidad | Revisar modularidad, calidad y resultados del análisis acordado. |
| RNF10 | Adaptabilidad y carga | Evaluar respuesta a picos y límites de capacidad en infraestructura definida. |
| RNF11 | Documentación | Revisar SRS, contratos API, diagramas y guías contra la implementación. |
| RNF12 | Resiliencia | Simular desconexión y fallos externos; recuperar estado y prevenir duplicados. |

### 3.4 Requisitos lógicos de base de datos

El modelo debe representar identidad/permisos, ciudades/sedes/flota, reservas/conductor/documentos, pagos/comprobantes, contratos, incidencias, notificaciones, promociones, reseñas y auditoría. Las relaciones deben conservar integridad referencial, tipos monetarios adecuados, estados válidos y restricciones consistentes con las reglas de negocio.

El [diccionario de datos](../04-architecture/database/data-dictionary.md) y el diagrama ER concretan nombres, claves, tipos, nulabilidad, índices y restricciones en HU-DOC-003/HU-DOC-008. Las tablas de la matriz actual requieren contraste con el SQL; no se adopta un nombre físico solo porque aparezca en una referencia. La retención y acceso a documentos y logs deben acordarse sin inventar períodos.

### 3.5 Restricciones de diseño y atributos del sistema

La separación por capas debe conservar autorización y reglas críticas en servidor. La administración de sucursal no puede acceder a otra sede por modificar identificadores. Los pagos necesitan validación de confirmaciones y prevención de duplicación. Los secretos y credenciales bancarias no deben figurar en documentación, contratos descargables o registros accesibles a usuarios sin permiso.

RNF7 no demuestra por sí solo que cualquier migración tenga rollback automático o cero interrupción; cada cambio requiere estrategia y validación. Las versiones de bibliotecas y los atributos de infraestructura se documentan mediante ADR y evidencia de entorno.

### 3.6 Reglas críticas de negocio

| Regla | Fuente | Condición verificable |
| --- | --- | --- |
| Acceso por rol y sede | RF7, RF40; RNF6 | Cada operación se autoriza por usuario, permiso y ámbito. |
| Reserva y precio | RF19 a RF22 | Se validan fechas, disponibilidad, conductor, descuentos y total antes de confirmar. |
| Pago digital | RF23 | El servidor valida el resultado del proveedor sin confirmar por una acción visual del cliente. |
| Efectivo | RF24 y RF47 | La reserva pendiente tiene vencimiento; el recaudo autorizado confirma y la expiración sin pago cancela. |
| Documentación y contrato | RF25 y RF26 | Se conserva expediente revisado y contrato firmado antes de autorizar entrega. |
| Entrega | RF27, RF50 y RF52 | La validación correcta del PIN y la inspección sustentan la autorización de entrega. |
| Respuesta oficial | RF49 | Una respuesta publicada no puede editarse ni eliminarse. |
| Devolución | RF53 y RF41 | Se compara con la inspección inicial y se registran cargos/incidencias según reglas autorizadas. |
| Promociones | RF21, RF43 y RF54 | Se valida vigencia, condiciones, límites y ámbito de la promoción. |

El plazo de efectivo se describe como máximo 72 horas o hasta 2 horas antes de recogida en RF24. La fórmula exacta y las reservas creadas dentro de esas últimas 2 horas deben definirse en la fuente antes de fijar casos límite. OTP, PIN de entrega y PIN/comprobante de efectivo son conceptos distintos; su longitud y tratamiento no se intercambian.

### 3.7 Aceptación, trazabilidad y evidencia

Cada HU utiliza la [plantilla Gherkin](../02-product/user-stories/HU-001-plantilla.md) y referencia RF/subrequisitos y RNF. Debe incluir flujo principal y, cuando corresponda, entradas inválidas, falta de autorización, vencimiento, fallos externos y prevención de duplicados. La trazabilidad conecta requisitos, historias, diagramas, API/modelo de datos y pruebas reales.

Los criterios globales de [acceptance-criteria.md](acceptance-criteria.md) no se consideran prueba ejecutada por sus casillas marcadas. La [matriz](matriz-trazabilidad.md) ya tiene numeración alineada; debe completar las relaciones UML y capacidades pendientes antes de certificar cobertura completa. El cierre requiere evidencia y revisión según la [Definition of Done](../08-development/definition-of-done.md).

## 4. Diferencias de fuentes y aprobación

### 4.1 Decisiones resueltas y asuntos pendientes

| ID | Diferencia comprobada | Tratamiento en esta consolidación | Validación requerida |
| --- | --- | --- | --- |
| D-01 | Numeración de RF y relaciones de trazabilidad. | **Resuelto documentalmente:** fichas, resumen y matriz usan los mismos 54 IDs y nombres; tablas/rutas se contrastaron con fuentes locales. | Completar relaciones UML y capacidades señaladas como pendientes; no equivale a pruebas ejecutadas. |
| D-02 | Alcance de web y app. | **Confirmado por Danna:** app exclusiva de cliente, sin panel administrativo; web para clientes y con panel administrativo. Nota y rangos RF actualizados. | Validar implementación por rol/plataforma; alcance ya definido. |
| D-03 | Idiomas del producto. | **Confirmado por Danna:** español, inglés, francés, portugués y portugués de Brasil. Criterios globales sincronizados con RNF3. | Validar correspondencia técnica de la clave br con pt-BR y cobertura de traducciones. |
| D-04 | Plan: React 18. El package.json web local declara React `^19.2.5`; el móvil `19.2.3`. | No se fija React 18 como versión instalada; decisiones de stack remitidas a ADR. | Danna/Emily deben contrastar versiones con la rama de entrega. |
| D-05 | PDF/documentos previos: Android 13/14 y PWA; RNF5: API 26+/Android 8. Plan: React Native con Expo. | App cliente Android y web separadas; compatibilidad exacta pendiente de matriz. | Acordar versiones mínimas soportadas y canal móvil vigente. |
| D-06 | Restricciones previas niegan offline; RNF12 exige persistencia de borrador y recuperación. | Recuperación local admitida; transacciones confirmadas requieren servidor. | Actualizar restricciones y detallar datos recuperables. |
| D-07 | Formato del PIN de entrega. | **Confirmado por Danna:** exactamente 4 dígitos numéricos, conservando ceros iniciales. RF27/RF52 sincronizados; OTP de correo conserva 6 dígitos. | Implementar/validar persistencia y contrato de PIN; no se cambia el código de efectivo ni se certifica implementación. |
| D-08 | Plan: wizard móvil de 3 pasos; fichas RF19–RF22 describen 4 etapas funcionales. | Se documentan etapas de negocio sin fijar número de pantallas. | Acordar agrupación visual y trazabilidad en web/móvil. |
| D-09 | Cobertura de reseñas con fotos y asignación de conductor. | El índice ya coincide con RF32/RF33 de onboarding/chat. BL-16 conserva RF49; las brechas de reseñas/fotos y conductor se registran sin crear RF nuevos arbitrarios. | Completar requisitos, modelo y contratos de esas capacidades en sus HU correspondientes. |
| D-10 | RNF1 tiene cifras distintas en resumen/ficha/tabla; documentos de objetivos y RNF4 difieren en nivel WCAG; RNF7 menciona PostgreSQL/MySQL y promesas automáticas de recuperación. | Se conservan objetivos como requisitos por validar; no se certifica rendimiento, accesibilidad ni rollback. | Acordar umbrales, entornos y procedimientos antes de pruebas de aceptación. |
| D-11 | RF24 expresa vencimiento dinámico sin resolver todos los casos límite. | Se mantiene la regla declarada sin inventar fórmula operativa. | Definir cálculo exacto, reloj de referencia y reservas cercanas a recogida. |

El PDF aportado contiene secciones introductorias anteriores y fichas posteriores actualizadas; también conserva un año de portada anterior y marcadores de índice sin resolver. Se usa como fuente de contenido, no como evidencia de una versión aprobada. Esta HU no modifica el PDF ni los archivos asignados a otras integrantes.

### 4.2 Aprobación y cambios

Danna entrega los cuatro documentos de HU-DOC-002 en la rama de trabajo. Laura valida la coherencia con HU-DOC-001 y el equipo revisa visión, prioridades y decisiones pendientes. La línea base se aprueba cuando se resuelven o acuerdan explícitamente los puntos que afectan alcance y aceptación. Cambios posteriores deben actualizar las referencias y pasar revisión; no se renumeran RF para ocultar divergencias.

## Anexo A. Verificación de HU-DOC-002

| Criterio solicitado | Evidencia documental |
| --- | --- |
| SRS estructurado bajo Drivique | Secciones 1, 2 y 3 con propósito, alcance, definiciones, referencias, producto, usuarios, restricciones, interfaces, RF, RNF, datos y aceptación. |
| Delimitar app y web | Sección 1.2 de este SRS y visión: app exclusiva de cliente; web con portal cliente y panel administrativo. |
| Backlog de todos los módulos con MoSCoW | BL-01–BL-16 cubren RF1–RF54; BL-17–BL-24 cubren RNF1–RNF12; BL-25–BL-28 registran Won't. |
| Plantilla oficial con Given–When–Then | Plantilla reutilizable en español Gherkin, con éxito/error/autorización y ejemplo diligenciado. |

La estructura y los entregables pueden revisarse completos. La aprobación de negocio y la reconciliación de fuentes son pasos de cierre del equipo, no resultados atribuidos a esta edición.
