# Matriz de trazabilidad de requisitos - Drivique

**Fecha de sincronización:** 2026-10-06. La numeración y los nombres corresponden exactamente a las 54 fichas de [functional-requirements.md](functional-requirements.md). Se corrigieron las asociaciones antiguas de pagos, contratos, historial y operación de sucursal.

## Alcance y evidencia

- **App:** solo cliente final; sin panel administrativo.
- **Web:** portal cliente y panel administrativo por rol/sucursal.
- **PIN de entrega:** exactamente 4 dígitos numéricos; OTP de correo de 6 dígitos es otro flujo.
- **BD:** tablas contrastadas con SQL del commit `681041da4d882aebf2b157cbc827e0b265af7147` de database; consultar el [diccionario](../04-architecture/database/data-dictionary.md).
- **API:** rutas observadas en controllers del commit `10309795b6af42ef6467e8c409a845a1e3b723bb` de Back-end, prefijo `/api` incluido. La presencia de una ruta no demuestra que cubra todo el RF ni que una prueba haya pasado.
- **UI:** componentes requeridos por las fichas; validar su correspondencia exacta con los frontends.
- **UML:** se conservan las [fuentes disponibles](../03-design/uml/diagrams/source/). Los IDs CU-001 a CU-054 de la matriz anterior no tenían correspondencia verificada con nodos de diagramas; no se certifican como diagramas existentes. Debe vincularse el caso de uso y la secuencia reales por función antes de cerrar cobertura UML.

## Requisitos funcionales RF1 a RF54

| ID RF | Nombre de la ficha detallada | UML | Tablas del modelo revisado | Endpoint observado en backend | Interfaz requerida por el RF |
| --- | --- | --- | --- | --- | --- |
| **RF1** | Página de inicio (visitante sin sesión) | Vincular CU/secuencia de esta función | `fleet.vehicles` | `GET /api/v1/vehicles/featured` | Interfaz LandingPage, HeroSection, FeaturedVehicles, HowItWorks, Footer |
| **RF2** | Redirección tras inicio de sesión | Vincular CU/secuencia de esta función | `iam.users`, `iam.user_roles`, `iam.roles` | `GET /api/v1/users/me` | Guardias de Navegación ProtectedRoute, GuestRoute, Almacén de Autenticación |
| **RF3** | Registro de usuario | Vincular CU/secuencia de esta función | `iam.users`, `iam.verification_codes` | `POST /api/v1/auth/register` | Interfaz RegisterPage, RegisterForm, PasswordStrengthBar |
| **RF4** | Verificación de identidad con doble factor (2FA / Código de Correo) | Vincular CU/secuencia de esta función | `iam.verification_codes`, `iam.users` | `POST /api/v1/auth/verify-email` | Interfaz Verify2FAPage, OTPInputGroup, CountdownTimer |
| **RF5** | Inicio de sesión | Vincular CU/secuencia de esta función | `iam.users`, `iam.user_sessions` | `POST /api/v1/auth/login` | Interfaz LoginPage, LoginForm |
| **RF6** | Recuperar contraseña | Vincular CU/secuencia de esta función | `iam.verification_codes`, `iam.users` | `POST /api/v1/auth/forgot-password`<br>`POST /api/v1/auth/validate-reset-code`<br>`POST /api/v1/auth/reset-password` | Rutas Recuperación de Contraseña y Restablecimiento de Contraseña -> ForgotPasswordPage, ResetPasswordPage |
| **RF7** | Inicio de sesión con rol (Administrador y Encargado de sucursal) | Vincular CU/secuencia de esta función | `iam.users`, `iam.user_roles`, `iam.roles`, `iam.role_permissions`, `iam.permissions` | `POST /api/v1/auth/login` | Rúter Principal -> AppRoutes, RoleBasedGuard |
| **RF8** | Acceso modo invitado sin registro | Vincular CU/secuencia de esta función | `fleet.vehicles` | `GET /api/v1/vehicles/search` | Catálogo de Vehículos, Modal Emergente de Detalle de Vehículo |
| **RF9** | Encabezado y buscador del catálogo | Vincular CU/secuencia de esta función | `fleet.vehicles`, `location.branches`, `location.cities` | `GET /api/v1/vehicles/search` | Interfaz CatalogHeader, SearchBar |
| **RF10** | Filtros del catálogo | Vincular CU/secuencia de esta función | `fleet.vehicles`, `fleet.vehicle_categories` | `GET /api/v1/vehicles/search` | Componente CatalogSidebarFilters en Catálogo de Vehículos |
| **RF11** | Ordenar resultados del catálogo | Vincular CU/secuencia de esta función | `fleet.vehicles` | `GET /api/v1/vehicles/search` | Componente CatalogSortDropdown |
| **RF12** | Tarjetas de vehículos | Vincular CU/secuencia de esta función | `fleet.vehicles`, `fleet.vehicle_images` | `GET /api/v1/vehicles/{id}` | Componente VehicleCard en catálogo y vistas principales |
| **RF13** | Ver detalles de un vehículo | Vincular CU/secuencia de esta función | `fleet.vehicles`, `fleet.vehicle_features`, `rental.vehicle_ratings` | `GET /api/v1/vehicles/{id}`<br>`GET /api/v1/vehicles/{id}/features`<br>`GET /api/v1/vehicles/{id}/reviews` | Ruta Modal Emergente de Detalle de Vehículo -> VehicleDetailsModal, ImageGallery, ReviewsSection |
| **RF14** | Menú de navegación principal catálogo | Vincular CU/secuencia de esta función | UI / servicio externo o persistencia por validar | No requiere endpoint para navegación | Componente CustomerNavbar |
| **RF15** | Sección menú Mis Reservas | Vincular CU/secuencia de esta función | `rental.reservations` | `GET /api/v1/reservations/me` | Interfaz MyReservationsPage, ReservationCard, LeaveReviewModal |
| **RF16** | Sección menú Mis Favoritos | Vincular CU/secuencia de esta función | `fleet.user_favorite_vehicles` | `GET /api/v1/users/me/favorites`<br>`POST /api/v1/users/me/favorites/{vehicleId}`<br>`DELETE /api/v1/users/me/favorites/{vehicleId}` | Interfaz FavoritesPage |
| **RF17** | Sección menú Notificaciones (Cliente) | Vincular CU/secuencia de esta función | `support.notifications` | `GET /api/v1/notifications`<br>`PATCH /api/v1/notifications/{id}/read` | Interfaz CustomerNotificationsPage |
| **RF18** | Sección menú Soporte | Vincular CU/secuencia de esta función | UI / servicio externo o persistencia por validar | Sin endpoint específico identificado | Interfaz SupportCenterPage, FAQAccordion, ContactForm |
| **RF19** | Configuración de reserva, fechas, horarios y sucursales (Paso 1 del Wizard) | Vincular CU/secuencia de esta función | `rental.reservations`, `location.branches`, `rental.reservation_delivery_points` | `POST /api/v1/reservations`<br>`POST /api/v1/reservations/{id}/delivery-points` | Interfaz ReservationFlowPage, UnifiedReservationConfigCard, DateStep, DomicilioModal, PicoYPlacaChecker |
| **RF20** | Selección de coberturas de protección y servicios adicionales (Paso 2 del Wizard) | Vincular CU/secuencia de esta función | `catalog.insurance_coverages`, `catalog.additional_services`, `catalog.mileage_plans`, `rental.reservation_additional_services` | `GET /api/v1/additional-services`<br>`GET /api/v1/insurance-coverages`<br>`GET /api/v1/mileage-plans` | Componentes ProtectionPlans, AdditionalServices, SideSummary en ReservationFlowPage |
| **RF21** | Datos del conductor, comprobación de licencia y cupones de descuento (Paso 3 del Wizard) | Vincular CU/secuencia de esta función | `iam.users`, `iam.user_documents`, `catalog.promotions`, `catalog.user_coupon_usages` | `POST /api/v1/promotions/validate` | Componentes PersonalData, SideSummary en ReservationFlowPage |
| **RF22** | Resumen financiero final y selección de método de pago (Paso 4 del Wizard) | Vincular CU/secuencia de esta función | `rental.reservations`, `rental.reservation_additional_services`, `rental.reservation_promotions` | `POST /api/v1/pricing/quote` | Componentes PaymentMethodCard, SideSummary en ReservationFlowPage |
| **RF23** | Procesamiento de pago digital en línea (Pasarela Virtual Wompi) | Vincular CU/secuencia de esta función | `billing.payments`, `billing.payment_methods`, `billing.payment_statuses` | `POST /api/v1/payments/wompi/initiate`<br>`POST /api/v1/payments/wompi/webhook` | Interfaz PaymentResponsePage, Estrategia de Pago Wompi |
| **RF24** | Cobro presencial en efectivo en sucursal con plazo de vencimiento dinámico | Vincular CU/secuencia de esta función | `rental.reservations`, `billing.payments`, `billing.payment_receipts` | `POST /api/v1/payments/cash/confirm`<br>`POST /api/v1/admin/reservations/expire-pending` | Cliente: ReservationsPage \| Admin/Encargado: CashCollectionPage |
| **RF25** | Carga y verificación documental de identidad y licencia (Cédula y Licencia) | Vincular CU/secuencia de esta función | `iam.user_documents`, `iam.document_types`, `iam.document_statuses` | `GET /api/v1/users/me/documents`<br>`POST /api/v1/users/me/documents`<br>`PATCH /api/v1/kyc/documents/{id}/review` | Cliente: Perfil de Usuario \| Admin: DocumentVerificationPage |
| **RF26** | Generación y firma electrónica del contrato digital de alquiler | Vincular CU/secuencia de esta función | `contract.rental_contracts`, `contract.contract_clauses`, `contract.contract_clause_assignments` | `POST /api/v1/contracts/generate`<br>`POST /api/v1/contracts/{id}/sign` | Interfaz ContractSigningPage, SignatureCanvas |
| **RF27** | Generación y verificación del código PIN de seguridad para entrega y recogida | Vincular CU/secuencia de esta función | Pendiente modelo específico de PIN de entrega | Sin endpoint específico identificado | Cliente: ReservationsPage \| Admin: DeliveryManagementPage |
| **RF28** | Historial, consulta y seguimiento de reservas del cliente | Vincular CU/secuencia de esta función | `rental.reservations` | `GET /api/v1/reservations/me`<br>`GET /api/v1/reservations/{id}` | Interfaz ReservationsPage |
| **RF29** | Ver y editar información personal | Vincular CU/secuencia de esta función | `iam.users`, `iam.user_profiles` | `GET /api/v1/users/me`<br>`PUT /api/v1/users/me` | Interfaz UserProfilePage, EditProfileForm |
| **RF30** | Cambiar contraseña | Vincular CU/secuencia de esta función | `iam.users` | Sin endpoint específico identificado | Componente ChangePasswordTab en Perfil de Usuario |
| **RF31** | Cerrar sesión | Vincular CU/secuencia de esta función | `iam.user_sessions` | `POST /api/v1/auth/logout` | Menú de Usuario -> Almacén de Autenticación |
| **RF32** | Onboarding para nuevos usuarios | Vincular CU/secuencia de esta función | UI / servicio externo o persistencia por validar | Sin endpoint específico identificado | Componente WelcomeOnboardingModal |
| **RF33** | Chat flotante de soporte (Widget Tawk.to) | Vincular CU/secuencia de esta función | UI / servicio externo o persistencia por validar | Sin endpoint específico identificado | Componente LiveChatWidget |
| **RF34** | Dashboard del administrador y sucursal | Vincular CU/secuencia de esta función | `rental.reservations`, `billing.payments`, `fleet.vehicles` | Sin endpoint específico identificado | Rutas Panel del Administrador y Panel del Encargado de Sucursal -> AdminDashboardPage, KPICardGroup, RevenueChart |
| **RF35** | Gestión de ciudades | Vincular CU/secuencia de esta función | `location.cities`, `location.departments` | `GET /api/v1/cities`<br>`POST /api/v1/cities`<br>`PUT /api/v1/cities/{id}` | Interfaz ManageCitiesPage, CityModal |
| **RF36** | Gestión de Sucursales | Vincular CU/secuencia de esta función | `location.branches`, `location.branch_users` | `GET /api/v1/branches`<br>`POST /api/v1/branches`<br>`PUT /api/v1/branches/{id}` | Interfaz ManageBranchesPage, BranchFormModal |
| **RF37** | Gestión de vehículos (Flota) | Vincular CU/secuencia de esta función | `fleet.vehicles`, `fleet.vehicle_categories`, `fleet.vehicle_statuses` | `GET /api/v1/admin/vehicles`<br>`POST /api/v1/admin/vehicles`<br>`PUT /api/v1/admin/vehicles/{id}` | Interfaz ManageFleetPage, VehicleFormModal |
| **RF38** | Gestión de reservas | Vincular CU/secuencia de esta función | `rental.reservations`, `rental.reservation_statuses` | `GET /api/v1/reservations/{id}`<br>`POST /api/v1/admin/reservations/expire-pending` | Interfaz ManageReservationsPage, ReservationDetailModal |
| **RF39** | Gestión de usuarios y clientes | Vincular CU/secuencia de esta función | `iam.users`, `iam.user_profiles` | `GET /api/v1/users/me`<br>`PUT /api/v1/users/me` | Interfaz ManageUsersPage, UserProfileDetailModal |
| **RF40** | Gestión de administradores, roles y permisos | Vincular CU/secuencia de esta función | `iam.users`, `iam.roles`, `iam.permissions`, `iam.user_roles`, `iam.role_permissions` | `GET /api/v1/roles`<br>`GET /api/v1/permissions`<br>`POST /api/v1/users/{id}/roles` | Interfaz ManageRolesPage, AdminUserModal |
| **RF41** | Gestión de reportes de incidencias de vehículos | Vincular CU/secuencia de esta función | `support.incident_reports`, `support.incident_responses` | `POST /api/v1/incidents`<br>`POST /api/v1/incidents/{id}/responses` | Interfaz ManageIncidentsPage, IncidentReportModal |
| **RF42** | Gestión de contratos | Vincular CU/secuencia de esta función | `contract.rental_contracts`, `contract.contract_statuses` | `GET /api/v1/contracts/{id}`<br>`GET /api/v1/contracts/reservation/{reservationId}` | Interfaz ManageContractsPage |
| **RF43** | Gestión de promociones, cupones y ofertas destacadas | Vincular CU/secuencia de esta función | `catalog.promotions`, `catalog.user_coupon_usages` | `POST /api/v1/promotions/validate`<br>`GET /api/v1/promotions/featured` | Interfaz ManagePromotionsPage, CouponFormModal, FeaturedPromoCard |
| **RF44** | Reportes administrativos | Vincular CU/secuencia de esta función | `audit.administrative_report_types`, `audit.generated_reports` | `POST /api/v1/admin/reports/generate`<br>`GET /api/v1/admin/reports/{id}/download` | Interfaz ReportsPage, ReportExportWidget |
| **RF45** | Configuración de marca e identidad visual | Vincular CU/secuencia de esta función | `core.brand_configurations` | `GET /api/v1/brand-configurations/active`<br>`PUT /api/v1/brand-configurations` | Interfaz BrandSettingsPage |
| **RF46** | Auditoría y registro de actividad | Vincular CU/secuencia de esta función | `audit.audit_logs` | `GET /api/v1/admin/audit-logs`<br>`GET /api/v1/admin/audit-logs/{id}` | Interfaz AuditLogsPage |
| **RF47** | Confirmación de pago en efectivo (sucursal) | Vincular CU/secuencia de esta función | `rental.reservations`, `billing.payments`, `billing.payment_receipts` | `POST /api/v1/payments/cash/confirm` | Interfaz BranchCashierPage, CashPaymentReceiptModal |
| **RF48** | Centro de notificaciones operativas de sucursal | Vincular CU/secuencia de esta función | `support.notifications` | `GET /api/v1/notifications` | Interfaz BranchNotificationCenterPage |
| **RF49** | Moderación y respuesta a reseñas de sucursal | Vincular CU/secuencia de esta función | `rental.branch_reviews` | `POST /api/v1/reviews/branches` | Interfaz BranchReviewsPage, OfficialResponseModal |
| **RF50** | Inspección y entrega del vehículo | Vincular CU/secuencia de esta función | `contract.vehicle_inspections`, `contract.inspection_checklist_answers` | `POST /api/v1/contracts/{contractId}/inspections` | Interfaz DeliveryManagementPage, InspectionChecklist |
| **RF51** | Perfil Público y Operativo de Sucursal | Vincular CU/secuencia de esta función | `location.branches` | `GET /api/v1/branches/{id}`<br>`PUT /api/v1/branches/{id}` | Interfaz BranchProfilePage |
| **RF52** | Validación de Entrega con PIN Nequi | Vincular CU/secuencia de esta función | Pendiente modelo específico de PIN de entrega | Sin endpoint específico identificado | Modal BranchPinValidationModal en la vista de entregas |
| **RF53** | Formulario de Inspección de Devolución | Vincular CU/secuencia de esta función | `contract.vehicle_inspections`, `contract.inspection_checklist_answers` | `POST /api/v1/contracts/{contractId}/inspections` | Interfaz ReturnInspectionPage, ReturnChecklist |
| **RF54** | Gestión de Cupones Promocionales por Sucursal | Vincular CU/secuencia de esta función | `catalog.promotions` | `POST /api/v1/promotions/validate`<br>`GET /api/v1/promotions/featured` | Interfaz BranchCouponsPage |

## Observaciones de cobertura e implementación

- **RF2:** La redirección por rol se realiza en el cliente; la consulta de identidad es apoyo.
- **RF7:** El login es compartido; confirmar autorización administrativa y de sede en cada operación.
- **RF11:** Validar que el contrato de búsqueda exponga el ordenamiento requerido.
- **RF18:** Canales de ayuda externos/UI; no se identificó endpoint FAQ dedicado.
- **RF19:** Creación y puntos de entrega observados; no representan endpoints separados por paso visual.
- **RF21:** Validación de cupón observada; validar cobertura completa de datos y licencia del conductor.
- **RF24:** Recaudo y proceso de expiración observados; fórmula exacta de vencimiento aún requiere definición.
- **RF27:** Pendiente persistencia específica y endpoint de validación del PIN de entrega de 4 dígitos.
- **RF30:** No se identificó endpoint dedicado de cambio de contraseña autenticado; reset-password no es equivalente.
- **RF32:** No se identificó campo first-login/onboarding en el DDL; validar persistencia de la preferencia.
- **RF33:** Integración de chat externo; no se presupone tabla o endpoint propio de mensajes.
- **RF34:** Pendiente identificar contrato específico de KPIs/dashboard; reportes no equivalen a cobertura total del dashboard.
- **RF38:** Consulta de reserva y expiración son soporte parcial; validar listado, cambios y cancelación administrativos.
- **RF39:** users/me atiende al usuario autenticado; falta identificar cobertura de gestión administrativa de clientes.
- **RF40:** Consulta de roles/permisos y asignación a usuario; validar creación/modificación y alcance del RF completo.
- **RF41:** El modelo encontrado es de incidencias de soporte; validar su cobertura para incidencias de vehículo.
- **RF42:** Consulta individual/por reserva observada; validar listado y gestión administrativa completos.
- **RF43:** Validación y destacados observados; pendiente identificar CRUD administrativo de promociones.
- **RF48:** Endpoint de notificaciones de usuario observado; validar canal WebSocket y ámbito operativo de sede.
- **RF49:** POST reviews/branches publica reseña de cliente; no responde oficialmente. Faltan fotos, respuesta oficial y su inmutabilidad en el DDL revisado.
- **RF50:** Inspección observada; validación del PIN de entrega requiere implementación adicional.
- **RF51:** Consulta/edición de sucursal observadas; validar campos operativos y aprobación de cambios de ubicación.
- **RF52:** Pendiente endpoint y persistencia de PIN de entrega de exactamente 4 dígitos; no usar código de efectivo como sustituto.
- **RF53:** Inspección observada; validar liquidación de cargos, cierre y disponibilidad del vehículo.
- **RF54:** Promociones generales observadas; falta identificar ámbito/CRUD exclusivo de sucursal.


La vinculación de UML se valida por comportamiento; un número igual entre RF y CU no basta. RF puramente visuales pueden no requerir una secuencia backend, pero su interacción/actor debe representarse y justificarse en la cobertura de diseño. No se agregan endpoints ni tablas inexistentes para completar casillas.

## Requisitos no funcionales RNF1 a RNF12

| ID | Requisito | RF relacionados / ámbito | Diseño y evidencia de verificación |
| --- | --- | --- | --- |
| RNF1 | Rendimiento | RF1–RF54 según operaciones | Arquitectura y pruebas de latencia/carga con umbrales acordados. |
| RNF2 | Usabilidad | Recorridos de cliente y administración | Diseños UI y evaluación de tareas/accesibilidad. |
| RNF3 | Internacionalización | Interfaz cliente y web según alcance | Cinco variantes: es, en, fr, pt y pt-BR; mapear clave interna br y probar traducciones. |
| RNF4 | Temas claro y oscuro | Interfaces web y app | Tokens/temas y revisión de contraste. |
| RNF5 | Compatibilidad | Plataformas y dispositivos de entrega | Matriz de navegadores, tamaños y versiones Android. |
| RNF6 | Seguridad | Identidad, datos, pagos y ámbito de sede | Autorización, protección de datos y pruebas de acceso. |
| RNF7 | Escalabilidad y migraciones | Persistencia compartida | Changelogs Liquibase y validación de migraciones/recuperación. |
| RNF8 | Disponibilidad | API, BD y servicios externos | Medición de servicio y recuperación en entorno definido. |
| RNF9 | Mantenibilidad | Web, móvil y backend | ADR, modularidad y controles de calidad acordados. |
| RNF10 | Adaptabilidad y carga | Infraestructura de operación | Pruebas de capacidad y respuesta a picos. |
| RNF11 | Documentación | RF1–RF54 y contratos técnicos | SRS, API, diagramas, diccionario y guías revisados. |
| RNF12 | Resiliencia | Sesión, reserva, pagos y fallos externos | Pruebas de recuperación de borradores, reintentos y no duplicación. |

## Regla de mantenimiento

Actualizar primero la ficha RF y después sus relaciones de matriz, resumen, backlog, diagramas y pruebas. Conservar IDs estables. Distinguir una decisión de producto, una ruta observada y una capacidad implementada/probada; ninguna sustituye a las otras.
