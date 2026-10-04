# Historias de usuario — Integración real de Drivique

Estas historias eliminan los datos de negocio simulados de web y móvil. Los JSON de internacionalización (`i18n`) se conservan porque son traducciones estáticas, no datos de negocio.

---

## 🟢 HU-INT-03 | Contrato API único y configuración por ambiente

**Etiqueta:** 🔴 `Must have`

### Descripción

Tipo: Integración / Web / Móvil / Backend

Como equipo de desarrollo, necesitamos que web y móvil usen una única configuración de API por ambiente, autenticación Bearer, renovación de sesión y errores RFC 7807, sin URLs locales ni rutas duplicadas.

Criterios de aceptación:
• Web usa `VITE_API_URL` y móvil usa `EXPO_PUBLIC_API_URL`; no hay fallback productivo a `localhost` ni `tu-api.com`.
• Los clientes HTTP adjuntan y renuevan JWT de forma segura, cierran sesión al expirar el refresh token y muestran errores API legibles.
• CORS, OpenAPI y contratos de DTO se validan contra el backend en `dev`, `qa` y `main`.

Story Points: 5

Depende de: HU-BE-02, HU-BE-06

Flujo obligatorio de ramas:
• dev: crear `HU-INT-03-dev` en cada repositorio involucrado y PR hija -> dev.
• qa: crear `HU-INT-03-qa`, fusionar la hija -dev y PR hija -> qa.
• main: crear `HU-INT-03-main`, fusionar la hija -qa y PR hija -> main.

### DoR (Definition of Ready)
- [ ] URLs HTTPS de API por ambiente y colección OpenAPI disponibles.

### DoD (Definition of Done)
- [ ] Web y móvil consumen el backend real sin fallback mock.
- [ ] Pruebas de contrato y manejo de 401/403/422 pasan.
- [ ] Pipeline verde en los repositorios involucrados.

### Checklist de ejecución y cierre
- [ ] Centralizar cliente HTTP, token y mapeo de errores.
- [ ] Configurar variables de entorno y CORS.
- [ ] Eliminar endpoints y URLs simuladas.
- [ ] Validar flujo de sesión en web y móvil.

---

## 🟢 HU-INT-04 | Autenticación real, verificación por correo y recuperación de contraseña

**Etiqueta:** 🔴 `Must have`

### Descripción

Tipo: Integración / Auth / Email / Web / Móvil / Backend

Como cliente, quiero crear mi cuenta, recibir un código real por correo, verificarla y recuperar mi contraseña con un OTP de un solo uso.

Criterios de aceptación:
• Registro, verificación de correo, reenvío, recuperación y restablecimiento usan los endpoints reales; se elimina el código fijo `123456` y usuarios demo.
• El backend envía el OTP por un proveedor SMTP/API configurado con secretos por ambiente; no registra ni simula el contenido del correo en producción.
• Los códigos expiran, se invalidan al usarse, tienen límite de intentos y el mismo mensaje no enumera cuentas existentes.

Story Points: 8

Depende de: HU-INT-03, HU-BE-05, HU-BE-07

### DoR (Definition of Ready)
- [ ] Dominio remitente verificado y secretos SMTP/API configurados en dev y qa.

### DoD (Definition of Done)
- [ ] Correo real recibido en pruebas de integración controladas.
- [ ] Registro, verificación y recuperación completan el flujo en web y móvil.
- [ ] No quedan usuarios demo, códigos fijos ni contraseñas en almacenamiento local.

### Checklist de ejecución y cierre
- [ ] Configurar proveedor de correo y plantillas transaccionales.
- [ ] Conectar formularios web y Expo a los endpoints reales.
- [ ] Añadir límites, auditoría y pruebas de expiración/reintentos.
- [ ] Validar en dev -> qa -> main con cuentas de prueba.

---

## 🟢 HU-INT-05 | Inicio de sesión social seguro con Google y Facebook

**Etiqueta:** 🔴 `Must have`

### Descripción

Tipo: Auth / OAuth 2.0-OIDC / Web / Móvil / Backend

Como cliente, quiero iniciar sesión con Google o Facebook sin compartir mi contraseña con Drivique.

Criterios de aceptación:
• Web y móvil usan Authorization Code con PKCE y deep links/redirecciones aprobadas.
• Backend valida `issuer`, firma, audiencia, expiración y nonce del token recibido antes de crear o vincular una cuenta.
• Se prohíben tokens de proveedor en logs, URL, base de datos de negocio y almacenamiento inseguro; Drivique emite sus propios JWT y refresh tokens.

Story Points: 8

Depende de: HU-INT-03, HU-INT-04

### DoR (Definition of Ready)
- [ ] Aplicaciones OAuth creadas, consent screen y redirect URIs de cada ambiente registrados.

### DoD (Definition of Done)
- [ ] Login, cancelación, cuenta existente y vinculación se prueban en Google y Facebook sandbox.
- [ ] Pruebas de token inválido, audiencia incorrecta y callback manipulado pasan.

### Checklist de ejecución y cierre
- [ ] Implementar endpoints de callback/vinculación y proveedor OAuth en backend.
- [ ] Implementar PKCE y manejo de deep link en web y Expo.
- [ ] Configurar secretos únicamente en CI/CD y gestores de secretos.

---

## 🟢 HU-INT-06 | Catálogo, disponibilidad y reservas sin JSON simulados

**Etiqueta:** 🔴 `Must have`

### Descripción

Tipo: Catálogo / Reservas / Web / Móvil / Backend / Database

Como visitante o cliente, quiero consultar vehículos, sedes, catálogos, disponibilidad y mis reservas desde datos reales.

Criterios de aceptación:
• Se reemplazan `vehicles.json`, `branches.json`, `cities.json`, `bookings.json`, nacionalidades y servicios mock por endpoints reales.
• La disponibilidad se calcula en el backend con reservas reales; ambos clientes muestran precios, promociones y estados del servidor.
• Crear, modificar, cancelar y consultar una reserva se refleja igual en web, móvil y PostgreSQL.

Story Points: 13

Depende de: HU-INT-03, HU-BE-12 a HU-BE-25

### DoR (Definition of Ready)
- [ ] Datos semilla idempotentes y endpoints públicos/documentados disponibles.

### DoD (Definition of Done)
- [ ] Ningún flujo de catálogo/reserva consume mocks o `localStorage` como fuente de verdad.
- [ ] Pruebas E2E cubren búsqueda -> cotización -> reserva -> consulta de historial.

### Checklist de ejecución y cierre
- [ ] Crear adaptadores de DTO para web y móvil.
- [ ] Retirar mocks de negocio y limpiar imports no usados.
- [ ] Añadir estados de carga, vacío y error.
- [ ] Validar consistencia de datos entre las cuatro capas.

---

## 🟢 HU-INT-07 | Pagos, contratos, inspecciones y comprobantes con datos reales

**Etiqueta:** 🔴 `Must have`

### Descripción

Tipo: Billing / Contracts / Fleet / Web / Móvil / Backend / Database

Como cliente u operador, quiero completar pagos, firmar, inspeccionar y descargar documentos reales sin datos ficticios.

Criterios de aceptación:
• Wompi se inicia exclusivamente mediante backend; los clientes no consultan ni exponen claves privadas ni verifican transacciones directamente con Wompi.
• Pago aprobado actualiza la reserva, genera contrato/recibo y permite descarga autorizada del PDF.
• Firma, check-in/check-out, fotos de evidencia y cobros resultantes usan IDs y archivos reales del backend.

Story Points: 13

Depende de: HU-INT-06, HU-BE-31 a HU-BE-35

### DoR (Definition of Ready)
- [ ] Credenciales Wompi sandbox, URL pública de webhook y almacenamiento de archivos configurados.

### DoD (Definition of Done)
- [ ] Flujo E2E de pago sandbox, webhook válido, firma, inspección y recibo pasa en web y móvil.
- [ ] No quedan vehículos, contratos, pagos ni clientes ficticios en pantallas operativas.

### Checklist de ejecución y cierre
- [ ] Reemplazar clientes Wompi y contratos mock.
- [ ] Conectar cargas multipart y descargas PDF.
- [ ] Validar permisos de cliente, cajero y operador.

---

## 🟢 HU-INT-08 | Notificaciones reales y módulos de soporte/reseñas

**Etiqueta:** 🟡 `Should have`

### Descripción

Tipo: Notifications / Support / Reviews / Web / Móvil / Backend / Database

Como cliente, quiero recibir notificaciones reales y gestionar reseñas e incidencias usando información persistida.

Criterios de aceptación:
• Lista, lectura individual y lectura masiva de notificaciones consumen el backend; se eliminan notificaciones, cupones y promociones dummy.
• Las notificaciones por correo respetan preferencias y registran resultado de entrega; SMS/push se implementan mediante proveedor configurado, no logs simulados.
• Soporte y reseñas usan endpoints reales, adjuntos reales y autorización del usuario.

Story Points: 8

Depende de: HU-INT-04, HU-BE-36, HU-BE-37

### DoR (Definition of Ready)
- [ ] Proveedores email/SMS/push elegidos, credenciales y políticas de consentimiento aprobadas.

### DoD (Definition of Done)
- [ ] In-app, email y al menos un canal móvil externo se verifican de punta a punta.
- [ ] No hay stores, JSON ni servicios dummy para notificaciones, soporte o reseñas.

### Checklist de ejecución y cierre
- [ ] Conectar pantallas y estados de lectura.
- [ ] Implementar proveedores y trazabilidad de entrega.
- [ ] Retirar contenido demo y probar permisos.

---

## 🟢 HU-QA-03 | Certificación E2E sin mocks y despliegue integrado

**Etiqueta:** 🔴 `Must have`

### Descripción

Tipo: QA / DevOps / Todos los repositorios

Como equipo, queremos certificar que el producto desplegado usa exclusivamente API, PostgreSQL y servicios externos reales de sandbox/controlados.

Criterios de aceptación:
• CI ejecuta migraciones/validación de base de datos, pruebas backend, build web, lint/build móvil y pruebas E2E contra un ambiente efímero.
• Un análisis bloquea imports de mocks/fixtures en código de producción, excepcionando únicamente i18n y datos de prueba.
• Se validan registro, OTP, login social, reserva, pago, contrato, notificación, soporte y cierre de sesión.

Story Points: 13

Depende de: HU-INT-03 a HU-INT-08

### DoR (Definition of Ready)
- [ ] Ambientes dev/qa, secretos, cuentas sandbox y datos de prueba aislados.

### DoD (Definition of Done)
- [ ] Matriz E2E aprobada en web y Android/iOS/Expo web.
- [ ] Pipelines de los cuatro repositorios en verde y documentación de despliegue actualizada.

### Checklist de ejecución y cierre
- [ ] Crear pruebas E2E y contrato entre repositorios.
- [ ] Añadir detección de mocks en producción.
- [ ] Ejecutar smoke test tras despliegue y registrar evidencia.
