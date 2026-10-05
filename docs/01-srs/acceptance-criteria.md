# ✅ Criterios de Aceptación Globales del SRS — Drivique

Este documento define los criterios de aceptación globales para la especificación de requerimientos de software de la plataforma **Drivique**.

---

## 🎯 Criterios de Aceptación por Módulo

### 1. Requerimientos Funcionales (RF1 a RF47+)
- [x] **Completitud:** Todos los módulos del sistema (Landing, Autenticación, Catálogo, Reservas, Pagos Wompi/Efectivo PIN, Entregas a Domicilio, Cupones, Reseñas con Fotos y Respuesta Inmutable, Contratos y Auditoría) cuentan con su especificación detallada.
- [x] **Formato Estándar:** Cada requerimiento incluye Actor, Descripción, Entrada, Salida, Acción y Criterios de Aceptación verificables.
- [x] **Consistencia con el Frontend:** Las funcionalidades reflejan 100% los componentes y pantallas reales del proyecto Web (`web-drivique/src/modules/admin/pages`) y App Móvil.

### 2. Requerimientos No Funcionales (RNF)
- [x] **Internacionalización (i18n):** Soporte activo y reactivo para 5 idiomas (Español, Inglés, Francés, Portugués, Alemán).
- [x] **Modo Oscuro Nativo:** Las vistas soportan alternancia entre Light y Dark Mode sin perder contraste.
- [x] **Seguridad:** Tokens JWT, encriptación BCrypt, HTTPS y cumplimiento OWASP Top 10.
- [x] **Persistencia BD:** Migraciones versionadas en PostgreSQL 17 gobernadas por Liquibase.

### 3. Trazabilidad
- [x] **Trazabilidad Total:** Cada RF está mapeado hacia su tabla de Base de Datos (`hu-base-de-datos`), su Endpoint REST de Backend y su Vista Frontend correspondiente en la matriz de trazabilidad.
