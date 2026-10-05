# 🛡️ Requerimientos No Funcionales — Drivique

Este documento detalla los Requerimientos No Funcionales (RNF) del sistema **Drivique**, especificando los atributos de calidad, rendimiento, seguridad, mantenibilidad y accesibilidad que gobiernan la plataforma.

---

## 🔒 1. Seguridad (RNF-SEG)
* **RNF-SEG-01 (Autenticación JWT):** Toda comunicación cliente-servidor autenticada debe emplear tokens **JSON Web Token (JWT)** firmados mediante algoritmos HMAC-SHA256 con expiración máxima de 24 horas y rotación de Refresh Tokens.
* **RNF-SEG-02 (Cifrado de Comunicaciones):** Todo el tráfico web y móvil debe transmitirse exclusivamente sobre protocolos seguros cifrados **HTTPS / TLS 1.3** con certificados válidos.
* **RNF-SEG-03 (Protección de Credenciales):** Las contraseñas de los usuarios deben almacenarse mediante **BCrypt** con un factor de trabajo (*salting*) mínimo de 10.
* **RNF-SEG-04 (Control de Acceso por Roles - RBAC):** El backend en Spring Boot debe aplicar la anotación `@PreAuthorize` en cada endpoint sensible para asegurar el principio de menor privilegio (`ROLE_CLIENT`, `ROLE_BRANCH_MANAGER`, `ROLE_CASHIER`, `ROLE_SUPER_ADMIN`).
* **RNF-SEG-05 (Cumplimiento PCI-DSS):** Ninguna información sensible de tarjetas de crédito o débito debe almacenarse en las bases de datos de Drivique; el procesamiento de pagos se delega al tokenizador y pasarela oficial de **Wompi**.

---

## 🚀 2. Rendimiento y Eficiencia (RNF-PERF)
* **RNF-PERF-01 (Tiempo de Carga Frontend):** La página de inicio y el catálogo deben lograr un tiempo de primera pintura con contenido (**FCP**) menor a 1.5 segundos y tiempo de carga total menor a 3.0 segundos sobre conexiones 4G/Wi-Fi.
* **RNF-PERF-02 (Latencia de la API REST):** El 95% de los endpoints de consulta del backend Spring Boot deben responder en menos de 200 milisegundos.
* **RNF-PERF-03 (Optimizaciones de Bundling):** El Frontend Web debe compilarse utilizando **Vite**, separando librerías pesadas (JSPDF, XLSX, Lucide Icons) en trozos independientes (*code-splitting*).

---

## 🌐 3. Usabilidad e Internacionalización (RNF-USA)
* **RNF-USA-01 (Internacionalización - i18n):** La plataforma debe soportar de manera reactiva e instantánea **5 idiomas oficiales**:
  1. Español (`es`)
  2. Inglés (`en`)
  3. Francés (`fr`)
  4. Portugués (`pt`)
  5. Alemán (`de`)
* **RNF-USA-02 (Modo Oscuro Nativo):** Las interfaces Web y Móvil deben incorporar soporte completo para **Modo Claro (Light Mode)** y **Modo Oscuro (Dark Mode)** adaptándose a la preferencia del sistema o al selector de usuario.
* **RNF-USA-03 (Accesibilidad Web):** El diseño de la interfaz debe cumplir los lineamientos internacionales **WCAG 2.1 Nivel AA**, incluyendo contraste adecuado de color, soporte para lectores de pantalla y navegación por teclado.

---

## 🗄️ 4. Persistencia y Mantenibilidad de Base de Datos (RNF-BD)
* **RNF-BD-01 (Motor Relacional):** La base de datos debe ejecutarse sobre **PostgreSQL 17** con soporte nativo de extensión `pgcrypto` para identificadores UUID v4 (`gen_random_uuid()`).
* **RNF-BD-02 (Migraciones con Liquibase):** Todo cambio en la estructura DDL/DML de la base de datos debe gestionarse de forma automatizada y versionada a través de changelogs de **Liquibase** (`db.changelog-master.xml`), prohibiendo modificaciones manuales en caliente.
* **RNF-BD-03 (Preservación e Integridad de Datos):** Las tablas maestras deben utilizar estrategias de **Soft Delete** (`is_active = FALSE`) en lugar de borrado físico y registrar auditoría inmutable en `audit_logs` con capturas `JSONB`.

---

## 📱 5. Compatibilidad y Despliegue (RNF-COMP)
* **RNF-COMP-01 (Compatibilidad Web):** La aplicación web administrativa y de clientes debe ser 100% compatible con los navegadores Google Chrome, Mozilla Firefox, Safari y Microsoft Edge.
* **RNF-COMP-02 (Compatibilidad Móvil):** La aplicación móvil debe desarrollarse sobre **React Native + Expo Router**, siendo compatible con dispositivos **Android 13/14+** e **iOS 16+**.
