# Rutas del Back-end sin pantalla

> Generado el 2026-11-01 comparando las rutas de los controladores del Back-end con las llamadas que hacen la web y la app móvil.
> De **235** rutas, **53** no tienen una llamada que las use. El método busca las rutas escritas en el código de los clientes; una ruta armada de forma dinámica podría aparecer aquí aunque se use, así que esta lista es un punto de partida para decidir y no una prueba definitiva.

Cada ruta queda en una de dos categorías:

* **Uso externo:** no necesita pantalla porque la llama otro sistema o se abre desde un enlace.
* **Sin pantalla todavía:** la ruta existe y está protegida por rol, pero ninguna pantalla la usa. No se retira: queda pendiente de una pantalla o de una decisión del equipo.

## Uso externo (no necesitan pantalla)

| Ruta | Quién la usa |
|---|---|
| `GET /api/v1/public/deliveries/action` | Se abre desde el enlace del correo que recibe el conductor; responde su propia página |
| `POST /api/v1/public/deliveries/action` | Se abre desde el enlace del correo que recibe el conductor; responde su propia página |
| `POST /api/v1/payments/wompi/payment-methods` | Lo llama Wompi (servidor a servidor) |
| `POST /api/v1/payments/wompi/webhook` | Lo llama Wompi (servidor a servidor) |

## Sin pantalla todavía

| Controlador | Ruta | Para qué sirve |
|---|---|---|
| AdminRentalExtensionController | `GET /api/v1/admin/extensions` | Administración de extensiones de alquiler |
| AdminRentalExtensionController | `GET /api/v1/admin/extensions/*` | Administración de extensiones de alquiler |
| AdminRentalExtensionController | `PATCH /api/v1/admin/extensions/*` | Administración de extensiones de alquiler |
| AdminReportController | `GET /api/v1/admin/reports/types` | Tipos de reporte, generación y descarga (la pantalla de reportes usa otras rutas del mismo controlador) |
| AdminReportController | `POST /api/v1/admin/reports/generate` | Tipos de reporte, generación y descarga (la pantalla de reportes usa otras rutas del mismo controlador) |
| AdminReportController | `GET /api/v1/admin/reports/*/download` | Tipos de reporte, generación y descarga (la pantalla de reportes usa otras rutas del mismo controlador) |
| AdminReservationController | `POST /api/v1/admin/reservations/expire-pending` | Vencimiento manual de reservas pendientes |
| AdminVehicleController | `PATCH /api/v1/admin/vehicles/*/toggle-status` | Estado alterno y características de vehículo |
| AdminVehicleController | `POST /api/v1/admin/vehicles/*/features` | Estado alterno y características de vehículo |
| AdminVehicleController | `DELETE /api/v1/admin/vehicles/*/features/*` | Estado alterno y características de vehículo |
| AuthController | `GET /api/v1/auth/me` | Funcionalidad de apoyo |
| BranchController | `GET /api/v1/branches/*/reviews` | Funcionalidad de apoyo |
| CashPaymentController | `GET /api/v1/payments/cash/pending` | Funcionalidad de apoyo |
| CatalogController | `PATCH /api/v1/languages/*/toggle-status` | Idiomas y sincronización de tasas de cambio |
| CatalogController | `POST /api/v1/exchange-rates/sync` | Idiomas y sincronización de tasas de cambio |
| ConsentController | `POST /api/v1/consents` | Consentimientos de uso de datos |
| ConsentController | `GET /api/v1/users/me/consents` | Consentimientos de uso de datos |
| ConsentController | `GET /api/v1/consents/status` | Consentimientos de uso de datos |
| ContractController | `GET /api/v1/contracts/clauses` | Funcionalidad de apoyo |
| ContractController | `GET /api/v1/contracts/number/*` | Funcionalidad de apoyo |
| DepartmentController | `GET /api/v1/departments/*/cities` | Funcionalidad de apoyo |
| FeatureController | `GET /api/v1/features/all` | Catálogo de características |
| FeatureController | `GET /api/v1/features/vehicle/*` | Catálogo de características |
| KycAuditController | `GET /api/v1/kyc/documents/*/file` | Descarga de documentos de identidad por personal autorizado |
| MaintenanceController | `POST /api/v1/admin/maintenances` | Mantenimientos de vehículo |
| MaintenanceController | `PATCH /api/v1/admin/maintenances/*/complete` | Mantenimientos de vehículo |
| MaintenanceController | `GET /api/v1/admin/vehicles/*/maintenances` | Mantenimientos de vehículo |
| PaymentReceiptController | `GET /api/v1/payments/*/receipt` | Comprobante de pago en PDF |
| PricingCatalogController | `POST /api/v1/admin/additional-services` | Alta y edición de servicios adicionales y coberturas |
| PricingCatalogController | `PUT /api/v1/admin/additional-services/*` | Alta y edición de servicios adicionales y coberturas |
| PricingCatalogController | `POST /api/v1/admin/insurance-coverages` | Alta y edición de servicios adicionales y coberturas |
| PricingCatalogController | `PUT /api/v1/admin/insurance-coverages/*` | Alta y edición de servicios adicionales y coberturas |
| RentalExtensionController | `POST /api/v1/reservations/*/extensions` | Solicitud de extensiones de alquiler por la persona usuaria |
| RentalExtensionController | `GET /api/v1/reservations/*/extensions` | Solicitud de extensiones de alquiler por la persona usuaria |
| ReservationController | `GET /api/v1/reservations/*/allowed-transitions` | Funcionalidad de apoyo |
| ReservationController | `PATCH /api/v1/reservations/*/services` | Funcionalidad de apoyo |
| ReservationDeliveryPointController | `PUT /api/v1/reservations/*/delivery-points/*` | Funcionalidad de apoyo |
| SecurityConfigurationController | `GET /api/v1/security-configurations` | Lectura de la configuración de seguridad |
| UserController | `POST /api/v1/users/*/roles` | Asignación de roles |
| UserDocumentController | `GET /api/v1/users/me/documents/*/file` | Descarga del documento propio |
| VehicleAssetController | `GET /api/v1/admin/vehicles/*/images` | Imágenes y documentos de vehículo |
| VehicleAssetController | `POST /api/v1/admin/vehicles/*/images` | Imágenes y documentos de vehículo |
| VehicleAssetController | `PATCH /api/v1/admin/vehicles/*/images/*/primary` | Imágenes y documentos de vehículo |
| VehicleAssetController | `DELETE /api/v1/admin/vehicles/*/images/*` | Imágenes y documentos de vehículo |
| VehicleAssetController | `GET /api/v1/admin/vehicles/documents/expiring` | Imágenes y documentos de vehículo |
| VehicleAssetController | `GET /api/v1/admin/vehicles/*/documents` | Imágenes y documentos de vehículo |
| VehicleAssetController | `POST /api/v1/admin/vehicles/*/documents` | Imágenes y documentos de vehículo |
| VehicleAssetController | `GET /api/v1/admin/vehicles/*/documents/expiring` | Imágenes y documentos de vehículo |
| VehicleAssetController | `DELETE /api/v1/admin/vehicles/*/documents/*` | Imágenes y documentos de vehículo |

## Cómo se revisa

1. Cuando se agregue una pantalla que use una de estas rutas, se quita de la tabla.
2. Si el equipo decide que una ruta ya no hace falta, se elimina del Back-end y de `docs/openapi.json` en el mismo cambio, y se anota aquí como retirada.
