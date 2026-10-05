# 🗺️ Matriz de Trazabilidad de Requerimientos — Drivique

Esta matriz vincula cada **Requerimiento Funcional (RF)** de Drivique con su correspondiente **Diagrama UML**, **Tabla de Base de Datos**, **Endpoint del Backend (Spring Boot)** y **Vista del Frontend (Web Admin / App Móvil)**.

---

## 📊 Matriz de Trazabilidad Completa

| ID RF | Nombre del Requerimiento Funcional | Diagrama UML Asociado | Tabla Base de Datos (`hu-base-de-datos`) | Endpoint Backend (Spring Boot) | Vista / Componente Frontend |
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
| **RF21b**| Asignación Entrega Domicilio PIN | CU-028: Asignar Chofer Domicilio | `rental.delivery_assignments` | `POST /api/v1/deliveries/assign` | `admin/pages/DeliveryManagementPage.jsx` |
| **RF43**| Promociones y Cupones | CU-029: Administrar Cupones | `billing.promotions` | `POST /api/v1/promotions` | `admin/pages/PromotionManagementPage.jsx` |
| **RF26b**| Reseñas y Resp. Inmutable | CU-030: Publicar Reseñas y Resp.| `support.branch_reviews` | `POST /api/v1/reviews/{id}/response` | `admin/pages/BranchReviewsPage.jsx` |
| **RF34**| Dashboard e Informes KPIs | CU-031: Consultar Dashboard | `billing.payments`, `rental.reservations` | `GET /api/v1/reports/kpis` | `admin/pages/ReportsManagementPage.jsx` |
| **RF35**| Gestión Ciudades y Sedes | CU-032: Administrar Sedes | `location.cities`, `location.branches` | `POST /api/v1/admin/branches` | `admin/pages/BranchManagementPage.jsx` |
| **RF37**| Flota e Incidencias Autos | CU-033: Gestionar Vehículos e Incidencias | `fleet.vehicles`, `fleet.vehicle_incidents` | `POST /api/v1/admin/incidents` | `admin/pages/IncidentManagementPage.jsx` |
| **RF42**| Contratos y Firma Digital | CU-034: Generar y Firmar Contrato | `contract.contracts` | `GET /api/v1/contracts/{id}/pdf` | `admin/pages/ContractManagementPage.jsx` |
| **RF46**| Bitácora Auditoría Forense | CU-035: Auditar Sistema | `audit.audit_logs` | `GET /api/v1/audit/logs` | `admin/pages/AuditLogManagementPage.jsx` |
