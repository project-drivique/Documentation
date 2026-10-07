# Estructura de Carpetas — Drivique Web

Este documento describe la estructura de directorios y la arquitectura de archivos del proyecto de administración web de **Drivique** (`front-end_web/web-drivique`).

---

## 📂 Árbol de Directorios del Código Fuente (`src/`)

```text
front-end_web/web-drivique/src/
├── assets/                  # Recurso estáticos (imágenes, logos de marca, favicon, iconos)
├── components/              # Componentes de UI globales y atómicos
│   ├── common/              # Botones, insignias (badges), tarjetas, loaders, modales
│   ├── layout/              # Navbar, Sidebar administrativo, Footer, Layout principal
│   └── tables/              # Tabla base reutilizable y celdas atómicas de renderizado
├── hooks/                   # Custom Hooks globales de UI e infraestructura
│   ├── useBranchScope.js    # Aislamiento de datos y permisos por sucursal
│   ├── useManagementTable.js# Paginación, filtrado y búsqueda en tablas
│   ├── useManagementModal.js# Estado y modos de diálogo modal
│   └── useManagementExport.js# Motor de exportación (Excel, PDF, Impresión)
├── modules/                 # Módulos de dominio autocontenidos (Feature-First)
│   ├── admin/               # Gestión de personal de sede, roles y auditoría de accesos
│   │   ├── components/      # Modales de asignación de sede y auditoría
│   │   ├── services/        # Servicios de gestión de sucursal
│   │   └── views/           # Vistas del Panel Administrador General y Encargado
│   ├── auth/                # Autenticación, JWT, roles y permisos
│   │   ├── context/         # AuthContext (proveedor global de sesión)
│   │   └── views/           # Login, Recuperación y Registro
│   ├── catalog/             # Gestión de catálogo de vehículos, marcas y categorías
│   ├── kyc/                 # Verificación de identidad y documentos del conductor
│   ├── payments/            # Procesamiento de pagos y recibos
│   │   ├── factories/       # Factory Method de procesadores de pago
│   │   ├── strategies/      # Patrón Estrategia (Wompi, Efectivo)
│   │   └── views/           # Comprobantes y módulo de facturación
│   ├── profile/             # Perfil del usuario autenticado y preferencias
│   └── reservation/         # Gestión de reservas, extensiones e inspecciones
├── routes/                  # Enrutamiento de la aplicación (React Router DOM)
│   ├── AppRouter.jsx        # Configuración principal de rutas y Error Boundary
│   └── ProtectedRoute.jsx   # Guardias de seguridad según rol (SUPER_ADMIN, BRANCH_ADMIN, EMPLOYEE)
├── services/                # Capa de Servicios API (HTTP Client / Fetch Wrapper)
│   ├── api.js               # Instancia global de Fetch con interceptor JWT
│   ├── authService.js       # Endpoints de login, refresh token y social auth
│   ├── userService.js       # Endpoints de gestión de usuario y eliminación
│   └── branchService.js     # Consulta y actualización de sedes
├── styles/                  # Sistema de Estilos Vanilla CSS con Tokens HSL
│   ├── index.css            # Reset CSS y variables globales de tema
│   ├── admin-system.css     # Estilos unificados para tablas y formularios
│   └── components/          # Módulos de estilos independientes por componente
├── utils/                   # Utilidades generales y formateadores
│   ├── formatters.js        # Formato de moneda COP, fechas y placas
│   └── listExportUtils.js   # Generación de reportes Excel y PDF
├── App.jsx                  # Componente raíz con proveedores globales
└── main.jsx                 # Punto de entrada de Vite y React DOM
```

---

## 🧱 Descripción de Módulos y Capas Principales

### 1. `src/modules/` (Dominio por Funcionalidad)
Cada módulo agrupa sus componentes, vistas y servicios específicos evitando la dispersión del código. Un desarrollador puede trabajar en el módulo `payments` sin alterar el módulo `catalog`.

### 2. `src/hooks/` (Capa de Lógica de UI)
Separa estrictamente la lógica de estado de los componentes visuales. Todos los comportamientos repetitivos de administración (filtrar tablas, abrir modales, exportar archivos) están encapsulados en Custom Hooks.

### 3. `src/services/` (Capa de Infraestructura HTTP)
Encapsula la comunicación con la API del backend Spring Boot. Incluye interceptores automáticos para adjuntar el encabezado `Authorization: Bearer <token>` y manejar respuestas de error HTTP 401/403.

### 4. `src/styles/` (Diseño Visual)
Utiliza CSS Vanilla puro organizado mediante variables HSL, garantizando cero dependencias externas de framework de estilos y un rendimiento óptimo de renderizado.
