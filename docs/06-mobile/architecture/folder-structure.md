# Estructura de Carpetas — Drivique App Móvil

Este documento describe la estructura de directorios y la arquitectura técnica de la aplicación móvil de **Drivique** (`front-end_movil/app-drivique`).

---

## 📂 Árbol de Directorios del Código Fuente (`app-drivique/`)

```text
front-end_movil/app-drivique/
├── app/                      # Rutas y navegación basada en archivos (Expo Router)
│   ├── (auth)/               # Pantallas del flujo de autenticación (Login, Registro, OTP)
│   ├── (main)/               # Pantallas principales accesibles tras iniciar sesión
│   │   ├── (tabs)/           # Navegación por pestañas inferiores (Inicio, Catálogo, Reservas, Perfil)
│   │   ├── catalog/          # Ficha detallada del vehículo seleccionado
│   │   └── reservation/      # Flujo guiado de reserva (Wizard en 3 pasos)
│   ├── _layout.tsx           # Layout raíz con Proveedores de Contexto (Auth, Theme, i18n)
│   └── index.tsx             # Pantalla Splash / Redirección según estado de sesión
├── assets/                   # Imágenes, logos de marcas de autos, fuentes e iconos
├── components/               # Componentes UI reutilizables
│   ├── common/               # Botones adaptativos, tarjetas de autos, insignias, loaders
│   ├── forms/                # Campos de entrada con validación estricta
│   └── modals/               # Diálogos emergentes (selección de fecha, filtros, cupones)
├── context/                  # Proveedores de estado global (Pub-Sub / Observer)
│   ├── AuthContext.tsx       # Estado de autenticación y tokens JWT
│   ├── ThemeContext.tsx      # Gestión reactiva de Modo Claro / Modo Oscuro
│   └── LanguageContext.tsx   # Motor i18n con soporte para 5 idiomas
├── hooks/                    # Custom Hooks reactivos e infraestructura
│   ├── useAuth.ts            # Consumo de sesión y renovación de tokens
│   ├── useCatalog.ts         # Búsqueda y filtrado de flota por ciudad
│   ├── useProfile.ts         # Perfil de usuario y documentos KYC
│   ├── useIdioma.ts          # Cambio reactivo de idioma
│   ├── useTemaColores.ts     # Tokens de color dinámicos HSL/RGB
│   └── useCurrency.ts        # Conversión y formato monetario COP
├── modules/                  # Módulos de dominio autocontenidos (Feature-First)
│   ├── auth/                 # Servicios de login, registro y redes sociales
│   ├── catalog/              # Servicios de flota, categorías y reseñas
│   ├── profile/              # Carga de cédula/licencia y preferencias
│   └── reservation/          # Máquina de estados de reserva (Wizard) y pagos Wompi/Efectivo
├── services/                 # Capa de Infraestructura HTTP y Almacenamiento Local
│   ├── api.ts                # Adaptador Axios / Fetch con interceptores JWT
│   ├── storage.ts            # Wrapper sobre AsyncStorage para credenciales locales
│   └── pdfService.ts         # Adaptador para generación de contratos PDF en el dispositivo
├── types/                    # Interfaces y tipos TypeScript estrictos
│   ├── auth.types.ts         # Tipos de usuario, tokens y roles
│   ├── catalog.types.ts      # Tipos de vehículo, categoría y marcas
│   └── reservation.types.ts  # Tipos de reserva, seguros y cotizaciones
└── app.json                  # Configuración de Expo y metadatos de la aplicación
```

---

## 🧱 Descripción de Módulos y Capas Principales

### 1. `app/` (Expo Router)
Utiliza enrutamiento basado en archivos de Expo Router. La carpeta `(auth)` agrupa pantallas públicas de acceso y `(main)` agrupa el flujo de cliente autenticado.

### 2. `modules/` (Dominio Autocontenido)
Organiza los servicios de negocio por funcionalidad. El código correspondiente a la lógica de cotizaciones de reserva vive exclusivamente en `modules/reservation/`.

### 3. `context/` (Sincronización Global)
Implementa el patrón Observer mediante React Context API, notificando cambios de idioma, tema y sesión a toda la jerarquía de pantallas de forma instantánea.

### 4. `services/` (Infraestructura Móvil)
Maneja el acceso a la red, persistencia segura en el almacenamiento local del teléfono (`AsyncStorage`) y compilación nativa de contratos en PDF con `Expo Print`.
