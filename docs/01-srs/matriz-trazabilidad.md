# Matriz de Trazabilidad de Requisitos (RF1 a RF54) — Drivique

**Fecha de sincronización:** 2026-10-31 · **Rama:** `HU-INT-22-dev`

La numeración corresponde a las 54 fichas de [functional-requirements.md](functional-requirements.md). Cada fila apunta **solo a artefactos que existen en los repositorios**:

- **Endpoint:** verificado contra el contrato exportado [openapi.json](../07-backend/contracts/openapi/openapi.json) (contexto `/api`) y el controlador real de `Back-end/src/main/java/com/drivique/api/controller/`.
- **Web:** ruta relativa a `front-end_web/web-drivique/`.
- **Móvil:** ruta relativa a `front-end_movil/app-drivique/` (solo funciones de cliente; la app no tiene panel administrativo).
- **UML:** archivos reales de `docs/03-design/uml/diagrams/exports/`:
  - `CU` = [DIAGRAMAS CASOS DE USO DRIVIQUE.pdf](../03-design/uml/diagrams/exports/DIAGRAMAS%20CASOS%20DE%20USO%20DRIVIQUE.pdf)
  - `SEC` = [DIAGRAMAS SECUENCIALES DRIVIQUE.pdf](../03-design/uml/diagrams/exports/DIAGRAMAS%20SECUENCIALES%20DRIVIQUE.pdf)
  - `CLA` = [DIAGRAMA DE CLASE.pdf](../03-design/uml/diagrams/exports/DIAGRAMA%20DE%20CLASE.pdf)
  - `DOM` = [DIAGRAMA DE DOMINIO.pdf](../03-design/uml/diagrams/exports/DIAGRAMA%20DE%20DOMINIO.pdf)
  - Fuentes editables en [source/](../03-design/uml/diagrams/source/).

> [!NOTE]
> Si un componente se divide o renombra, esta matriz debe actualizarse en el mismo PR (ver *Regla de mantenimiento*).

## Requisitos funcionales

| RF | Nombre | UML | Tablas | Endpoint (controlador) | Web | Móvil |
| --- | --- | --- | --- | --- | --- | --- |
| **RF1** | Página de inicio | CU, DOM | `fleet.vehicles`, `core.brand_configurations` | `GET /api/v1/vehicles/featured` (`VehicleController`), `GET /api/v1/brand-configurations/active` (`BrandController`) | `src/modules/landing/LandingPage.jsx` | `app/(tabs)/index.tsx` |
| **RF2** | Redirección tras inicio de sesión | CU, SEC | `iam.users`, `iam.user_roles`, `iam.roles` | `GET /api/v1/auth/me` (`AuthController`) | `src/routes/AppRouter.jsx`, `src/store/authStore.js` | `app/_layout.tsx` |
| **RF3** | Registro de usuario | CU, SEC, CLA | `iam.users`, `iam.verification_codes` | `POST /api/v1/auth/register` (`AuthController`) | `src/modules/auth/pages/RegistrationPage.jsx` | `app/(auth)/register.tsx` |
| **RF4** | Verificación por código de correo | CU, SEC | `iam.verification_codes`, `iam.users` | `POST /api/v1/auth/verify-email`, `POST /api/v1/auth/resend-verification` (`AuthController`) | `src/modules/auth/pages/VerifyEmailPage.jsx`, `src/modules/auth/pages/Verify2FAPage.jsx` | `app/(auth)/verify-email.tsx` |
| **RF5** | Inicio de sesión | CU, SEC, CLA | `iam.users`, `iam.user_sessions` | `POST /api/v1/auth/login` (`AuthController`) | `src/modules/auth/pages/LoginPage.jsx` | `app/(auth)/login.tsx` |
| **RF6** | Recuperar contraseña | CU, SEC | `iam.verification_codes`, `iam.users` | `POST /api/v1/auth/forgot-password`, `/validate-reset-code`, `/reset-password` (`AuthController`) | `src/modules/auth/pages/RecoverPasswordPage.jsx`, `VerifyRecoverPage.jsx`, `NewPasswordPage.jsx` | `app/(auth)/forgot-password.tsx` |
| **RF7** | Inicio de sesión con rol | CU, SEC, CLA | `iam.roles`, `iam.permissions`, `iam.role_permissions`, `iam.user_roles` | `POST /api/v1/auth/login` (`AuthController`) | `src/modules/auth/utils/accessControl.js`, `src/modules/admin/components/ManagementSidebar.jsx` | — (solo web) |
| **RF8** | Modo invitado | CU, DOM | `fleet.vehicles` | `GET /api/v1/vehicles/search` (`VehicleController`) | `src/modules/catalog/pages/CatalogPage.jsx`, `src/modules/catalog/components/GuestReserveModal.jsx` | `app/(tabs)/catalog.tsx` |
| **RF9** | Encabezado y buscador | CU | `fleet.vehicles`, `location.branches`, `location.cities` | `GET /api/v1/vehicles/search` (`VehicleController`) | `src/modules/catalog/components/CatalogTopHeader.jsx`, `CatalogSearchBar.jsx` | `modules/catalog/components/CatalogSearch.tsx` |
| **RF10** | Filtros del catálogo | CU | `fleet.vehicles`, `fleet.vehicle_categories` | `GET /api/v1/vehicles/search` (`VehicleController`) | `src/modules/catalog/components/CatalogFilters.jsx`, `MobileFiltersModal.jsx` | `modules/catalog/components/CatalogFilters.tsx` |
| **RF11** | Ordenar resultados | CU | `fleet.vehicles` | `GET /api/v1/vehicles/search` (`VehicleController`) | `src/modules/catalog/pages/CatalogPage.jsx`, `CatalogPagination.jsx` | `app/(tabs)/catalog.tsx` |
| **RF12** | Tarjetas de vehículos | CU, DOM | `fleet.vehicles`, `fleet.vehicle_images` | `GET /api/v1/vehicles/{id}` (`VehicleController`) | `src/modules/catalog/components/VehicleCard.jsx`, `VehicleGrid.jsx` | `modules/catalog/components/VehicleCard.tsx` |
| **RF13** | Detalle de vehículo | CU, SEC, CLA | `fleet.vehicles`, `fleet.vehicle_features`, `rental.vehicle_ratings` | `GET /api/v1/vehicles/{id}`, `/features`, `/reviews` (`VehicleController`) | `src/modules/catalog/pages/VehicleDetailsPage.jsx`, `VehicleDetailsModal.jsx` | `app/vehicle/[id].tsx`, `modules/catalog/components/VehicleGallery.tsx`, `VehicleReviews.tsx` |
| **RF14** | Menú de navegación | CU | `iam.user_preferences` | `GET/PUT /api/v1/users/me/preferences` (`UserController`) | `src/modules/catalog/components/CatalogTopHeader.jsx`, `src/components/MenuConfiguracion.jsx` | `app/(tabs)/_layout.tsx`, `modules/i18n/components/ConfiguracionModal.tsx` |
| **RF15** | Mis Reservas | CU, SEC | `rental.reservations` | `GET /api/v1/reservations/me` (`ReservationController`) | `src/modules/reservations/pages/ReservationsPage.jsx` | `app/(tabs)/my-bookings.tsx` |
| **RF16** | Mis Favoritos | CU, SEC | `fleet.user_favorite_vehicles` | `GET /api/v1/users/me/favorites`, `POST/DELETE /api/v1/users/me/favorites/{vehicleId}` (`UserFavoriteController`) | `src/modules/catalog/pages/FavoritesPage.jsx` | `app/(tabs)/favorites.tsx` |
| **RF17** | Notificaciones (cliente) | CU, SEC | `support.notifications` | `GET /api/v1/notifications`, `PATCH /api/v1/notifications/{id}/read` (`NotificationController`) | `src/modules/notifications/pages/NotificationsPage.jsx` | `app/(tabs)/notifications.tsx` |
| **RF18** | Soporte | CU | `support.incident_reports` | `POST /api/v1/incidents`, `GET /api/v1/incidents/me` (`IncidentController`) | `src/modules/support/pages/SupportPage.jsx` | `app/(tabs)/support.tsx` |
| **RF19** | Paso 1: fechas, horarios y sucursales | CU, SEC | `rental.reservations`, `rental.reservation_delivery_points` | `POST /api/v1/reservations/checkout/initiate` (`ReservationController`), `POST /api/v1/reservations/{id}/delivery-points` (`ReservationDeliveryPointController`) | `src/modules/reservations/pages/ReservationFlowPage.jsx`, `UnifiedReservationConfigCard.jsx`, `DateStep.jsx`, `DomicilioModal.jsx` | `app/(tabs)/reserve.tsx`, `modules/reservation/components/DatesLocationForm.tsx` |
| **RF20** | Paso 2: coberturas y servicios | CU, SEC | `catalog.insurance_coverages`, `catalog.additional_services`, `catalog.mileage_plans` | `GET /api/v1/insurance-coverages`, `/additional-services` (`PricingCatalogController`), `GET /api/v1/mileage-plans` (`MileagePlanController`) | `src/modules/reservations/components/ProtectionPlans.jsx`, `AdditionalServices.jsx`, `MileageType.jsx` | `modules/reservation/components/AdditionalPlans.tsx` |
| **RF21** | Paso 3: conductor y cupón | CU, SEC | `iam.user_documents`, `catalog.promotions`, `catalog.user_coupon_usages` | `POST /api/v1/promotions/validate` (`PromotionController`) | `src/modules/reservations/components/PersonalData.jsx` | `modules/reservation/components/PersonalDataForm.tsx`, `CouponSection.tsx` |
| **RF22** | Paso 4: resumen y método de pago | CU, SEC | `rental.reservations`, `rental.reservation_promotions` | `POST /api/v1/pricing/quote` (`PricingController`) | `src/modules/reservations/components/PaymentMethodCard.jsx`, `SideSummary.jsx` | `modules/reservation/components/BookingSummaryModal.tsx`, `TotalConfirmBar.tsx` |
| **RF23** | Pago Wompi | CU, SEC, CLA | `billing.payments`, `billing.payment_methods`, `billing.payment_statuses` | `POST /api/v1/payments/wompi/initiate`, `POST /api/v1/payments/wompi/webhook` (`PaymentWebhookController`), `POST /api/v1/reservations/checkout/confirm/{holdId}` | `src/services/wompiService.js`, `src/modules/payments/strategies/WompiPaymentStrategy.js`, `src/modules/payments/pages/PaymentResponsePage.jsx` | `modules/reservation/services/wompiService.ts`, `app/wompi-checkout.tsx`, `app/payment-response.tsx` |
| **RF24** | Pago en efectivo con vencimiento | CU, SEC | `rental.reservations`, `billing.payments` | `POST /api/v1/payments/cash/confirm`, `GET /api/v1/payments/cash/pending` (`CashPaymentController`), `POST /api/v1/admin/reservations/expire-pending` (`AdminReservationController`) | `src/modules/reservations/pages/ReservationsPage.jsx`, `src/modules/admin/pages/CashCollectionPage.jsx` | `modules/reservation/components/BranchCashPaymentModal.tsx`, `CashPaymentAlert.tsx` |
| **RF25** | Documentos de identidad y licencia | CU, SEC | `iam.user_documents`, `iam.document_types`, `iam.document_statuses` | `GET/POST /api/v1/users/me/documents` (`UserDocumentController`), `PATCH /api/v1/kyc/documents/{id}/review` (`KycAuditController`) | `src/modules/profile/pages/ProfilePage.jsx`, `src/modules/admin/pages/DocumentVerificationPage.jsx` | `modules/reservation/components/DocumentVerificationCard.tsx`, `DocumentUploadField.tsx` |
| **RF26** | Contrato y firma electrónica | CU, SEC, CLA | `contract.rental_contracts`, `contract.contract_clauses`, `contract.contract_clause_assignments` | `POST /api/v1/contracts/generate`, `POST /api/v1/contracts/{id}/sign` (`ContractController`) | `src/modules/contracts/pages/ContractSigningPage.jsx`, `ContractSignature.jsx`, `SignatureCanvas.jsx` | `app/contract-view.tsx`, `modules/reservation/components/SignatureCanvas.tsx` |
| **RF27** | PIN de entrega y recogida | CU, SEC | `rental.reservation_delivery_points` | `GET/POST /api/v1/reservations/{id}/delivery-points` (`ReservationDeliveryPointController`), `GET/POST /api/v1/public/deliveries/action` (`DeliveryDriverActionController`) | `src/modules/reservations/pages/ReservationsPage.jsx`, `src/modules/admin/pages/DeliveryManagementPage.jsx` | `app/(tabs)/my-bookings.tsx` |
| **RF28** | Historial de reservas | CU, SEC | `rental.reservations`, `rental.reservation_statuses` | `GET /api/v1/reservations/me`, `GET /api/v1/reservations/{id}` (`ReservationController`) | `src/modules/reservations/pages/ReservationsPage.jsx` | `app/(tabs)/my-bookings.tsx` |
| **RF29** | Ver y editar perfil | CU, SEC | `iam.users`, `iam.user_profiles` | `GET/PUT /api/v1/users/me` (`UserController`) | `src/modules/profile/pages/ProfilePage.jsx`, `CompleteProfileModal.jsx` | `app/(tabs)/profile.tsx`, `modules/profile/components/PersonalInfo.tsx` |
| **RF30** | Cambiar contraseña | CU, SEC | `iam.users`, `iam.password_policies` | `POST /api/v1/auth/change-password` (`AuthController`) | `src/modules/profile/components/ChangePassword.jsx` | `modules/profile/components/ChangePasswordModal.tsx` |
| **RF31** | Cerrar sesión | CU, SEC | `iam.user_sessions` | `POST /api/v1/auth/logout` (`AuthController`) | `src/store/authStore.js`, `src/services/httpClient.js` | `modules/auth/services/authService.ts` |
| **RF32** | Onboarding | CU | `iam.user_preferences` | `GET/PUT /api/v1/users/me/preferences` (`UserController`) | `src/modules/profile/components/CompleteProfileModal.jsx` | `app/onboarding/index.tsx`, `modules/onboarding/screens/` |
| **RF33** | Chat flotante de soporte | CU | Servicio externo (Tawk.to) | No aplica | `src/components/FloatingChatBot/FloatingChatBot.jsx` | `modules/support/constants/tawk.config.ts`, `modules/support/services/chatbotEngine.ts` |
| **RF34** | Dashboard administrador y sucursal | CU, SEC | `rental.reservations`, `billing.payments`, `fleet.vehicles` | `GET /api/v1/admin/reports/dashboard` (`AdminReportController`) | `src/modules/admin/components/ManagementDashboard.jsx`, `BranchDashboard.jsx` | — (solo web) |
| **RF35** | Gestión de ciudades | CU, CLA | `location.cities`, `location.departments` | `GET/POST /api/v1/cities`, `PUT/DELETE /api/v1/cities/{id}` (`CityController`) | `src/modules/admin/pages/CityManagementPage.jsx` | — |
| **RF36** | Gestión de sucursales | CU, CLA | `location.branches`, `location.branch_users` | `GET/POST /api/v1/branches`, `PUT /api/v1/branches/{id}` (`BranchController`), `/api/v1/branches/{branchId}/staff` (`BranchStaffController`) | `src/modules/admin/pages/BranchManagementPage.jsx` | — |
| **RF37** | Gestión de flota | CU, SEC, CLA | `fleet.vehicles`, `fleet.vehicle_categories`, `fleet.vehicle_statuses` | `GET/POST /api/v1/admin/vehicles`, `PUT /api/v1/admin/vehicles/{id}` (`AdminVehicleController`) | `src/modules/admin/pages/VehicleManagementPage.jsx` | — |
| **RF38** | Gestión de reservas | CU, SEC | `rental.reservations`, `rental.reservation_statuses` | `GET /api/v1/admin/reservations`, `POST /api/v1/admin/reservations/manual`, `/expire-pending` (`AdminReservationController`) | `src/modules/admin/pages/ReservationManagementPage.jsx` | — |
| **RF39** | Gestión de usuarios y clientes | CU, CLA | `iam.users`, `iam.user_profiles` | `GET/POST /api/v1/admin/users`, `PATCH /api/v1/admin/users/{id}/status` (`AdminUserController`) | `src/modules/admin/pages/UserManagementPage.jsx`, `src/modules/admin/components/AccountFormModal.jsx` | — |
| **RF40** | Roles y permisos | CU, SEC, CLA | `iam.roles`, `iam.permissions`, `iam.role_permissions`, `iam.user_roles` | `GET/POST /api/v1/roles` (`RoleController`), `GET /api/v1/permissions` (`PermissionController`), `POST /api/v1/users/{id}/roles` | `src/modules/admin/pages/AdminRolesManagementPage.jsx`, `RolePermissionsModal.jsx` | — |
| **RF41** | Incidencias de vehículos | CU, SEC | `support.incident_reports`, `support.incident_responses` | `GET/POST /api/v1/incidents`, `POST /api/v1/incidents/{id}/responses`, `PATCH /api/v1/incidents/{id}/status` (`IncidentController`) | `src/modules/admin/pages/IncidentManagementPage.jsx` | `modules/support/services/incidentService.ts` |
| **RF42** | Gestión de contratos | CU, SEC | `contract.rental_contracts`, `contract.contract_statuses` | `GET /api/v1/contracts/admin`, `GET /api/v1/contracts/{id}`, `GET /api/v1/contracts/reservation/{reservationId}` (`ContractController`) | `src/modules/admin/pages/ContractManagementPage.jsx` | — |
| **RF43** | Promociones y cupones | CU, SEC | `catalog.promotions`, `catalog.user_coupon_usages` | `GET/POST /api/v1/admin/promotions` (`AdminPromotionController`), `GET /api/v1/promotions/featured` (`PromotionController`) | `src/modules/admin/pages/PromotionManagementPage.jsx` | — |
| **RF44** | Reportes administrativos | CU, SEC | `audit.administrative_report_types`, `audit.generated_reports` | `POST /api/v1/admin/reports/generate`, `GET /api/v1/admin/reports/{id}/download` (`AdminReportController`) | `src/modules/admin/pages/ReportsManagementPage.jsx`, `src/utils/listExportUtils.js` | — |
| **RF45** | Marca e identidad visual | CU, CLA | `core.brand_configurations` | `GET /api/v1/brand-configurations/active`, `PUT /api/v1/brand-configurations` (`BrandController`) | `src/modules/admin/pages/BrandManagementPage.jsx` | — |
| **RF46** | Auditoría | CU, SEC | `audit.audit_logs` | `GET /api/v1/admin/audit-logs`, `GET /api/v1/admin/audit-logs/{id}` (`AdminAuditLogController`) | `src/modules/admin/pages/AuditLogManagementPage.jsx` | — |
| **RF47** | Confirmación de efectivo en sucursal | CU, SEC | `billing.payments`, `billing.payment_receipts` | `POST /api/v1/payments/cash/confirm` (`CashPaymentController`), `GET /api/v1/payments/{id}/receipt` (`PaymentReceiptController`) | `src/modules/admin/pages/CashCollectionPage.jsx` | — |
| **RF48** | Notificaciones operativas de sucursal | CU, SEC | `support.notifications` | `GET /api/v1/notifications`, `GET /api/v1/notifications/unread-count` (`NotificationController`) | `src/modules/admin/pages/BranchNotificationCenterPage.jsx`, `BranchNotificationDrawer.jsx` | — |
| **RF49** | Respuesta a reseñas de sucursal | CU, SEC | `rental.branch_reviews` | `GET /api/v1/admin/reviews/branches`, `PATCH /api/v1/admin/reviews/branches/{id}/reply` (`AdminBranchReviewController`) | `src/modules/admin/pages/BranchReviewsPage.jsx` | — |
| **RF50** | Inspección y entrega | CU, SEC | `contract.vehicle_inspections`, `contract.inspection_checklist_answers` | `POST /api/v1/contracts/{contractId}/inspections` (`VehicleInspectionController`), `GET /api/v1/inspection-checklist` (`InspectionChecklistController`) | `src/modules/admin/pages/DeliveryManagementPage.jsx`, `src/modules/admin/components/InspectionFormModal.jsx` | — |
| **RF51** | Perfil de sucursal | CU, CLA | `location.branches` | `GET/PUT /api/v1/branch-profile` (`BranchProfileController`) | `src/modules/admin/pages/BranchProfilePage.jsx`, `src/modules/catalog/pages/BranchesPage.jsx` | — |
| **RF52** | Validación de entrega con PIN | CU, SEC | `rental.reservation_delivery_points` | `POST /api/v1/admin/deliveries/{reservationId}/{pointType}/complete` (`DeliveryLogisticsController`), `POST /api/v1/public/deliveries/action` (`DeliveryDriverActionController`) | `src/modules/admin/pages/DeliveryManagementPage.jsx` | — |
| **RF53** | Inspección de devolución | CU, SEC | `contract.vehicle_inspections`, `contract.inspection_checklist_answers` | `POST /api/v1/contracts/{contractId}/inspections` (`VehicleInspectionController`) | `src/modules/admin/pages/DeliveryManagementPage.jsx`, `src/modules/admin/components/InspectionNovelties.jsx` | — |
| **RF54** | Cupones por sucursal | CU | `catalog.promotions` | `GET/POST /api/v1/admin/promotions`, `PATCH /api/v1/admin/promotions/{id}/active` (`AdminPromotionController`) | `src/modules/admin/pages/PromotionManagementPage.jsx` | — |

## Requisitos no funcionales

| ID | Requisito | Evidencia en repositorio |
| --- | --- | --- |
| RNF1 | Rendimiento | Índices en `database/01_ddl/10_indexes/`; búsqueda paginada `GET /api/v1/vehicles/search`. |
| RNF2 | Usabilidad y accesibilidad | Etiquetas `aria-*` en web y `accessibilityLabel` en las pantallas principales móviles. |
| RNF3 | Internacionalización | `web-drivique/src/i18n/locales/` y `app-drivique/modules/i18n/translations/` (es, en, fr, pt, br). |
| RNF4 | Temas claro y oscuro | `src/modules/landing/LandingContext.jsx` (web). |
| RNF5 | Compatibilidad | SPA React + Vite; app Expo Router. |
| RNF6 | Seguridad | `SecurityConfig.java` (CORS con lista blanca, JWT, `@PreAuthorize`), firma Wompi en servidor, sesión web en `sessionStorage`. |
| RNF7 | Migraciones | `database/changelog/db.changelog-master.yaml`, `05_rollbacks/`, CI `database/.github/workflows/ci.yml`. |
| RNF8 | Disponibilidad | `HEALTHCHECK` en `Back-end/Dockerfile`; `GET /api/actuator/health`. |
| RNF9 | Mantenibilidad | Clases Java ≤ 500 líneas; CI en los cuatro repositorios de código. |
| RNF10 | Capacidad | API stateless; pool de conexiones HikariCP. |
| RNF11 | Documentación | [openapi.json](../07-backend/contracts/openapi/openapi.json), [swagger.md](../07-backend/api-docs/swagger.md). |
| RNF12 | Resiliencia | Cabecera `Idempotency-Key` en checkout/confirmación; `WompiWebhookIdempotencyTests`. |

## Regla de mantenimiento

Actualizar primero la ficha RF y luego esta matriz, el backlog y las pruebas en el mismo PR. Si se renombra o divide un componente, la columna Web/Móvil se corrige antes del merge. No se agregan endpoints ni tablas inexistentes para completar casillas.
