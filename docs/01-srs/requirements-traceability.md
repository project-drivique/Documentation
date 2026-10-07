# Trazabilidad de requisitos - Drivique

La fuente de numeración es [functional-requirements.md](functional-requirements.md). Esta vista resume los módulos; las relaciones con SQL, API y UML se consultan en [matriz-trazabilidad.md](matriz-trazabilidad.md).

## Objetivos y requisitos

- Descubrimiento y acceso público: RF1, RF2 y RF8.
- Identidad y cuenta: RF3–RF7 y RF29–RF31.
- Catálogo y navegación del cliente: RF9–RF18.
- Configuración y cotización de reserva: RF19–RF22.
- Pagos: **RF23 (Wompi), RF24 (efectivo) y RF47 (confirmación de caja)**.
- Documentación y contratación: RF25 y **RF26 (contrato y firma)**.
- Entrega y devolución: **RF27 (PIN de entrega de 4 dígitos)**, RF50, RF52 y RF53.
- Historial del cliente: **RF28** y acceso desde RF15.
- Onboarding y chat: RF32 y RF33.
- Administración y operación de sucursal: RF34–RF54, según actor y acción.

## Módulos y requisitos

- Módulo 1: Landing Page (Página de Inicio Pública) — RF1 a RF2.
- Módulo 2: Autenticación y Gestión de Cuenta — RF3 a RF8.
- Módulo 3: Catálogo y Navegación del Cliente — RF9 a RF18.
- Módulo 4: Configuración y Resumen de Reserva — RF19 a RF22.
- Módulo 5: Pagos Wompi y Efectivo — RF23 a RF24.
- Módulo 6: Documentación, Contratos y PIN de Entrega — RF25 a RF27.
- Módulo 7: Historial de Reservas y Perfil — RF28 a RF31.
- Módulo 8: Onboarding y Chat de Soporte — RF32 a RF33.
- Módulo 9: Panel Administrativo y Operación de Sucursal — RF34 a RF54.

La app contiene funciones del cliente y no tiene panel administrativo. La web incluye portal cliente y panel de administración. Las acciones administrativas compartidas en fichas RF24/RF25/RF27 se ejecutan desde web. RNF1–RNF12 son transversales y se verifican según plataforma y operación.
