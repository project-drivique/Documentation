# Goals and Objectives — Drivique

## 1. Objetivo General (Goal)
Desarrollar e implementar **Drivique**, un sistema integral multi-sucursal de alquiler de vehículos (Web, Móvil y API REST sobre PostgreSQL 17) que optimice de extremo a extremo los procesos de cotización, reserva con bloqueo temporal, verificación documental KYC, pagos digitales con Wompi y recaudo en efectivo, contratación con firma electrónica, entrega con PIN e inspección vehicular, garantizando seguridad OWASP Top 10, trazabilidad y accesibilidad.

## 2. Objetivos Específicos (Objectives)
- Digitalizar y estandarizar el ciclo completo de alquiler vehicular en las 6 sedes operativas (Bogotá, Medellín Centro, Medellín Aeropuerto, Cali, Barranquilla y Cartagena).
- Proveer un panel administrativo y operativo por rol (`SUPER_ADMIN`, `ADMIN`, `BRANCH_ADMIN`) para la gestión de flota, tarifas, entregas/devoluciones, recaudo en caja, incidentes, auditoría y reportes ejecutivos (PDF, Excel, Word/CSV).
- Implementar una base de datos relacional PostgreSQL 17 versionada con Liquibase (78 tablas en 8 esquemas, 138 llaves foráneas, 94 índices y rollbacks pareados) y una API REST en Java 21 + Spring Boot 4.0.8 (53 controladores y 73 entidades JPA).
- Integrar pagos digitales seguros con Wompi iniciados y firmados en el servidor (`POST /api/v1/payments/wompi/initiate` + confirmación idempotente vía webhook `POST /api/v1/payments/wompi/webhook`).
- Garantizar controles de seguridad: autenticación JWT con rotación de refresh tokens, RBAC por sede, cifrado AES-GCM para documentos KYC, CORS restringido por origen y bloqueo por intentos fallidos.
- Cumplir con criterios de accesibilidad WCAG 2.1 nivel AA, soporte multilenguaje (5 variantes: `es`, `en`, `fr`, `pt`, `br`) y diseño adaptable (claro/oscuro).

---

## 3. Indicadores de Éxito del Producto (KPIs Medibles)

Para evaluar objetivamente el cumplimiento de los objetivos de negocio y técnicos de **Drivique**, se definen los siguientes **5 indicadores clave de desempeño (KPIs)** con metas numéricas verificables:

| ID KPI | Indicador | Fórmula de Medición | Línea Base (Proceso Manual) | Meta Numérica Objetivo | Frecuencia y Fuente de Verificación |
| --- | --- | --- | :---: | :---: | --- |
| **KPI-01** | **Tiempo promedio de completitud de reserva y contrato (End-to-End)** | $\text{Promedio}(t_{\text{contrato\_firmado}} - t_{\text{inicio\_cotizacion}})$ en minutos | 35 min (atención telefónica/presencial) | **$\le 5\text{ minutos}$** (reducción $\ge 85\%$) | Mensual · Timestamps `created_at` en `rental.reservations` y `signed_at` en `contract.rental_contracts` |
| **KPI-02** | **Tasa de conversión de reservas iniciadas a reservas confirmadas** | $\frac{\text{Reservas en estado CONFIRMED / ACTIVE / COMPLETED}}{\text{Total de holds iniciados en checkout}} \times 100$ | 42% | **$\ge 75\%$** | Semanal · Vista ejecutiva y tabla `rental.reservations` filtrada por `reservation_statuses` |
| **KPI-03** | **Tasa de conciliación automática de pagos digitales Wompi** | $\frac{\text{Pagos Wompi conciliados vía /initiate + webhook sin intervención manual}}{\text{Total de transacciones Wompi aprobadas}} \times 100$ | 0% (conciliación manual por comprobante) | **$\ge 99\%$** (0 discrepancias de firma o monto) | Diaria · Tabla `billing.payments` (`gateway_transaction_id`, `status_id`) y `audit.audit_logs` |
| **KPI-04** | **Tasa de ocupación efectiva de flota disponible por sucursal** | $\frac{\sum \text{Días-vehículo alquilados en el periodo}}{\sum \text{Días-vehículo disponibles en flota operativa}} \times 100$ | 48% | **$\ge 70\%$** | Mensual · Reporte ejecutivo `ReportDataService` (`fleet.vehicles` vs `rental.reservations`) |
| **KPI-05** | **Disponibilidad del servicio API y cumplimiento de SLA de respuesta (p95)** | $\text{Uptime mensual de } \texttt{/api/actuator/health} \text{ y percentil 95 de latencia REST}$ | N/A | **Disponibilidad $\ge 99.5\%$ y latencia $\text{p95} \le 400\text{ ms}$** | Continua · Monitoreo de salud `/api/actuator/health` en producción (`https://drivique.tech`) |
