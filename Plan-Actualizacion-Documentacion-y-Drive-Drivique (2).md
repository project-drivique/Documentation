# 📋 Plan Maestro de Actualización: Repositorio de Documentación y Google Drive - Drivique
**Plan Integral de Trabajo estructurado en Historias de Usuario (GitHub Repo) y Tareas Asignadas (Google Drive)**
**Equipo de Trabajo:** Emily, Danna y Laura

---

## 🚦 1. Cronograma y Orden Lógico de Ejecución (Pipeline de Trabajo)

Para que el trabajo no se bloquee y todo tenga coherencia técnica, las tareas deben ejecutarse en el siguiente orden secuencial por fases:

```
FASE 1: Cimientos y Requisitos (Inicia Laura)
  └─► Laura: HU-DOC-001 (SRS RF1 a RF30+ en Repo) + SRS Word en Drive
        │
        ▼ (Con los RF listos, se desbloquean Producto, Arquitectura y Patrones)
FASE 2: Producto, Arquitectura y Patrones (Danna y Emily en paralelo)
  ├─► Danna: HU-DOC-002 (Visión/Backlog) + HU-DOC-003 (ADRs y Diccionario de Datos)
  └─► Emily: HU-DOC-004 (Patrones Web/Móvil) + HU-DOC-005 (Estructuras Frameworks) + Doc Consolidada Word
        │
        ▼ (Con las reglas y entidades claras, se grafican todos los diagramas)
FASE 3: Diagramación UML y Base de Datos (Emily, Laura y Danna)
  ├─► Emily: HU-DOC-006 (Casos de Uso y Secuencias) + Carpeta Draw.io en Drive
  ├─► Laura: HU-DOC-007 (Clases y Dominio) + Exportación Clases/Dominio en Drive
  └─► Danna: HU-DOC-008 (Diagrama ER en Repo) + Diccionario de Datos
        │
        ▼ (Con los diagramas listos, se cierran estándares y QA)
FASE 4: Flujo Git, Testing y Despliegue (Cierre Técnico por Laura)
  └─► Laura: HU-DOC-009 (Git Workflow, Testing y Ambientes en Repo)
        │
        ▼
FASE 5: Sincronización Visual Final (Trabajo en Equipo)
  └─► Emily, Danna y Laura: Tarea 9 (Prototipos finales en Figma Web & App)
```

---

## 🏷️ 2. Regla Obligatoria de Estandarización de Marca y Renombrado

> [!IMPORTANT]
> Todos los documentos, scripts y diagramas heredados con la marca antigua **"Renta Móvil"** / **"RentaMovil"** / **"renta_movil"** deben ser **renombrados oficialmente con el nombre "Drivique" / "drivique"** tanto en el nombre del archivo como en el contenido interno (títulos, encabezados, pies de página y menciones de negocio).

### 🔄 Tabla de Renombrado Oficial de Archivos en Google Drive:

| Nombre Antiguo en Drive | Nuevo Nombre Oficial Drivique | Responsable |
| :--- | :--- | :---: |
| `SRS_actual_02-04-2026.docx` | **`SRS_Drivique_Consolidado_2026.docx`** | **Laura** |
| `renta_movil_documentacion.docx` | **`Drivique_Documentacion_Consolidada.docx`** | **Emily** |
| `renta_movil_final.sql` | **`drivique_database_final.sql`** | **Emily** |
| `SeleccionFramework_RentaMovil (1).pdf` | **`Seleccion_Frameworks_Drivique.pdf`** | **Laura** |
| `diagrama_clases_general.png` | **`diagrama_clases_drivique.png`** | **Laura** |
| `Diagramas de dominio.zip` | **`Diagramas_Dominio_Drivique.zip`** | **Laura** |
| `diagrama_ER.png` | **`diagrama_ER_drivique.png`** | **Emily** |
| `Diagramas secuenciales-Casos de Uso` (Carpeta) | **`Diagramas_Secuenciales_Casos_Uso_Drivique`** | **Emily** |

---

## 📐 3. Metodología de Trazabilidad: Requerimientos Funcionales $\rightarrow$ Diagramas UML

> [!CAUTION]
> **REGLA DE DIAGRAMACIÓN OBLIGATORIA:**
> Antes de diseñar o modificar cualquier diagrama, se debe realizar un **cruce exhaustivo entre los Requerimientos Funcionales (RF) actuales vs los Diagramas existentes**:
> 1. **Si un Requerimiento Funcional es NUEVO:** Se debe modelar y **crear un nuevo diagrama** (nuevo Caso de Uso, nuevo Diagrama de Secuencia o nuevas Clases/Tablas en el modelo ER).
> 2. **Si un Requerimiento Funcional fue MODIFICADO:** Se debe **actualizar el diagrama existente** para que refleje el nuevo comportamiento.
> 3. **Ningún Requisito Funcional puede quedarse sin representación UML.**

### 🗺️ Matriz de Nuevos Requerimientos Funcionales y Diagramas Requeridos:

| Módulo / Nuevos Requerimientos | Casos de Uso (CU) Requeridos | Diagramas Secuenciales Requeridos | Clases y Tablas ER Requeridas |
| :--- | :--- | :--- | :--- |
| **🚚 Entregas a Domicilio y Choferes (RF21-RF23)** | • *CU-Admin:* Asignar conductor a entrega.<br>• *CU-Cliente:* Consultar PIN Nequi de entrega y contactar por WhatsApp. | **Diagrama Secuencial Nuevo:** Flujo de Asignación y Notificación de Entrega (Web Admin $\rightarrow$ Backend $\rightarrow$ Conductor $\rightarrow$ App Móvil con PIN). | • Entidad `DeliveryAssignment`<br>• Relaciones con `Driver`, `Reservation`, `Vehicle`. |
| **🏷️ Promociones y Cupones (RF24-RF25)** | • *CU-Admin:* Crear y gestionar cupones.<br>• *CU-Cliente:* Aplicar cupón de descuento en reserva. | **Diagrama Secuencial Nuevo:** Validación de reglas de cupón (porcentaje/fijo, expiración, límite de uso). | • Entidad `Promotion` / `Coupon`<br>• Atributos de descuento, vigencia y tope. |
| **⭐ Reseñas con Fotos y Respuesta Oficial (RF26-RF27)** | • *CU-Cliente:* Calificar con estrellas y 3 fotos.<br>• *CU-Admin:* Publicar **Respuesta Oficial Inmutable**. | **Diagrama Secuencial Nuevo:** Moderación y emisión de respuesta oficial irreversible de sucursal. | • Entidad `BranchReview`<br>• Atributos `photos` (1-3), `official_response`, `is_immutable`. |
| **💵 Cobro en Efectivo en Sede con PIN (RF28)** | • *CU-Cliente:* Generar comprobante con PIN y cuenta regresiva.<br>• *CU-Admin:* Confirmar cobro en caja. | **Diagrama Secuencial Nuevo:** Flujo de expiración de PIN (72h $\rightarrow$ 2h) y confirmación física en mostrador. | • Entidad `CashCollectionReceipt`<br>• Atributo `payment_pin`, `expires_at`, `status`. |
| **📊 Inteligencia, Reportes y Auditoría (RF29-RF30)** | • *CU-Admin:* Consultar KPIs de facturación y ocupación.<br>• *CU-Admin:* Exportar bitácora de auditoría forense. | **Diagrama Secuencial Nuevo:** Generación de métricas financieras y exportación a Excel/PDF. | • Entidades `AuditLog` e `IncidentReport`. |

---

## 🗺️ 4. Mapeo de Ubicación: ¿Dónde se actualiza cada archivo?

| Archivo / Carpeta en Google Drive | ¿Dónde se actualiza? | Motivo y Acción Requerida |
| :--- | :---: | :--- |
| **`SRS_Drivique_Consolidado_2026.docx`** | **📁 En Google Drive** | Documento Word formal para entrega. Sincronizar con los 30+ Requisitos Funcionales del repo (`docs/01-srs/`). |
| **`Drivique_Documentacion_Consolidada.docx`** | **📁 En Google Drive** | Documento consolidado general. Actualizar toda la arquitectura en 4 capas y eliminar rastros de "Renta Móvil". |
| **`Seleccion_Frameworks_Drivique.pdf`** | **📁 Drive & 🐙 Repo** | Justificación técnica de React 18 + Vite (Web) y React Native + Expo Router + TypeScript (Móvil). |
| **`drivique_database_final.sql` / Carpeta `db_script`** | **📁 Drive & 🐙 Repo** | Reemplazar por el script SQL PostgreSQL 17 actualizado y changelogs de Liquibase. |
| **Carpeta `Diagramas_Secuenciales_Casos_Uso_Drivique`** | **📁 Drive & 🐙 Repo** | Sincronizar archivos Draw.io y PDFs de Casos de Uso y flujos Secuenciales (Wompi, Efectivo PIN, Domicilios). |
| **`diagrama_clases_drivique.png`** | **📁 Drive & 🐙 Repo** | Actualizar imagen y modelo de clases con nuevas entidades (`BranchReview`, `DeliveryAssignment`, `Promotion`, etc.). |
| **`Diagramas_Dominio_Drivique.zip`** | **📁 Drive & 🐙 Repo** | Actualizar modelo conceptual de dominio del negocio Drivique. |
| **`diagrama_ER_drivique.png`** | **📁 Drive & 🐙 Repo** | Actualizar diagrama Entidad-Relación con las nuevas tablas, llaves foráneas e índices. |
| **Diseños en Figma (Web & App)** | **🎨 Figma (Pendiente)** | Actualizar pantallas finales (Modo Oscuro, 5 Idiomas, Módulos Admin Web y Flujo de Reserva Móvil). |

---

## 🎯 5. Historias de Usuario para el Repositorio de Documentación (`project-drivique/Documentation`)

Distribución oficial de responsabilidades en GitHub:
* **Emily:** `HU-DOC-004`, `HU-DOC-005`, `HU-DOC-006`
* **Danna:** `HU-DOC-002`, `HU-DOC-003`, `HU-DOC-008`
* **Laura:** `HU-DOC-001`, `HU-DOC-007`, `HU-DOC-009`

---

### 🟢 HU-DOC-001: Actualización Integral del SRS y Requisitos Funcionales y No Funcionales
* **Responsable:** **Laura**
* **Fase de Ejecución:** **Fase 1 (Punto de partida)**
* **Módulo:** `docs/01-srs/`
* **Archivos a modificar:**
  * `docs/01-srs/functional-requirements.md` (Completar corte en línea 38 desde RF1 hasta RF30+)
  * `docs/01-srs/non-functional-requirements.md`
  * `docs/01-srs/acceptance-criteria.md`
  * `docs/01-srs/matriz-trazabilidad.md` (Completar archivo vacío)

**Descripción:**
> Como Analista de Requisitos, quiero actualizar y completar la especificación de requisitos funcionales y no funcionales en el repositorio de documentación bajo la marca Drivique, para que sirvan de insumo directo y trazable para los diagramas UML.

**Criterios de Aceptación:**
- [ ] `functional-requirements.md` incluye todos los RF ordenados desde RF1 hasta RF30+ (Entregas con PIN, Cupones, Reseñas con Fotos y Respuesta Inmutable, Cobro en Efectivo con Vencimiento Dinámico, Reportes y Auditoría).
- [ ] `non-functional-requirements.md` incluye RNF de Internacionalización (5 idiomas), Modo Oscuro nativo y Liquibase.
- [ ] `matriz-trazabilidad.md` vincula cada RF con su respectivo diagrama UML, endpoint de Backend y vista de Frontend.

---

### 🟢 HU-DOC-002: Consolidación del Documento SRS y Visión de Producto
* **Responsable:** **Danna**
* **Fase de Ejecución:** **Fase 2**
* **Módulo:** `docs/01-srs/` y `docs/02-product/`
* **Archivos a modificar:**
  * `docs/01-srs/srs.md` (Completar archivo vacío)
  * `docs/02-product/backlog.md` (Completar archivo vacío)
  * `docs/02-product/vision-y-alcance.md` (Completar archivo vacío)
  * `docs/02-product/user-stories/HU-001-plantilla.md` (Completar archivo vacío)

**Descripción:**
> Como Product Owner, quiero estructurar el documento maestro SRS consolidado y los lineamientos de producto en Markdown, formalizando la visión de Drivique y su backlog priorizado.

**Criterios de Aceptación:**
- [ ] `srs.md` implementa la estructura estándar IEEE 830 completa bajo el nombre oficial Drivique.
- [ ] `vision-y-alcance.md` delimita las dos plataformas: App Móvil (Cliente Final) y Panel Web (Encargado de Sucursal y Administrador General).
- [ ] `backlog.md` lista todos los módulos del sistema priorizados bajo la metodología MoSCoW.
- [ ] `HU-001-plantilla.md` documenta la plantilla oficial de Historias de Usuario con formato Gherkin (*Given-When-Then*).

---

### 🟢 HU-DOC-003: Decisiones de Arquitectura (ADRs) y Diccionario de Datos
* **Responsable:** **Danna**
* **Fase de Ejecución:** **Fase 2**
* **Módulo:** `docs/04-architecture/`
* **Archivos a modificar:**
  * `docs/04-architecture/decisions/0001-stack-web.md` (Completar archivo vacío)
  * `docs/04-architecture/decisions/0002-stack-mobile.md` (Completar archivo vacío)
  * `docs/04-architecture/overview.md`
  * `docs/04-architecture/database/data-dictionary.md`

**Descripción:**
> Como Arquitecta de Software, quiero documentar los Registros de Decisiones de Arquitectura (ADRs) y el Diccionario de Datos de Drivique, para fundamentar las elecciones tecnológicas y el modelo de datos.

**Criterios de Aceptación:**
- [ ] `0001-stack-web.md` justifica el uso de React 18, Vite, Vanilla CSS modular con tokens HSL y Custom Hooks.
- [ ] `0002-stack-mobile.md` justifica el uso de React Native con Expo Router, TypeScript en modo estricto e i18n reactivo en 5 idiomas.
- [ ] `overview.md` incluye el diagrama de arquitectura C4 de nivel 1 (Contexto) y nivel 2 (Contenedores) conectando Web, Móvil, Backend Spring Boot y PostgreSQL.
- [ ] `data-dictionary.md` documenta todas las tablas, tipos de datos, llaves foráneas y constraints de la BD de Drivique.

---

### 🟢 HU-DOC-004: Patrones de Diseño de Software (Web & Móvil)
* **Responsable:** **Emily**
* **Fase de Ejecución:** **Fase 2**
* **Módulo:** `docs/03-design/patrones/`
* **Archivos a modificar:**
  * `docs/03-design/patrones/patrones-frontend.md` (Completar archivo vacío)
  * `docs/03-design/patrones/patrones-mobile.md` (Completar archivo vacío)
  * `docs/03-design/patrones/patrones-backend.md` (Completar tabla final)

**Descripción:**
> Como Líder Técnica Frontend, quiero documentar los patrones de diseño y principios de Clean Code aplicados en Drivique Web y Móvil, para mantener una base de conocimiento técnica sólida y estandarizada.

**Criterios de Aceptación:**
- [ ] `patrones-frontend.md` documenta con diagramas y código:
  - **Custom Hooks:** `useBranchScope`, `useManagementTable`, `useManagementModal`, `useManagementExport`.
  - **Strategy & Factory:** `PaymentProcessorFactory`, `WompiPaymentStrategy`, `CashPaymentStrategy`.
  - **SRP y DRY:** Celdas independientes en tablas y centralización de exportaciones en `listExportUtils.js`.
- [ ] `patrones-mobile.md` documenta:
  - **Custom Hooks:** `useAuth`, `useCatalog`, `useProfile`, `useIdioma`, `useTemaColores`, `useCurrency`.
  - **Wizard / Step Pattern:** Flujo de reserva desacoplado en 3 pasos con validación secuencial.
  - **Adapter Pattern:** Generación de contratos PDF mediante `pdfService.ts` y normalización monetaria en COP.
  - **Observer / Pub-Sub:** Context API para sincronización global de tema e idioma.

---

### 🟢 HU-DOC-005: Estructura de Proyectos y Frameworks Web y Móvil
* **Responsable:** **Emily**
* **Fase de Ejecución:** **Fase 2**
* **Módulo:** `docs/05-web/` y `docs/06-mobile/`
* **Archivos a modificar:**
  * `docs/05-web/architecture/folder-structure.md`
  * `docs/05-web/architecture/tech-stack.md`
  * `docs/06-mobile/architecture/folder-structure.md`
  * `docs/06-mobile/architecture/tech-stack.md`

**Descripción:**
> Como Desarrolladora Frontend, quiero actualizar la documentación de estructura de carpetas y dependencias de Drivique Web y Móvil, para que coincida exactamente con la distribución modular actual de los repositorios.

**Criterios de Aceptación:**
- [ ] `docs/05-web/architecture/folder-structure.md` documenta el árbol modular real de `front-end_web/web-drivique/src` (`modules/admin`, `modules/payments`, `hooks/`, `components/`).
- [ ] `docs/05-web/architecture/tech-stack.md` lista dependencias reales (React 18, Vite, Lucide Icons, JSPDF, XLSX).
- [ ] `docs/06-mobile/architecture/folder-structure.md` documenta el árbol real de `front-end_movil/app-drivique` (`modules/auth`, `modules/catalog`, `modules/reservation`, `modules/profile`, `hooks/`).
- [ ] `docs/06-mobile/architecture/tech-stack.md` lista dependencias móviles (Expo Router, TypeScript, React Native SVG, AsyncStorage, Expo Print).

---

### 🟢 HU-DOC-006: Diagramación UML - Casos de Uso y Diagramas Secuenciales (Nuevos & Modificados)
* **Responsable:** **Emily**
* **Fase de Ejecución:** **Fase 3**
* **Módulo:** `docs/03-design/uml/`
* **Archivos a modificar:**
  * `docs/03-design/uml/diagrams/source/Diagramas casos de uso` (Draw.io)
  * `docs/03-design/uml/diagrams/source/Diagramas secuenciales .drawio`
  * `docs/03-design/uml/diagrams/exports/DIAGRAMAS CASOS DE USO DRIVIQUE.pdf`
  * `docs/03-design/uml/diagrams/exports/DIAGRAMAS SECUENCIALES DRIVIQUE.pdf`

**Descripción:**
> Como Diseñadora UML, quiero comparar los requerimientos funcionales actuales contra los diagramas existentes y crear los nuevos diagramas de Casos de Uso y Secuencia necesarios para cubrir el 100% de los nuevos flujos.

**Criterios de Aceptación:**
- [ ] **Comparación completada:** Se verificó que cada nuevo RF tenga su Caso de Uso y Secuencia correspondiente.
- [ ] **Nuevos Casos de Uso creados:** "Asignar Conductor a Entrega a Domicilio", "Emitir Respuesta Oficial Inmutable", "Aplicar Cupón de Descuento", "Generar Comprobante de Cobro en Efectivo" y "Exportar Bitácora de Auditoría".
- [ ] **Nuevos Diagramas Secuenciales creados:**
  - Flujo de Entrega con Conductor y Notificación a App con PIN Nequi.
  - Flujo de Validación de Cupones y Deducción de Precio.
  - Flujo de Respuesta Inmutable de Reseña de Sucursal.
  - Flujo de Cobro en Mostrador con Vencimiento Dinámico (72h $\rightarrow$ 2h).
- [ ] Se exportan y actualizan los PDFs en `exports/` bajo el nombre oficial de Drivique.

---

### 🟢 HU-DOC-007: Diagramación UML - Diagramas de Clases y Modelo de Dominio (Nuevos & Modificados)
* **Responsable:** **Laura**
* **Fase de Ejecución:** **Fase 3**
* **Módulo:** `docs/03-design/uml/`
* **Archivos a modificar:**
  * `docs/03-design/uml/diagrams/source/Diagrama de clases.drawio`
  * `docs/03-design/uml/diagrams/source/Diagrama de dominio.drawio`
  * `docs/03-design/uml/diagrams/exports/DIAGRAMA CLASES DRIVIQUE.pdf`
  * `docs/03-design/uml/diagrams/exports/DIAGRAMA DOMINIO DRIVIQUE.pdf`

**Descripción:**
> Como Diseñadora UML, quiero actualizar el diagrama de clases general y el modelo de dominio conceptual, incorporando todas las nuevas entidades generadas por los nuevos requerimientos funcionales.

**Criterios de Aceptación:**
- [x] **Nuevas Clases incorporadas:** `BranchReview` (con `official_response` e `is_immutable`), `DeliveryAssignment` (con `nequi_pin` y estado), `Promotion` (con tipo, descuento y límite), `AuditLog` e `IncidentReport`.
- [x] **Modelo de Dominio actualizado:** Refleja los nuevos conceptos del negocio y la separación por ámbito de sucursal.
- [x] Se generan los archivos de exportación en PDF y PNG en alta resolución bajo el nombre `diagrama_clases_drivique.png`.

---

### 🟢 HU-DOC-008: Diagramación UML - Diagrama Entidad-Relación (ER) y Modelo Físico (Nuevas Tablas)
* **Responsable:** **Danna**
* **Fase de Ejecución:** **Fase 3**
* **Módulo:** `docs/03-design/uml/` y `docs/04-architecture/database/`
* **Archivos a modificar:**
  * `docs/03-design/uml/diagrams/source/Diagrama ER.drawio`
  * `docs/03-design/uml/diagrams/exports/DIAGRAMA ER DRIVIQUE.pdf`
  * `docs/04-architecture/database/data-dictionary.md`

**Descripción:**
> Como Especialista en Base de Datos, quiero contrastar los requerimientos de persistencia y crear en el Diagrama ER las nuevas tablas, llaves foráneas y restricciones requeridas por PostgreSQL 17.

**Criterios de Aceptación:**
- [ ] **Nuevas Tablas incorporadas en el ER:** `branch_reviews`, `delivery_assignments`, `promotions`, `audit_logs`, `cash_collection_receipts`.
- [ ] Tipos de datos actualizados (`UUID`, `VARCHAR`, `TIMESTAMP`, `NUMERIC`) e índices de búsqueda rápida.
- [ ] Se exporta el archivo `DIAGRAMA ER DRIVIQUE.pdf` y la imagen `diagrama_ER_drivique.png`.

---

### 🟢 HU-DOC-009: Flujo de Desarrollo, Estándares Git, Testing y Despliegue
* **Responsable:** **Laura**
* **Fase de Ejecución:** **Fase 4**
* **Módulo:** `docs/08-development/` y `docs/09-deployment/`
* **Archivos a modificar:**
  * `docs/08-development/git-workflow.md` (Completar archivo vacío)
  * `docs/08-development/git-branching-strategy.md`
  * `docs/08-development/testing.md` (Completar archivo vacío)
  * `docs/08-development/environments.md` (Completar archivo vacío)
  * `docs/09-deployment/dev.md`, `qa.md`, `production.md` (Completar archivos vacíos)

**Descripción:**
> Como DevOps & QA Lead, quiero documentar el flujo de ramas Git, la convención de commits, el plan de pruebas y los ambientes de despliegue en el repositorio de documentación de Drivique.

**Criterios de Aceptación:**
- [ ] `git-workflow.md` documenta el flujo de ramas (`develop` $\rightarrow$ `fix/*-qa` $\rightarrow$ `fix/*-main` $\rightarrow$ `main`) y la convención **Conventional Commits** (`feat:`, `fix:`, `docs:`, `refactor:`).
- [ ] `testing.md` describe la pirámide de pruebas (JUnit/Jest, Spring Boot Test y pruebas de componentes).
- [ ] `docs/09-deployment/` documenta el despliegue con Docker Compose (BD), Netlify (Web), Expo EAS (Móvil) y VPS (Backend).

---

## 📁 6. Tareas Específicas para los Archivos de Google Drive (Con Renombrado Oficial)

Esta sección detalla las acciones puntuales que deben realizarse sobre los archivos y carpetas del Google Drive:

---

### 📌 Tarea Drive 1: Renombrar y Sincronizar `SRS_actual_02-04-2026.docx` $\rightarrow$ `SRS_Drivique_Consolidado_2026.docx`
* **Responsable:** **Laura** (Fase 1)
* **Nombre Antiguo:** `SRS_actual_02-04-2026.docx`
* **Nuevo Nombre Oficial:** **`SRS_Drivique_Consolidado_2026.docx`**
* **Acción:**
  1. Abrir el documento Word en Google Docs o Word.
  2. Reemplazar toda mención de "Renta Móvil" por **Drivique**.
  3. Sincronizar la sección de Requisitos Funcionales con los 30+ RF (añadir entregas con PIN, cupones, reseñas con fotos, cobros en efectivo y reportes).
  4. Actualizar los Requisitos No Funcionales (5 idiomas, dark mode nativo, Liquibase).
  5. Guardar y renombrar el archivo en Drive como `SRS_Drivique_Consolidado_2026.docx`.

---

### 📌 Tarea Drive 2: Renombrar y Actualizar `renta_movil_documentacion.docx` $\rightarrow$ `Drivique_Documentacion_Consolidada.docx`
* **Responsable:** **Emily** (Fase 2)
* **Nombre Antiguo:** `renta_movil_documentacion.docx`
* **Nuevo Nombre Oficial:** **`Drivique_Documentacion_Consolidada.docx`**
* **Acción:**
  1. Reemplazar todas las menciones de marca "Renta Móvil" por **Drivique**.
  2. Insertar la descripción de la arquitectura en 4 capas y el diagrama C4.
  3. Añadir la sección de Patrones de Diseño implementados (Custom Hooks, Strategy, Factory, Wizard).
  4. Renombrar el archivo en Drive a `Drivique_Documentacion_Consolidada.docx`.

---

### 📌 Tarea Drive 3: Renombrar Script SQL y Actualizar Carpeta `db_script`
* **Responsable:** **Emily** (Fase 3)
* **Nombre Antiguo:** `renta_movil_final.sql`
* **Nuevo Nombre Oficial:** **`drivique_database_final.sql`**
* **Acción:**
  1. Reemplazar el archivo SQL antiguo por el contenido actualizado de `database_drivique.sql` para PostgreSQL 17.
  2. Renombrar el archivo a `drivique_database_final.sql`.
  3. Subir dentro de la carpeta `db_script` los changelogs de Liquibase (`01_database_drivique.sql` y `changelog-master.xml`).

---

### 📌 Tarea Drive 4: Renombrar y Actualizar `SeleccionFramework_RentaMovil (1).pdf` $\rightarrow$ `Seleccion_Frameworks_Drivique.pdf`
* **Responsable:** **Laura** (Fase 3)
* **Nombre Antiguo:** `SeleccionFramework_RentaMovil (1).pdf`
* **Nuevo Nombre Oficial:** **`Seleccion_Frameworks_Drivique.pdf`**
* **Acción:**
  1. Actualizar el informe técnico de selección de frameworks cambiando el nombre del proyecto a Drivique.
  2. Sustentar la elección de **React 18 + Vite** para la Web de administración y **React Native + Expo Router** para la App Móvil.
  3. Exportar a PDF y subir como `Seleccion_Frameworks_Drivique.pdf`.

---

### 📌 Tarea Drive 5: Renombrar Carpeta de Diagramas Secuenciales y Casos de Uso
* **Responsable:** **Emily** (Fase 3)
* **Nombre Antiguo:** `Diagramas secuenciales-Casos de Uso`
* **Nuevo Nombre Oficial:** **`Diagramas_Secuenciales_Casos_Uso_Drivique`**
* **Acción:**
  1. Comparar los RF nuevos (RF21 a RF30+) y crear los nuevos diagramas de Secuencia y Casos de Uso correspondientes.
  2. Renombrar la carpeta en Drive.
  3. Subir a esta carpeta los archivos fuente `.drawio` de los diagramas de Casos de Uso y Secuencias con membrete de Drivique.
  4. Subir las exportaciones actualizadas en PDF y PNG.

---

### 📌 Tarea Drive 6: Renombrar y Subir `diagrama_clases_general.png` $\rightarrow$ `diagrama_clases_drivique.png`
* **Responsable:** **Laura** (Fase 3)
* **Nombre Antiguo:** `diagrama_clases_general.png`
* **Nuevo Nombre Oficial:** **`diagrama_clases_drivique.png`**
* **Acción:**
  1. Comparar con los nuevos RF e incorporar las nuevas clases (`BranchReview`, `DeliveryAssignment`, `Promotion`, etc.).
  2. Exportar en alta resolución (PNG) el diagrama de clases general de Drivique.
  3. Subir a Drive con el nombre `diagrama_clases_drivique.png`.

---

### 📌 Tarea Drive 7: Renombrar y Actualizar `Diagramas de dominio.zip` $\rightarrow$ `Diagramas_Dominio_Drivique.zip`
* **Responsable:** **Laura** (Fase 3)
* **Nombre Antiguo:** `Diagramas de dominio.zip`
* **Nuevo Nombre Oficial:** **`Diagramas_Dominio_Drivique.zip`**
* **Acción:**
  1. Actualizar los diagramas conceptuales del dominio Drivique reflejando los nuevos módulos.
  2. Empaquetar en un ZIP limpio con el nombre `Diagramas_Dominio_Drivique.zip` y subir a Drive.

---

### 📌 Tarea Drive 8: Renombrar y Subir `diagrama_ER.png` $\rightarrow$ `diagrama_ER_drivique.png`
* **Responsable:** **Emily** (Fase 3)
* **Nombre Antiguo:** `diagrama_ER.png`
* **Nuevo Nombre Oficial:** **`diagrama_ER_drivique.png`**
* **Acción:**
  1. Contrastar con los nuevos requerimientos y añadir las nuevas tablas en el modelo entidad-relación.
  2. Exportar en alta resolución (PNG) el diagrama Entidad-Relación físico actualizado con todas las tablas de PostgreSQL 17.
  3. Subir a Drive con el nombre `diagrama_ER_drivique.png`.

---

### 📌 Tarea Drive 9 (Tarea Pendiente Final): Actualización y Sincronización de Diseños en Figma (Web & App)
* **Responsables:** **Emily, Danna y Laura** (Fase 5)
* **Plataforma:** **Figma (Diseño UI/UX)**
* **Acción:**
  1. **Web de Administración (Figma Web):**
     * Actualizar los prototipos de `DeliveryManagementPage` (tabla con 10 columnas y asignación de conductor).
     * Diseñar la vista `PromotionManagementPage` (creación y listado de cupones).
     * Diseñar la vista `BranchReviewsPage` (tabla de 12 columnas con visor Lightbox y respuesta oficial inmutable).
     * Diseñar el dashboard de `ReportsManagementPage` (gráficas interactivas y KPIs).
  2. **App Móvil de Cliente (Figma Mobile):**
     * Diseñar y sincronizar las pantallas en **Modo Oscuro** y **Modo Claro**.
     * Diseñar la pantalla de confirmación con el **PIN Nequi de 4 dígitos** (con botón de ojo para ocultar/mostrar) y botón de **WhatsApp**.
     * Diseñar el modal de calificación con carga de hasta 3 fotos.
     * Diseñar la sección de cupones de descuento en el paso 3 de la reserva.
  3. Vincular el enlace actualizado del proyecto Figma en `docs/03-design/ui-ux/`.
