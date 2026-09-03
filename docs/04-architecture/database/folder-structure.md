# Estructura de Carpetas del Repositorio de Base de Datos

## Arquitectura y Organización

El repositorio de base de datos de **Drivique** sigue una arquitectura modular y estructurada basada en la separación estricta por sub-lenguajes SQL (DDL, DML, DCL, TCL), orden de dependencia secuencial y principios de reversibilidad (Rollbacks obligatorios).

---

## Árbol de Directorios

```text
database/
├── 01_ddl/                     # Definición de datos (Data Definition Language)
│   ├── 00_extensions/          # Extensiones de base de datos (ej. uuid-ossp, pgcrypto)
│   ├── 01_schemas/             # Creación y configuración de esquemas lógicos
│   ├── 02_types/               # Tipos de datos personalizados, ENUMs y dominios
│   ├── 03_tables/              # Definición de tablas de la base de datos
│   ├── 04_constraints/         # Llaves primarias, foráneas, checks y uniques
│   ├── 05_views/               # Vistas estándar para consultas complejas
│   ├── 06_materialized_views/  # Vistas materializadas para rendimiento analítico
│   ├── 07_functions/           # Funciones PL/pgSQL y rutinas de cálculo
│   ├── 08_procedures/          # Procedimientos almacenados para lógica de negocio
│   ├── 09_triggers/            # Disparadores de auditoría y automatización
│   ├── 10_indexes/             # Índices para optimización y búsqueda
│   └── 11_schema_assignments/  # Asignaciones y configuraciones de esquemas
│
├── 02_dml/                     # Manipulación de datos (Data Manipulation Language)
│   ├── 00_inserts/             # Semillas iniciales (seeds), catálogos y roles base
│   ├── 01_updates/             # Modificaciones y actualizaciones de datos
│   ├── 02_deletes/             # Eliminaciones controladas de registros obsoletos
│   ├── 03_upserts/             # Inserciones con resolución de conflictos (ON CONFLICT)
│   └── 04_patches/             # Parches de corrección de datos para incidencias
│
├── 03_dcl/                     # Control de acceso y seguridad (Data Control Language)
│   ├── 00_roles/               # Creación de roles, usuarios de servicio y perfiles
│   └── 01_grants/              # Asignación de privilegios, permisos y políticas RLS
│
├── 04_tcl/                     # Control de transacciones (Transaction Control Language)
│   ├── 00_transaction_blocks/  # Bloques transaccionales seguros (BEGIN, COMMIT, SAVEPOINT)
│   ├── 01_manual_recoveries/   # Scripts de recuperación manual ante fallas
│   └── 02_release_tags/        # Puntos de control e hitos por versión (Releases)
│
├── 05_rollbacks/               # Scripts de reversión simétrica (Espejo de 01 a 04)
│   ├── 01_ddl/                 # Reversión de cambios DDL (DROP TABLE, etc.)
│   ├── 02_dml/                 # Reversión de datos DML
│   ├── 03_dcl/                 # Reversión de permisos DCL (REVOKE)
│   └── 04_tcl/                 # Reversión transaccional
│
├── changelog/                  # Orquestación y versionamiento automatizado
│   └── db.changelog-master.yaml # Registro maestro de cambios (Liquibase)
│
├── scripts/                    # Scripts de utilidad, automatización, backups y despliegue
├── .gitignore                  # Exclusión de archivos sensibles, temporales y volcados .sql
└── README.md                   # Documentación general y guía operativa del repositorio
```

---

## Descripción y Responsabilidad de cada Capa

### 1. `01_ddl/` (Data Definition Language)
Encargada exclusivamente de la estructura y metadatos del motor. Se divide numéricamente para garantizar el orden de ejecución correcto:
* Primero se instancian las **extensiones** y **esquemas**.
* Luego los **tipos y enums**, seguidos de las **tablas base**.
* Posteriormente las **restricciones/constraints** para evitar dependencias circulares al crear tablas.
* Finalmente **vistas, funciones, procedimientos, triggers e índices**.

### 2. `02_dml/` (Data Manipulation Language)
Gestiona la información residente en las tablas.
* `00_inserts`: Contiene los datos indispensables para que el sistema funcione (roles de usuario, categorías de vehículos, estados de viaje/reserva).
* `03_upserts`: Maneja cargas masivas o sincronizaciones idempotentes mediante cláusulas de conflicto.
* `04_patches`: Parches de datos controlados y fechados para solucionar inconsistencias.

### 3. `03_dcl/` (Data Control Language)
Garantiza el principio de mínimo privilegio y seguridad:
* Define roles diferenciados para la API del Backend (lectura/escritura acotada), herramientas de BI/Reportes (solo lectura) y administradores de BD.

### 4. `04_tcl/` (Transaction Control Language)
Define scripts que requieren ejecución atómica en bloque con control de errores explícito, además de registrar tags de versiones liberadas.

### 5. `05_rollbacks/` (Reversión Simétrica)
Política de calidad obligatoria: **Todo cambio aplicado debe tener un script de deshecho equivalente**.
* Si se agrega una columna o tabla en `01_ddl`, debe existir el respectivo script en `05_rollbacks/01_ddl` para eliminarla limpiamente sin dejar estados corruptos.

### 6. `changelog/`
Utiliza el estándar `db.changelog-master.yaml` para permitir la integración con herramientas de CI/CD y despliegue automatizado de esquemas (ej. Liquibase), manteniendo la trazabilidad histórica de ejecuciones por ambiente (`dev`, `qa`, `main`).
