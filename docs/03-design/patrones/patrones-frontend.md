# Patrones de Diseño y Principios de Software en Drivique Web

Este documento describe los patrones de diseño, principios SOLID y prácticas de Clean Code aplicados en la plataforma web de administración de **Drivique** (`front-end_web/web-drivique`).

---

## 🏗️ 1. Arquitectura del Proyecto Web

El panel web de Drivique utiliza una **Arquitectura Modular Orientada a Dominios (Feature-First Layered Architecture)**:

```
src/
├── components/          # Componentes compartidos y atómicos (UI, modales, tablas)
├── hooks/               # Custom hooks de infraestructura y alcance de negocio
├── modules/             # Módulos desacoplados por dominio
│   ├── admin/           # Administración general y gestión de sucursal
│   ├── auth/            # Autenticación, JWT, roles y permisos
│   ├── catalog/         # Catálogo de flota, categorías y marcas
│   ├── payments/        # Módulo de pagos, comprobantes y pasarelas
│   ├── profile/         # Gestión de perfil y documentos de usuario
│   └── reservation/     # Gestión de reservas y alquileres
├── services/            # Capa de servicios y comunicación API (Service Layer)
└── utils/               # Utilidades comunes (exportación Excel/PDF, formateadores)
```

---

## 🧩 2. Patrón Custom Hooks (Ganchos Personalizados)

Los Custom Hooks encapsulan la lógica de estado de UI, efectos secundarios y lógica de negocio, manteniendo los componentes visuales limpios (Presentational Components).

### 2.1. `useBranchScope` (Aislamiento de Sucursal y Rol)
Controla los permisos operativos y restringe el alcance de los datos según la sucursal del usuario autenticado (`branchOnly`, `esEncargado`, `sucursalAsignada`).

```javascript
// src/hooks/useBranchScope.js
import { useAuth } from '../modules/auth/context/AuthContext';

export function useBranchScope() {
    const { user, hasRole } = useAuth();
    
    const isSuperAdmin = hasRole('SUPER_ADMIN');
    const isBranchAdmin = hasRole('BRANCH_ADMIN');
    const isEmployee = hasRole('EMPLOYEE');
    
    const sucursalAsignada = user?.branchId || null;
    const branchOnly = !isSuperAdmin && (isBranchAdmin || isEmployee);

    const filterByBranchScope = (dataList, branchKey = 'branchId') => {
        if (!branchOnly || !sucursalAsignada) return dataList;
        return dataList.filter(item => item[branchKey] === sucursalAsignada);
    };

    return {
        isSuperAdmin,
        isBranchAdmin,
        isEmployee,
        sucursalAsignada,
        branchOnly,
        filterByBranchScope
    };
}
```

### 2.2. `useManagementTable` (Gestión Completa de Tablas)
Centraliza paginación, ordenamiento, filtrado por pestañas/estado y búsqueda en tiempo real sobre listados administrativos.

```javascript
// src/hooks/useManagementTable.js
import { useState, useMemo } from 'react';

export function useManagementTable({ data = [], initialTab = 'ALL', pageSize = 10 }) {
    const [activeTab, setActiveTab] = useState(initialTab);
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(1);

    const filteredData = useMemo(() => {
        return data.filter(item => {
            const matchesTab = activeTab === 'ALL' || item.status === activeTab;
            const matchesSearch = Object.values(item).some(val => 
                String(val).toLowerCase().includes(searchTerm.toLowerCase())
            );
            return matchesTab && matchesSearch;
        });
    }, [data, activeTab, searchTerm]);

    const paginatedData = useMemo(() => {
        const start = (currentPage - 1) * pageSize;
        return filteredData.slice(start, start + pageSize);
    }, [filteredData, currentPage, pageSize]);

    return {
        activeTab,
        setActiveTab,
        searchTerm,
        setSearchTerm,
        currentPage,
        setCurrentPage,
        filteredData,
        paginatedData,
        totalPages: Math.ceil(filteredData.length / pageSize)
    };
}
```

### 2.3. `useManagementModal` (Control de Modales y Confirmaciones)
Maneja el estado de apertura/cierre de modales, carga de entidades para edición y diálogos de confirmación de operaciones destructivas.

```javascript
// src/hooks/useManagementModal.js
import { useState } from 'react';

export function useManagementModal() {
    const [isOpen, setIsOpen] = useState(false);
    const [selectedItem, setSelectedItem] = useState(null);
    const [modalMode, setModalMode] = useState('CREATE'); // CREATE, EDIT, DELETE, VIEW

    const openModal = (item = null, mode = 'CREATE') => {
        setSelectedItem(item);
        setModalMode(mode);
        setIsOpen(true);
    };

    const closeModal = () => {
        setIsOpen(false);
        setSelectedItem(null);
    };

    return { isOpen, selectedItem, modalMode, openModal, closeModal };
}
```

### 2.4. `useManagementExport` (Abstracción de Motores de Exportación)
Encapsula la generación y descarga de datos en formatos Excel, PDF e impresión directa.

```javascript
// src/hooks/useManagementExport.js
import { exportToExcel, exportToPdf, printTable } from '../utils/listExportUtils';

export function useManagementExport(filename = 'reporte-drivique') {
    const handleExportExcel = (data, columns) => exportToExcel(data, columns, filename);
    const handleExportPdf = (data, columns, title) => exportToPdf(data, columns, title, filename);
    const handlePrint = (data, columns, title) => printTable(data, columns, title);

    return { handleExportExcel, handleExportPdf, handlePrint };
}
```

---

## 🎯 3. Patrones Strategy y Factory (Procesamiento de Pagos)

En el módulo de pagos de la plataforma web (`src/modules/payments/`), la selección del método de pago se resuelve mediante la combinación de **Strategy Pattern** y **Factory Method Pattern**.

```
                   ┌──────────────────────────────┐
                   │   PaymentProcessorFactory    │
                   └──────────────┬───────────────┘
                                  │ instanciarStrategy()
                                  ▼
                   ┌──────────────────────────────┐
                   │    PaymentStrategy (Base)    │
                   └──────────────┬───────────────┘
                                  │
          ┌───────────────────────┴───────────────────────┐
          ▼                                               ▼
┌───────────────────────────┐                   ┌───────────────────────────┐
│   WompiPaymentStrategy    │                   │    CashPaymentStrategy    │
├───────────────────────────┤                   ├───────────────────────────┤
│ + processPayment()        │                   │ + processPayment()        │
│ (PSE, Tarjetas en línea)  │                   │ (Registro en Caja Sucursal│
└───────────────────────────┘                   └───────────────────────────┘
```

### 3.1. Estrategia Base e Implementaciones

```javascript
// src/modules/payments/strategies/PaymentStrategy.js
export class PaymentStrategy {
    async processPayment(paymentData) {
        throw new Error('El método processPayment debe ser implementado');
    }
}

// src/modules/payments/strategies/WompiPaymentStrategy.js
export class WompiPaymentStrategy extends PaymentStrategy {
    async processPayment({ reservationId, amount, token, customerEmail }) {
        const response = await fetch('/api/v1/payments/wompi/charge', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ reservationId, amount, token, customerEmail })
        });
        return await response.json();
    }
}

// src/modules/payments/strategies/CashPaymentStrategy.js
export class CashPaymentStrategy extends PaymentStrategy {
    async processPayment({ reservationId, amount, branchId, staffUserId }) {
        const response = await fetch('/api/v1/payments/cash/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ reservationId, amount, branchId, staffUserId })
        });
        return await response.json();
    }
}
```

### 3.2. Factory Method (`PaymentProcessorFactory`)

```javascript
// src/modules/payments/factories/PaymentProcessorFactory.js
import { WompiPaymentStrategy } from '../strategies/WompiPaymentStrategy';
import { CashPaymentStrategy } from '../strategies/CashPaymentStrategy';

export class PaymentProcessorFactory {
    static getStrategy(paymentMethod) {
        switch (paymentMethod) {
            case 'WOMPI':
            case 'CARD':
            case 'PSE':
                return new WompiPaymentStrategy();
            case 'CASH':
            case 'BRANCH_OFFICE':
                return new CashPaymentStrategy();
            default:
                throw new Error(`Método de pago no soportado: ${paymentMethod}`);
        }
    }
}
```

---

## ♻️ 4. Principios Clean Code: SRP y DRY

### 4.1. Single Responsibility Principle (SRP) en Tablas
Las celdas de las tablas administrativas se estructuran como componentes independientes encargados de un único dato de presentación (estado, fecha, moneda, acciones).

```javascript
// src/components/tables/cells/StatusCell.jsx
export function StatusCell({ status }) {
    const statusMap = {
        CONFIRMED: { label: 'Confirmada', className: 'badge-success' },
        PENDING: { label: 'Pendiente', className: 'badge-warning' },
        CANCELLED: { label: 'Cancelada', className: 'badge-danger' }
    };
    const current = statusMap[status] || { label: status, className: 'badge-secondary' };

    return <span className={`badge ${current.className}`}>{current.label}</span>;
}
```

### 4.2. Don't Repeat Yourself (DRY) en Exportación (`listExportUtils.js`)
Centraliza los formateadores y motores de renderizado de reportes evitando duplicar código de descarga en las vistas de administración.

```javascript
// src/utils/listExportUtils.js
import * as XLSX from 'xlsx';

export function exportToExcel(data, columns, filename) {
    const formattedData = data.map(item => {
        const row = {};
        columns.forEach(col => {
            row[col.header] = col.accessor(item);
        });
        return row;
    });

    const worksheet = XLSX.utils.json_to_sheet(formattedData);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Datos');
    XLSX.writeFile(workbook, `${filename}.xlsx`);
}
```
