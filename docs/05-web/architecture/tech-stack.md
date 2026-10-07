# Stack Tecnológico — Drivique Web

Este documento detalla las tecnologías, frameworks, librerías y dependencias utilizadas en el panel web administrativo de **Drivique** (`front-end_web/web-drivique`).

---

## 🚀 1. Núcleo y Lenguaje

| Tecnología | Versión | Propósito / Justificación |
| :--- | :--- | :--- |
| **React** | `^18.3.1` | Biblioteca principal para la construcción de interfaces de usuario declarativas basadas en componentes. |
| **Vite** | `^5.4.2` | Herramienta de compilación (bundler) ultrarrápida que reemplaza Create React App, ofreciendo HMR (Hot Module Replacement) instantáneo. |
| **JavaScript (ES6+)** | ES2022 | Lenguaje de programación nativo con sintaxis moderna (Async/Await, Optional Chaining, Destructuring). |

---

## 🎨 2. Estilos y Sistema de Diseño Visual

| Tecnología | Propósito / Justificación |
| :--- | :--- |
| **Vanilla CSS Modular** | Estilos puros de alto rendimiento sin librerías externas ni overhead de procesamiento. |
| **Variables HSL (Tokens)** | Paleta de coloresTailored HSL con soporte dinámico para modo claro y modo oscuro. |
| **Lucide React Icons** (`^0.446.0`) | Set moderno y ligero de iconos vectoriales SVG para la interfaz administrativa. |

---

## 🛠️ 3. Dependencias Operativas y Herramientas

| Librería / Dependencia | Versión | Propósito en el Proyecto |
| :--- | :--- | :--- |
| **React Router DOM** | `^6.26.2` | Manejo de enrutamiento del lado del cliente, rutas protegidas por rol y navegación sin recarga. |
| **XLSX (SheetJS)** | `^0.18.5` | Generación y exportación de hojas de cálculo Excel desde tablas administrativas. |
| **jsPDF & AutoTable** | `^2.5.2` | Motor de generación de reportes operativos, recibos y comprobantes de caja en formato PDF. |
| **ESLint** | `^9.9.0` | Linter estático para garantizar buenas prácticas y calidad de código Clean Code. |

---

## 📋 4. Archivo de Configuración de Dependencias (`package.json`)

```json
{
  "name": "web-drivique",
  "private": true,
  "version": "0.0.1",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint .",
    "preview": "vite preview"
  },
  "dependencies": {
    "jspdf": "^2.5.2",
    "jspdf-autotable": "^3.8.3",
    "lucide-react": "^0.446.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.26.2",
    "xlsx": "^0.18.5"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.1",
    "eslint": "^9.9.0",
    "vite": "^5.4.2"
  }
}
```
