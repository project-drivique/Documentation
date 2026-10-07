# Stack Tecnológico — Drivique App Móvil

Este documento detalla las tecnologías, frameworks, librerías nativas y dependencias utilizadas en la aplicación móvil para clientes de **Drivique** (`front-end_movil/app-drivique`).

---

## 🚀 1. Núcleo y Framework Móvil

| Tecnología | Versión | Propósito / Justificación |
| :--- | :--- | :--- |
| **React Native** | `^0.74.5` | Framework multiplataforma para construir aplicaciones móviles nativas en iOS y Android usando React. |
| **Expo SDK** | `~51.0.0` | Ecosistema de desarrollo móvil que simplifica el acceso a APIs nativas (Cámara, Archivos, Impresión) y despliegues. |
| **Expo Router** | `~3.5.0` | Sistema de enrutamiento basado en archivos con navegación nativa fluida (Tabs, Stacks, Modales). |
| **TypeScript** | `~5.3.3` | Lenguaje de programación con tipado estático en modo estricto (`strict: true`) para prevenir errores en tiempo de ejecución. |

---

## 🎨 2. Interfaz de Usuario y Gráficos Nativos

| Tecnología / Librería | Versión | Propósito en el Proyecto |
| :--- | :--- | :--- |
| **React Native Vector Icons / Lucide** | `^0.446.0` | Iconografía nativa escalable de alta definición para iOS y Android. |
| **React Native SVG** | `^15.2.0` | Renderizado gráfico vectorial nativo para logotipos, esquemas de autos e insignias. |
| **React Native Reanimated** | `~3.10.1` | Motor de animaciones fluidas a 60fps para transiciones de pantalla y feedback visual. |
| **StyleSheet Dinámico** | Nativo | Hojas de estilo optimizadas con soporte para tokens HSL adaptativos (Modo Claro / Modo Oscuro). |

---

## 💾 3. Almacenamiento Local e Integraciones

| Librería / Dependencia | Versión | Propósito |
| :--- | :--- | :--- |
| **AsyncStorage** | `1.23.1` | Persistencia local cifrada de tokens JWT, idioma preferido y borradores de reserva. |
| **Expo Print** | `~13.0.1` | Renderizado y generación nativa de contratos de alquiler en formato PDF dentro del teléfono. |
| **Expo Sharing** | `~12.0.1` | Apertura de hojas de compartir nativas de iOS/Android para enviar contratos y comprobantes. |
| **Expo Document Picker** | `~12.0.2` | Selección y carga de documentos de identidad (Cédula y Licencia) para validación KYC. |

---

## 📋 4. Archivo de Configuración de Dependencias (`package.json`)

```json
{
  "name": "app-drivique",
  "version": "1.0.0",
  "main": "expo-router/entry",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web"
  },
  "dependencies": {
    "@react-native-async-storage/async-storage": "1.23.1",
    "expo": "~51.0.0",
    "expo-document-picker": "~12.0.2",
    "expo-font": "~12.0.9",
    "expo-print": "~13.0.1",
    "expo-router": "~3.5.0",
    "expo-sharing": "~12.0.1",
    "expo-status-bar": "~1.12.1",
    "react": "18.2.0",
    "react-native": "0.74.5",
    "react-native-reanimated": "~3.10.1",
    "react-native-safe-area-context": "4.10.5",
    "react-native-screens": "3.31.1",
    "react-native-svg": "^15.2.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "@types/react": "~18.2.45",
    "typescript": "~5.3.3"
  },
  "private": true
}
```
