# Historias de Usuario y Criterios de Aceptación — Drivique

Cada historia de usuario del sistema **Drivique** vincula el rol de negocio, los requisitos funcionales asociados (`RF1` a `RF54`), los endpoints REST verificados y sus **Criterios de Aceptación** verificables en formato Gherkin (`Dado / Cuando / Entonces`).

---

## HU-01: Exploración pública del catálogo y página de inicio
- **Rol:** Visitante (sin sesión)
- **Requisitos relacionados:** `RF1`, `RF8`, `RF9`, `RF10`, `RF11`, `RF12`, `RF13`
- **Historia:** Como visitante, quiero explorar la página de inicio y el catálogo de vehículos filtrando por ciudad, sucursal, fechas y categoría para conocer la disponibilidad y tarifas reales sin obligación de registrarme previamente.
- **Criterios de Aceptación:**
  1. **Dado** que un visitante ingresa a `https://drivique.tech` o abre la app móvil en modo invitado, **cuando** consulta el catálogo (`GET /api/v1/vehicles/search` y `GET /api/v1/vehicles/featured`), **entonces** el sistema muestra únicamente vehículos activos con su tarifa diaria en COP, sede, transmisión, capacidad y calificación promedio real.
  2. **Dado** que el visitante aplica filtros por ciudad, categoría, rango de precio o transmisión, **cuando** ejecuta la búsqueda, **entonces** la lista se actualiza en $\le 400\text{ ms}$ mostrando los vehículos disponibles para ese criterio o un estado vacío informativo si no hay coincidencias.
  3. **Dado** que el visitante selecciona un vehículo del catálogo, **cuando** abre el detalle (`GET /api/v1/vehicles/{id}`, `/features`, `/reviews`), **entonces** visualiza la galería de imágenes, ficha técnica, reseñas verificadas y el botón para iniciar reserva (que solicita autenticación antes de confirmar el bloqueo).

---

## HU-02: Registro de cliente y verificación de identidad por correo (OTP)
- **Rol:** Cliente
- **Requisitos relacionados:** `RF3`, `RF4`
- **Historia:** Como cliente nuevo, quiero registrarme con mis datos reales y verificar mi correo electrónico mediante un código OTP de 6 dígitos para activar mi cuenta de forma segura.
- **Criterios de Aceptación:**
  1. **Dado** que un usuario completa el formulario de registro con nombre, apellido, correo único y contraseña que cumple la política de seguridad (mínimo 8 caracteres, mayúscula, minúscula, número y símbolo), **cuando** envía `POST /api/v1/auth/register`, **entonces** el sistema crea el usuario en `iam.users` con contraseña cifrada en `BCrypt` (costo 12) y envía un código OTP de 6 dígitos registrado en `iam.verification_codes` con vigencia de 15 minutos.
  2. **Dado** que el usuario tiene un código OTP vigente, **cuando** lo ingresa en `POST /api/v1/auth/verify-email`, **entonces** la cuenta pasa a estado `ACTIVE` y `email_verified = true`.
  3. **Dado** un código OTP expirado o inválido, **cuando** el usuario intenta verificarlo, **entonces** la API responde con estado `400 Bad Request` / `422` en formato RFC 7807 sin activar la cuenta.

---

## HU-03: Inicio de sesión, redirección por rol y recuperación de contraseña
- **Rol:** Cliente / Administrador General / Encargado de Sucursal
- **Requisitos relacionados:** `RF2`, `RF5`, `RF6`, `RF7`, `RF30`, `RF31`
- **Historia:** Como usuario registrado, quiero iniciar sesión con mis credenciales o proveedor OAuth, ser redirigido según mi rol operativo y poder recuperar mi contraseña o cerrar sesión de forma segura.
- **Criterios de Aceptación:**
  1. **Dado** un usuario con cuenta `ACTIVE`, **cuando** envía credenciales válidas a `POST /api/v1/auth/login`, **entonces** el servidor emite un `accessToken` JWT firmado (con roles y `branchId` si aplica) y un `refreshToken` registrado en `iam.user_sessions`, almacenando la sesión en `sessionStorage` en web y `SecureStore` en móvil.
  2. **Dado** un inicio de sesión exitoso en web, **cuando** el rol del token es `SUPER_ADMIN` o `ADMIN`, **entonces** el sistema redirige al panel administrativo global (`/admin`); si es `BRANCH_ADMIN` o `BRANCH_MANAGER`, redirige al panel de su sucursal asignada; si es `CUSTOMER`, redirige al catálogo/portal de cliente.
  3. **Dado** que un usuario supera el umbral de intentos fallidos de inicio de sesión, **cuando** vuelve a intentar autenticarse, **entonces** la cuenta se bloquea temporalmente conforme a `iam.security_configurations` y se registra el evento en `audit.audit_logs`.
  4. **Dado** que el usuario solicita recuperar su contraseña (`POST /api/v1/auth/forgot-password`), **cuando** valida el código (`POST /api/v1/auth/validate-reset-code`) y envía la nueva clave (`POST /api/v1/auth/reset-password`), **entonces** se actualiza el hash `BCrypt` y se revocan las sesiones previas.

---

## HU-04: Cotización y creación de reserva paso a paso con puntos de entrega
- **Rol:** Cliente
- **Requisitos relacionados:** `RF19`, `RF20`, `RF21`, `RF22`
- **Historia:** Como cliente autenticado, quiero configurar mi reserva seleccionando fechas y horas de retiro/devolución, punto de entrega (sucursal, aeropuerto, terminal o domicilio), coberturas de seguro, plan de kilometraje, servicios adicionales y cupón promocional para obtener el desglose financiero exacto y bloquear temporalmente el vehículo (`hold`).
- **Criterios de Aceptación:**
  1. **Dado** un vehículo disponible en las fechas seleccionadas ($t_{\text{devolución}} > t_{\text{retiro}}$), **cuando** el cliente solicita cotización (`POST /api/v1/pricing/quote`), **entonces** el servidor calcula de forma determinista los bloques de 24 horas, cobertura, kilometraje, servicios adicionales, recargo de entrega e impuestos, más el descuento de cupón validado (`POST /api/v1/promotions/validate`).
  2. **Dado** que la fecha/hora de devolución es menor o igual a la de retiro, **cuando** el cliente intenta avanzar o persistir la reserva, **entonces** el cliente y el servidor rechazan la solicitud con un error de validación explícito sin desplazar silenciosamente las fechas.
  3. **Dado** el formulario de reserva completo, **cuando** el cliente inicia el checkout (`POST /api/v1/reservations/checkout/initiate` con `Idempotency-Key` y configura `POST /api/v1/reservations/{id}/delivery-points`), **entonces** se crea el registro en `rental.reservations` en estado `PENDING_PAYMENT` bloqueando la disponibilidad del vehículo durante la ventana de pago.

---

## HU-05: Pago digital con Wompi firmado en servidor y pago en efectivo en sucursal
- **Rol:** Cliente / Encargado de Sucursal
- **Requisitos relacionados:** `RF23`, `RF24`, `RF47`
- **Historia:** Como cliente, quiero pagar mi reserva en línea a través de Wompi con firma de integridad generada en el servidor o elegir pago en efectivo en taquilla de sucursal dentro del plazo límite para confirmar mi reserva sin exponer llaves criptográficas en el cliente.
- **Criterios de Aceptación:**
  1. **Dado** una reserva en estado `PENDING_PAYMENT`, **cuando** el cliente web o móvil inicia el pago con Wompi, **entonces** la aplicación invoca `POST /api/v1/payments/wompi/initiate` enviando `reservationReference` (o `contractId`), el servidor crea la fila en estado `PENDING` en `billing.payments` con referencia `PAY-<uuid>` y retorna `{ reference, amountInCents, currency, publicKey, integritySignature }` calculada en el servidor con el secreto `WOMPI_INTEGRITY_SECRET` (sin que exista `integrityKey` en el código fuente web ni móvil).
  2. **Dado** que Wompi procesa la transacción, **cuando** Wompi invoca `POST /api/v1/payments/wompi/webhook` con firma válida verificada en tiempo constante (`WompiSignatureService`) o el cliente regresa a `/respuesta` invocando `POST /api/v1/reservations/checkout/confirm/{holdId}`, **entonces** el pago pasa a `APPROVED` en `billing.payments`, se emite el comprobante en `billing.payment_receipts` y la reserva pasa a `CONFIRMED`.
  3. **Dado** que el cliente selecciona pago en efectivo en sucursal, **cuando** acude a la sede antes del vencimiento y el encargado confirma el recaudo (`POST /api/v1/payments/cash/confirm`), **entonces** se registra el pago en efectivo y se genera el recibo oficial; si vence el plazo sin pago, el job `POST /api/v1/admin/reservations/expire-pending` libera automáticamente el vehículo.

---

## HU-06: Verificación documental KYC y firma electrónica del contrato de alquiler
- **Rol:** Cliente / Administrador / Encargado de Sucursal
- **Requisitos relacionados:** `RF25`, `RF26`, `RF42`
- **Historia:** Como cliente, quiero cargar mis documentos de identidad y licencia de conducción cifrados y firmar electrónicamente el contrato de alquiler para formalizar legalmente la entrega del vehículo.
- **Criterios de Aceptación:**
  1. **Dado** un cliente autenticado, **cuando** sube su documento de identidad y licencia (`POST /api/v1/users/me/documents`), **entonces** los archivos se almacenan cifrados en reposo con AES-GCM (`DocumentEncryptionService`), el acceso directo a `/uploads/kyc/**` está bloqueado por `SecurityConfig` y el encargado puede aprobarlos o rechazarlos (`PATCH /api/v1/kyc/documents/{id}/review`).
  2. **Dado** una reserva con pago confirmado, **cuando** el cliente solicita su contrato (`POST /api/v1/contracts/generate`) y estampa su firma digital (`POST /api/v1/contracts/{id}/sign`), **entonces** se persiste la firma, fecha, IP y hash de integridad en `contract.rental_contracts` cambiando el estado del contrato a `SIGNED`.

---

## HU-07: Consulta de reservas, favoritos, notificaciones, perfil y soporte del cliente
- **Rol:** Cliente
- **Requisitos relacionados:** `RF14`, `RF15`, `RF16`, `RF17`, `RF18`, `RF28`, `RF29`, `RF32`, `RF33`
- **Historia:** Como cliente autenticado, quiero consultar y gestionar mi historial de reservas, vehículos favoritos, notificaciones en tiempo real, datos de perfil, reseñas y canales de soporte.
- **Criterios de Aceptación:**
  1. **Dado** un cliente autenticado, **cuando** consulta `GET /api/v1/reservations/me`, `GET /api/v1/users/me/favorites` y `GET /api/v1/notifications`, **entonces** visualiza únicamente sus propios registros y puede cancelar reservas elegibles (`PATCH /api/v1/reservations/{id}/cancel` con motivo obligatorio) o marcar notificaciones como leídas (`PATCH /api/v1/notifications/{id}/read`).
  2. **Dado** una reserva finalizada (`COMPLETED`), **cuando** el cliente envía una calificación del vehículo (`POST /api/v1/reviews/vehicles`) o de la sucursal (`POST /api/v1/reviews/branches`), **entonces** se verifica elegibilidad previa (`GET /api/v1/reservations/{id}/review-eligibility`) y se registra la reseña en `rental.vehicle_ratings` o `rental.branch_reviews`.

---

## HU-08: Administración global y operación por sucursal (Flota, Sedes, Usuarios, Roles, Reportes y Auditoría)
- **Rol:** Administrador General (`SUPER_ADMIN` / `ADMIN`) y Encargado de Sucursal (`BRANCH_ADMIN`)
- **Requisitos relacionados:** `RF34`, `RF35`, `RF36`, `RF37`, `RF38`, `RF39`, `RF40`, `RF43`, `RF44`, `RF45`, `RF46`, `RF48`, `RF49`, `RF51`, `RF54`
- **Historia:** Como administrador general o encargado de sucursal, quiero gestionar ciudades, sedes, flota vehicular, reservas, usuarios/roles, promociones, identidad de marca, reportes ejecutivos y bitácora de auditoría dentro del alcance estricto de mis permisos.
- **Criterios de Aceptación:**
  1. **Dado** un usuario con rol `BRANCH_ADMIN`, **cuando** accede a los endpoints administrativos de flota, reservas, entregas, caja o reportes, **entonces** el backend filtra y restringe todas las operaciones exclusivamente al `branchId` asignado a su cuenta, rechazando con `403 Forbidden` cualquier intento de operar sobre otra sede.
  2. **Dado** un usuario con rol `SUPER_ADMIN`, **cuando** genera un reporte administrativo (`POST /api/v1/admin/reports/generate`) o consulta la bitácora (`GET /api/v1/admin/audit-logs`), **entonces** puede exportar la información consolidada o por sede en formatos PDF, Excel (`.xlsx`) o Word/CSV, quedando cada acción crítica registrada en `audit.audit_logs`.

---

## HU-09: Entrega con PIN de seguridad, inspección de salida/retorno y gestión de incidencias
- **Rol:** Encargado de Sucursal / Operador / Repartidor
- **Requisitos relacionados:** `RF27`, `RF41`, `RF50`, `RF52`, `RF53`
- **Historia:** Como encargado u operador de sucursal, quiero validar el código PIN de 4 dígitos del cliente, registrar la lista de chequeo de inspección en la entrega y devolución del vehículo y gestionar reportes de incidencias para controlar el estado físico y operativo de la flota.
- **Criterios de Aceptación:**
  1. **Dado** un contrato firmado y pago aprobado, **cuando** el operador registra la inspección de salida (`POST /api/v1/contracts/{contractId}/inspections`) y valida el PIN de entrega de 4 dígitos (`POST /api/v1/reservations/{id}/delivery-points`), **entonces** quedan almacenadas las respuestas del checklist en `contract.vehicle_inspections` y `contract.inspection_checklist_answers` y la reserva pasa a estado `ACTIVE`.
  2. **Dado** un vehículo en devolución, **cuando** el operador registra la inspección de retorno y reporta eventuales daños o novedades (`POST /api/v1/incidents` y `POST /api/v1/incidents/{id}/responses`), **entonces** se actualiza el estado del vehículo en `fleet.vehicles` y se cierra el ciclo del alquiler (`COMPLETED`).
