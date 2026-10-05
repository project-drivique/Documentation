# 🗺️ Matriz de Trazabilidad de Requerimientos — Drivique

Esta matriz vincula cada **Requerimiento Funcional (RF1 a RF54)** y **Requerimiento No Funcional (RNF1 a RNF12)** de Drivique con su correspondiente **Diagrama UML**, **Tabla de Base de Datos**, **Endpoint del Backend (Spring Boot)** y **Vista/Componente del Frontend (Web Admin / App Móvil)**.

---

## 📊 Matriz de Trazabilidad Completa (RF1 a RF54)

| ID RF | Nombre del Requerimiento Funcional | Diagrama UML Asociado | Tabla Base de Datos (`hu-base-de-datos`) | Endpoint Backend (Spring Boot) | Vista / Componente Frontend (Web & App) |
| :---: | :--- | :--- | :--- | :--- | :--- |
| **RF1** | Página de inicio pública | CU-001: Explorar Landing Page | N/A (Estático) | `GET /api/v1/public/landing` | `landing/LandingPage.jsx` |
| **RF2** | Redirección por sesión activa | CU-002: Autenticar Usuario | `iam.users` | `GET /api/v1/auth/me` | `routes/AppRoutes.jsx` |
| **RF3** | Registro de usuario cliente | CU-003: Registrar Cliente | `iam.users`, `iam.profiles` | `POST /api/v1/auth/register` | `auth/RegisterModal.jsx` |
| **RF4** | Verificación 2FA con OTP | CU-004: Verificar 2FA | `iam.user_otps` | `POST /api/v1/auth/verify-2fa` | `auth/TwoFactorModal.jsx` |
| **RF5** | Inicio de sesión (Login) | CU-005: Iniciar Sesión | `iam.users` | `POST /api/v1/auth/login` | `auth/LoginModal.jsx` |
| **RF6** | Recuperar contraseña | CU-006: Resetear Password | `iam.password_resets` | `POST /api/v1/auth/forgot-password` | `auth/ForgotPasswordModal.jsx` |
| **RF7** | Login administrativo por roles | CU-007: Autenticar Admin | `iam.users`, `iam.roles` | `POST /api/v1/admin/auth/login` | `admin/pages/AdminPage.jsx` |
| **RF8** | Modo invitado sin registro | CU-008: Navegar Invitado | `catalog.vehicles` | `GET /api/v1/catalog/public` | `catalog/CatalogPage.jsx` |
| **RF9** | Buscador principal catálogo | CU-009: Buscar Vehículos | `catalog.vehicles`, `location.branches` | `GET /api/v1/catalog/search` | `catalog/components/CatalogSearch.jsx` |
| **RF10**| Filtros avanzados catálogo | CU-010: Filtrar Catálogo | `fleet.vehicles`, `fleet.categories` | `GET /api/v1/catalog/filter` | `catalog/components/CatalogFilters.jsx` |
| **RF11**| Ordenamiento de resultados | CU-011: Ordenar Catálogo | `catalog.vehicles` | `GET /api/v1/catalog/sort` | `catalog/components/CatalogSort.jsx` |
| **RF12**| Tarjetas informativas de vehículo| CU-012: Visualizar Ficha | `fleet.vehicles`, `core.currencies` | `GET /api/v1/vehicles/{id}` | `catalog/components/VehicleCard.jsx` |
| **RF13**| Detalle técnico del vehículo | CU-013: Ver Detalle Vehículo| `fleet.vehicles`, `support.reviews` | `GET /api/v1/vehicles/{id}/details`| `catalog/VehicleDetailPage.jsx` |
| **RF14**| Menú de navegación cliente | CU-014: Navegar Menú | N/A | N/A | `components/Navbar.jsx` |
| **RF15**| Sección Mis Reservas | CU-015: Consultar Reservas | `rental.reservations` | `GET /api/v1/reservations/my-reservations` | `reservations/MyReservationsPage.jsx` |
| **RF16**| Sección Favoritos | CU-016: Gestionar Favoritos | `catalog.user_favorites` | `POST /api/v1/favorites/toggle` | `profile/FavoritesPage.jsx` |
| **RF17**| Centro de notificaciones | CU-017: Ver Notificaciones | `support.notifications` | `GET /api/v1/notifications` | `notifications/NotificationCenter.jsx` |
| **RF18**| Soporte y FAQ | CU-018: Consultar Soporte | `support.faqs` | `GET /api/v1/support/faqs` | `support/SupportPage.jsx` |
| **RF19**| Paso 1 Reserva: Selección Auto | CU-019: Iniciar Reserva | `rental.reservations` | `POST /api/v1/reservations/init` | `reservations/ReservationWizardStep1.jsx` |
| **RF20**| Paso 2 Reserva: Lugar y Domicilio| CU-020: Configurar Entrega | `location.branches` | `POST /api/v1/reservations/delivery-option` | `reservations/ReservationWizardStep2.jsx` |
| **RF21**| Resumen de Reserva y Costos | CU-021: Validar Resumen | `rental.reservations` | `POST /api/v1/reservations/summary` | `reservations/ReservationSummaryStep.jsx` |
| **RF22**| Coberturas de Protección | CU-022: Elegir Seguro | `rental.insurance_plans` | `GET /api/v1/insurance-plans` | `reservations/InsuranceSelector.jsx` |
| **RF23**| Servicios adicionales y Km | CU-023: Agregar Opcionales | `rental.reservation_addons` | `GET /api/v1/addons` | `reservations/AddonsSelector.jsx` |
| **RF24**| Formulario Datos Conductor | CU-024: Registrar Conductor| `rental.drivers` | `POST /api/v1/reservations/driver-info` | `reservations/DriverFormStep.jsx` |
| **RF25**| Verificación Documental | CU-025: Subir Documentos | `rental.driver_documents` | `POST /api/v1/documents/upload` | `admin/pages/DocumentVerificationPage.jsx` |
| **RF26**| Pago en línea Wompi | CU-026: Procesar Wompi | `billing.payments` | `POST /api/v1/payments/wompi/init` | `payments/WompiCheckoutWidget.jsx` |
| **RF27**| Cobro en Efectivo PIN Sede | CU-027: Pagar Efectivo PIN | `billing.cash_collection_receipts` | `POST /api/v1/payments/cash/confirm` | `admin/pages/CashCollectionPage.jsx` |
| **RF28**| Contratos y Firma Digital | CU-028: Firmar Contrato | `contract.contracts` | `POST /api/v1/contracts/sign` | `contracts/DigitalContractViewer.jsx` |
| **RF29**| Ver y editar información personal | CU-029: Editar Perfil | `iam.profiles` | `PUT /api/v1/users/profile` | `profile/EditProfilePage.jsx` |
| **RF30**| Cambiar contraseña | CU-030: Modificar Password| `iam.users` | `PUT /api/v1/users/change-password` | `profile/ChangePasswordPage.jsx` |
| **RF31**| Cerrar sesión | CU-031: Logout | N/A | `POST /api/v1/auth/logout` | `components/Navbar.jsx` |
| **RF32**| Onboarding para nuevos usuarios | CU-032: Ver Tutorial | N/A | N/A | `onboarding/OnboardingModal.jsx` |
| **RF33**| Chat flotante de soporte | CU-033: Asistencia Chat | `support.chat_messages` | `POST /api/v1/support/chat` | `support/FloatingChatWidget.jsx` |
| **RF34**| Dashboard del Administrador | CU-034: Consultar KPIs | `billing.payments`, `rental.reservations` | `GET /api/v1/admin/dashboard` | `admin/pages/ReportsManagementPage.jsx` |
| **RF35**| Gestión de Ciudades | CU-035: Administrar Ciudades| `location.cities` | `POST /api/v1/admin/cities` | `admin/pages/CityManagementPage.jsx` |
| **RF36**| Gestión de Sucursales | CU-036: Administrar Sedes | `location.branches` | `POST /api/v1/admin/branches` | `admin/pages/BranchManagementPage.jsx` |
| **RF37**| Gestión de Vehículos | CU-037: Gestionar Flota | `fleet.vehicles` | `POST /api/v1/admin/vehicles` | `admin/pages/VehicleManagementPage.jsx` |
| **RF38**| Gestión de Reservas Admin | CU-038: Administrar Reservas| `rental.reservations` | `GET /api/v1/admin/reservations` | `admin/pages/ReservationManagementPage.jsx` |
| **RF39**| Gestión de Usuarios Cliente | CU-039: Administrar Clientes| `iam.users` | `GET /api/v1/admin/users` | `admin/pages/UserManagementPage.jsx` |
| **RF40**| Gestión de Roles y Permisos | CU-040: Administrar Roles | `iam.roles`, `iam.permissions` | `POST /api/v1/admin/roles` | `admin/pages/AdminRolesManagementPage.jsx` |
| **RF41**| Gestión de Incidencias Autos | CU-041: Reportar Averías | `fleet.vehicle_incidents` | `POST /api/v1/admin/incidents` | `admin/pages/IncidentManagementPage.jsx` |
| **RF42**| Gestión de Contratos Admin | CU-042: Administrar Contratos| `contract.contracts` | `GET /api/v1/admin/contracts` | `admin/pages/ContractManagementPage.jsx` |
| **RF43**| Gestión de Promociones y Cupones| CU-043: Administrar Cupones | `billing.promotions` | `POST /api/v1/admin/promotions` | `admin/pages/PromotionManagementPage.jsx` |
| **RF44**| Reportes Administrativos | CU-044: Generar Reportes | `billing.payments`, `rental.reservations` | `GET /api/v1/admin/reports/export` | `admin/pages/ReportsManagementPage.jsx` |
| **RF45**| Configuración de Marca | CU-045: Ajustar Branding | `core.brand_config` | `PUT /api/v1/admin/brand` | `admin/pages/BrandManagementPage.jsx` |
| **RF46**| Auditoría y Bitácora Forense | CU-046: Consultar Logs | `audit.audit_logs` | `GET /api/v1/admin/audit-logs` | `admin/pages/AuditLogManagementPage.jsx` |
| **RF47**| Confirmación de Pago en Efectivo| CU-047: Procesar Pago Caja | `billing.cash_collection_receipts` | `POST /api/v1/admin/payments/cash/confirm` | `admin/pages/CashCollectionPage.jsx` |
| **RF48**| Entrega a Domicilio con Chofer | CU-048: Asignar Conductor | `rental.delivery_assignments` | `POST /api/v1/admin/deliveries/assign` | `admin/pages/DeliveryManagementPage.jsx` |
| **RF49**| Reseñas y Resp. Inmutable | CU-049: Responder Reseñas | `support.branch_reviews` | `POST /api/v1/admin/reviews/{id}/response` | `admin/pages/BranchReviewsPage.jsx` |
| **RF50**| Centro de Notificaciones Sede | CU-050: Notificar Sucursal | `support.notifications` | `GET /api/v1/admin/notifications` | `admin/pages/BranchNotificationCenterPage.jsx` |
| **RF51**| Perfil de Sucursal | CU-051: Configurar Sede | `location.branches` | `PUT /api/v1/admin/branch-profile` | `admin/pages/BranchProfilePage.jsx` |
| **RF52**| Verificación Documental Admin | CU-052: Auditar Documentos| `rental.driver_documents` | `POST /api/v1/admin/documents/verify` | `admin/pages/DocumentVerificationPage.jsx` |
| **RF53**| Categorización de Vehículos | CU-053: Administrar Tipos | `fleet.categories` | `POST /api/v1/admin/categories` | `admin/pages/VehicleManagementPage.jsx` |
| **RF54**| Gestión de Encargados de Sucursal| CU-054: Asignar Managers | `iam.user_branches` | `POST /api/v1/admin/branch-managers` | `admin/pages/BranchManagerPage.jsx` |
