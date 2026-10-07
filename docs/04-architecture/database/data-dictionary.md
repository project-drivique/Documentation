# Diccionario de datos físico - Drivique

**Responsable:** Danna Valentina Barrios Penagos · **HU:** HU-DOC-003 · **Fecha:** 2026-10-06

## 1. Alcance, fuente y convenciones

Este diccionario describe el esquema **versionado en SQL**, no una instancia desplegada. Fuente: repositorio `database`, rama `HU-INT-04-dev`, commit `681041da4d882aebf2b157cbc827e0b265af7147`. Se revisaron tablas, alteraciones posteriores, índices y triggers de `01_ddl/`. Todos los archivos de tablas/alteraciones aquí documentados están referenciados por el maestro Liquibase.

**Cobertura:** 68 tablas, 558 columnas, 94 índices explícitos y 53 triggers definidos en los archivos revisados. Los índices implícitos de PK/UNIQUE no se cuentan como índices explícitos.

- **PK:** clave primaria; implica NOT NULL, incluso cuando no se repite en la columna.
- **FK:** referencia a otra tabla; se conserva nombre, columnas y acción ON DELETE si se declara.
- **Nulos:** indica si el DDL admite NULL; ausencia de NOT NULL no equivale a dato obligatorio.
- **Default:** valor o expresión por defecto, cuando está declarado.
- **Restricciones:** se transcriben CHECK, UNIQUE, PK/FK de tabla y exclusiones. Las de columna aparecen en su fila.
- **TIMESTAMPTZ:** timestamp con zona; la presentación horaria se resuelve en aplicación.
- **NUMERIC:** se conservan precisión y escala del DDL; no se sustituyen por punto flotante.
- **UUID / JSONB / INET:** identificadores, datos estructurados y direcciones IP según sus columnas.

Las descripciones identifican el propósito de tabla y atributos principales. Los nombres, tipos y restricciones exactos prevalecen sobre una interpretación del negocio. Los campos sin significado adicional confirmado conservan su nombre y dominio declarado, evitando atribuirles una regla no implementada.

Fuente de migraciones: [changelog/db.changelog-master.yaml](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/changelog/db.changelog-master.yaml). Las referencias externas fijan el commit consultado y se verificaron contra el clon local.

## 2. Inventario por esquema

| Esquema | Responsabilidad | Tablas | Columnas |
| --- | --- | --- | --- |
| `core` | Configuración común | 4 | 33 |
| `iam` | Identidad y acceso | 16 | 131 |
| `location` | Cobertura y sucursales | 4 | 27 |
| `fleet` | Flota | 13 | 98 |
| `catalog` | Oferta y condiciones comerciales | 5 | 39 |
| `rental` | Reservas y experiencia de alquiler | 8 | 69 |
| `contract` | Contratos e inspecciones | 7 | 60 |
| `billing` | Pagos y comprobantes | 5 | 41 |
| `support` | Atención y notificaciones | 3 | 30 |
| `audit` | Auditoría y reportes | 3 | 30 |

### Índice de tablas

- **core**: [core.brand_configurations](#core-brand_configurations), [core.currencies](#core-currencies), [core.exchange_rates](#core-exchange_rates), [core.languages](#core-languages).
- **iam**: [iam.document_statuses](#iam-document_statuses), [iam.document_types](#iam-document_types), [iam.nationalities](#iam-nationalities), [iam.password_policies](#iam-password_policies), [iam.permissions](#iam-permissions), [iam.role_permissions](#iam-role_permissions), [iam.roles](#iam-roles), [iam.security_configurations](#iam-security_configurations), [iam.user_consents](#iam-user_consents), [iam.user_documents](#iam-user_documents), [iam.user_preferences](#iam-user_preferences), [iam.user_profiles](#iam-user_profiles), [iam.user_roles](#iam-user_roles), [iam.user_sessions](#iam-user_sessions), [iam.users](#iam-users), [iam.verification_codes](#iam-verification_codes).
- **location**: [location.branch_users](#location-branch_users), [location.branches](#location-branches), [location.cities](#location-cities), [location.departments](#location-departments).
- **fleet**: [fleet.features](#fleet-features), [fleet.fuel_types](#fleet-fuel_types), [fleet.maintenance_types](#fleet-maintenance_types), [fleet.transmission_types](#fleet-transmission_types), [fleet.user_favorite_vehicles](#fleet-user_favorite_vehicles), [fleet.vehicle_brands](#fleet-vehicle_brands), [fleet.vehicle_categories](#fleet-vehicle_categories), [fleet.vehicle_documents](#fleet-vehicle_documents), [fleet.vehicle_features](#fleet-vehicle_features), [fleet.vehicle_images](#fleet-vehicle_images), [fleet.vehicle_maintenances](#fleet-vehicle_maintenances), [fleet.vehicle_statuses](#fleet-vehicle_statuses), [fleet.vehicles](#fleet-vehicles).
- **catalog**: [catalog.additional_services](#catalog-additional_services), [catalog.insurance_coverages](#catalog-insurance_coverages), [catalog.mileage_plans](#catalog-mileage_plans), [catalog.promotions](#catalog-promotions), [catalog.user_coupon_usages](#catalog-user_coupon_usages).
- **rental**: [rental.branch_reviews](#rental-branch_reviews), [rental.rental_extension_requests](#rental-rental_extension_requests), [rental.reservation_additional_services](#rental-reservation_additional_services), [rental.reservation_delivery_points](#rental-reservation_delivery_points), [rental.reservation_promotions](#rental-reservation_promotions), [rental.reservation_statuses](#rental-reservation_statuses), [rental.reservations](#rental-reservations), [rental.vehicle_ratings](#rental-vehicle_ratings).
- **contract**: [contract.contract_clause_assignments](#contract-contract_clause_assignments), [contract.contract_clauses](#contract-contract_clauses), [contract.contract_statuses](#contract-contract_statuses), [contract.inspection_checklist_answers](#contract-inspection_checklist_answers), [contract.inspection_checklist_items](#contract-inspection_checklist_items), [contract.rental_contracts](#contract-rental_contracts), [contract.vehicle_inspections](#contract-vehicle_inspections).
- **billing**: [billing.payment_methods](#billing-payment_methods), [billing.payment_receipts](#billing-payment_receipts), [billing.payment_statuses](#billing-payment_statuses), [billing.payments](#billing-payments), [billing.user_saved_payment_methods](#billing-user_saved_payment_methods).
- **support**: [support.incident_reports](#support-incident_reports), [support.incident_responses](#support-incident_responses), [support.notifications](#support-notifications).
- **audit**: [audit.administrative_report_types](#audit-administrative_report_types), [audit.audit_logs](#audit-audit_logs), [audit.generated_reports](#audit-generated_reports).


## 3. Detalle de tablas

### Esquema `core` - Configuración común

<a id="core-brand_configurations"></a>

#### core.brand_configurations

Configuración persistida de identidad visual.

**Fuente DDL:** [01_ddl/03_tables/core/brand-configurations.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/core/brand-configurations.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `company_name` | `VARCHAR(100)` | No | No declarado | Atributo `company_name` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `logo_url` | `VARCHAR(2048)` | Sí | No declarado | Atributo `logo_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `favicon_url` | `VARCHAR(2048)` | Sí | No declarado | Atributo `favicon_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `primary_color` | `VARCHAR(7)` | No | No declarado | Atributo `primary_color` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `secondary_color` | `VARCHAR(7)` | No | No declarado | Atributo `secondary_color` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `accent_color` | `VARCHAR(7)` | No | No declarado | Atributo `accent_color` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `default_theme` | `VARCHAR(10)` | No | `'SYSTEM'` | Atributo `default_theme` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 'SYSTEM'` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT chk_brand_configurations_primary_color_hex CHECK (primary_color ~ '^#[0-9A-Fa-f]{6}$');
CONSTRAINT chk_brand_configurations_secondary_color_hex CHECK (secondary_color ~ '^#[0-9A-Fa-f]{6}$');
CONSTRAINT chk_brand_configurations_accent_color_hex CHECK (accent_color ~ '^#[0-9A-Fa-f]{6}$');
CONSTRAINT chk_brand_configurations_distinct_colors CHECK ( primary_color <> secondary_color AND primary_color <> accent_color AND secondary_color <> accent_color );
CONSTRAINT chk_brand_configurations_default_theme CHECK (default_theme IN ('LIGHT', 'DARK', 'SYSTEM'));
```

**Índices explícitos**

```sql
CREATE UNIQUE INDEX uq_brand_configurations_one_active ON core.brand_configurations (is_active) WHERE is_active;
```

Fuente: [01_ddl/10_indexes/core/create-brand-configurations-active-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/core/create-brand-configurations-active-index.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_brand_configurations_set_updated_at BEFORE UPDATE ON core.brand_configurations FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/core/add-brand-configurations-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/core/add-brand-configurations-updated-at-trigger.sql).

<a id="core-currencies"></a>

#### core.currencies

Catálogo de monedas y formato monetario.

**Fuente DDL:** [01_ddl/03_tables/core/004-create-currencies-table.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/core/004-create-currencies-table.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `CHAR(3)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(50)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `symbol` | `VARCHAR(5)` | No | No declarado | Atributo `symbol` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `is_default` | `BOOLEAN` | No | `FALSE` | Atributo `is_default` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_currencies_code UNIQUE (code);
CONSTRAINT uq_currencies_name UNIQUE (name);
CONSTRAINT chk_currencies_code_format CHECK (code ~ '^[A-Z]{3}$');
```

**Índices explícitos**

```sql
CREATE UNIQUE INDEX uq_currencies_one_default ON core.currencies (is_default) WHERE is_default;
```

Fuente: [01_ddl/10_indexes/core/008-create-default-catalog-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/core/008-create-default-catalog-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_currencies_set_updated_at BEFORE UPDATE ON core.currencies FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/core/007-add-currencies-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/core/007-add-currencies-updated-at-trigger.sql).

<a id="core-exchange_rates"></a>

#### core.exchange_rates

Tasas de cambio entre monedas con fecha de vigencia.

**Fuente DDL:** [01_ddl/03_tables/core/011-create-exchange-rates-table.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/core/011-create-exchange-rates-table.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `from_currency_id` | `UUID` | No | No declarado | Referencia a `core.currencies (id)`. | `NOT NULL` |
| `to_currency_id` | `UUID` | No | No declarado | Referencia a `core.currencies (id)`. | `NOT NULL` |
| `rate` | `NUMERIC(16, 6)` | No | No declarado | Atributo `rate` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `provider` | `VARCHAR(80)` | No | No declarado | Atributo `provider` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `fetched_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Atributo `fetched_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_exchange_rates_from_currency FOREIGN KEY (from_currency_id) REFERENCES core.currencies (id);
CONSTRAINT fk_exchange_rates_to_currency FOREIGN KEY (to_currency_id) REFERENCES core.currencies (id);
CONSTRAINT uq_exchange_rates_pair_fetched_at UNIQUE (from_currency_id, to_currency_id, fetched_at);
CONSTRAINT chk_exchange_rates_rate_positive CHECK (rate > 0);
CONSTRAINT chk_exchange_rates_currency_pair CHECK (from_currency_id <> to_currency_id);
```

**Índices explícitos**

```sql
CREATE INDEX idx_exchange_rates_currency_pair_fetched_at ON core.exchange_rates (from_currency_id, to_currency_id, fetched_at DESC);
```

Fuente: [01_ddl/10_indexes/core/012-create-exchange-rates-lookup-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/core/012-create-exchange-rates-lookup-index.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="core-languages"></a>

#### core.languages

Catálogo de idiomas y variantes regionales.

**Fuente DDL:** [01_ddl/03_tables/core/003-create-languages-table.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/core/003-create-languages-table.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(10)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(50)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_default` | `BOOLEAN` | No | `FALSE` | Atributo `is_default` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_languages_code UNIQUE (code);
CONSTRAINT uq_languages_name UNIQUE (name);
CONSTRAINT chk_languages_code_format CHECK (code ~ '^[a-z]{2}(-[A-Z]{2})?$');
```

**Índices explícitos**

```sql
CREATE UNIQUE INDEX uq_languages_one_default ON core.languages (is_default) WHERE is_default;
```

Fuente: [01_ddl/10_indexes/core/008-create-default-catalog-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/core/008-create-default-catalog-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_languages_set_updated_at BEFORE UPDATE ON core.languages FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/core/006-add-languages-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/core/006-add-languages-updated-at-trigger.sql).

### Esquema `iam` - Identidad y acceso

<a id="iam-document_statuses"></a>

#### iam.document_statuses

Estados de revisión documental.

**Fuente DDL:** [01_ddl/03_tables/iam/document-statuses.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/document-statuses.sql), [01_ddl/03_tables/iam/add-document-statuses-description.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/add-document-statuses-description.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(20)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `description` | `VARCHAR(255)` | Sí | No declarado | Descripción del registro. | Sin restricción de columna adicional |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_document_statuses_code UNIQUE (code);
CONSTRAINT uq_document_statuses_name UNIQUE (name);
CONSTRAINT chk_document_statuses_code_format CHECK (code ~ '^[A-Z][A-Z0-9_]*$');
```

**Índices explícitos**

```sql
CREATE INDEX idx_document_statuses_active ON iam.document_statuses (code) WHERE is_active;
```

Fuente: [01_ddl/10_indexes/iam/create-identity-catalogs-active-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-identity-catalogs-active-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_document_statuses_set_updated_at BEFORE UPDATE ON iam.document_statuses FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-document-statuses-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-document-statuses-updated-at-trigger.sql).

<a id="iam-document_types"></a>

#### iam.document_types

Tipos de documento de identidad/verificación.

**Fuente DDL:** [01_ddl/03_tables/iam/document-types.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/document-types.sql), [01_ddl/03_tables/iam/add-document-catalog-and-user-document-fields.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/add-document-catalog-and-user-document-fields.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(20)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `requires_front_and_back` | `BOOLEAN` | No | `TRUE` | Atributo `requires_front_and_back` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT TRUE` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `description` | `VARCHAR(255)` | Sí | No declarado | Descripción del registro. | Sin restricción de columna adicional |
| `is_mandatory` | `BOOLEAN` | No | `TRUE` | Atributo `is_mandatory` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT TRUE` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_document_types_code UNIQUE (code);
CONSTRAINT uq_document_types_name UNIQUE (name);
CONSTRAINT chk_document_types_code_format CHECK (code ~ '^[A-Z][A-Z0-9_]*$');
```

**Índices explícitos**

```sql
CREATE INDEX idx_document_types_active ON iam.document_types (code) WHERE is_active;
```

Fuente: [01_ddl/10_indexes/iam/create-identity-catalogs-active-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-identity-catalogs-active-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_document_types_set_updated_at BEFORE UPDATE ON iam.document_types FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-document-types-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-document-types-updated-at-trigger.sql).

<a id="iam-nationalities"></a>

#### iam.nationalities

Catálogo de nacionalidades.

**Fuente DDL:** [01_ddl/03_tables/iam/nationalities.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/nationalities.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `iso_code` | `CHAR(2)` | No | No declarado | Atributo `iso_code` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_nationalities_name UNIQUE (name);
CONSTRAINT uq_nationalities_iso_code UNIQUE (iso_code);
CONSTRAINT chk_nationalities_iso_code_format CHECK (iso_code ~ '^[A-Z]{2}$');
```

**Índices explícitos**

```sql
CREATE INDEX idx_nationalities_active ON iam.nationalities (name) WHERE is_active;
```

Fuente: [01_ddl/10_indexes/iam/create-identity-catalogs-active-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-identity-catalogs-active-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_nationalities_set_updated_at BEFORE UPDATE ON iam.nationalities FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-nationalities-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-nationalities-updated-at-trigger.sql).

<a id="iam-password_policies"></a>

#### iam.password_policies

Reglas configurables de contraseña.

**Fuente DDL:** [01_ddl/03_tables/iam/password-policies.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/password-policies.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `policy_name` | `VARCHAR(80)` | No | No declarado | Atributo `policy_name` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `min_length` | `SMALLINT` | No | No declarado | Atributo `min_length` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `require_uppercase` | `BOOLEAN` | No | `TRUE` | Atributo `require_uppercase` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT TRUE` |
| `require_number` | `BOOLEAN` | No | `TRUE` | Atributo `require_number` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT TRUE` |
| `require_symbol` | `BOOLEAN` | No | `TRUE` | Atributo `require_symbol` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT TRUE` |
| `password_history_limit` | `SMALLINT` | No | `5` | Atributo `password_history_limit` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 5` |
| `expiration_days` | `SMALLINT` | No | `90` | Atributo `expiration_days` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 90` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_password_policies_name UNIQUE (policy_name);
CONSTRAINT chk_password_policies_min_length CHECK (min_length >= 8);
CONSTRAINT chk_password_policies_history_limit CHECK (password_history_limit >= 0);
CONSTRAINT chk_password_policies_expiration_days CHECK (expiration_days > 0);
```

**Índices explícitos**

```sql
CREATE UNIQUE INDEX uq_password_policies_one_active ON iam.password_policies (is_active) WHERE is_active;
```

Fuente: [01_ddl/10_indexes/iam/create-password-policies-active-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-password-policies-active-index.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_password_policies_set_updated_at BEFORE UPDATE ON iam.password_policies FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-password-policies-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-password-policies-updated-at-trigger.sql).

<a id="iam-permissions"></a>

#### iam.permissions

Catálogo de permisos.

**Fuente DDL:** [01_ddl/03_tables/iam/permissions.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/permissions.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(80)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(120)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `description` | `VARCHAR(255)` | Sí | No declarado | Descripción del registro. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_permissions_code UNIQUE (code);
CONSTRAINT chk_permissions_code_format CHECK (code ~ '^[A-Z][A-Z0-9_]*$');
CONSTRAINT chk_permissions_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="iam-role_permissions"></a>

#### iam.role_permissions

Asignación de permisos a roles.

**Fuente DDL:** [01_ddl/03_tables/iam/role_permissions.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/role_permissions.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `role_id` | `UUID` | No | No declarado | Referencia a `iam.roles (id)`. | `NOT NULL` |
| `permission_id` | `UUID` | No | No declarado | Referencia a `iam.permissions (id)`. | `NOT NULL` |
| `assigned_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Atributo `assigned_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT pk_role_permissions PRIMARY KEY (role_id, permission_id);
CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES iam.roles(id) ON DELETE CASCADE;
CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES iam.permissions(id) ON DELETE CASCADE;
```

**Índices explícitos**

```sql
CREATE INDEX idx_role_permissions_permission_id ON iam.role_permissions (permission_id);
```

Fuente: [01_ddl/10_indexes/iam/create-role-permissions-lookup-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-role-permissions-lookup-index.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="iam-roles"></a>

#### iam.roles

Catálogo de roles.

**Fuente DDL:** [01_ddl/03_tables/iam/roles.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/roles.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(40)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(80)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `description` | `VARCHAR(255)` | Sí | No declarado | Descripción del registro. | Sin restricción de columna adicional |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_roles_code UNIQUE (code);
CONSTRAINT uq_roles_name UNIQUE (name);
CONSTRAINT chk_roles_code_format CHECK (code ~ '^[A-Z][A-Z0-9_]*$');
CONSTRAINT chk_roles_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_roles_is_active ON iam.roles (is_active);
```

Fuente: [01_ddl/10_indexes/iam/create-roles-active-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-roles-active-index.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_roles_set_updated_at BEFORE UPDATE ON iam.roles FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-roles-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-roles-updated-at-trigger.sql).

<a id="iam-security_configurations"></a>

#### iam.security_configurations

Configuración de seguridad por clave.

**Fuente DDL:** [01_ddl/03_tables/iam/security-configurations.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/security-configurations.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `config_key` | `VARCHAR(100)` | No | No declarado | Atributo `config_key` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `config_value` | `TEXT` | No | No declarado | Atributo `config_value` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `description` | `VARCHAR(500)` | No | No declarado | Descripción del registro. | `NOT NULL` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_security_configurations_key UNIQUE (config_key);
CONSTRAINT chk_security_configurations_key_format CHECK (config_key ~ '^[A-Z][A-Z0-9_]*$');
CONSTRAINT chk_security_configurations_value_not_blank CHECK (btrim(config_value) <> '');
CONSTRAINT chk_security_configurations_description_not_blank CHECK (btrim(description) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_security_configurations_set_updated_at BEFORE UPDATE ON iam.security_configurations FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-security-configurations-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-security-configurations-updated-at-trigger.sql).

<a id="iam-user_consents"></a>

#### iam.user_consents

Evidencia de consentimiento con protección por trigger.

**Fuente DDL:** [01_ddl/03_tables/iam/user-consents.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/user-consents.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `consent_type` | `VARCHAR(60)` | No | No declarado | Atributo `consent_type` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `document_version` | `VARCHAR(40)` | No | No declarado | Atributo `document_version` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `accepted_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Atributo `accepted_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `ip_address` | `INET` | No | No declarado | Dirección IP registrada. | `NOT NULL` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_user_consents_user FOREIGN KEY (user_id) REFERENCES iam.users (id);
CONSTRAINT uq_user_consents_user_type_version UNIQUE (user_id, consent_type, document_version);
CONSTRAINT chk_user_consents_type_not_blank CHECK (btrim(consent_type) <> '');
CONSTRAINT chk_user_consents_version_not_blank CHECK (btrim(document_version) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_user_consents_user_accepted_at ON iam.user_consents (user_id, accepted_at DESC);
```

Fuente: [01_ddl/10_indexes/iam/create-user-consents-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-user-consents-index.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_user_consents_immutable BEFORE UPDATE OR DELETE ON iam.user_consents FOR EACH ROW EXECUTE FUNCTION iam.prevent_user_consent_mutation();
```

Fuente: [01_ddl/09_triggers/iam/add-user-consents-immutable-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-user-consents-immutable-trigger.sql).

<a id="iam-user_documents"></a>

#### iam.user_documents

Expedientes documentales del usuario y revisión.

**Fuente DDL:** [01_ddl/03_tables/iam/user-documents.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/user-documents.sql), [01_ddl/03_tables/iam/add-document-catalog-and-user-document-fields.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/add-document-catalog-and-user-document-fields.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `document_type_id` | `UUID` | No | No declarado | Referencia a `iam.document_types (id)`. | `NOT NULL` |
| `status_id` | `UUID` | No | No declarado | Referencia a `iam.document_statuses (id)`. | `NOT NULL` |
| `front_url` | `VARCHAR(1000)` | No | No declarado | Atributo `front_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `back_url` | `VARCHAR(1000)` | Sí | No declarado | Atributo `back_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `review_notes` | `VARCHAR(500)` | Sí | No declarado | Atributo `review_notes` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `reviewed_by` | `UUID` | Sí | No declarado | Referencia a `iam.users (id)`. | Sin restricción de columna adicional |
| `reviewed_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `reviewed_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `document_number` | `VARCHAR(50)` | Sí | No declarado | Atributo `document_number` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_user_documents_user FOREIGN KEY (user_id) REFERENCES iam.users (id);
CONSTRAINT fk_user_documents_document_type FOREIGN KEY (document_type_id) REFERENCES iam.document_types (id);
CONSTRAINT fk_user_documents_status FOREIGN KEY (status_id) REFERENCES iam.document_statuses (id);
CONSTRAINT fk_user_documents_reviewer FOREIGN KEY (reviewed_by) REFERENCES iam.users (id);
CONSTRAINT chk_user_documents_front_url_not_blank CHECK (btrim(front_url) <> '');
CONSTRAINT chk_user_documents_back_url_not_blank CHECK (back_url IS NULL OR btrim(back_url) <> '');
CONSTRAINT chk_user_documents_review_notes_not_blank CHECK (review_notes IS NULL OR btrim(review_notes) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_user_documents_user ON iam.user_documents (user_id);
CREATE INDEX idx_user_documents_status ON iam.user_documents (status_id);
```

Fuente: [01_ddl/10_indexes/iam/create-user-documents-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-user-documents-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_user_documents_set_updated_at BEFORE UPDATE ON iam.user_documents FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
CREATE TRIGGER trg_user_documents_validate BEFORE INSERT OR UPDATE ON iam.user_documents FOR EACH ROW EXECUTE FUNCTION iam.validate_user_document();
```

Fuente: [01_ddl/09_triggers/iam/add-user-documents-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-user-documents-updated-at-trigger.sql), [01_ddl/09_triggers/iam/add-user-documents-validation-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-user-documents-validation-trigger.sql).

<a id="iam-user_preferences"></a>

#### iam.user_preferences

Preferencias de idioma, moneda, tema y notificaciones.

**Fuente DDL:** [01_ddl/03_tables/iam/user_preferences.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/user_preferences.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `PRIMARY KEY REFERENCES iam.users(id) ON DELETE CASCADE` |
| `language_id` | `UUID` | Sí | No declarado | Referencia a `core.languages (id)`. | `REFERENCES core.languages(id) ON DELETE SET NULL` |
| `currency_id` | `UUID` | Sí | No declarado | Referencia a `core.currencies (id)`. | `REFERENCES core.currencies(id) ON DELETE SET NULL` |
| `theme_preference` | `VARCHAR(20)` | No | `'SYSTEM'` | Preferencia LIGHT, DARK o SYSTEM según CHECK. | `NOT NULL DEFAULT 'SYSTEM' CHECK (theme_preference IN ('LIGHT', 'DARK', 'SYSTEM'))` |
| `email_notifications` | `BOOLEAN` | No | `true` | Atributo `email_notifications` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT true` |
| `sms_notifications` | `BOOLEAN` | No | `true` | Atributo `sms_notifications` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT true` |
| `created_at` | `TIMESTAMPTZ` | No | `now()` | Fecha y hora de creación. | `NOT NULL DEFAULT now()` |
| `updated_at` | `TIMESTAMPTZ` | No | `now()` | Fecha y hora de actualización. | `NOT NULL DEFAULT now()` |

**Claves y restricciones de tabla**

No hay constraints de tabla adicionales; consultar las PK/FK/CHECK declaradas directamente en las columnas.

**Índices explícitos**

```sql
CREATE INDEX IF NOT EXISTS idx_user_preferences_lang ON iam.user_preferences (language_id);
CREATE INDEX IF NOT EXISTS idx_user_preferences_curr ON iam.user_preferences (currency_id);
```

Fuente: [01_ddl/10_indexes/iam/create-user-preferences-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-user-preferences-indexes.sql).

**Triggers definidos**

```sql
CREATE OR REPLACE TRIGGER trg_user_preferences_updated_at BEFORE UPDATE ON iam.user_preferences FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-user-preferences-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-user-preferences-updated-at-trigger.sql).

<a id="iam-user_profiles"></a>

#### iam.user_profiles

Datos complementarios del perfil de usuario.

**Fuente DDL:** [01_ddl/03_tables/iam/user_profiles.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/user_profiles.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `PRIMARY KEY` |
| `address` | `VARCHAR(255)` | Sí | No declarado | Atributo `address` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `city_of_residence` | `VARCHAR(100)` | Sí | No declarado | Atributo `city_of_residence` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `department_of_residence` | `VARCHAR(100)` | Sí | No declarado | Atributo `department_of_residence` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `postal_code` | `VARCHAR(20)` | Sí | No declarado | Atributo `postal_code` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `gender` | `VARCHAR(20)` | Sí | No declarado | Atributo `gender` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `emergency_contact_name` | `VARCHAR(150)` | Sí | No declarado | Atributo `emergency_contact_name` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `emergency_contact_phone` | `VARCHAR(30)` | Sí | No declarado | Atributo `emergency_contact_phone` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `avatar_url` | `VARCHAR(1000)` | Sí | No declarado | Atributo `avatar_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_user_profiles_user FOREIGN KEY (user_id) REFERENCES iam.users(id) ON DELETE CASCADE;
CONSTRAINT chk_user_profiles_gender CHECK (gender IS NULL OR gender IN ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY'));
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_user_profiles_set_updated_at BEFORE UPDATE ON iam.user_profiles FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-user-profiles-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-user-profiles-updated-at-trigger.sql).

<a id="iam-user_roles"></a>

#### iam.user_roles

Asignación de roles a usuarios.

**Fuente DDL:** [01_ddl/03_tables/iam/user_roles.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/user_roles.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `role_id` | `UUID` | No | No declarado | Referencia a `iam.roles (id)`. | `NOT NULL` |
| `assigned_by` | `UUID` | Sí | No declarado | Referencia a `iam.users (id)`. | Sin restricción de columna adicional |
| `assigned_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Atributo `assigned_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT pk_user_roles PRIMARY KEY (user_id, role_id);
CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES iam.users(id) ON DELETE CASCADE;
CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES iam.roles(id) ON DELETE RESTRICT;
CONSTRAINT fk_user_roles_assigned_by FOREIGN KEY (assigned_by) REFERENCES iam.users(id) ON DELETE SET NULL;
```

**Índices explícitos**

```sql
CREATE INDEX idx_user_roles_role_id ON iam.user_roles (role_id);
```

Fuente: [01_ddl/10_indexes/iam/create-user-roles-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-user-roles-indexes.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="iam-user_sessions"></a>

#### iam.user_sessions

Sesiones y datos de renovación/revocación.

**Fuente DDL:** [01_ddl/03_tables/iam/user_sessions.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/user_sessions.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE` |
| `refresh_token_hash` | `VARCHAR(255)` | No | No declarado | Hash del token de renovación. | `NOT NULL UNIQUE` |
| `device_info` | `VARCHAR(255)` | Sí | No declarado | Atributo `device_info` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `ip_address` | `VARCHAR(45)` | Sí | No declarado | Dirección IP registrada. | Sin restricción de columna adicional |
| `user_agent` | `VARCHAR(500)` | Sí | No declarado | Atributo `user_agent` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `started_at` | `TIMESTAMPTZ` | No | `now()` | Atributo `started_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT now()` |
| `expires_at` | `TIMESTAMPTZ` | No | No declarado | Atributo `expires_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `revoked_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `revoked_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `now()` | Fecha y hora de creación. | `NOT NULL DEFAULT now()` |
| `updated_at` | `TIMESTAMPTZ` | No | `now()` | Fecha y hora de actualización. | `NOT NULL DEFAULT now()` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT chk_user_sessions_expires_at CHECK (expires_at > started_at);
```

**Índices explícitos**

```sql
CREATE INDEX IF NOT EXISTS idx_user_sessions_user ON iam.user_sessions (user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_exp ON iam.user_sessions (expires_at);
CREATE INDEX IF NOT EXISTS idx_user_sessions_revoked ON iam.user_sessions (revoked_at);
```

Fuente: [01_ddl/10_indexes/iam/create-user-sessions-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-user-sessions-indexes.sql).

**Triggers definidos**

```sql
CREATE OR REPLACE TRIGGER trg_user_sessions_updated_at BEFORE UPDATE ON iam.user_sessions FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-user-sessions-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-user-sessions-updated-at-trigger.sql).

<a id="iam-users"></a>

#### iam.users

Cuentas de usuario y datos de identidad/autenticación.

**Fuente DDL:** [01_ddl/03_tables/iam/users.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/users.sql), [01_ddl/03_tables/iam/add-users-identity-catalog-foreign-keys.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/add-users-identity-catalog-foreign-keys.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `first_name` | `VARCHAR(100)` | No | No declarado | Atributo `first_name` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `last_name` | `VARCHAR(100)` | No | No declarado | Atributo `last_name` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `email` | `VARCHAR(254)` | No | No declarado | Correo electrónico. | `NOT NULL` |
| `phone` | `VARCHAR(30)` | Sí | No declarado | Atributo `phone` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `document_type_id` | `UUID` | Sí | No declarado | Referencia a `iam.document_types (id)`. | Sin restricción de columna adicional |
| `document_number` | `VARCHAR(50)` | Sí | No declarado | Atributo `document_number` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `birth_date` | `DATE` | Sí | No declarado | Atributo `birth_date` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `nationality_id` | `UUID` | Sí | No declarado | Referencia a `iam.nationalities (id)`. | Sin restricción de columna adicional |
| `password_hash` | `VARCHAR(255)` | No | No declarado | Hash de contraseña; no contraseña en claro. | `NOT NULL` |
| `account_status` | `VARCHAR(30)` | No | `'ACTIVE'` | Atributo `account_status` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 'ACTIVE'` |
| `is_profile_complete` | `BOOLEAN` | No | `FALSE` | Atributo `is_profile_complete` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `failed_login_attempts` | `SMALLINT` | No | `0` | Atributo `failed_login_attempts` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 0` |
| `locked_until` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `locked_until` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `email_verified_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `email_verified_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `last_login_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `last_login_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `deleted_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `deleted_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_users_email UNIQUE (email);
CONSTRAINT uq_users_document_number UNIQUE (document_number);
CONSTRAINT chk_users_email_not_blank CHECK (btrim(email) <> '');
CONSTRAINT chk_users_failed_attempts CHECK (failed_login_attempts >= 0);
CONSTRAINT chk_users_account_status CHECK (account_status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'LOCKED', 'PENDING_VERIFICATION'));
CONSTRAINT fk_users_document_type FOREIGN KEY (document_type_id) REFERENCES iam.document_types (id);
CONSTRAINT fk_users_nationality FOREIGN KEY (nationality_id) REFERENCES iam.nationalities (id);
```

**Índices explícitos**

```sql
CREATE INDEX idx_users_email ON iam.users (email);
CREATE INDEX idx_users_doc_num ON iam.users (document_number);
CREATE INDEX idx_users_account_status ON iam.users (account_status);
```

Fuente: [01_ddl/10_indexes/iam/create-users-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-users-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_users_set_updated_at BEFORE UPDATE ON iam.users FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/iam/add-users-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/iam/add-users-updated-at-trigger.sql).

<a id="iam-verification_codes"></a>

#### iam.verification_codes

Códigos de verificación con propósito y vencimiento.

**Fuente DDL:** [01_ddl/03_tables/iam/verification_codes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/iam/verification_codes.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `purpose` | `VARCHAR(40)` | No | No declarado | Atributo `purpose` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `code_hash` | `VARCHAR(255)` | No | No declarado | Atributo `code_hash` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `expires_at` | `TIMESTAMPTZ` | No | No declarado | Atributo `expires_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `used_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `used_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_verification_codes_user FOREIGN KEY (user_id) REFERENCES iam.users(id) ON DELETE CASCADE;
CONSTRAINT chk_verification_codes_purpose CHECK (purpose IN ('ACCOUNT_VERIFICATION', 'EMAIL_VERIFICATION', 'PASSWORD_RESET', 'TWO_FACTOR_AUTH', 'EMAIL_CHANGE'));
```

**Índices explícitos**

```sql
CREATE INDEX idx_verification_codes_user_purpose ON iam.verification_codes (user_id, purpose);
CREATE INDEX IF NOT EXISTS idx_verification_codes_user ON iam.verification_codes (user_id);
CREATE INDEX IF NOT EXISTS idx_verification_codes_exp ON iam.verification_codes (expires_at);
```

Fuente: [01_ddl/10_indexes/iam/create-verification-codes-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-verification-codes-indexes.sql), [01_ddl/10_indexes/iam/create-verification-codes-user-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/iam/create-verification-codes-user-index.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

### Esquema `location` - Cobertura y sucursales

<a id="location-branch_users"></a>

#### location.branch_users

Asignación de usuarios a sucursales.

**Fuente DDL:** [01_ddl/03_tables/location/branch-users.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/location/branch-users.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `branch_id` | `UUID` | No | No declarado | Referencia a `location.branches (id)`. | `NOT NULL` |
| `assigned_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Atributo `assigned_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT pk_branch_users PRIMARY KEY (user_id, branch_id);
CONSTRAINT fk_branch_users_user FOREIGN KEY (user_id) REFERENCES iam.users (id) ON DELETE CASCADE;
CONSTRAINT fk_branch_users_branch FOREIGN KEY (branch_id) REFERENCES location.branches (id) ON DELETE CASCADE;
```

**Índices explícitos**

```sql
CREATE INDEX idx_branch_users_branch ON location.branch_users (branch_id);
```

Fuente: [01_ddl/10_indexes/location/create-branch-users-branch-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/location/create-branch-users-branch-index.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="location-branches"></a>

#### location.branches

Sucursales físicas y datos operativos.

**Fuente DDL:** [01_ddl/03_tables/location/branches.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/location/branches.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(120)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `address` | `VARCHAR(255)` | No | No declarado | Atributo `address` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `city_id` | `UUID` | No | No declarado | Referencia a `location.cities (id)`. | `NOT NULL` |
| `phone` | `VARCHAR(30)` | No | No declarado | Atributo `phone` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `opening_time` | `TIME` | No | No declarado | Atributo `opening_time` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `closing_time` | `TIME` | No | No declarado | Atributo `closing_time` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `allows_cash_payment` | `BOOLEAN` | No | `TRUE` | Atributo `allows_cash_payment` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT TRUE` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_branches_city FOREIGN KEY (city_id) REFERENCES location.cities (id);
CONSTRAINT uq_branches_name UNIQUE (name);
CONSTRAINT chk_branches_name_not_blank CHECK (btrim(name) <> '');
CONSTRAINT chk_branches_address_not_blank CHECK (btrim(address) <> '');
CONSTRAINT chk_branches_phone_not_blank CHECK (btrim(phone) <> '');
CONSTRAINT chk_branches_business_hours CHECK (closing_time > opening_time);
```

**Índices explícitos**

```sql
CREATE INDEX idx_branches_city ON location.branches (city_id);
```

Fuente: [01_ddl/10_indexes/location/create-branches-city-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/location/create-branches-city-index.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_branches_set_updated_at BEFORE UPDATE ON location.branches FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/location/add-branches-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/location/add-branches-updated-at-trigger.sql).

<a id="location-cities"></a>

#### location.cities

Ciudades asociadas a departamentos.

**Fuente DDL:** [01_ddl/03_tables/location/cities.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/location/cities.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `department_id` | `UUID` | No | No declarado | Referencia a `location.departments (id)`. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `has_airport` | `BOOLEAN` | No | `FALSE` | Atributo `has_airport` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `has_terminal` | `BOOLEAN` | No | `FALSE` | Atributo `has_terminal` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_cities_department FOREIGN KEY (department_id) REFERENCES location.departments (id);
CONSTRAINT uq_cities_department_name UNIQUE (department_id, name);
CONSTRAINT chk_cities_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_cities_dept ON location.cities (department_id);
```

Fuente: [01_ddl/10_indexes/location/create-cities-department-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/location/create-cities-department-index.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_cities_set_updated_at BEFORE UPDATE ON location.cities FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/location/add-cities-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/location/add-cities-updated-at-trigger.sql).

<a id="location-departments"></a>

#### location.departments

Departamentos de la cobertura geográfica.

**Fuente DDL:** [01_ddl/03_tables/location/departments.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/location/departments.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_departments_name UNIQUE (name);
CONSTRAINT chk_departments_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_departments_set_updated_at BEFORE UPDATE ON location.departments FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/location/add-departments-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/location/add-departments-updated-at-trigger.sql).

### Esquema `fleet` - Flota

<a id="fleet-features"></a>

#### fleet.features

Catálogo de características de vehículo.

**Fuente DDL:** [01_ddl/03_tables/fleet/features.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/features.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `feature_group` | `VARCHAR(30)` | No | No declarado | Atributo `feature_group` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `icon` | `VARCHAR(100)` | Sí | No declarado | Atributo `icon` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_features_name UNIQUE (name);
CONSTRAINT chk_features_name_not_blank CHECK (btrim(name) <> '');
CONSTRAINT chk_features_group CHECK (feature_group IN ('STANDARD', 'TECHNOLOGY', 'SECURITY', 'COMFORT'));
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="fleet-fuel_types"></a>

#### fleet.fuel_types

Tipos de combustible.

**Fuente DDL:** [01_ddl/03_tables/fleet/fuel-types.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/fuel-types.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(30)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_fuel_types_code UNIQUE (code);
CONSTRAINT chk_fuel_types_code_format CHECK (code ~ '^[A-Z][A-Z_]*$');
CONSTRAINT chk_fuel_types_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_fuel_types_set_updated_at BEFORE UPDATE ON fleet.fuel_types FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/fleet/add-fuel-types-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/fleet/add-fuel-types-updated-at-trigger.sql).

<a id="fleet-maintenance_types"></a>

#### fleet.maintenance_types

Tipos de mantenimiento.

**Fuente DDL:** [01_ddl/03_tables/fleet/maintenance-types.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/maintenance-types.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(40)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(80)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_maintenance_types_code UNIQUE (code);
CONSTRAINT uq_maintenance_types_name UNIQUE (name);
CONSTRAINT chk_maintenance_types_code CHECK (code IN ('PREVENTIVE', 'CORRECTIVE', 'OIL_CHANGE', 'TIRES'));
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="fleet-transmission_types"></a>

#### fleet.transmission_types

Tipos de transmisión.

**Fuente DDL:** [01_ddl/03_tables/fleet/transmission-types.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/transmission-types.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(30)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_transmission_types_code UNIQUE (code);
CONSTRAINT chk_transmission_types_code_format CHECK (code ~ '^[A-Z][A-Z_]*$');
CONSTRAINT chk_transmission_types_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_transmission_types_set_updated_at BEFORE UPDATE ON fleet.transmission_types FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/fleet/add-transmission-types-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/fleet/add-transmission-types-updated-at-trigger.sql).

<a id="fleet-user_favorite_vehicles"></a>

#### fleet.user_favorite_vehicles

Vehículos favoritos de usuarios.

**Fuente DDL:** [01_ddl/03_tables/fleet/user-favorite-vehicles.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/user-favorite-vehicles.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `vehicle_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicles (id)`. | `NOT NULL` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
PRIMARY KEY (user_id, vehicle_id);
CONSTRAINT fk_user_favorite_vehicles_user FOREIGN KEY (user_id) REFERENCES iam.users (id) ON DELETE CASCADE;
CONSTRAINT fk_user_favorite_vehicles_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id) ON DELETE CASCADE;
```

**Índices explícitos**

```sql
CREATE INDEX idx_user_favorite_vehicles_veh ON fleet.user_favorite_vehicles (vehicle_id);
CREATE INDEX idx_user_favorite_vehicles_user ON fleet.user_favorite_vehicles (user_id);
```

Fuente: [01_ddl/10_indexes/fleet/create-features-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/fleet/create-features-indexes.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="fleet-vehicle_brands"></a>

#### fleet.vehicle_brands

Catálogo de marcas de vehículo.

**Fuente DDL:** [01_ddl/03_tables/fleet/vehicle-brands.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/vehicle-brands.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_vehicle_brands_name UNIQUE (name);
CONSTRAINT chk_vehicle_brands_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_vehicle_brands_set_updated_at BEFORE UPDATE ON fleet.vehicle_brands FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/fleet/add-vehicle-brands-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/fleet/add-vehicle-brands-updated-at-trigger.sql).

<a id="fleet-vehicle_categories"></a>

#### fleet.vehicle_categories

Categorías comerciales de vehículos.

**Fuente DDL:** [01_ddl/03_tables/fleet/vehicle-categories.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/vehicle-categories.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `base_daily_rate` | `NUMERIC(12,2)` | No | `0.00` | Atributo `base_daily_rate` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 0.00` |
| `security_deposit` | `NUMERIC(12,2)` | No | `0.00` | Atributo `security_deposit` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 0.00` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_vehicle_categories_name UNIQUE (name);
CONSTRAINT chk_vehicle_categories_name_not_blank CHECK (btrim(name) <> '');
CONSTRAINT chk_vehicle_categories_base_daily_rate CHECK (base_daily_rate >= 0);
CONSTRAINT chk_vehicle_categories_security_deposit CHECK (security_deposit >= 0);
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_vehicle_categories_set_updated_at BEFORE UPDATE ON fleet.vehicle_categories FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/fleet/add-vehicle-categories-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/fleet/add-vehicle-categories-updated-at-trigger.sql).

<a id="fleet-vehicle_documents"></a>

#### fleet.vehicle_documents

Documentos de operación del vehículo y su vigencia.

**Fuente DDL:** [01_ddl/03_tables/fleet/vehicle-documents.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/vehicle-documents.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `vehicle_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicles (id)`. | `NOT NULL` |
| `document_type` | `VARCHAR(30)` | No | No declarado | Atributo `document_type` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `document_number` | `VARCHAR(100)` | Sí | No declarado | Atributo `document_number` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `file_url` | `VARCHAR(1000)` | No | No declarado | Atributo `file_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `issued_at` | `DATE` | Sí | No declarado | Atributo `issued_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `expires_at` | `DATE` | Sí | No declarado | Atributo `expires_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `verified_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `verified_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `verified_by` | `UUID` | Sí | No declarado | Referencia a `iam.users (id)`. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_vehicle_documents_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id) ON DELETE CASCADE;
CONSTRAINT fk_vehicle_documents_verified_by FOREIGN KEY (verified_by) REFERENCES iam.users (id) ON DELETE SET NULL;
CONSTRAINT chk_vehicle_documents_type CHECK (document_type IN ('SOAT', 'TECHNICAL_INSPECTION', 'REGISTRATION', 'INSURANCE', 'OTHER'));
CONSTRAINT chk_vehicle_documents_file_url_not_blank CHECK (btrim(file_url) <> '');
CONSTRAINT chk_vehicle_documents_dates CHECK (expires_at IS NULL OR issued_at IS NULL OR expires_at >= issued_at);
```

**Índices explícitos**

```sql
CREATE INDEX idx_vehicle_documents_veh ON fleet.vehicle_documents (vehicle_id);
CREATE UNIQUE INDEX uq_vehicle_documents_active_type ON fleet.vehicle_documents (vehicle_id, document_type) WHERE is_active;
CREATE INDEX idx_vehicle_documents_expiration ON fleet.vehicle_documents (expires_at) WHERE is_active AND expires_at IS NOT NULL;
```

Fuente: [01_ddl/10_indexes/fleet/create-vehicle-assets-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/fleet/create-vehicle-assets-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_vehicle_documents_updated_at BEFORE UPDATE ON fleet.vehicle_documents FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/fleet/add-vehicle-documents-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/fleet/add-vehicle-documents-updated-at-trigger.sql).

<a id="fleet-vehicle_features"></a>

#### fleet.vehicle_features

Relación entre vehículos y características.

**Fuente DDL:** [01_ddl/03_tables/fleet/vehicle-features.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/vehicle-features.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `vehicle_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicles (id)`. | `NOT NULL` |
| `feature_id` | `UUID` | No | No declarado | Referencia a `fleet.features (id)`. | `NOT NULL` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
PRIMARY KEY (vehicle_id, feature_id);
CONSTRAINT fk_vehicle_features_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id) ON DELETE CASCADE;
CONSTRAINT fk_vehicle_features_feature FOREIGN KEY (feature_id) REFERENCES fleet.features (id) ON DELETE CASCADE;
```

**Índices explícitos**

```sql
CREATE INDEX idx_vehicle_features_feat ON fleet.vehicle_features (feature_id);
```

Fuente: [01_ddl/10_indexes/fleet/create-features-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/fleet/create-features-indexes.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="fleet-vehicle_images"></a>

#### fleet.vehicle_images

Imágenes asociadas a vehículos.

**Fuente DDL:** [01_ddl/03_tables/fleet/vehicle-images.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/vehicle-images.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `vehicle_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicles (id)`. | `NOT NULL` |
| `url` | `VARCHAR(1000)` | No | No declarado | Atributo `url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `is_primary` | `BOOLEAN` | No | `FALSE` | Atributo `is_primary` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `sort_order` | `SMALLINT` | No | `1` | Atributo `sort_order` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 1` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_vehicle_images_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id) ON DELETE CASCADE;
CONSTRAINT uq_vehicle_images_vehicle_sort_order UNIQUE (vehicle_id, sort_order);
CONSTRAINT chk_vehicle_images_url_not_blank CHECK (btrim(url) <> '');
CONSTRAINT chk_vehicle_images_sort_order CHECK (sort_order > 0);
```

**Índices explícitos**

```sql
CREATE INDEX idx_vehicle_images_veh ON fleet.vehicle_images (vehicle_id);
CREATE UNIQUE INDEX uq_vehicle_images_primary ON fleet.vehicle_images (vehicle_id) WHERE is_primary;
```

Fuente: [01_ddl/10_indexes/fleet/create-vehicle-assets-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/fleet/create-vehicle-assets-indexes.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="fleet-vehicle_maintenances"></a>

#### fleet.vehicle_maintenances

Registro de mantenimientos de flota.

**Fuente DDL:** [01_ddl/03_tables/fleet/vehicle-maintenances.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/vehicle-maintenances.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `vehicle_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicles (id)`. | `NOT NULL` |
| `maintenance_type_id` | `UUID` | No | No declarado | Referencia a `fleet.maintenance_types (id)`. | `NOT NULL` |
| `scheduled_date` | `DATE` | No | No declarado | Atributo `scheduled_date` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `completed_date` | `DATE` | Sí | No declarado | Atributo `completed_date` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `cost` | `NUMERIC(12,2)` | No | `0.00` | Atributo `cost` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 0.00` |
| `description` | `TEXT` | Sí | No declarado | Descripción del registro. | Sin restricción de columna adicional |
| `created_by` | `UUID` | Sí | No declarado | Referencia a `iam.users (id)`. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_vehicle_maintenances_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id) ON DELETE CASCADE;
CONSTRAINT fk_vehicle_maintenances_type FOREIGN KEY (maintenance_type_id) REFERENCES fleet.maintenance_types (id);
CONSTRAINT fk_vehicle_maintenances_created_by FOREIGN KEY (created_by) REFERENCES iam.users (id) ON DELETE SET NULL;
CONSTRAINT chk_vehicle_maintenances_cost CHECK (cost >= 0);
CONSTRAINT chk_vehicle_maintenances_dates CHECK (completed_date IS NULL OR completed_date >= scheduled_date);
```

**Índices explícitos**

```sql
CREATE INDEX idx_vehicle_maintenances_veh ON fleet.vehicle_maintenances (vehicle_id);
CREATE INDEX idx_vehicle_maintenances_type ON fleet.vehicle_maintenances (maintenance_type_id);
CREATE INDEX idx_vehicle_maintenances_scheduled ON fleet.vehicle_maintenances (scheduled_date);
```

Fuente: [01_ddl/10_indexes/fleet/create-vehicle-maintenances-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/fleet/create-vehicle-maintenances-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_vehicle_maintenances_updated_at BEFORE UPDATE ON fleet.vehicle_maintenances FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/fleet/add-vehicle-maintenances-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/fleet/add-vehicle-maintenances-updated-at-trigger.sql).

<a id="fleet-vehicle_statuses"></a>

#### fleet.vehicle_statuses

Estados de disponibilidad/operación de flota.

**Fuente DDL:** [01_ddl/03_tables/fleet/vehicle-statuses.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/vehicle-statuses.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(30)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `allows_reservation` | `BOOLEAN` | No | `FALSE` | Atributo `allows_reservation` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_vehicle_statuses_code UNIQUE (code);
CONSTRAINT chk_vehicle_statuses_code_format CHECK (code ~ '^[A-Z][A-Z_]*$');
CONSTRAINT chk_vehicle_statuses_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_vehicle_statuses_set_updated_at BEFORE UPDATE ON fleet.vehicle_statuses FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/fleet/add-vehicle-statuses-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/fleet/add-vehicle-statuses-updated-at-trigger.sql).

<a id="fleet-vehicles"></a>

#### fleet.vehicles

Vehículos de flota, datos técnicos, sede y estado.

**Fuente DDL:** [01_ddl/03_tables/fleet/vehicles.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/fleet/vehicles.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `plate` | `VARCHAR(10)` | No | No declarado | Atributo `plate` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `vin` | `VARCHAR(17)` | No | No declarado | Atributo `vin` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `brand_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicle_brands (id)`. | `NOT NULL` |
| `category_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicle_categories (id)`. | `NOT NULL` |
| `transmission_type_id` | `UUID` | No | No declarado | Referencia a `fleet.transmission_types (id)`. | `NOT NULL` |
| `fuel_type_id` | `UUID` | No | No declarado | Referencia a `fleet.fuel_types (id)`. | `NOT NULL` |
| `status_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicle_statuses (id)`. | `NOT NULL` |
| `current_branch_id` | `UUID` | No | No declarado | Referencia a `location.branches (id)`. | `NOT NULL` |
| `model` | `VARCHAR(100)` | No | No declarado | Atributo `model` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `year` | `SMALLINT` | No | No declarado | Atributo `year` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `color` | `VARCHAR(50)` | Sí | No declarado | Atributo `color` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `passenger_capacity` | `SMALLINT` | No | No declarado | Atributo `passenger_capacity` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `doors_count` | `SMALLINT` | Sí | No declarado | Atributo `doors_count` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `trunk_capacity_liters` | `INTEGER` | Sí | No declarado | Atributo `trunk_capacity_liters` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `mileage` | `INTEGER` | No | `0` | Atributo `mileage` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 0` |
| `daily_rate` | `NUMERIC(12,2)` | No | `0.00` | Tarifa diaria registrada para la reserva o vehículo. | `NOT NULL DEFAULT 0.00` |
| `main_image_url` | `VARCHAR(2048)` | Sí | No declarado | Atributo `main_image_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `is_featured` | `BOOLEAN` | No | `FALSE` | Atributo `is_featured` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_vehicles_plate UNIQUE (plate);
CONSTRAINT uq_vehicles_vin UNIQUE (vin);
CONSTRAINT fk_vehicles_brand FOREIGN KEY (brand_id) REFERENCES fleet.vehicle_brands (id);
CONSTRAINT fk_vehicles_category FOREIGN KEY (category_id) REFERENCES fleet.vehicle_categories (id);
CONSTRAINT fk_vehicles_transmission_type FOREIGN KEY (transmission_type_id) REFERENCES fleet.transmission_types (id);
CONSTRAINT fk_vehicles_fuel_type FOREIGN KEY (fuel_type_id) REFERENCES fleet.fuel_types (id);
CONSTRAINT fk_vehicles_status FOREIGN KEY (status_id) REFERENCES fleet.vehicle_statuses (id);
CONSTRAINT fk_vehicles_current_branch FOREIGN KEY (current_branch_id) REFERENCES location.branches (id);
CONSTRAINT chk_vehicles_plate_not_blank CHECK (btrim(plate) <> '');
CONSTRAINT chk_vehicles_vin_not_blank CHECK (btrim(vin) <> '');
CONSTRAINT chk_vehicles_model_not_blank CHECK (btrim(model) <> '');
CONSTRAINT chk_vehicles_year CHECK (year BETWEEN 1900 AND 2100);
CONSTRAINT chk_vehicles_passenger_capacity CHECK (passenger_capacity > 0);
CONSTRAINT chk_vehicles_mileage CHECK (mileage >= 0);
CONSTRAINT chk_vehicles_daily_rate CHECK (daily_rate >= 0);
```

**Índices explícitos**

```sql
CREATE INDEX idx_vehicles_plate ON fleet.vehicles (plate);
CREATE INDEX idx_vehicles_branch_status ON fleet.vehicles (current_branch_id, status_id, is_active);
CREATE INDEX idx_vehicles_cat_rate ON fleet.vehicles (category_id, daily_rate);
```

Fuente: [01_ddl/10_indexes/fleet/create-vehicles-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/fleet/create-vehicles-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_vehicles_set_updated_at BEFORE UPDATE ON fleet.vehicles FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/fleet/add-vehicles-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/fleet/add-vehicles-updated-at-trigger.sql).

### Esquema `catalog` - Oferta y condiciones comerciales

<a id="catalog-additional_services"></a>

#### catalog.additional_services

Servicios adicionales del alquiler y precio.

**Fuente DDL:** [01_ddl/03_tables/catalog/additional-services.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/catalog/additional-services.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(120)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `daily_rate` | `NUMERIC(12, 2)` | No | No declarado | Tarifa diaria registrada para la reserva o vehículo. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_additional_services_name UNIQUE (name);
CONSTRAINT chk_additional_services_name_not_blank CHECK (btrim(name) <> '');
CONSTRAINT chk_additional_services_daily_rate_nonnegative CHECK (daily_rate >= 0);
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_additional_services_set_updated_at BEFORE UPDATE ON catalog.additional_services FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/catalog/add-additional-services-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/catalog/add-additional-services-updated-at-trigger.sql).

<a id="catalog-insurance_coverages"></a>

#### catalog.insurance_coverages

Coberturas de protección del alquiler.

**Fuente DDL:** [01_ddl/03_tables/catalog/insurance-coverages.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/catalog/insurance-coverages.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(120)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `daily_rate` | `NUMERIC(12, 2)` | No | No declarado | Tarifa diaria registrada para la reserva o vehículo. | `NOT NULL` |
| `description` | `TEXT` | No | No declarado | Descripción del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_insurance_coverages_name UNIQUE (name);
CONSTRAINT chk_insurance_coverages_name_not_blank CHECK (btrim(name) <> '');
CONSTRAINT chk_insurance_coverages_description_not_blank CHECK (btrim(description) <> '');
CONSTRAINT chk_insurance_coverages_daily_rate_nonnegative CHECK (daily_rate >= 0);
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_insurance_coverages_set_updated_at BEFORE UPDATE ON catalog.insurance_coverages FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/catalog/add-insurance-coverages-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/catalog/add-insurance-coverages-updated-at-trigger.sql).

<a id="catalog-mileage_plans"></a>

#### catalog.mileage_plans

Planes y condiciones de kilometraje.

**Fuente DDL:** [01_ddl/03_tables/catalog/mileage-plans.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/catalog/mileage-plans.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(120)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `included_km` | `INT` | Sí | No declarado | Atributo `included_km` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `daily_rate` | `NUMERIC(12, 2)` | No | No declarado | Tarifa diaria registrada para la reserva o vehículo. | `NOT NULL` |
| `extra_km_rate` | `NUMERIC(12, 2)` | No | No declarado | Atributo `extra_km_rate` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_mileage_plans_name UNIQUE (name);
CONSTRAINT chk_mileage_plans_name_not_blank CHECK (btrim(name) <> '');
CONSTRAINT chk_mileage_plans_included_km_nonnegative CHECK (included_km IS NULL OR included_km >= 0);
CONSTRAINT chk_mileage_plans_daily_rate_nonnegative CHECK (daily_rate >= 0);
CONSTRAINT chk_mileage_plans_extra_km_rate_nonnegative CHECK (extra_km_rate >= 0);
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_mileage_plans_set_updated_at BEFORE UPDATE ON catalog.mileage_plans FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/catalog/add-mileage-plans-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/catalog/add-mileage-plans-updated-at-trigger.sql).

<a id="catalog-promotions"></a>

#### catalog.promotions

Promociones y parámetros de descuento.

**Fuente DDL:** [01_ddl/03_tables/catalog/promotions.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/catalog/promotions.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(50)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `offer_type` | `VARCHAR(20)` | No | No declarado | Atributo `offer_type` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `discount_type` | `VARCHAR(20)` | No | No declarado | Atributo `discount_type` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `discount_value` | `NUMERIC(12, 2)` | No | No declarado | Atributo `discount_value` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `starts_at` | `TIMESTAMPTZ` | No | No declarado | Atributo `starts_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `ends_at` | `TIMESTAMPTZ` | No | No declarado | Atributo `ends_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `minimum_rental_days` | `INT` | No | `1` | Atributo `minimum_rental_days` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 1` |
| `max_uses_limit` | `INT` | Sí | No declarado | Atributo `max_uses_limit` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `current_uses_count` | `INT` | No | `0` | Atributo `current_uses_count` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 0` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT chk_promotions_code_not_blank CHECK (btrim(code) <> '');
CONSTRAINT chk_promotions_offer_type CHECK (offer_type IN ('PROMOTION', 'COUPON'));
CONSTRAINT chk_promotions_discount_type CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT'));
CONSTRAINT chk_promotions_discount_value_positive CHECK (discount_value > 0);
CONSTRAINT chk_promotions_percentage_maximum CHECK (discount_type <> 'PERCENTAGE' OR discount_value <= 100);
CONSTRAINT chk_promotions_date_range CHECK (ends_at > starts_at);
CONSTRAINT chk_promotions_minimum_rental_days CHECK (minimum_rental_days >= 1);
CONSTRAINT chk_promotions_use_counts CHECK ( current_uses_count >= 0 AND (max_uses_limit IS NULL OR max_uses_limit >= current_uses_count) );
```

**Índices explícitos**

```sql
CREATE UNIQUE INDEX idx_promotions_code ON catalog.promotions (code);
CREATE INDEX idx_promotions_dates ON catalog.promotions (starts_at, ends_at);
```

Fuente: [01_ddl/10_indexes/catalog/create-promotions-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/catalog/create-promotions-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_promotions_set_updated_at BEFORE UPDATE ON catalog.promotions FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/catalog/add-promotions-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/catalog/add-promotions-updated-at-trigger.sql).

<a id="catalog-user_coupon_usages"></a>

#### catalog.user_coupon_usages

Registro de uso de cupones por usuario.

**Fuente DDL:** [01_ddl/03_tables/catalog/user-coupon-usages.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/catalog/user-coupon-usages.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `promotion_id` | `UUID` | No | No declarado | Referencia a `catalog.promotions (id)`. | `NOT NULL` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `used_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Atributo `used_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `discount_amount` | `NUMERIC(12, 2)` | No | No declarado | Atributo `discount_amount` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_user_coupon_usages_promotion FOREIGN KEY (promotion_id) REFERENCES catalog.promotions (id) ON DELETE RESTRICT;
CONSTRAINT fk_user_coupon_usages_user FOREIGN KEY (user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_user_coupon_usages_discount_amount_nonnegative CHECK (discount_amount >= 0);
```

**Índices explícitos**

```sql
CREATE INDEX idx_user_coupon_usages_user ON catalog.user_coupon_usages (user_id, used_at DESC);
```

Fuente: [01_ddl/10_indexes/catalog/create-promotions-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/catalog/create-promotions-indexes.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

### Esquema `rental` - Reservas y experiencia de alquiler

<a id="rental-branch_reviews"></a>

#### rental.branch_reviews

Reseñas de sucursal vinculadas a usuario/reserva.

**Fuente DDL:** [01_ddl/03_tables/rental/branch-reviews.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/rental/branch-reviews.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `branch_id` | `UUID` | No | No declarado | Referencia a `location.branches (id)`. | `NOT NULL` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `reservation_id` | `UUID` | No | No declarado | Referencia a `rental.reservations (id)`. | `NOT NULL` |
| `rating` | `SMALLINT` | No | No declarado | Puntuación de la calificación o reseña. | `NOT NULL` |
| `comment` | `VARCHAR(1000)` | Sí | No declarado | Comentario asociado. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_branch_reviews_reservation_branch UNIQUE (reservation_id, branch_id);
CONSTRAINT fk_branch_reviews_branch FOREIGN KEY (branch_id) REFERENCES location.branches (id) ON DELETE RESTRICT;
CONSTRAINT fk_branch_reviews_user FOREIGN KEY (user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT fk_branch_reviews_reservation FOREIGN KEY (reservation_id) REFERENCES rental.reservations (id) ON DELETE RESTRICT;
CONSTRAINT chk_branch_reviews_rating CHECK (rating BETWEEN 1 AND 5);
CONSTRAINT chk_branch_reviews_comment_not_blank CHECK (comment IS NULL OR btrim(comment) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_branch_reviews_branch ON rental.branch_reviews (branch_id);
```

Fuente: [01_ddl/10_indexes/rental/create-ratings-and-reviews-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/rental/create-ratings-and-reviews-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_branch_reviews_set_updated_at BEFORE UPDATE ON rental.branch_reviews FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/rental/add-ratings-and-reviews-updated-at-triggers.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/rental/add-ratings-and-reviews-updated-at-triggers.sql).

<a id="rental-rental_extension_requests"></a>

#### rental.rental_extension_requests

Solicitudes de extensión del período de alquiler.

**Fuente DDL:** [01_ddl/03_tables/rental/rental-extension-requests.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/rental/rental-extension-requests.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `reservation_id` | `UUID` | No | No declarado | Referencia a `rental.reservations (id)`. | `NOT NULL` |
| `requested_return_date` | `TIMESTAMPTZ` | No | No declarado | Atributo `requested_return_date` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `status` | `VARCHAR(20)` | No | `'PENDING'` | Atributo `status` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 'PENDING'` |
| `additional_amount` | `NUMERIC(12, 2)` | No | `0.00` | Atributo `additional_amount` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 0.00` |
| `reviewed_by` | `UUID` | Sí | No declarado | Referencia a `iam.users (id)`. | Sin restricción de columna adicional |
| `reviewed_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `reviewed_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_rental_extension_requests_reservation FOREIGN KEY (reservation_id) REFERENCES rental.reservations (id) ON DELETE CASCADE;
CONSTRAINT fk_rental_extension_requests_reviewer FOREIGN KEY (reviewed_by) REFERENCES iam.users (id) ON DELETE SET NULL;
CONSTRAINT chk_rental_extension_requests_status CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED'));
CONSTRAINT chk_rental_extension_requests_additional_amount_nonnegative CHECK (additional_amount >= 0);
```

**Índices explícitos**

```sql
CREATE INDEX idx_rental_extension_requests_reservation ON rental.rental_extension_requests (reservation_id);
CREATE INDEX idx_rental_extension_requests_status ON rental.rental_extension_requests (status);
CREATE INDEX idx_rental_extension_requests_reviewer ON rental.rental_extension_requests (reviewed_by);
```

Fuente: [01_ddl/10_indexes/rental/create-rental-extension-requests-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/rental/create-rental-extension-requests-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_rental_extension_requests_set_updated_at BEFORE UPDATE ON rental.rental_extension_requests FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/rental/add-rental-extension-requests-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/rental/add-rental-extension-requests-updated-at-trigger.sql).

<a id="rental-reservation_additional_services"></a>

#### rental.reservation_additional_services

Servicios adicionales contratados por reserva.

**Fuente DDL:** [01_ddl/03_tables/rental/reservation-additional-services.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/rental/reservation-additional-services.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `reservation_id` | `UUID` | No | No declarado | Referencia a `rental.reservations (id)`. | `NOT NULL` |
| `additional_service_id` | `UUID` | No | No declarado | Referencia a `catalog.additional_services (id)`. | `NOT NULL` |
| `quantity` | `SMALLINT` | No | `1` | Atributo `quantity` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 1` |
| `daily_rate` | `NUMERIC(12, 2)` | No | No declarado | Tarifa diaria registrada para la reserva o vehículo. | `NOT NULL` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT pk_reservation_additional_services PRIMARY KEY (reservation_id, additional_service_id);
CONSTRAINT fk_reservation_additional_services_reservation FOREIGN KEY (reservation_id) REFERENCES rental.reservations (id) ON DELETE CASCADE;
CONSTRAINT fk_reservation_additional_services_service FOREIGN KEY (additional_service_id) REFERENCES catalog.additional_services (id) ON DELETE RESTRICT;
CONSTRAINT chk_reservation_additional_services_quantity_positive CHECK (quantity > 0);
CONSTRAINT chk_reservation_additional_services_daily_rate_nonnegative CHECK (daily_rate >= 0);
```

**Índices explícitos**

```sql
CREATE INDEX idx_reservation_additional_services_service ON rental.reservation_additional_services (additional_service_id);
```

Fuente: [01_ddl/10_indexes/rental/create-reservation-services-and-promotions-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/rental/create-reservation-services-and-promotions-indexes.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="rental-reservation_delivery_points"></a>

#### rental.reservation_delivery_points

Puntos y modalidades de recogida/devolución.

**Fuente DDL:** [01_ddl/03_tables/rental/reservation-delivery-points.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/rental/reservation-delivery-points.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `reservation_id` | `UUID` | No | No declarado | Referencia a `rental.reservations (id)`. | `NOT NULL` |
| `point_type` | `VARCHAR(10)` | No | No declarado | Atributo `point_type` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `modality` | `VARCHAR(20)` | No | No declarado | Atributo `modality` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `branch_id` | `UUID` | Sí | No declarado | Referencia a `location.branches (id)`. | Sin restricción de columna adicional |
| `city_id` | `UUID` | Sí | No declarado | Referencia a `location.cities (id)`. | Sin restricción de columna adicional |
| `neighborhood` | `VARCHAR(120)` | Sí | No declarado | Atributo `neighborhood` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `address` | `VARCHAR(255)` | Sí | No declarado | Atributo `address` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `flight_or_bus_number` | `VARCHAR(60)` | Sí | No declarado | Atributo `flight_or_bus_number` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `reference_details` | `VARCHAR(500)` | Sí | No declarado | Atributo `reference_details` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_reservation_delivery_points_reservation FOREIGN KEY (reservation_id) REFERENCES rental.reservations (id) ON DELETE CASCADE;
CONSTRAINT fk_reservation_delivery_points_branch FOREIGN KEY (branch_id) REFERENCES location.branches (id);
CONSTRAINT fk_reservation_delivery_points_city FOREIGN KEY (city_id) REFERENCES location.cities (id);
CONSTRAINT uq_reservation_delivery_points_reservation_point_type UNIQUE (reservation_id, point_type);
CONSTRAINT chk_reservation_delivery_points_point_type CHECK (point_type IN ('PICKUP', 'RETURN'));
CONSTRAINT chk_reservation_delivery_points_modality CHECK (modality IN ('BRANCH', 'HOME_DELIVERY', 'AIRPORT', 'TERMINAL'));
CONSTRAINT chk_reservation_delivery_points_modality_data CHECK ( (modality = 'BRANCH' AND branch_id IS NOT NULL AND city_id IS NULL AND address IS NULL) OR (modality = 'HOME_DELIVERY' AND branch_id IS NULL AND city_id IS NOT NULL AND address IS NOT NULL) OR (modality IN ('AIRPORT', 'TERMINAL') AND branch_id IS NULL AND city_id IS NOT NULL) );
CONSTRAINT chk_reservation_delivery_points_neighborhood_not_blank CHECK (neighborhood IS NULL OR btrim(neighborhood) <> '');
CONSTRAINT chk_reservation_delivery_points_address_not_blank CHECK (address IS NULL OR btrim(address) <> '');
CONSTRAINT chk_reservation_delivery_points_flight_or_bus_number_not_blank CHECK (flight_or_bus_number IS NULL OR btrim(flight_or_bus_number) <> '');
CONSTRAINT chk_reservation_delivery_points_reference_details_not_blank CHECK (reference_details IS NULL OR btrim(reference_details) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_reservation_delivery_points_reservation ON rental.reservation_delivery_points (reservation_id);
CREATE INDEX idx_reservation_delivery_points_branch ON rental.reservation_delivery_points (branch_id);
CREATE INDEX idx_reservation_delivery_points_city ON rental.reservation_delivery_points (city_id);
```

Fuente: [01_ddl/10_indexes/rental/create-reservation-delivery-points-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/rental/create-reservation-delivery-points-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_reservation_delivery_points_set_updated_at BEFORE UPDATE ON rental.reservation_delivery_points FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/rental/add-reservation-delivery-points-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/rental/add-reservation-delivery-points-updated-at-trigger.sql).

<a id="rental-reservation_promotions"></a>

#### rental.reservation_promotions

Promociones aplicadas a una reserva.

**Fuente DDL:** [01_ddl/03_tables/rental/reservation-promotions.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/rental/reservation-promotions.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `reservation_id` | `UUID` | No | No declarado | Referencia a `rental.reservations (id)`. | `NOT NULL` |
| `promotion_id` | `UUID` | No | No declarado | Referencia a `catalog.promotions (id)`. | `NOT NULL` |
| `discount_applied` | `NUMERIC(12, 2)` | No | No declarado | Atributo `discount_applied` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT pk_reservation_promotions PRIMARY KEY (reservation_id, promotion_id);
CONSTRAINT fk_reservation_promotions_reservation FOREIGN KEY (reservation_id) REFERENCES rental.reservations (id) ON DELETE CASCADE;
CONSTRAINT fk_reservation_promotions_promotion FOREIGN KEY (promotion_id) REFERENCES catalog.promotions (id) ON DELETE RESTRICT;
CONSTRAINT chk_reservation_promotions_discount_applied_nonnegative CHECK (discount_applied >= 0);
```

**Índices explícitos**

```sql
CREATE INDEX idx_reservation_promotions_promotion ON rental.reservation_promotions (promotion_id);
```

Fuente: [01_ddl/10_indexes/rental/create-reservation-services-and-promotions-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/rental/create-reservation-services-and-promotions-indexes.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="rental-reservation_statuses"></a>

#### rental.reservation_statuses

Estados del ciclo de reserva.

**Fuente DDL:** [01_ddl/03_tables/rental/reservation-statuses.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/rental/reservation-statuses.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(30)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `blocks_availability` | `BOOLEAN` | No | `FALSE` | Indica si la reserva participa en la exclusión de disponibilidad. | `NOT NULL DEFAULT FALSE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_reservation_statuses_code UNIQUE (code);
CONSTRAINT chk_reservation_statuses_code_format CHECK (code ~ '^[A-Z][A-Z_]*$');
CONSTRAINT chk_reservation_statuses_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_reservation_statuses_set_updated_at BEFORE UPDATE ON rental.reservation_statuses FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/rental/add-reservation-statuses-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/rental/add-reservation-statuses-updated-at-trigger.sql).

<a id="rental-reservations"></a>

#### rental.reservations

Reserva de vehículo, condiciones, importes y plazo de efectivo.

**Fuente DDL:** [01_ddl/03_tables/rental/reservations.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/rental/reservations.sql), [01_ddl/10_indexes/rental/create-reservations-indexes-and-exclusion.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/rental/create-reservations-indexes-and-exclusion.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(30)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `customer_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `vehicle_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicles (id)`. | `NOT NULL` |
| `status_id` | `UUID` | No | No declarado | Referencia a `rental.reservation_statuses (id)`. | `NOT NULL` |
| `insurance_coverage_id` | `UUID` | No | No declarado | Referencia a `catalog.insurance_coverages (id)`. | `NOT NULL` |
| `mileage_plan_id` | `UUID` | No | No declarado | Referencia a `catalog.mileage_plans (id)`. | `NOT NULL` |
| `cash_payment_branch_id` | `UUID` | Sí | No declarado | Referencia a `location.branches (id)`. | Sin restricción de columna adicional |
| `pickup_date` | `TIMESTAMPTZ` | No | No declarado | Fecha y hora programadas de recogida. | `NOT NULL` |
| `return_date` | `TIMESTAMPTZ` | No | No declarado | Fecha y hora programadas de devolución. | `NOT NULL` |
| `daily_rate` | `NUMERIC(12, 2)` | No | No declarado | Tarifa diaria registrada para la reserva o vehículo. | `NOT NULL` |
| `total_estimated` | `NUMERIC(12, 2)` | No | No declarado | Importe total estimado de la reserva. | `NOT NULL` |
| `cash_payment_code` | `VARCHAR(30)` | Sí | No declarado | Código del pago presencial; no se identifica como PIN de entrega. | Sin restricción de columna adicional |
| `cash_payment_expires_at` | `TIMESTAMPTZ` | Sí | No declarado | Fecha y hora de vencimiento del pago presencial. | Sin restricción de columna adicional |
| `blocks_availability` | `BOOLEAN` | No | `FALSE` | Indica si la reserva participa en la exclusión de disponibilidad. | `NOT NULL DEFAULT FALSE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_reservations_code UNIQUE (code);
CONSTRAINT uq_reservations_cash_payment_code UNIQUE (cash_payment_code);
CONSTRAINT fk_reservations_customer FOREIGN KEY (customer_id) REFERENCES iam.users (id);
CONSTRAINT fk_reservations_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id);
CONSTRAINT fk_reservations_status FOREIGN KEY (status_id) REFERENCES rental.reservation_statuses (id);
CONSTRAINT fk_reservations_insurance_coverage FOREIGN KEY (insurance_coverage_id) REFERENCES catalog.insurance_coverages (id);
CONSTRAINT fk_reservations_mileage_plan FOREIGN KEY (mileage_plan_id) REFERENCES catalog.mileage_plans (id);
CONSTRAINT fk_reservations_cash_payment_branch FOREIGN KEY (cash_payment_branch_id) REFERENCES location.branches (id);
CONSTRAINT chk_reservations_code_not_blank CHECK (btrim(code) <> '');
CONSTRAINT chk_reservations_period CHECK (return_date > pickup_date);
CONSTRAINT chk_reservations_daily_rate_nonnegative CHECK (daily_rate >= 0);
CONSTRAINT chk_reservations_total_estimated_nonnegative CHECK (total_estimated >= 0);
CONSTRAINT chk_reservations_cash_payment_code_not_blank CHECK (cash_payment_code IS NULL OR btrim(cash_payment_code) <> '');
CONSTRAINT reservations_vehicle_period_no_overlap EXCLUDE USING GIST ( vehicle_id WITH =, tstzrange(pickup_date, return_date, '[)') WITH && ) WHERE (blocks_availability);
```

**Índices explícitos**

```sql
CREATE INDEX idx_reservations_customer ON rental.reservations (customer_id);
CREATE INDEX idx_reservations_vehicle ON rental.reservations (vehicle_id);
CREATE INDEX idx_reservations_status ON rental.reservations (status_id);
CREATE INDEX idx_reservations_dates ON rental.reservations (pickup_date, return_date);
```

Fuente: [01_ddl/10_indexes/rental/create-reservations-indexes-and-exclusion.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/rental/create-reservations-indexes-and-exclusion.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_reservations_apply_rules BEFORE INSERT OR UPDATE ON rental.reservations FOR EACH ROW EXECUTE FUNCTION rental.apply_reservation_rules();
```

Fuente: [01_ddl/09_triggers/rental/add-reservations-rules-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/rental/add-reservations-rules-trigger.sql).

<a id="rental-vehicle_ratings"></a>

#### rental.vehicle_ratings

Calificaciones de vehículo vinculadas a usuario/reserva.

**Fuente DDL:** [01_ddl/03_tables/rental/vehicle-ratings.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/rental/vehicle-ratings.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `reservation_id` | `UUID` | No | No declarado | Referencia a `rental.reservations (id)`. | `NOT NULL` |
| `vehicle_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicles (id)`. | `NOT NULL` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `rating` | `SMALLINT` | No | No declarado | Puntuación de la calificación o reseña. | `NOT NULL` |
| `comment` | `VARCHAR(1000)` | Sí | No declarado | Comentario asociado. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_vehicle_ratings_reservation UNIQUE (reservation_id);
CONSTRAINT fk_vehicle_ratings_reservation FOREIGN KEY (reservation_id) REFERENCES rental.reservations (id) ON DELETE RESTRICT;
CONSTRAINT fk_vehicle_ratings_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id) ON DELETE RESTRICT;
CONSTRAINT fk_vehicle_ratings_user FOREIGN KEY (user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_vehicle_ratings_rating CHECK (rating BETWEEN 1 AND 5);
CONSTRAINT chk_vehicle_ratings_comment_not_blank CHECK (comment IS NULL OR btrim(comment) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_vehicle_ratings_veh ON rental.vehicle_ratings (vehicle_id);
```

Fuente: [01_ddl/10_indexes/rental/create-ratings-and-reviews-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/rental/create-ratings-and-reviews-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_vehicle_ratings_set_updated_at BEFORE UPDATE ON rental.vehicle_ratings FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/rental/add-ratings-and-reviews-updated-at-triggers.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/rental/add-ratings-and-reviews-updated-at-triggers.sql).

### Esquema `contract` - Contratos e inspecciones

<a id="contract-contract_clause_assignments"></a>

#### contract.contract_clause_assignments

Asignación de cláusulas a contratos.

**Fuente DDL:** [01_ddl/03_tables/contract/contract-clause-assignments.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/contract/contract-clause-assignments.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `contract_id` | `UUID` | No | No declarado | Referencia a `contract.rental_contracts (id)`. | `NOT NULL` |
| `clause_id` | `UUID` | No | No declarado | Referencia a `contract.contract_clauses (id)`. | `NOT NULL` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT pk_contract_clause_assignments PRIMARY KEY (contract_id, clause_id);
CONSTRAINT fk_contract_clause_assignments_contract FOREIGN KEY (contract_id) REFERENCES contract.rental_contracts (id) ON DELETE CASCADE;
CONSTRAINT fk_contract_clause_assignments_clause FOREIGN KEY (clause_id) REFERENCES contract.contract_clauses (id) ON DELETE RESTRICT;
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="contract-contract_clauses"></a>

#### contract.contract_clauses

Cláusulas disponibles para contratos.

**Fuente DDL:** [01_ddl/03_tables/contract/contract-clauses.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/contract/contract-clauses.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `version` | `VARCHAR(40)` | No | No declarado | Atributo `version` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `sort_order` | `SMALLINT` | No | No declarado | Atributo `sort_order` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `title` | `VARCHAR(255)` | No | No declarado | Atributo `title` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `content` | `TEXT` | No | No declarado | Atributo `content` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_contract_clauses_version_sort_order UNIQUE (version, sort_order);
CONSTRAINT chk_contract_clauses_version_not_blank CHECK (btrim(version) <> '');
CONSTRAINT chk_contract_clauses_sort_order_positive CHECK (sort_order > 0);
CONSTRAINT chk_contract_clauses_title_not_blank CHECK (btrim(title) <> '');
CONSTRAINT chk_contract_clauses_content_not_blank CHECK (btrim(content) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_contract_clauses_set_updated_at BEFORE UPDATE ON contract.contract_clauses FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/contract/add-contract-clauses-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/contract/add-contract-clauses-updated-at-trigger.sql).

<a id="contract-contract_statuses"></a>

#### contract.contract_statuses

Estados del contrato.

**Fuente DDL:** [01_ddl/03_tables/contract/contract-statuses.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/contract/contract-statuses.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(40)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(80)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `is_final` | `BOOLEAN` | No | `FALSE` | Atributo `is_final` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_contract_statuses_code UNIQUE (code);
CONSTRAINT uq_contract_statuses_name UNIQUE (name);
CONSTRAINT chk_contract_statuses_code_not_blank CHECK (btrim(code) <> '');
CONSTRAINT chk_contract_statuses_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_contract_statuses_set_updated_at BEFORE UPDATE ON contract.contract_statuses FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/contract/add-contract-statuses-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/contract/add-contract-statuses-updated-at-trigger.sql).

<a id="contract-inspection_checklist_answers"></a>

#### contract.inspection_checklist_answers

Respuestas y evidencia del checklist de inspección.

**Fuente DDL:** [01_ddl/03_tables/contract/inspection-checklist-answers.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/contract/inspection-checklist-answers.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `inspection_id` | `UUID` | No | No declarado | Referencia a `contract.vehicle_inspections (id)`. | `NOT NULL` |
| `checklist_item_id` | `UUID` | No | No declarado | Referencia a `contract.inspection_checklist_items (id)`. | `NOT NULL` |
| `is_compliant` | `BOOLEAN` | No | `TRUE` | Atributo `is_compliant` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT TRUE` |
| `observation` | `TEXT` | Sí | No declarado | Atributo `observation` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `evidence_photo_url` | `VARCHAR(1000)` | Sí | No declarado | Atributo `evidence_photo_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_inspection_checklist_answers_item UNIQUE (inspection_id, checklist_item_id);
CONSTRAINT fk_inspection_checklist_answers_inspection FOREIGN KEY (inspection_id) REFERENCES contract.vehicle_inspections (id) ON DELETE CASCADE;
CONSTRAINT fk_inspection_checklist_answers_item FOREIGN KEY (checklist_item_id) REFERENCES contract.inspection_checklist_items (id) ON DELETE RESTRICT;
CONSTRAINT chk_inspection_checklist_answers_observation_not_blank CHECK (observation IS NULL OR btrim(observation) <> '');
CONSTRAINT chk_inspection_checklist_answers_evidence_url_not_blank CHECK (evidence_photo_url IS NULL OR btrim(evidence_photo_url) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_inspection_checklist_answers_item ON contract.inspection_checklist_answers (checklist_item_id);
```

Fuente: [01_ddl/10_indexes/contract/create-vehicle-inspections-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/contract/create-vehicle-inspections-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_inspection_checklist_answers_set_updated_at BEFORE UPDATE ON contract.inspection_checklist_answers FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/contract/add-inspection-checklist-answers-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/contract/add-inspection-checklist-answers-updated-at-trigger.sql).

<a id="contract-inspection_checklist_items"></a>

#### contract.inspection_checklist_items

Ítems del checklist de inspección.

**Fuente DDL:** [01_ddl/03_tables/contract/inspection-checklist-items.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/contract/inspection-checklist-items.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `VARCHAR(120)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `description` | `VARCHAR(255)` | Sí | No declarado | Descripción del registro. | Sin restricción de columna adicional |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_inspection_checklist_items_name UNIQUE (name);
CONSTRAINT chk_inspection_checklist_items_name_not_blank CHECK (btrim(name) <> '');
CONSTRAINT chk_inspection_checklist_items_description_not_blank CHECK (description IS NULL OR btrim(description) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_inspection_checklist_items_set_updated_at BEFORE UPDATE ON contract.inspection_checklist_items FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/contract/add-inspection-checklist-items-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/contract/add-inspection-checklist-items-updated-at-trigger.sql).

<a id="contract-rental_contracts"></a>

#### contract.rental_contracts

Contrato de alquiler, datos de firma y referencias a PDF.

**Fuente DDL:** [01_ddl/03_tables/contract/rental-contracts.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/contract/rental-contracts.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `contract_number` | `VARCHAR(30)` | No | No declarado | Atributo `contract_number` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `reservation_id` | `UUID` | No | No declarado | Referencia a `rental.reservations (id)`. | `NOT NULL` |
| `customer_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `vehicle_id` | `UUID` | No | No declarado | Referencia a `fleet.vehicles (id)`. | `NOT NULL` |
| `status_id` | `UUID` | No | No declarado | Referencia a `contract.contract_statuses (id)`. | `NOT NULL` |
| `pickup_branch_id` | `UUID` | No | No declarado | Referencia a `location.branches (id)`. | `NOT NULL` |
| `return_branch_id` | `UUID` | No | No declarado | Referencia a `location.branches (id)`. | `NOT NULL` |
| `scheduled_start_at` | `TIMESTAMPTZ` | No | No declarado | Atributo `scheduled_start_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `scheduled_end_at` | `TIMESTAMPTZ` | No | No declarado | Atributo `scheduled_end_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `base_amount` | `NUMERIC(12, 2)` | No | No declarado | Atributo `base_amount` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `security_deposit` | `NUMERIC(12, 2)` | No | `0.00` | Atributo `security_deposit` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 0.00` |
| `signature_url` | `VARCHAR(1000)` | Sí | No declarado | Referencia al archivo de firma. | Sin restricción de columna adicional |
| `signature_stroke_data` | `JSONB` | Sí | No declarado | Trazado de firma almacenado en JSON. | Sin restricción de columna adicional |
| `signed_city_id` | `UUID` | Sí | No declarado | Referencia a `location.cities (id)`. | Sin restricción de columna adicional |
| `signed_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `signed_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `pdf_url` | `VARCHAR(1000)` | Sí | No declarado | Referencia al archivo PDF. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_rental_contracts_contract_number UNIQUE (contract_number);
CONSTRAINT uq_rental_contracts_reservation UNIQUE (reservation_id);
CONSTRAINT fk_rental_contracts_reservation FOREIGN KEY (reservation_id) REFERENCES rental.reservations (id) ON DELETE CASCADE;
CONSTRAINT fk_rental_contracts_customer FOREIGN KEY (customer_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT fk_rental_contracts_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id) ON DELETE RESTRICT;
CONSTRAINT fk_rental_contracts_status FOREIGN KEY (status_id) REFERENCES contract.contract_statuses (id) ON DELETE RESTRICT;
CONSTRAINT fk_rental_contracts_pickup_branch FOREIGN KEY (pickup_branch_id) REFERENCES location.branches (id) ON DELETE RESTRICT;
CONSTRAINT fk_rental_contracts_return_branch FOREIGN KEY (return_branch_id) REFERENCES location.branches (id) ON DELETE RESTRICT;
CONSTRAINT fk_rental_contracts_signed_city FOREIGN KEY (signed_city_id) REFERENCES location.cities (id) ON DELETE RESTRICT;
CONSTRAINT chk_rental_contracts_contract_number_not_blank CHECK (btrim(contract_number) <> '');
CONSTRAINT chk_rental_contracts_scheduled_period CHECK (scheduled_end_at > scheduled_start_at);
CONSTRAINT chk_rental_contracts_base_amount_nonnegative CHECK (base_amount >= 0);
CONSTRAINT chk_rental_contracts_security_deposit_nonnegative CHECK (security_deposit >= 0);
CONSTRAINT chk_rental_contracts_signature_url_not_blank CHECK (signature_url IS NULL OR btrim(signature_url) <> '');
CONSTRAINT chk_rental_contracts_pdf_url_not_blank CHECK (pdf_url IS NULL OR btrim(pdf_url) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_contracts_reservation ON contract.rental_contracts (reservation_id);
CREATE INDEX idx_contracts_customer ON contract.rental_contracts (customer_id);
CREATE INDEX idx_contracts_status ON contract.rental_contracts (status_id);
```

Fuente: [01_ddl/10_indexes/contract/create-rental-contracts-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/contract/create-rental-contracts-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_rental_contracts_set_updated_at BEFORE UPDATE ON contract.rental_contracts FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/contract/add-rental-contracts-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/contract/add-rental-contracts-updated-at-trigger.sql).

<a id="contract-vehicle_inspections"></a>

#### contract.vehicle_inspections

Inspecciones de entrada/salida asociadas a contratos.

**Fuente DDL:** [01_ddl/03_tables/contract/vehicle-inspections.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/contract/vehicle-inspections.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `contract_id` | `UUID` | No | No declarado | Referencia a `contract.rental_contracts (id)`. | `NOT NULL` |
| `inspection_type` | `VARCHAR(20)` | No | No declarado | Atributo `inspection_type` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `inspector_user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `mileage` | `INTEGER` | No | No declarado | Atributo `mileage` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `fuel_level_percent` | `NUMERIC(5, 2)` | No | No declarado | Atributo `fuel_level_percent` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `observations` | `TEXT` | Sí | No declarado | Atributo `observations` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_vehicle_inspections_contract_type UNIQUE (contract_id, inspection_type);
CONSTRAINT fk_vehicle_inspections_contract FOREIGN KEY (contract_id) REFERENCES contract.rental_contracts (id) ON DELETE CASCADE;
CONSTRAINT fk_vehicle_inspections_inspector FOREIGN KEY (inspector_user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_vehicle_inspections_type CHECK (inspection_type IN ('CHECK_IN', 'CHECK_OUT'));
CONSTRAINT chk_vehicle_inspections_mileage_nonnegative CHECK (mileage >= 0);
CONSTRAINT chk_vehicle_inspections_fuel_level_percent CHECK (fuel_level_percent >= 0.00 AND fuel_level_percent <= 100.00);
CONSTRAINT chk_vehicle_inspections_observations_not_blank CHECK (observations IS NULL OR btrim(observations) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_vehicle_inspections_contract ON contract.vehicle_inspections (contract_id);
CREATE INDEX idx_vehicle_inspections_inspector ON contract.vehicle_inspections (inspector_user_id);
```

Fuente: [01_ddl/10_indexes/contract/create-vehicle-inspections-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/contract/create-vehicle-inspections-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_vehicle_inspections_set_updated_at BEFORE UPDATE ON contract.vehicle_inspections FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/contract/add-vehicle-inspections-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/contract/add-vehicle-inspections-updated-at-trigger.sql).

### Esquema `billing` - Pagos y comprobantes

<a id="billing-payment_methods"></a>

#### billing.payment_methods

Catálogo de métodos de pago.

**Fuente DDL:** [01_ddl/03_tables/billing/payment-methods.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/billing/payment-methods.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(30)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_payment_methods_code UNIQUE (code);
CONSTRAINT chk_payment_methods_code_format CHECK (code ~ '^[A-Z][A-Z_]*$');
CONSTRAINT chk_payment_methods_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_payment_methods_set_updated_at BEFORE UPDATE ON billing.payment_methods FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/billing/add-payment-methods-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/billing/add-payment-methods-updated-at-trigger.sql).

<a id="billing-payment_receipts"></a>

#### billing.payment_receipts

Comprobantes asociados a pagos.

**Fuente DDL:** [01_ddl/03_tables/billing/payment-receipts.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/billing/payment-receipts.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `payment_id` | `UUID` | No | No declarado | Referencia a `billing.payments (id)`. | `NOT NULL` |
| `receipt_number` | `VARCHAR(50)` | No | No declarado | Atributo `receipt_number` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `pdf_url` | `VARCHAR(1000)` | No | No declarado | Referencia al archivo PDF. | `NOT NULL` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_payment_receipts_payment UNIQUE (payment_id);
CONSTRAINT uq_payment_receipts_number UNIQUE (receipt_number);
CONSTRAINT fk_payment_receipts_payment FOREIGN KEY (payment_id) REFERENCES billing.payments (id) ON DELETE RESTRICT;
CONSTRAINT chk_payment_receipts_number_not_blank CHECK (btrim(receipt_number) <> '');
CONSTRAINT chk_payment_receipts_pdf_url_not_blank CHECK (btrim(pdf_url) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_payment_receipts_set_updated_at BEFORE UPDATE ON billing.payment_receipts FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/billing/add-payment-receipts-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/billing/add-payment-receipts-updated-at-trigger.sql).

<a id="billing-payment_statuses"></a>

#### billing.payment_statuses

Catálogo de estados de pago.

**Fuente DDL:** [01_ddl/03_tables/billing/payment-statuses.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/billing/payment-statuses.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(30)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `is_final` | `BOOLEAN` | No | `FALSE` | Atributo `is_final` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_payment_statuses_code UNIQUE (code);
CONSTRAINT chk_payment_statuses_code_format CHECK (code ~ '^[A-Z][A-Z_]*$');
CONSTRAINT chk_payment_statuses_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

No se identifica un CREATE INDEX explícito para esta tabla en los archivos revisados. PK/UNIQUE pueden crear índices implícitos.

**Triggers definidos**

```sql
CREATE TRIGGER trg_payment_statuses_set_updated_at BEFORE UPDATE ON billing.payment_statuses FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/billing/add-payment-statuses-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/billing/add-payment-statuses-updated-at-trigger.sql).

<a id="billing-payments"></a>

#### billing.payments

Pagos de reserva, importe y referencia de operación.

**Fuente DDL:** [01_ddl/03_tables/billing/payments.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/billing/payments.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `contract_id` | `UUID` | No | No declarado | Referencia a `contract.rental_contracts (id)`. | `NOT NULL` |
| `payment_method_id` | `UUID` | No | No declarado | Referencia a `billing.payment_methods (id)`. | `NOT NULL` |
| `status_id` | `UUID` | No | No declarado | Referencia a `billing.payment_statuses (id)`. | `NOT NULL` |
| `gateway_provider` | `VARCHAR(30)` | No | No declarado | Atributo `gateway_provider` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `gateway_reference` | `VARCHAR(100)` | No | No declarado | Atributo `gateway_reference` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `amount` | `NUMERIC(12, 2)` | No | No declarado | Atributo `amount` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `currency_id` | `UUID` | No | No declarado | Referencia a `core.currencies (id)`. | `NOT NULL` |
| `paid_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `paid_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `confirmed_by_user_id` | `UUID` | Sí | No declarado | Referencia a `iam.users (id)`. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_payments_gateway_reference UNIQUE (gateway_provider, gateway_reference);
CONSTRAINT fk_payments_contract FOREIGN KEY (contract_id) REFERENCES contract.rental_contracts (id) ON DELETE RESTRICT;
CONSTRAINT fk_payments_method FOREIGN KEY (payment_method_id) REFERENCES billing.payment_methods (id) ON DELETE RESTRICT;
CONSTRAINT fk_payments_status FOREIGN KEY (status_id) REFERENCES billing.payment_statuses (id) ON DELETE RESTRICT;
CONSTRAINT fk_payments_currency FOREIGN KEY (currency_id) REFERENCES core.currencies (id) ON DELETE RESTRICT;
CONSTRAINT fk_payments_confirmed_by FOREIGN KEY (confirmed_by_user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_payments_gateway_provider CHECK (gateway_provider IN ('WOMPI', 'EFECTIVO_CAJA'));
CONSTRAINT chk_payments_gateway_reference_not_blank CHECK (btrim(gateway_reference) <> '');
CONSTRAINT chk_payments_amount_positive CHECK (amount > 0);
```

**Índices explícitos**

```sql
CREATE INDEX idx_payments_contract ON billing.payments (contract_id);
CREATE INDEX idx_payments_status ON billing.payments (status_id);
```

Fuente: [01_ddl/10_indexes/billing/create-payments-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/billing/create-payments-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_payments_set_updated_at BEFORE UPDATE ON billing.payments FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/billing/add-payments-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/billing/add-payments-updated-at-trigger.sql).

<a id="billing-user_saved_payment_methods"></a>

#### billing.user_saved_payment_methods

Referencias tokenizadas de métodos guardados por usuario.

**Fuente DDL:** [01_ddl/03_tables/billing/user-saved-payment-methods.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/billing/user-saved-payment-methods.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `gateway_provider` | `VARCHAR(30)` | No | `'WOMPI'` | Atributo `gateway_provider` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 'WOMPI'` |
| `payment_token` | `VARCHAR(255)` | No | No declarado | Atributo `payment_token` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `card_brand` | `VARCHAR(50)` | No | No declarado | Atributo `card_brand` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `last_four` | `CHAR(4)` | No | No declarado | Atributo `last_four` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `exp_month` | `SMALLINT` | No | No declarado | Atributo `exp_month` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `exp_year` | `SMALLINT` | No | No declarado | Atributo `exp_year` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_user_saved_payment_methods_token UNIQUE (payment_token);
CONSTRAINT fk_user_saved_payment_methods_user FOREIGN KEY (user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_user_saved_payment_methods_provider CHECK (gateway_provider = 'WOMPI');
CONSTRAINT chk_user_saved_payment_methods_token_not_blank CHECK (btrim(payment_token) <> '');
CONSTRAINT chk_user_saved_payment_methods_token_not_pan CHECK (payment_token !~ '^[0-9]{13,19}$');
CONSTRAINT chk_user_saved_payment_methods_brand_not_blank CHECK (btrim(card_brand) <> '');
CONSTRAINT chk_user_saved_payment_methods_last_four CHECK (last_four ~ '^[0-9]{4}$');
CONSTRAINT chk_user_saved_payment_methods_exp_month CHECK (exp_month BETWEEN 1 AND 12);
CONSTRAINT chk_user_saved_payment_methods_exp_year CHECK (exp_year >= 2024);
```

**Índices explícitos**

```sql
CREATE INDEX idx_user_saved_payment_methods_active_user ON billing.user_saved_payment_methods (user_id) WHERE is_active;
```

Fuente: [01_ddl/10_indexes/billing/create-user-saved-payment-methods-index.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/billing/create-user-saved-payment-methods-index.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_user_saved_payment_methods_set_updated_at BEFORE UPDATE ON billing.user_saved_payment_methods FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/billing/add-user-saved-payment-methods-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/billing/add-user-saved-payment-methods-updated-at-trigger.sql).

### Esquema `support` - Atención y notificaciones

<a id="support-incident_reports"></a>

#### support.incident_reports

Incidencias y solicitudes de atención.

**Fuente DDL:** [01_ddl/03_tables/support/incident-reports.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/support/incident-reports.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `incident_code` | `VARCHAR(30)` | No | No declarado | Atributo `incident_code` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `vehicle_id` | `UUID` | Sí | No declarado | Referencia a `fleet.vehicles (id)`. | Sin restricción de columna adicional |
| `reservation_id` | `UUID` | Sí | No declarado | Referencia a `rental.reservations (id)`. | Sin restricción de columna adicional |
| `reported_by_user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `status` | `VARCHAR(20)` | No | `'OPEN'` | Atributo `status` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 'OPEN'` |
| `priority` | `VARCHAR(20)` | No | `'MEDIUM'` | Atributo `priority` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 'MEDIUM'` |
| `subject` | `VARCHAR(150)` | No | No declarado | Atributo `subject` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `description` | `TEXT` | No | No declarado | Descripción del registro. | `NOT NULL` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_incident_reports_incident_code UNIQUE (incident_code);
CONSTRAINT fk_incident_reports_vehicle FOREIGN KEY (vehicle_id) REFERENCES fleet.vehicles (id) ON DELETE RESTRICT;
CONSTRAINT fk_incident_reports_reservation FOREIGN KEY (reservation_id) REFERENCES rental.reservations (id) ON DELETE RESTRICT;
CONSTRAINT fk_incident_reports_reported_by FOREIGN KEY (reported_by_user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_incident_reports_status CHECK (status IN ('OPEN', 'IN_REVIEW', 'RESOLVED', 'CLOSED'));
CONSTRAINT chk_incident_reports_priority CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL'));
CONSTRAINT chk_incident_reports_incident_code_not_blank CHECK (btrim(incident_code) <> '');
CONSTRAINT chk_incident_reports_subject_not_blank CHECK (btrim(subject) <> '');
CONSTRAINT chk_incident_reports_description_not_blank CHECK (btrim(description) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_incident_reports_code ON support.incident_reports (incident_code);
CREATE INDEX idx_incident_reports_vehicle ON support.incident_reports (vehicle_id);
CREATE INDEX idx_incident_reports_reservation ON support.incident_reports (reservation_id);
CREATE INDEX idx_incident_reports_reported_by ON support.incident_reports (reported_by_user_id);
CREATE INDEX idx_incident_reports_status ON support.incident_reports (status);
```

Fuente: [01_ddl/10_indexes/support/create-incidents-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/support/create-incidents-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_incident_reports_set_updated_at BEFORE UPDATE ON support.incident_reports FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/support/add-incidents-updated-at-triggers.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/support/add-incidents-updated-at-triggers.sql).

<a id="support-incident_responses"></a>

#### support.incident_responses

Respuestas registradas para incidencias.

**Fuente DDL:** [01_ddl/03_tables/support/incident-responses.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/support/incident-responses.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `incident_report_id` | `UUID` | No | No declarado | Referencia a `support.incident_reports (id)`. | `NOT NULL` |
| `author_user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `message` | `TEXT` | No | No declarado | Atributo `message` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `attachment_url` | `VARCHAR(500)` | Sí | No declarado | Atributo `attachment_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_incident_responses_report FOREIGN KEY (incident_report_id) REFERENCES support.incident_reports (id) ON DELETE CASCADE;
CONSTRAINT fk_incident_responses_author FOREIGN KEY (author_user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_incident_responses_message_not_blank CHECK (btrim(message) <> '');
CONSTRAINT chk_incident_responses_attachment_url_not_blank CHECK (attachment_url IS NULL OR btrim(attachment_url) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_incident_responses_report ON support.incident_responses (incident_report_id);
CREATE INDEX idx_incident_responses_author ON support.incident_responses (author_user_id);
```

Fuente: [01_ddl/10_indexes/support/create-incidents-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/support/create-incidents-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_incident_responses_set_updated_at BEFORE UPDATE ON support.incident_responses FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/support/add-incidents-updated-at-triggers.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/support/add-incidents-updated-at-triggers.sql).

<a id="support-notifications"></a>

#### support.notifications

Notificaciones dirigidas a usuarios y estados de lectura.

**Fuente DDL:** [01_ddl/03_tables/support/notifications.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/support/notifications.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `user_id` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `channel` | `VARCHAR(20)` | No | No declarado | Atributo `channel` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `type` | `VARCHAR(30)` | No | No declarado | Atributo `type` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `subject` | `VARCHAR(200)` | No | No declarado | Atributo `subject` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `message` | `TEXT` | No | No declarado | Atributo `message` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `reference_id` | `UUID` | Sí | No declarado | Atributo `reference_id` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `is_read` | `BOOLEAN` | No | `FALSE` | Atributo `is_read` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT FALSE` |
| `sent_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Atributo `sent_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `read_at` | `TIMESTAMPTZ` | Sí | No declarado | Atributo `read_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_notifications_channel CHECK (channel IN ('EMAIL', 'SMS', 'PUSH', 'IN_APP'));
CONSTRAINT chk_notifications_type CHECK (type IN ('GENERAL', 'SECURITY', 'RESERVATION', 'PROMOTION'));
CONSTRAINT chk_notifications_subject_not_blank CHECK (btrim(subject) <> '');
CONSTRAINT chk_notifications_message_not_blank CHECK (btrim(message) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_notifications_user_unread ON support.notifications (user_id, is_read);
CREATE INDEX idx_notifications_user ON support.notifications (user_id);
CREATE INDEX idx_notifications_type ON support.notifications (type);
CREATE INDEX idx_notifications_channel ON support.notifications (channel);
CREATE INDEX idx_notifications_created_at ON support.notifications (created_at);
```

Fuente: [01_ddl/10_indexes/support/create-notifications-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/support/create-notifications-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_notifications_set_updated_at BEFORE UPDATE ON support.notifications FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/support/add-notifications-updated-at-trigger.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/support/add-notifications-updated-at-trigger.sql).

### Esquema `audit` - Auditoría y reportes

<a id="audit-administrative_report_types"></a>

#### audit.administrative_report_types

Tipos de reporte administrativo.

**Fuente DDL:** [01_ddl/03_tables/audit/administrative-report-types.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/audit/administrative-report-types.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `code` | `VARCHAR(50)` | No | No declarado | Código de identificación del registro. | `NOT NULL` |
| `name` | `VARCHAR(100)` | No | No declarado | Nombre del registro. | `NOT NULL` |
| `description` | `VARCHAR(255)` | Sí | No declarado | Descripción del registro. | Sin restricción de columna adicional |
| `is_active` | `BOOLEAN` | No | `TRUE` | Indicador de estado activo. | `NOT NULL DEFAULT TRUE` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT uq_administrative_report_types_code UNIQUE (code);
CONSTRAINT chk_administrative_report_types_code CHECK (code IN ('FLEET_OCCUPANCY', 'REVENUE_SUMMARY', 'AUDIT_TRAIL', 'MAINTENANCE'));
CONSTRAINT chk_administrative_report_types_name_not_blank CHECK (btrim(name) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_administrative_report_types_code ON audit.administrative_report_types (code);
```

Fuente: [01_ddl/10_indexes/audit/create-administrative-reports-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/audit/create-administrative-reports-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_administrative_report_types_set_updated_at BEFORE UPDATE ON audit.administrative_report_types FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/audit/add-administrative-reports-updated-at-triggers.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/audit/add-administrative-reports-updated-at-triggers.sql).

<a id="audit-audit_logs"></a>

#### audit.audit_logs

Eventos de auditoría con actor, entidad y datos de cambio.

**Fuente DDL:** [01_ddl/03_tables/audit/audit-logs.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/audit/audit-logs.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `domain_name` | `VARCHAR(50)` | No | No declarado | Atributo `domain_name` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `entity_name` | `VARCHAR(128)` | No | No declarado | Atributo `entity_name` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `entity_id` | `UUID` | Sí | No declarado | Atributo `entity_id` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `operation` | `VARCHAR(20)` | No | No declarado | Atributo `operation` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `result` | `VARCHAR(20)` | No | `'SUCCESS'` | Atributo `result` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 'SUCCESS'` |
| `actor_user_id` | `UUID` | Sí | No declarado | Referencia a `iam.users (id)`. | Sin restricción de columna adicional |
| `branch_id` | `UUID` | Sí | No declarado | Referencia a `location.branches (id)`. | Sin restricción de columna adicional |
| `ip_address` | `INET` | Sí | No declarado | Dirección IP registrada. | Sin restricción de columna adicional |
| `description` | `TEXT` | Sí | No declarado | Descripción del registro. | Sin restricción de columna adicional |
| `old_data` | `JSONB` | Sí | No declarado | Datos anteriores del cambio en formato JSON. | Sin restricción de columna adicional |
| `new_data` | `JSONB` | Sí | No declarado | Datos posteriores del cambio en formato JSON. | Sin restricción de columna adicional |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_audit_logs_actor FOREIGN KEY (actor_user_id) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT fk_audit_logs_branch FOREIGN KEY (branch_id) REFERENCES location.branches (id) ON DELETE RESTRICT;
CONSTRAINT chk_audit_logs_operation CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'));
CONSTRAINT chk_audit_logs_result CHECK (result IN ('SUCCESS', 'FAILURE'));
CONSTRAINT chk_audit_logs_domain_not_blank CHECK (btrim(domain_name) <> '');
CONSTRAINT chk_audit_logs_entity_not_blank CHECK (btrim(entity_name) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_audit_table_date ON audit.audit_logs (entity_name, created_at);
CREATE INDEX idx_audit_actor ON audit.audit_logs (actor_user_id);
CREATE INDEX idx_audit_logs_domain ON audit.audit_logs (domain_name);
CREATE INDEX idx_audit_logs_entity_id ON audit.audit_logs (entity_id);
CREATE INDEX idx_audit_logs_branch ON audit.audit_logs (branch_id);
CREATE INDEX idx_audit_logs_operation ON audit.audit_logs (operation);
CREATE INDEX idx_audit_logs_old_data ON audit.audit_logs USING gin (old_data);
CREATE INDEX idx_audit_logs_new_data ON audit.audit_logs USING gin (new_data);
```

Fuente: [01_ddl/10_indexes/audit/create-audit-logs-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/audit/create-audit-logs-indexes.sql).

**Triggers definidos**

No se identifica un trigger para esta tabla en los archivos revisados.

<a id="audit-generated_reports"></a>

#### audit.generated_reports

Ejecuciones/archivos de reportes administrativos.

**Fuente DDL:** [01_ddl/03_tables/audit/generated-reports.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/03_tables/audit/generated-reports.sql).

| Columna | Tipo | Nulos | Default | Descripción | Restricciones de columna |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `gen_random_uuid()` | Identificador del registro. | `PRIMARY KEY DEFAULT gen_random_uuid()` |
| `report_type_id` | `UUID` | No | No declarado | Referencia a `audit.administrative_report_types (id)`. | `NOT NULL` |
| `format` | `VARCHAR(20)` | No | No declarado | Atributo `format` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL` |
| `generated_by` | `UUID` | No | No declarado | Referencia a `iam.users (id)`. | `NOT NULL` |
| `filters` | `JSONB` | No | `'{}'::jsonb` | Atributo `filters` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT '{}'::jsonb` |
| `file_url` | `VARCHAR(500)` | Sí | No declarado | Atributo `file_url` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | Sin restricción de columna adicional |
| `status` | `VARCHAR(20)` | No | `'COMPLETED'` | Atributo `status` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT 'COMPLETED'` |
| `generated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Atributo `generated_at` definido por el DDL; su dominio se especifica en las restricciones de esta tabla. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `created_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de creación. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| `updated_at` | `TIMESTAMPTZ` | No | `CURRENT_TIMESTAMP` | Fecha y hora de actualización. | `NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Claves y restricciones de tabla**

```sql
CONSTRAINT fk_generated_reports_type FOREIGN KEY (report_type_id) REFERENCES audit.administrative_report_types (id) ON DELETE RESTRICT;
CONSTRAINT fk_generated_reports_generated_by FOREIGN KEY (generated_by) REFERENCES iam.users (id) ON DELETE RESTRICT;
CONSTRAINT chk_generated_reports_format CHECK (format IN ('PDF', 'EXCEL', 'WORD', 'CSV'));
CONSTRAINT chk_generated_reports_status CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED'));
CONSTRAINT chk_generated_reports_file_url_not_blank CHECK (file_url IS NULL OR btrim(file_url) <> '');
```

**Índices explícitos**

```sql
CREATE INDEX idx_generated_reports_type ON audit.generated_reports (report_type_id);
CREATE INDEX idx_generated_reports_generated_by ON audit.generated_reports (generated_by);
CREATE INDEX idx_generated_reports_format ON audit.generated_reports (format);
CREATE INDEX idx_generated_reports_generated_at ON audit.generated_reports (generated_at);
CREATE INDEX idx_generated_reports_filters ON audit.generated_reports USING gin (filters);
```

Fuente: [01_ddl/10_indexes/audit/create-administrative-reports-indexes.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/10_indexes/audit/create-administrative-reports-indexes.sql).

**Triggers definidos**

```sql
CREATE TRIGGER trg_generated_reports_set_updated_at BEFORE UPDATE ON audit.generated_reports FOR EACH ROW EXECUTE FUNCTION core.set_updated_at();
```

Fuente: [01_ddl/09_triggers/audit/add-administrative-reports-updated-at-triggers.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/09_triggers/audit/add-administrative-reports-updated-at-triggers.sql).


## 4. Reglas transversales que requieren lectura conjunta

- `rental.reservations` declara una exclusión GiST sobre vehículo y período para filas con `blocks_availability`; el intervalo usa límite inicial incluido y final excluido (`[)`). La función de reglas y triggers de reserva determinan comportamiento adicional; un CHECK aislado no acredita todo el flujo.
- Las FK muestran cascada, restricción o SET NULL cuando se especifica. Si no se declara una acción, se conserva el comportamiento por defecto de PostgreSQL; no se inventa ON DELETE CASCADE.
- `iam.user_documents` incorpora `document_number` por ALTER y triggers de revisión; `iam.document_types` y `iam.document_statuses` incorporan campos posteriores. Las filas reflejan esas alteraciones.
- `iam.user_preferences` contiene FK y CHECK en columnas; no se omiten por no utilizar CONSTRAINT de tabla.
- `iam.user_consents` tiene un trigger específico de inmutabilidad. `audit.audit_logs` no tiene un trigger de inmutabilidad en estos archivos; el nombre audit_logs no demuestra protección contra cambios.
- Los montos, límites, dominios y estados se conservan como están declarados en cada tabla. Catálogos semilla y servicios pueden aportar reglas adicionales, cuya existencia no sustituye las constraints físicas.

Las funciones relacionadas se consultan en [01_ddl/07_functions/rental/apply-reservation-rules.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/07_functions/rental/apply-reservation-rules.sql), [01_ddl/07_functions/iam/validate-user-document.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/07_functions/iam/validate-user-document.sql) y [01_ddl/07_functions/iam/prevent-user-consent-mutation.sql](https://github.com/project-drivique/database/blob/681041da4d882aebf2b157cbc827e0b265af7147/01_ddl/07_functions/iam/prevent-user-consent-mutation.sql). Esta HU no ejecuta SQL ni aplica modificaciones al esquema.

## 5. Correspondencia con el plan y brechas del modelo

| Concepto del plan | Modelo encontrado | Diferencia que debe atender la HU correspondiente |
| --- | --- | --- |
| Reseñas de sucursal | `rental.branch_reviews` | Tiene puntuación/comentario y relación usuario-reserva-sede; no contiene `photos`, `official_response` ni `is_immutable`. No se presenta la respuesta inmutable como implementada en BD. |
| Promociones y cupones | `catalog.promotions`, `catalog.user_coupon_usages`, `rental.reservation_promotions` | Los nombres y dominios exactos están en las fichas anteriores; no se usa un esquema billing imaginario. |
| Auditoría | `audit.audit_logs` | Registra operación/resultado/actor; la inmutabilidad y cobertura de eventos necesitan evidencia adicional del diseño y permisos. |
| Pago en efectivo | `rental.reservations.cash_payment_code`, `cash_payment_expires_at`, `billing.payments`, `billing.payment_receipts` | No existe una tabla `cash_collection_receipts` en el DDL revisado. El código de efectivo no se documenta como PIN de entrega. |
| Entrega a domicilio | `rental.reservation_delivery_points` | Modela modalidad y ubicación; no existe `delivery_assignments` ni una asignación persistida de conductor en estas tablas. |
| PIN de entrega de 4 dígitos | No se identifica una columna específica de PIN de entrega en el DDL de las 68 tablas | La decisión confirmada por Danna requiere diseño del almacenamiento seguro, validación y migración en la HU de implementación. No se transforma un código de efectivo en PIN de entrega. |
| Incidencias | `support.incident_reports`, `support.incident_responses` | Son las tablas físicas encontradas; contrastar su cobertura con incidencias de flota y soporte en RF41 y las HU correspondientes. |

El diccionario documenta **lo existente** y registra las diferencias. Agregar campos, tablas o restricciones para implementar las capacidades pendientes es trabajo de diseño/migración; HU-DOC-008 debe mantener el diagrama ER sincronizado con la versión real que se acuerde.

## 6. Verificación documental y mantenimiento

Se verificaron correspondencia con CREATE TABLE, columnas agregadas por ALTER, claves y constraints, índices y triggers, así como referencias desde el maestro Liquibase. Esto no prueba que las migraciones se hayan aplicado en dev/qa/producción ni que pasen pruebas de concurrencia, seguridad o recuperación.

Para actualizar este documento: identificar commit y rama de database, revisar nuevas migraciones y sus alteraciones, conservar tipos/reglas exactos, ajustar inventario y ER y validar referencias. No copiar tablas de la matriz de trazabilidad sin contrastarlas con el SQL.

Relacionados: [arquitectura C4](../overview.md), [ADR de base de datos](../decisions/0004-motor-base-de-datos.md), [SRS](../../01-srs/srs.md) y [matriz de trazabilidad](../../01-srs/matriz-trazabilidad.md).
