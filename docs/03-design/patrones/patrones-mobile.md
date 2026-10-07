# Patrones de Diseño y Principios de Software en Drivique App Móvil

Este documento documenta los patrones de diseño, estructura técnica y arquitectura aplicada en la aplicación móvil de **Drivique** (`front-end_movil/app-drivique`).

---

## 📱 1. Arquitectura de la Aplicación Móvil

La App Móvil utiliza **React Native** con **Expo Router**, TypeScript en modo estricto y una arquitectura modular por características (**Feature-First MVVM & Clean Architecture**):

```
app-drivique/
├── app/                  # Enrutamiento basado en archivos (Expo Router)
│   ├── (auth)/           # Rutas de autenticación (login, registro, OTP)
│   ├── (main)/           # Pantallas principales (catálogo, reservas, perfil)
│   └── _layout.tsx       # Proveedores globales de contexto (Theme, i18n, Auth)
├── modules/              # Módulos de dominio autocontenidos
│   ├── auth/             # Servicios de sesión y autenticación
│   ├── catalog/          # Búsqueda y ficha de vehículos
│   ├── profile/          # Gestión de usuario y documentos KYC
│   └── reservation/      # Flujo guiado de reserva (Wizard 3 Pasos)
├── hooks/                # Custom hooks reactivos e infraestructura
├── services/             # Adaptadores de red y almacenamiento local
└── types/                # Definiciones estricta de TypeScript
```

---

## 🧩 2. Custom Hooks Pattern (Ganchos Personalizados)

Los Custom Hooks desacoplan la UI de la lógica de negocio y consumo de APIs en la app móvil:

### 2.1. `useAuth`
Maneja el estado de sesión del cliente, almacenamiento persistente de tokens JWT en `AsyncStorage` y renovación automática.

```typescript
// modules/auth/hooks/useAuth.ts
import { useContext } from 'react';
import { AuthContext } from '../context/AuthContext';

export function useAuth() {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth debe usarse dentro de un AuthProvider');
    }
    return context;
}
```

### 2.2. `useCatalog`
Gestión del catálogo móvil con filtros por ciudad, categoría, rango de precio e integración con búsqueda en tiempo real.

```typescript
// modules/catalog/hooks/useCatalog.ts
import { useState, useEffect } from 'react';
import { catalogService } from '../services/catalogService';
import { Vehicle } from '../types/catalog.types';

export function useCatalog(cityId?: string) {
    const [vehicles, setVehicles] = useState<Vehicle[]>([]);
    const [loading, setLoading] = useState<boolean>(true);

    useEffect(() => {
        let isMounted = true;
        setLoading(true);
        catalogService.getAvailableVehicles(cityId)
            .then(data => { if (isMounted) setVehicles(data); })
            .finally(() => { if (isMounted) setLoading(false); });
        return () => { isMounted = false; };
    }, [cityId]);

    return { vehicles, loading };
}
```

### 2.3. `useProfile`
Gestión de datos personales del usuario y estado de la carga de documentos de identidad / licencia para validación KYC.

### 2.4. `useIdioma`
Controlador reactivo de internacionalización con soporte para 5 idiomas (`es`, `en`, `fr`, `pt`, `br`) y persistencia del idioma seleccionado.

### 2.5. `useTemaColores`
Soporte dinámico para Modo Claro (Light) y Modo Oscuro (Dark) exponiendo tokens HSL y colores adaptativos.

### 2.6. `useCurrency`
Formateador y conversor monetario en tiempo real con soporte para COP, USD y EUR.

```typescript
// hooks/useCurrency.ts
export function useCurrency() {
    const formatCOP = (amount: number): string => {
        return new Intl.NumberFormat('es-CO', {
            style: 'currency',
            currency: 'COP',
            maximumFractionDigits: 0
        }).format(amount);
    };

    return { formatCOP };
}
```

---

## 🪜 3. Wizard / Step Pattern (Máquina de Estados de Reserva)

El proceso de reserva en la app móvil está desacoplado en un **flujo guiado de 3 pasos** con validación secuencial antes de permitir avanzar a la confirmación final:

```
┌────────────────────────────────┐
│ Paso 1: Selección de Fechas    │ ---> Valida rango válido, horarios de sucursal
└───────────────┬────────────────┘      y tipo de entrega (Sucursal / Domicilio)
                │
                ▼
┌────────────────────────────────┐
│ Paso 2: Coberturas y Extras    │ ---> Valida coberturas de seguro (Básica, Total)
└───────────────┬────────────────┘      y servicios adicionales seleccionados
                │
                ▼
┌────────────────────────────────┐
│ Paso 3: Conductor y Pago       │ ---> Valida documentos KYC del conductor,
└────────────────────────────────┘      cupones y método de pago (Wompi / Efectivo)
```

```typescript
// modules/reservation/hooks/useReservationWizard.ts
import { useState } from 'react';

export function useReservationWizard() {
    const [currentStep, setCurrentStep] = useState<number>(1);

    const nextStep = (isValidStep: boolean) => {
        if (isValidStep && currentStep < 3) {
            setCurrentStep(prev => prev + 1);
        }
    };

    const prevStep = () => {
        if (currentStep > 1) {
            setCurrentStep(prev => prev - 1);
        }
    };

    return { currentStep, nextStep, prevStep };
}
```

---

## 🔌 4. Adapter Pattern (Patrón Adaptador)

El patrón **Adapter** normaliza los DTOs del backend hacia los componentes de la interfaz de usuario móvil y adapta servicios nativos.

### 4.1. Generación de Contratos PDF (`pdfService.ts`)
Adapta la estructura del contrato recibida de la API a plantillas HTML/Print compatibles con **Expo Print**:

```typescript
// services/pdfService.ts
import * as Print from 'expo-print';

export async function generateContractPdf(contractData: any): Promise<string> {
    const htmlContent = `
        <html>
            <body>
                <h1>Contrato de Alquiler Drivique #${contractData.contractNumber}</h1>
                <p>Cliente: ${contractData.customerName}</p>
                <p>Vehículo: ${contractData.vehiclePlate}</p>
                <p>Total: $${contractData.totalAmount} COP</p>
            </body>
        </html>
    `;
    const { uri } = await Print.printToFileAsync({ html: htmlContent });
    return uri;
}
```

---

## 📡 5. Observer / Pub-Sub (Context API Global)

La App Móvil utiliza **React Context API** para implementar el patrón **Observer / Publicador-Suscriptor**:

- **`AuthContext`**: Notifica instantáneamente a todas las vistas cuando la sesión es iniciada o revocada.
- **`ThemeContext`**: Notifica el cambio global de modo claro a modo oscuro.
- **`LanguageContext`**: Transmite el cambio de idioma a todos los componentes suscriptos sin necesidad de recargar la aplicación.

```typescript
// context/ThemeContext.tsx
import React, { createContext, useState } from 'react';

export const ThemeContext = createContext({ isDark: false, toggleTheme: () => {} });

export const ThemeProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [isDark, setIsDark] = useState(false);
    const toggleTheme = () => setIsDark(prev => !prev);

    return (
        <ThemeContext.Provider value={{ isDark, toggleTheme }}>
            {children}
        </ThemeContext.Provider>
    );
};
```
