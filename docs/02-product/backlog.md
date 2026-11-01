# Backlog Priorizado y Criterios de Aceptación por Épica — Drivique

**Responsable:** Danna Valentina Barrios Penagos · **HU:** HU-DOC-002 / HU-INT-22 · **Fecha de actualización:** 2026-10-31  
**Estado:** Línea base MoSCoW sincronizada con los 54 Requisitos Funcionales (`RF1`–`RF54`), los 12 Requisitos No Funcionales (`RNF1`–`RNF12`), los [KPIs de producto](goals-and-objectives.md) y los criterios de aceptación de [user-stories.md](../01-srs/user-stories.md).

## 1. Base y reglas de priorización

Este backlog agrupa todos los requisitos `RF1` a `RF54` de las [fichas funcionales](../01-srs/functional-requirements.md) y los [criterios de aceptación detallados](../01-srs/acceptance-criteria.md):

- **Must:** Imprescindible para ejecutar de extremo a extremo el alquiler vehicular de forma segura.
- **Should:** Importante para la operación multi-sucursal y experiencia de usuario.
- **Could:** Mejora funcional o de personalización visual que no bloquea el flujo transaccional.
- **Won't (en esta entrega):** Exclusión explícita de alcance acordada en el SRS.

## 2. Módulos funcionales y Criterios de Aceptación Verificables

| ID | Módulo / Resultado | MoSCoW | RF de origen | HU Asociada | Criterios de Aceptación de Cierre (DoD Funcional) |
| --- | --- | :---: | --- | :---: | --- |
| **BL-01** | Identidad, autenticación y RBAC | Must | RF2–RF7, RF30–RF31 | HU-02, HU-03 | Registro con `BCrypt` (costo 12), OTP de 6 dígitos en `iam.verification_codes`, login JWT (`accessToken` + `refreshToken`), sesión en `sessionStorage`/`SecureStore`, bloqueo por intentos fallidos y redirección por rol (`CUSTOMER`, `BRANCH_ADMIN`, `SUPER_ADMIN`). |
| **BL-02** | Presencia pública y navegación | Should | RF1, RF8, RF14 | HU-01 | `LandingPage` y navegación principal muestran vehículos destacados (`GET /api/v1/vehicles/featured`), sedes y acceso en modo invitado sin exponer rutas protegidas. |
| **BL-03** | Catálogo y búsqueda de vehículos | Must | RF9–RF13 | HU-01 | Búsqueda (`GET /api/v1/vehicles/search`), filtrado por ciudad/categoría/transmisión/precio, ordenamiento y modal de detalle (`GET /api/v1/vehicles/{id}`, `/features`, `/reviews`) responden con datos reales de `fleet.vehicles`. |
| **BL-04** | Reserva paso a paso y cotización | Must | RF19–RF22 | HU-04 | Validación estricta de fechas ($t_{\text{devolución}} > t_{\text{retiro}}$), cotización (`POST /api/v1/pricing/quote`), validación de cupón (`POST /api/v1/promotions/validate`) y creación de hold (`POST /api/v1/reservations/checkout/initiate`) con `Idempotency-Key`. |
| **BL-05** | Pagos digitales Wompi y recaudo en efectivo | Must | RF23–RF24, RF47 | HU-05 | Web y móvil invocan `POST /api/v1/payments/wompi/initiate` (que crea la fila `PENDING` en `billing.payments` y firma en servidor sin `integrityKey` en cliente); webhook `POST /api/v1/payments/wompi/webhook` y confirmación en caja (`POST /api/v1/payments/cash/confirm`) actualizan estado y emiten recibo. |
| **BL-06** | Verificación KYC y firma de contrato | Must | RF25–RF26, RF42 | HU-06 | Documentos de identidad/licencia cifrados con AES-GCM (`iam.user_documents`), revisión por encargado (`PATCH /api/v1/kyc/documents/{id}/review`), generación (`POST /api/v1/contracts/generate`) y firma electrónica (`POST /api/v1/contracts/{id}/sign`) en `contract.rental_contracts`. |
| **BL-07** | Entrega, PIN de 4 dígitos e inspección | Must | RF27, RF50, RF52 | HU-09 | Configuración y seguimiento de puntos de entrega (`POST /api/v1/reservations/{id}/delivery-points`), portal de repartidor con PIN de 4 dígitos y registro de checklist de entrega (`POST /api/v1/contracts/{contractId}/inspections`). |
| **BL-08** | Devolución e incidencias de flota | Must | RF41, RF53 | HU-09 | Inspección de retorno en `contract.vehicle_inspections`, apertura y seguimiento de incidencias (`POST /api/v1/incidents`, `POST /api/v1/incidents/{id}/responses`) y actualización de estado en `fleet.vehicles`. |
| **BL-09** | Historial de reservas y perfil del cliente | Must | RF15, RF28–RF29 | HU-07 | Consulta de reservas propias (`GET /api/v1/reservations/me`), cancelación con motivo (`PATCH /api/v1/reservations/{id}/cancel`) y lectura/actualización de perfil (`GET/PUT /api/v1/users/me`). |
| **BL-10** | Favoritos, notificaciones y soporte | Should | RF16–RF18, RF32–RF33 | HU-07 | CRUD de favoritos (`GET/POST/DELETE /api/v1/users/me/favorites`), centro de notificaciones (`GET /api/v1/notifications`, `PATCH /api/v1/notifications/{id}/read`), onboarding y centro de soporte/PQRS (`SupportPage`, `support.tsx`). |
| **BL-11** | Administración de sedes, flota y usuarios | Must | RF35–RF40 | HU-08 | Gestión protegida por `@PreAuthorize` de ciudades (`/api/v1/cities`), sedes (`/api/v1/branches`), flota (`/api/v1/admin/vehicles`), reservas (`/api/v1/admin/reservations`), usuarios (`/api/v1/admin/users`) y roles (`/api/v1/roles`). |
| **BL-12** | Dashboard operativo y reportes ejecutivos | Should | RF34, RF44 | HU-08 | Dashboard por sede/global (`ManagementDashboard`, `BranchDashboard`) y exportación de reportes (`POST /api/v1/admin/reports/generate`, `GET /api/v1/admin/reports/{id}/download`) en PDF/Excel/CSV. |
| **BL-13** | Promociones y cupones por sucursal | Should | RF43, RF54 | HU-08 | Gestión administrativa de campañas y cupones (`PromotionManagementPage`, `/api/v1/promotions`) con control de redención en `catalog.user_coupon_usages`. |
| **BL-14** | Identidad de marca y perfil de sucursal | Could | RF45, RF51 | HU-08 | Personalización activa en `core.brand_configurations` (`GET/PUT /api/v1/brand-configurations`) y gestión de perfil/coordenadas de sede (`BranchProfilePage`). |
| **BL-15** | Auditoría inmutable y alertas de sede | Must | RF46, RF48 | HU-08 | Consulta de bitácora (`GET /api/v1/admin/audit-logs`, `AuditLogManagementPage`) y centro de notificaciones operativas de sucursal (`BranchNotificationCenterPage`). |
| **BL-16** | Calificaciones, reseñas y moderación | Should | RF49 | HU-07, HU-08 | Elegibilidad (`GET /api/v1/reservations/{id}/review-eligibility`), publicación de reseñas de vehículo y sede (`POST /api/v1/reviews/vehicles`, `POST /api/v1/reviews/branches`) y moderación en `BranchReviewsPage`. |

## 3. Calidad y plataforma (Requisitos No Funcionales)

| ID | Requisito transversal | MoSCoW | Referencia | Criterio de Aceptación y Evidencia Verificable |
| --- | --- | :---: | --- | --- |
| **BL-17** | Rendimiento y capacidad | Must | RNF1, RNF10 | Latencia $\text{p95} \le 400\text{ ms}$ en lecturas de catálogo y salud (`/api/actuator/health` HTTP 200 en `https://drivique.tech`). |
| **BL-18** | Usabilidad, accesibilidad y diseño adaptable | Must | RNF2, RNF5 | Componentes web y pantallas móviles con `accessibilityLabel`, `accessibilityRole`, navegación clara y soporte responsive. |
| **BL-19** | Internacionalización en 5 variantes | Must | RNF3 | Diccionarios completos y selector activo para `es`, `en`, `fr`, `pt` y `br` (`pt-BR`) tanto en web como en móvil y cabeceras `X-App-Language`. |
| **BL-20** | Temas claro y oscuro | Should | RNF4 | Persistencia de tema y contraste adecuado en componentes web y móviles. |
| **BL-21** | Seguridad OWASP y cero secretos | Must | RNF6 | CORS restringido a orígenes explícitos (`https://drivique.tech`), `require-secrets: true`, Gitleaks en CI, 0 usos de `dangerouslySetInnerHTML`, token fuera de `localStorage` y pago Wompi firmado en servidor. |
| **BL-22** | Persistencia versionada con Liquibase | Must | RNF7 | 78 tablas migradas con Liquibase (`changelog/db.changelog-master.yaml`), 50 pruebas SQL automatizadas en CI y rollbacks pareados en `05_rollbacks/`. |
| **BL-23** | Disponibilidad y resiliencia (Idempotencia) | Must | RNF8, RNF12 | Claves `Idempotency-Key` en reserva y confirmación de pago, verificación idempotente de webhook Wompi y manejo explícito de errores RFC 7807. |
| **BL-24** | Mantenibilidad, modularidad y documentación | Must | RNF9, RNF11 | Ninguna clase o componente supera las 500 líneas (`R-4.7`), contrato OpenAPI 3.0 exportado y matriz de trazabilidad cerrada al 100% contra código y UML. |

## 4. Exclusiones de esta entrega (Won't)

| ID | Función excluida | Motivo |
| --- | --- | --- |
| **BL-25** | Panel administrativo en la app móvil | La arquitectura define la app móvil exclusivamente para el rol cliente (`CUSTOMER`); toda la administración reside en la aplicación web. |
| **BL-26** | Facturación electrónica DIAN / ERP contable externo | El alcance cubre recibos de pago, contratos y reportes operativos/financieros internos. |
| **BL-27** | Confirmación offline de reservas y pagos | El bloqueo de disponibilidad vehicular y la firma de pagos exigen validación transaccional en el servidor central. |
| **BL-28** | Telemetría GPS de hardware embarcado | El seguimiento de entrega opera mediante estados del portal de repartidor y validación de PIN de 4 dígitos. |
