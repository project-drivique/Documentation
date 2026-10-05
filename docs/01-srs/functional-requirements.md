# ESPECIFICACIÓN DE REQUERIMIENTOS FUNCIONALES (SRS DRIVIQUE)

**Proyecto:** Drivique - Sistema Integral de Alquiler de Vehículos (Web & App Móvil)  
**Documento:** `functional-requirements.md`  
**Estándar de Documentación:** IEEE 830-1998  
**Ámbito de Aplicación:** Web (Plataforma Cliente y Panel Administrativo) y App Móvil (Plataforma Cliente Android)  
**Fecha de Emisión:** 2026  

---

## 📌 NOTA ARQUITECTÓNICA Y ALCANCE DE PLATAFORMAS (WEB Y APP MÓVIL)

1. **Aclaración de Alcance para la App Móvil:**
   - La **Aplicación Móvil (Android)** implementa exactamente la misma lógica de negocio, reglas de validación y requerimientos del cliente descritos desde el **RF1 hasta el RF33** (Autenticación, Catálogo, Búsqueda, Cupones, Reservas, Pagos con Wompi, Cobro en Efectivo con Vencimiento Dinámico, Contrato Digital, Validación de PIN Nequi de Entrega, Reseñas con Fotos, Soporte y Perfil).
   - La App Móvil **excluye** los módulos de administración y gestión operativa (**RF34 al RF54**), los cuales corresponden exclusivamente al Panel Web para Super Administradores y Encargados de Sucursal.

2. **Atributos No Funcionales Excluidos como RF Standalone:**
   - **Diseño Responsivo (RWD):** Adaptación visual a distintos tamaños de pantalla (clasificado en `non-functional-requirements.md` como RNF5).
   - **Selector de Idioma (i18n):** Cambio de idioma global para 5 idiomas (clasificado en `non-functional-requirements.md` como RNF3).
   - **Cambio de Tema Visual (Light/Dark Mode):** Alternancia entre modo claro y oscuro mediante variables CSS globales (clasificado en `non-functional-requirements.md` como RNF4).

---

## 📌 ESTRUCTURA GENERAL DE MÓDULOS FUNCIONALES

- **Módulo 1: Landing Page (Página de Inicio Pública)** (RF1 - RF2)
- **Módulo 2: Autenticación y Gestión de Cuenta** (RF3 - RF8)
- **Módulo 3: Catálogo de Vehículos y Experiencia del Cliente** (RF9 - RF18)
- **Módulo 4: Flujo Multipasos de Reservas (Wizard de Reserva)** (RF19 - RF25)
- **Módulo 5: Pasarela de Pagos (Wompi Virtual y Efectivo en Sucursal)** (RF26 - RF27)
- **Módulo 6: Contratos Digitales, Firma Electrónica y Entrega con PIN** (RF28)
- **Módulo 7: Gestión de Mis Reservas y Perfil del Cliente** (RF29 - RF31)
- **Módulo 8: Calificaciones y Reseñas de Vehículos con Fotografía** (RF32 - RF33)
- **Módulo 9: Canales de Soporte al Cliente, Notificaciones y Asistente Virtual** (RF34 - RF35)
- **Módulo 10: Panel Administrativo y Gestión Operativa de Sucursal** (RF36 - RF54)

---

# MÓDULO 1: LANDING PAGE (PÁGINA DE INICIO PÚBLICA)

---

### RF1: Página de inicio (visitante sin sesión)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF1.1** Renderizar la sección Hero principal presentando la propuesta de valor de Drivique, eslogan de la marca, descripción breve del servicio y botones de llamado a la acción ("Explorar vehículos" y "Registrarse").
2. **RF1.2** Mostrar el panel interactivo "Disponibles ahora" con tarjetas resumen de la flota destacada en tiempo real.
3. **RF1.3** Renderizar la sección "¿Cómo funciona?" mediante 4 pasos secuenciales del proceso de alquiler (Buscar, Seleccionar, Reservar, Conducir).
4. **RF1.4** Mostrar la sección "Por qué elegirnos" destacando las ventajas competitivas (flota garantizada, seguros incluidos, asistencia 24/7 y precios transparentes).
5. **RF1.5** Renderizar la sección de cierre orientada a la conversión de visitantes no registrados.
6. **RF1.6** Mostrar el pie de página (Footer) con enlaces institucionales, términos de uso, políticas de privacidad y accesos a redes sociales.
7. **RF1.7** Mostrar la barra de navegación superior fija (Sticky Navbar) con el logo corporativo e ítems de menú.
8. **RF1.8** Renderizar los botones "Iniciar sesión" y "Registrarse" en el menú para usuarios no autenticados.
9. **RF1.9** Redirigir al usuario al formulario de login (`/login`) o registro (`/registro`) al interactuar con botones de conversión o intentar acciones restringidas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF1 Página de inicio (visitante sin sesión) |
| **Tipo / Actor** | Visitante (Usuario no autenticado sin sesión iniciada en la plataforma) |
| **Ruta / Componente (UI)** | Ruta `/` -> `LandingPage.jsx`, `HeroSection.jsx`, `FeaturedVehicles.jsx`, `HowItWorks.jsx`, `Footer.jsx` |
| **Descripción** | Presenta la propuesta de valor comercial y la identidad de marca de Drivique a los visitantes públicos. Permite consultar la flota destacada en tiempo real, comprender los 4 pasos del flujo de alquiler, revisar beneficios corporativos y conducir la navegación hacia los formularios de registro de cuenta e inicio de sesión cuando se intentan realizar acciones restringidas. |
| **Entrada** | 1. Carga de la ruta raíz del dominio (`/`) sin un token JWT activo en la sesión.<br>2. Clics del usuario en los botones principales de conversión ("Explorar vehículos", "Registrarse").<br>3. Clics en los ítems de la barra de navegación superior y pie de página (Footer).<br>4. Interacción con las tarjetas de la sección "Disponibles ahora". |
| **Salida** | 1. Renderizado de la estructura visual completa de la Landing Page con sus 5 secciones principales.<br>2. Despliegue de los botones "Iniciar sesión" y "Registrarse" en el encabezado fijo.<br>3. Redirección inmediata a las rutas protegidas de autenticación (`/login` o `/registro`) ante cualquier interacción de conversión. |
| **Acción** | 1. Verificar la ausencia de token JWT en el estado global (`useAuthStore`).<br>2. Consultar y cargar en memoria el listado de vehículos destacados de la flota activa via `GET /api/v1/vehicles/featured`.<br>3. Interceptación de intentos de acceso a funcionalidades de usuario registrado y redirección al enrutador de autenticación. |
| **Manejo de Situaciones Anormales** | 1. Si la API de vehículos destacados falla (HTTP 500/503), la página renderiza un estado degradado mostrando una vista previa estática sin romper la maquetación.<br>2. Si la conexión a internet cae, se despliega una barra superior indicando estado offline. |
| **Criterios de Aceptación** | 1. La página pública debe renderizarse correctamente sin solicitar credenciales ni bloquear el acceso.<br>2. El botón "Explorar vehículos" debe llevar al catálogo en modo lectura.<br>3. El botón "Registrarse" debe redirigir al formulario de registro en dos pasos.<br>4. El menú superior debe exhibir de forma permanente los accesos a inicio de sesión y registro. |

---

### RF2: Redirección tras inicio de sesión

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF2.1** Redirigir automáticamente al catálogo de vehículos (`/home`) tras la autenticación exitosa de un usuario con rol Cliente.
2. **RF2.2** Bloquear la visualización de la Landing Page pública (`/`) cuando exista una sesión activa, redirigiendo al panel asignado al rol.
3. **RF2.3** Ocultar los botones de "Iniciar sesión" y "Registrarse" en el menú superior para usuarios autenticados, desplegando en su lugar el nombre de usuario, avatar e ícono de notificaciones.
4. **RF2.4** Permitir la libre navegación por el catálogo e iniciar procesos de reserva sin modales de bloqueo para el usuario autenticado.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF2 Redirección tras inicio de sesión |
| **Tipo / Actor** | Cliente / Super Administrador (`ROLE_SUPER_ADMIN`) / Encargado de Sucursal (`ROLE_BRANCH_MANAGER`) |
| **Ruta / Componente (UI)** | Guardias de Navegación `ProtectedRoute.jsx`, `GuestRoute.jsx`, `useAuthStore.js` |
| **Descripción** | Administra el flujo de control de acceso y enrutamiento defensivo del sistema. Garantiza que cualquier usuario que posea un token de sesión activo (JWT) y pretenda ingresar a la ruta pública (`/`) sea evaluado y redirigido automáticamente a la vista principal correspondiente a su rol de usuario sin exponer la Landing Page de visitante. |
| **Entrada** | 1. Evento de autenticación exitosa en el formulario de inicio de sesión.<br>2. Intento de navegación manual a la URL raíz (`/`) teniendo una sesión activa persistida en el navegador. |
| **Salida** | 1. Redirección automática a la ruta `/home` para usuarios con rol de Cliente.<br>2. Redirección a `/admin` para usuarios con rol de Super Administrador.<br>3. Redirección a `/encargado` para el rol Encargado de Sucursal.<br>4. Menú de navegación actualizado con el perfil, avatar e insignias del usuario autenticado. |
| **Acción** | 1. Leer el estado del token JWT e hidratar el usuario desde `authStore`.<br>2. Ejecutar la función helper de control de acceso `getRoleHome(usuario.rol)`.<br>3. Reemplazar la entrada en el historial de navegación para evitar bucles de retorno al presionar el botón "Atrás" del navegador. |
| **Manejo de Situaciones Anormales** | 1. Si el token JWT ha expirado durante la verificación, el sistema destruye las credenciales guardadas y redirige a `/login` con un mensaje de expiración de sesión. |
| **Criterios de Aceptación** | 1. Un usuario autenticado no debe poder visualizar la Landing Page de visitantes bajo ninguna circunstancia.<br>2. El sistema debe redirigir exactamente al panel correspondiente al rol del token.<br>3. Los botones de inicio de sesión y registro no deben ser visibles para usuarios autenticados. |

---

# MÓDULO 2: AUTENTICACIÓN Y GESTIÓN DE CUENTA

---

### RF3: Registro de usuario

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF3.1** Renderizar pantalla dividida en dos paneles: panel informativo a la izquierda y formulario de registro a la derecha (`/registro`).
2. **RF3.2** Solicitar los campos obligatorios: correo electrónico, contraseña y confirmación de contraseña.
3. **RF3.3** Validar cada campo del formulario en tiempo real conforme se digitan los caracteres.
4. **RF3.4** Aplicar política de contraseñas robustas (mínimo 8 caracteres, al menos una letra mayúscula, un número y un carácter especial).
5. **RF3.5** Comparar y validar que la contraseña y su confirmación sean exactamente idénticas.
6. **RF3.6** Desplegar indicador visual de fuerza de contraseña (Débil, Media, Fuerte) mediante barras de progreso y colores.
7. **RF3.7** Alternar la visibilidad de la contraseña (mostrar/ocultar texto) mediante ícono de ojo interactivo.
8. **RF3.8** Requerir la aceptación obligatoria de los Términos y Condiciones y Política de Privacidad mediante checkbox.
9. **RF3.9** Deshabilitar el botón "Registrarse" mientras existan errores de validación o campos obligatorios vacíos.
10. **RF3.10** Enviar petición de registro al servidor REST backend (`POST /api/v1/auth/register`).
11. **RF3.11** Redirigir automáticamente a la pantalla de verificación 2FA (`/verify-2fa`) tras completar el envío inicial.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF3 Registro de usuario |
| **Tipo / Actor** | Visitante / Nuevo Usuario |
| **Ruta / Componente (UI)** | Ruta `/registro` -> `RegisterPage.jsx`, `RegisterForm.jsx`, `PasswordStrengthBar.jsx` |
| **Descripción** | Permite el alta de nuevos usuarios en la plataforma Drivique mediante la captura de credenciales básicas de acceso. Garantiza la calidad de la información ingresada mediante validaciones reactivas, fortalece la seguridad exigiendo contraseñas complejas y asegura el consentimiento legal del usuario previo al envío de datos. |
| **Entrada** | 1. Correo electrónico válido (formato RFC 5322).<br>2. Contraseña y Confirmación de contraseña.<br>3. Marcado del checkbox de Aceptación de Términos y Condiciones. |
| **Salida** | 1. Feedback visual instantáneo sobre la validez de los campos.<br>2. Creación del registro temporal de usuario en estado "Pendiente de Verificación".<br>3. Envío de código OTP de 6 dígitos al correo electrónico registrado.<br>4. Redirección automática a la vista `/verify-2fa`. |
| **Acción** | 1. Ejecutar validación de esquema con Zod / React Hook Form.<br>2. Transmitir payload JSON cifrado por HTTPS al backend.<br>3. Guardar temporalmente el correo electrónico en el estado de registro para la fase de 2FA. |
| **Manejo de Situaciones Anormales** | 1. Si el correo ya se encuentra registrado en el sistema, la API retorna error `409 Conflict` y el formulario resalta el campo de correo con el mensaje "Este correo electrónico ya está registrado".<br>2. Si falla el servidor, se notifica mediante un Toast rojo de error. |
| **Criterios de Aceptación** | 1. No se permite el registro si las contraseñas no coinciden o no cumplen la regla de fortaleza.<br>2. El botón de envío no se activa hasta haber aceptado los Términos y Condiciones.<br>3. Al completar el formulario, se redirige inmediatamente a la verificación de código OTP. |

---

### RF4: Verificación de identidad con doble factor (2FA / Código de Correo)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF4.1** Renderizar la pantalla de verificación de código OTP de 6 dígitos (`/verify-2fa`).
2. **RF4.2** Desplegar 6 casillas numéricas independientes con avance automático de foco al digitar cada número.
3. **RF4.3** Mostrar el correo electrónico al cual fue enviado el código de confirmación.
4. **RF4.4** Implementar contador regresivo de tiempo de validez del código (ej. 05:00 minutos).
5. **RF4.5** Ofrecer botón "Reenviar código" que se habilita únicamente cuando el contador llega a cero.
6. **RF4.6** Validar automáticamente el código al completar el último dígito en la sexta casilla.
7. **RF4.7** Activar la cuenta de usuario en la base de datos tras la validación exitosa.
8. **RF4.8** Redirigir al usuario autenticado al catálogo (`/home`) con el token JWT de sesión activo.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF4 Verificación de identidad con doble factor (2FA / Código de Correo) |
| **Tipo / Actor** | Usuario en Proceso de Registro |
| **Ruta / Componente (UI)** | Ruta `/verify-2fa` -> `Verify2FAPage.jsx`, `OTPInputGroup.jsx`, `CountdownTimer.jsx` |
| **Descripción** | Mecanismo de seguridad de doble factor que exige la confirmación del correo electrónico registrado mediante la introducción de una clave de un solo uso (OTP) de 6 dígitos. Previene la creación de cuentas falsas o no autorizadas. |
| **Entrada** | 1. Código numérico OTP de 6 dígitos ingresado por el usuario.<br>2. Evento de clic en "Reenviar código". |
| **Salida** | 1. Activación de la cuenta de usuario en la base de datos (`is_active = true`).<br>2. Generación e inyección del token JWT de sesión en la plataforma.<br>3. Redirección automática a la vista `/home`. |
| **Acción** | 1. Transmitir el código numérico a `POST /api/v1/auth/verify-otp`.<br>2. Comparar la clave ingresada contra el hash del código temporal en servidor.<br>3. Autenticar de forma transparente al usuario una vez validado. |
| **Manejo de Situaciones Anormales** | 1. Si el código ingresado es incorrecto, se limpia el input y se despliega la alerta "Código de verificación inválido".<br>2. Si el código ha expirado, se exige presionar "Reenviar código" para recibir uno nuevo. |
| **Criterios de Aceptación** | 1. El avance entre las 6 casillas numéricas debe ser automático e intuitivo.<br>2. La cuenta no puede iniciar sesión sin haber completado la verificación OTP.<br>3. El reenvió de código debe estar bloqueado mientras el contador regresivo se encuentre activo. |

---

### RF5: Inicio de sesión

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF5.1** Renderizar formulario de inicio de sesión (`/login`) con campos de correo electrónico y contraseña.
2. **RF5.2** Ofrecer la función "Recordarme" para mantener la sesión activa en el navegador.
3. **RF5.3** Incluir enlace "¿Olvidaste tu contraseña?" con redirección a la vista de recuperación (`/forgot-password`).
4. **RF5.4** Alternar la visibilidad del texto de la contraseña mediante ícono interactivo.
5. **RF5.5** Enviar credenciales al backend (`POST /api/v1/auth/login`) cifradas en canal HTTPS.
6. **RF5.6** Almacenar el token JWT recibido en el almacenamiento del cliente (`localStorage` / Cookie HTTP-Only).
7. **RF5.7** Cargar el perfil de usuario en el estado global de la aplicación.
8. **RF5.8** Redirigir al usuario al catálogo (`/home`) o al panel asignado según su rol.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF5 Inicio de sesión |
| **Tipo / Actor** | Usuario Registrado (Cliente) |
| **Ruta / Componente (UI)** | Ruta `/login` -> `LoginPage.jsx`, `LoginForm.jsx` |
| **Descripción** | Permite el acceso seguro de usuarios previamente registrados a la plataforma mediante la verificación de sus credenciales (correo y contraseña). Inicia la sesión de usuario y otorga el token JWT necesario para realizar operaciones autenticadas. |
| **Entrada** | 1. Correo electrónico del usuario.<br>2. Contraseña del usuario.<br>3. Selección del checkbox "Recordarme". |
| **Salida** | 1. Token JWT de autenticación retornado por el servidor.<br>2. Perfil del usuario cargado en memoria.<br>3. Redirección exitosa a la vista correspondiente. |
| **Acción** | 1. Validar el formato de los datos ingresados.<br>2. Invocar la API de autenticación backend.<br>3. Guardar el token y configurar los encabezados HTTP `Authorization: Bearer <token>` para peticiones futuras. |
| **Manejo de Situaciones Anormales** | 1. Si las credenciales son erróneas, se despliega la alerta "Correo o contraseña incorrectos".<br>2. Si la cuenta no está verificada (falta 2FA), redirige automáticamente a `/verify-2fa`. |
| **Criterios de Aceptación** | 1. Las credenciales deben enviarse cifradas obligatoriamente.<br>2. Al autenticarse correctamente, el sistema redirige al catálogo sin demoras.<br>3. La opción "Recordarme" extiende la persistencia del token de sesión. |

---

### RF6: Recuperar contraseña

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF6.1** Renderizar la pantalla de solicitud de recuperación de contraseña (`/forgot-password`).
2. **RF6.2** Solicitar el correo electrónico asociado a la cuenta.
3. **RF6.3** Enviar enlace con token de restablecimiento único al correo del usuario (`POST /api/v1/auth/forgot-password`).
4. **RF6.4** Renderizar la pantalla de restablecimiento de contraseña (`/reset-password`) al acceder desde el enlace del correo.
5. **RF6.5** Solicitar nueva contraseña y confirmación de la misma con validación de fortaleza.
6. **RF6.6** Actualizar la contraseña en la base de datos y revocar tokens de restablecimiento utilizados.
7. **RF6.7** Redirigir al usuario a la pantalla de login (`/login`) con mensaje de éxito.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF6 Recuperar contraseña |
| **Tipo / Actor** | Usuario Registrado |
| **Ruta / Componente (UI)** | Rutas `/forgot-password` y `/reset-password` -> `ForgotPasswordPage.jsx`, `ResetPasswordPage.jsx` |
| **Descripción** | Flujo de autoservicio que permite a los usuarios que han olvidado su contraseña restablecerla de forma segura mediante la verificación de propiedad de su correo electrónico. |
| **Entrada** | 1. Correo electrónico registrado.<br>2. Token de recuperación recibido en el enlace.<br>3. Nueva contraseña y confirmación. |
| **Salida** | 1. Correo con enlace de restablecimiento seguro (válido por 15 minutos).<br>2. Actualización del hash de contraseña en la base de datos.<br>3. Notificación de éxito y redirección a login. |
| **Acción** | 1. Generar token de un solo uso en servidor asociado al usuario.<br>2. Validar el token enviado en la URL de restablecimiento.<br>3. Cifrar la nueva contraseña con BCrypt y guardarla en la BD. |
| **Manejo de Situaciones Anormales** | 1. Si el enlace ha expirado o el token es inválido, se muestra una pantalla de error solicitando generar un nuevo enlace.<br>2. Si el correo no existe, por seguridad se muestra el mismo mensaje ambiguo "Si el correo está registrado, recibirás las instrucciones". |
| **Criterios de Aceptación** | 1. El token de restablecimiento caduca automáticamente a los 15 minutos.<br>2. La nueva contraseña debe cumplir con los mismos requisitos de fortaleza del registro.<br>3. La contraseña anterior queda invalidada de inmediato. |

---

### RF7: Inicio de sesión con rol (Administrador y Encargado de sucursal)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF7.1** Evaluar los claims del token JWT tras la autenticación de cualquier usuario.
2. **RF7.2** Redirigir al panel `/admin` si el usuario posee el rol Super Administrador (`ROLE_SUPER_ADMIN`).
3. **RF7.3** Redirigir al panel `/encargado` si el usuario posee el rol Encargado de Sucursal (`ROLE_BRANCH_MANAGER`).
4. **RF7.4** Restringir el acceso a rutas administrativas a usuarios con rol Cliente (`ROLE_CUSTOMER`), retornando error 403 Forbidden.
5. **RF7.5** Cargar las variables de contexto específicas del rol en el almacenamiento de la aplicación.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF7 Inicio de sesión con rol (Administrador y Encargado de sucursal) |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Ruta / Componente (UI)** | Rúter Principal -> `AppRoutes.jsx`, `RoleBasedGuard.jsx` |
| **Descripción** | Control de acceso basado en roles (RBAC) que canaliza a los usuarios administrativos hacia sus respectivos paneles de control de acuerdo con sus permisos asignados en el sistema. |
| **Entrada** | 1. Token JWT validado con claims de rol (`ROLE_SUPER_ADMIN`, `ROLE_BRANCH_MANAGER`). |
| **Salida** | 1. Redirección al dashboard administrativo correspondiente (`/admin` o `/encargado`).<br>2. Habilitación de menús y opciones de gestión administrativa. |
| **Acción** | 1. Decodificar payload JWT y extraer el arreglo de roles/permisos.<br>2. Comparar roles contra la matriz de permisos de la ruta solicitada.<br>3. Renderizar el layout administrativo o denegar el acceso. |
| **Manejo de Situaciones Anormales** | 1. Si un usuario intenta forzar la URL de un panel sin tener el rol adecuado, es redirigido inmediatamente a su panel correspondiente o a la página 403. |
| **Criterios de Aceptación** | 1. Los administradores ingresan directamente a su panel operativo.<br>2. Los clientes no pueden acceder visual ni lógicamente a ninguna vista de administración. |

---

### RF8: Acceso modo invitado sin registro

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF8.1** Permitir la libre navegación por el catálogo de vehículos (`/catalogo`) a usuarios no registrados (Visitantes).
2. **RF8.2** Habilitar el uso de buscadores, filtros de categorías, precios y ubicaciones en modo lectura.
3. **RF8.3** Permitir la visualización completa de los detalles de cualquier vehículo (`Modal Emergente -> VehicleDetailsModal.jsx`).
4. **RF8.4** Interceptar el clic en el botón "Reservar ahora" desplegando modal de autenticación requerida.
5. **RF8.5** Redirigir al flujo de login/registro guardando el vehículo seleccionado para retomar la reserva tras autenticarse.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF8 Acceso modo invitado sin registro |
| **Tipo / Actor** | Visitante / Usuario no autenticado |
| **Ruta / Componente (UI)** | Rutas `/catalogo`, `Modal Emergente -> VehicleDetailsModal.jsx` -> `CatalogPage.jsx`, `VehicleDetailsModal.jsx`, `AuthRequiredModal.jsx` |
| **Descripción** | Otorga libertad de navegación pública para explorar la oferta de vehículos y servicios de Drivique sin exigir registro previo, postergando la solicitud de credenciales hasta el momento exacto en que se desea iniciar una reserva. |
| **Entrada** | 1. Navegación libre por las rutas de catálogo y detalle.<br>2. Intento de interacción con acciones privilegiadas ("Reservar", "Guardar en favoritos"). |
| **Salida** | 1. Visualización completa de información de flota en modo lectura.<br>2. Despliegue de modal instructivo invitando a iniciar sesión o registrarse. |
| **Acción** | 1. Permitir peticiones GET públicas a la API de catálogo.<br>2. Capturar intención de reserva y almacenar la URL de retorno en la sesión temporal. |
| **Manejo de Situaciones Anormales** | 1. Si el visitante intenta saltar directamente a la URL de checkout (`/checkout`), la guardia de ruta lo redirige inmediatamente a `/login`. |
| **Criterios de Aceptación** | 1. Los visitantes pueden consultar vehículos y precios sin restricción.<br>2. La acción de reservar requiere autenticación previa en el 100% de los casos. |

---

# MÓDULO 3: CATÁLOGO DE VEHÍCULOS Y EXPERIENCIA DEL CLIENTE

---

### RF9: Encabezado y buscador del catálogo

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF9.1** Renderizar barra de búsqueda principal en la cabecera del catálogo (`/catalogo`).
2. **RF9.2** Incluir campo de entrada de texto libre para buscar por marca, modelo o palabra clave.
3. **RF9.3** Incluir selectores desplegables de Ubicación/Sucursal, Fecha de Inicio y Fecha de Fin.
4. **RF9.4** Ejecutar búsqueda en tiempo real (debounce 300ms) conforme se escribe en el campo de texto.
5. **RF9.5** Filtrar dinámicamente las tarjetas de vehículos expuestas en el catálogo según los criterios ingresados.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF9 Encabezado y buscador del catálogo |
| **Tipo / Actor** | Cliente / Visitante |
| **Ruta / Componente (UI)** | Ruta `/catalogo` -> `CatalogHeader.jsx`, `SearchBar.jsx` |
| **Descripción** | Proporciona una herramienta de búsqueda avanzada en la cabecera del catálogo que combina texto libre y parámetros espacio-temporales para encontrar vehículos disponibles. |
| **Entrada** | 1. Texto de búsqueda.<br>2. Ciudad o sucursal seleccionada.<br>3. Rango de fechas (Recogida y Devolución). |
| **Salida** | 1. Actualización instantánea del listado de vehículos que coinciden con los criterios.<br>2. Contador con el número total de resultados encontrados. |
| **Acción** | 1. Construir query string de consulta para la API REST (`GET /api/v1/vehicles?search=...&city=...&startDate=...`).<br>2. Actualizar el estado de la lista de vehículos en la interfaz. |
| **Manejo de Situaciones Anormales** | 1. Si no se encuentran resultados, se muestra una ilustración de "Sin coincidencias" con sugerencias para ampliar los criterios de búsqueda. |
| **Criterios de Aceptación** | 1. La búsqueda debe responder en menos de 500 milisegundos.<br>2. La búsqueda por texto debe ignorar mayúsculas, minúsculas y tildes. |

---

### RF10: Filtros del catálogo

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF10.1** Desplegar panel lateral de filtros en el catálogo con múltiples categorías combinables.
2. **RF10.2** Incluir filtro por tipo de vehículo (Sedán, SUV, Hatchback, Camioneta, Eléctrico, Lujo).
3. **RF10.3** Incluir filtro por tipo de transmisión (Automática, Manual).
4. **RF10.4** Incluir filtro por tipo de combustible (Gasolina, Diésel, Híbrido, Eléctrico).
5. **RF10.5** Incluir control deslizante (Slider) de rango de precio por día de alquiler.
6. **RF10.6** Ofrecer botón "Limpiar todos los filtros" para restablecer la búsqueda a su estado inicial.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF10 Filtros del catálogo |
| **Tipo / Actor** | Cliente / Visitante |
| **Ruta / Componente (UI)** | Componente `CatalogSidebarFilters.jsx` en `/catalogo` |
| **Descripción** | Permite afinar la búsqueda de vehículos mediante la aplicación simultánea de múltiples facetas de filtrado técnico y económico. |
| **Entrada** | 1. Checkboxes de categorías, transmisión y combustible.<br>2. Valores mínimo y máximo en el slider de precio. |
| **Salida** | 1. Re-renderizado reactivo del catálogo adaptado a las facetas activas.<br>2. Etiquetas (Badges) indicando los filtros actualmente aplicados. |
| **Acción** | 1. Aplicar lógica de filtrado acumulativo sobre el arreglo de vehículos.<br>2. Actualizar parámetros en la URL para permitir compartir búsquedas filtradas. |
| **Manejo de Situaciones Anormales** | 1. Si la combinación de filtros devuelve 0 vehículos, se ofrece un botón de un solo clic para restablecerlos. |
| **Criterios de Aceptación** | 1. Los filtros deben poder combinarse libremente sin causar errores de lógica.<br>2. La acción de limpiar filtros restablece inmediatamente toda la oferta de la sucursal. |

---

### RF11: Ordenar resultados del catálogo

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF11.1** Incluir menú desplegable de ordenamiento en la parte superior derecha de la lista de vehículos.
2. **RF11.2** Ofrecer las siguientes opciones de ordenamiento: "Precio: Menor a Mayor", "Precio: Mayor a Menor", "Mejor Valorados" y "Más Populares".
3. **RF11.3** Reorganizar instantáneamente las tarjetas del catálogo sin requerir recarga de la página.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF11 Ordenar resultados del catálogo |
| **Tipo / Actor** | Cliente / Visitante |
| **Ruta / Componente (UI)** | Componente `CatalogSortDropdown.jsx` |
| **Descripción** | Permite reorganizar la secuencia de presentación de las tarjetas de vehículos según los criterios de preferencia del usuario. |
| **Entrada** | 1. Selección de un criterio del menú desplegable de ordenamiento. |
| **Salida** | 1. Reordenamiento visual inmediato de la cuadrícula de vehículos. |
| **Acción** | 1. Ejecutar algoritmo de ordenación en memoria o solicitar datos ordenados a la API REST. |
| **Manejo de Situaciones Anormales** | 1. En caso de empate en precios o calificaciones, el sistema aplica un orden secundario por fecha de creación del vehículo. |
| **Criterios de Aceptación** | 1. El cambio de orden se ejecuta en menos de 100 milisegundos.<br>2. Se conserva el criterio de ordenamiento seleccionado al aplicar nuevos filtros. |

---

### RF12: Tarjetas de vehículos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF12.1** Renderizar tarjetas de vehículos (`VehicleCard.jsx`) con diseño visual atractivo y estructurado.
2. **RF12.2** Mostrar imagen principal del vehículo con carrusel o vista previa al pasar el cursor.
3. **RF12.3** Desplegar nombre (Marca y Modelo), año, categoría y sucursal de origen.
4. **RF12.4** Exhibir especificaciones clave: número de pasajeros, tipo de transmisión, equipamiento destacado (Aire Acondicionado, GPS).
5. **RF12.5** Mostrar calificación promedio mediante estrellas e indicador numérico de reseñas.
6. **RF12.6** Destacar el tarifa por día en moneda local (COP) con indicación de impuestos incluidos.
7. **RF12.7** Incluir botón de favorito (ícono de corazón) para guardar el vehículo.
8. **RF12.8** Incluir botón principal "Reservar ahora" para iniciar el proceso de alquiler.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF12 Tarjetas de vehículos |
| **Tipo / Actor** | Cliente / Visitante |
| **Ruta / Componente (UI)** | Componente `VehicleCard.jsx` en catálogo y vistas principales |
| **Descripción** | Unidad visual fundamental de la interfaz que resume los atributos esenciales de cada vehículo para facilitar la toma de decisiones del cliente. |
| **Entrada** | 1. Objeto JSON con los datos del vehículo.<br>2. Clic en la tarjeta, botón de favorito o botón de reserva. |
| **Salida** | 1. Renderizado completo de la tarjeta con imagen, datos y acciones.<br>2. Redirección a la vista de detalle o inicio de flujo de reserva. |
| **Acción** | 1. Cargar imagen desde CDN con fallback de imagen en caso de falla de red.<br>2. Consultar estado de favorito en el estado global. |
| **Manejo de Situaciones Anormales** | 1. Si la imagen no se encuentra disponible, se muestra una imagen placeholder genérica de la marca Drivique. |
| **Criterios de Aceptación** | 1. Toda tarjeta debe exhibir de forma transparente la tarifa diaria y la calificación promedio.<br>2. El botón de favoritos responde al instante alternando el estado visual del corazón. |

---

### RF13: Ver detalles de un vehículo

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF13.1** Renderizar vista detallada del vehículo (`Modal Emergente -> VehicleDetailsModal.jsx`).
2. **RF13.2** Mostrar galería multimedia interactiva con imágenes en alta resolución e inspección a 360° si está disponible.
3. **RF13.3** Desplegar ficha técnica completa: motor, potencia, consumo de combustible, capacidad de maletero y características de seguridad.
4. **RF13.4** Mostrar listado de equipamientos y servicios incluidos sin costo adicional.
5. **RF13.5** Renderizar sección de reseñas de clientes anteriores con fotos reales y calificación por estrellas.
6. **RF13.6** Desplegar tarjeta fija lateral (Sticky Widget) con resumen de precio por día y formulario rápido de selección de fechas para reservar.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF13 Ver detalles de un vehículo |
| **Tipo / Actor** | Cliente / Visitante |
| **Ruta / Componente (UI)** | Ruta `Modal Emergente -> VehicleDetailsModal.jsx` -> `VehicleDetailsModal.jsx`, `ImageGallery.jsx`, `ReviewsSection.jsx` |
| **Descripción** | Proporciona una vista inmersiva y transparente con toda la información técnica, visual y reputacional de un vehículo específico. |
| **Entrada** | 1. Identificador único del vehículo en la URL (`:id`). |
| **Salida** | 1. Carga completa de la galería, especificaciones, términos de alquiler y reseñas verificadas. |
| **Acción** | 1. Consultar endpoint REST `GET /api/v1/vehicles/:id`.<br>2. Cargar listado de reseñas asociadas vía `GET /api/v1/vehicles/:id/reviews`. |
| **Manejo de Situaciones Anormales** | 1. Si el vehículo no existe o fue dado de baja, se muestra una página de error 404 sugerente recomendando vehículos similares. |
| **Criterios de Aceptación** | 1. La galería permite ampliar imágenes en modo pantalla completa.<br>2. Se exhiben las respuestas oficiales de la sucursal ante reseñas de clientes. |

---

### RF14: Menú de navegación principal catálogo

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF14.1** Renderizar barra de navegación superior (Navbar) persistente para el cliente autenticado.
2. **RF14.2** Incluir enlaces de acceso rápido: "Catálogo", "Mis Reservas", "Favoritos", "Notificaciones" y "Soporte".
3. **RF14.3** Mostrar menú desplegable de usuario (Profile Menu) con el nombre, avatar y opción de "Cerrar sesión".
4. **RF14.4** Desplegar indicador numérico (Badge) en la campana de notificaciones con la cantidad de alertas no leídas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF14 Menú de navegación principal catálogo |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `CustomerNavbar.jsx` |
| **Descripción** | Encabezado de control del cliente que centraliza el acceso a todos los módulos funcionales de la cuenta personal. |
| **Entrada** | 1. Clics en las secciones del menú.<br>2. Interacción con el menú desplegable de perfil. |
| **Salida** | 1. Navegación fluida entre pantallas del cliente.<br>2. Despliegue de insignias de notificación en tiempo real. |
| **Acción** | 1. Mantener sincronizado el estado global del usuario y sus notificaciones. |
| **Manejo de Situaciones Anormales** | 1. Si falla la carga de la foto de avatar, se muestran las iniciales del nombre del usuario dentro de un círculo con color corporativo. |
| **Criterios de Aceptación** | 1. El menú debe ser totalmente responsivo, colapsando en un menú lateral de hamburguesa en pantallas móviles. |

---

### RF15: Sección menú Mis Reservas

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF15.1** Renderizar la pantalla "Mis Reservas" (`/mis-reservas`) con el historial completo de alquileres del usuario.
2. **RF15.2** Organizar las reservas en pestañas clasificatorias: "Activas", "Completadas" y "Canceladas".
3. **RF15.3** Mostrar tarjetas resumen de cada reserva con imagen del vehículo, fechas, sucursal, código de reserva y estado actual (ej. *Confirmada*, *Pendiente de Pago*, *En Curso*, *Finalizada*).
4. **RF15.4** Permitir descargar el comprobante de reserva y contrato digital en formato PDF.
5. **RF15.5** Habilitar el botón "Cancelar reserva" para reservas activas que cumplan con la política de cancelación gratuita.
6. **RF15.6** Habilitar el botón "Dejar reseña" con carga de foto para reservas completadas que aún no hayan sido valoradas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF15 Sección menú Mis Reservas |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Ruta `/mis-reservas` -> `MyReservationsPage.jsx`, `ReservationCard.jsx`, `LeaveReviewModal.jsx` |
| **Descripción** | Módulo de gestión personal donde el cliente puede supervisar, administrar, descargar contratos o cancelar sus reservas de vehículos. |
| **Entrada** | 1. Clic en las pestañas de estado.<br>2. Solicitud de descarga de PDF.<br>3. Envío de formulario de cancelación o reseña. |
| **Salida** | 1. Listado ordenado de reservas.<br>2. Descarga de archivo PDF de contrato.<br>3. Registro de calificación con foto en la base de datos. |
| **Acción** | 1. Consultar `GET /api/v1/customer/reservations`.<br>2. Invocar endpoint de cancelación o publicación de reseña con adjuntos. |
| **Manejo de Situaciones Anormales** | 1. Si la reserva ya sobrepasó el límite de cancelación sin penalización, se advierte al usuario sobre el costo asociado antes de proceder. |
| **Criterios de Aceptación** | 1. El cliente puede descargar el PDF de su contrato firmado en cualquier momento.<br>2. Solo se permite publicar una reseña por reserva completada. |

---

### RF16: Sección menú Mis Favoritos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF16.1** Renderizar la pantalla "Mis Favoritos" (`/favoritos`) exhibiendo los vehículos guardados por el cliente.
2. **RF16.2** Permite remover vehículos del listado de favoritos haciendo clic en el ícono de corazón.
3. **RF16.3** Incluir botón directo de reserva en cada tarjeta del listado.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF16 Sección menú Mis Favoritos |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Ruta `/favoritos` -> `FavoritesPage.jsx` |
| **Descripción** | Espacio de lista de deseos donde el cliente conserva los vehículos de su interés para futuras cotizaciones o alquileres. |
| **Entrada** | 1. Interacción con los botones de remover o reservar. |
| **Salida** | 1. Cuadrícula de vehículos guardados.<br>2. Actualización inmediata del contador de favoritos. |
| **Acción** | 1. Sincronizar el arreglo de favoritos con el backend (`POST/DELETE /api/v1/customer/favorites`). |
| **Manejo de Situaciones Anormales** | 1. Si la lista está vacía, se despliega una vista informativa con un botón para explorar el catálogo. |
| **Criterios de Aceptación** | 1. Los favoritos se conservan entre diferentes sesiones del usuario. |

---

### RF17: Sección menú Notificaciones (Cliente)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF17.1** Renderizar el centro de notificaciones personal (`/notificaciones`).
2. **RF17.2** Mostrar alertas en tiempo real sobre confirmaciones de reserva, vencimiento de plazo de pago en efectivo, asignación de PIN de entrega y promociones.
3. **RF17.3** Permitir marcar notificaciones como leídas de forma individual o masiva ("Marcar todas como leídas").

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF17 Sección menú Notificaciones (Cliente) |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Ruta `/notificaciones` -> `CustomerNotificationsPage.jsx` |
| **Descripción** | Canal de mensajería operativa que mantiene al cliente informado sobre el estado de sus transacciones y avisos importantes. |
| **Entrada** | 1. Eventos del sistema (cambios de estado de reserva).<br>2. Acciones del usuario para marcar como leídas. |
| **Salida** | 1. Lista cronológica de notificaciones con marca de tiempo y enlace a la acción relevante. |
| **Acción** | 1. Recepción de eventos vía WebSockets o Server-Sent Events (SSE). |
| **Manejo de Situaciones Anormales** | 1. Si la conexión de tiempo real falla, se aplica un mecanismo de sondeo (`polling`) cada 30 segundos. |
| **Criterios de Aceptación** | 1. Las notificaciones críticas (como código PIN o vencimiento de pago) se destacan con color distintivo. |

---

### RF18: Sección menú Soporte

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF18.1** Renderizar la página del Centro de Soporte (`/soporte`).
2. **RF18.2** Desplegar sección de Preguntas Frecuentes (FAQ) organizadas por categorías acordionadas (Reservas, Pagos, Seguros, Entregas).
3. **RF18.3** Incluir formulario de contacto para enviar solicitudes de ayuda o PQR al equipo de atención.
4. **RF18.4** Mostrar información de contacto directo: líneas de atención 24/7, correo electrónico e integración con WhatsApp Web.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF18 Sección menú Soporte |
| **Tipo / Actor** | Cliente / Visitante |
| **Ruta / Componente (UI)** | Ruta `/soporte` -> `SupportCenterPage.jsx`, `FAQAccordion.jsx`, `ContactForm.jsx` |
| **Descripción** | Portal de asistencia integral diseñado para resolver dudas operativas y ofrecer canales directos de contacto al cliente. |
| **Entrada** | 1. Interacción con acordeones FAQ.<br>2. Llenado del formulario de soporte. |
| **Salida** | 1. Despliegue de respuestas inmediatas.<br>2. Ticket de soporte generado con código de seguimiento enviado al correo. |
| **Acción** | 1. Transmitir el ticket a `POST /api/v1/support/tickets`. |
| **Manejo de Situaciones Anormales** | 1. Si el envío del ticket falla, se despliega el número telefónico directo de urgencias. |
| **Criterios de Aceptación** | 1. El cliente recibe una confirmación automática por correo tras enviar una solicitud de soporte. |

---

# MÓDULO 4: FLUJO MULTIPASOS DE RESERVAS

---

### RF19: Ficha informativa del vehículo a reservar

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF19.1** Mostrar resumen del vehículo seleccionado en la cabecera del flujo de checkout.
2. **RF19.2** Exhibir foto, modelo, tarifa base diaria y sucursal propietaria durante todos los pasos del proceso.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF19 Ficha informativa del vehículo a reservar |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `CheckoutVehicleHeader.jsx` en `/checkout/*` |
| **Descripción** | Componente de contexto visual que garantiza que el usuario mantenga visibilidad constante del vehículo que está en proceso de alquiler. |
| **Entrada** | 1. Datos del vehículo seleccionados desde el catálogo. |
| **Salida** | 1. Renderizado compacto e informativo en la parte superior del flujo de reserva. |
| **Acción** | 1. Mantener hidratado el estado de la reserva en `useReservationStore`. |
| **Manejo de Situaciones Anormales** | 1. Si el vehículo deja de estar disponible mientras el usuario está en el flujo, se emite una alerta bloqueante. |
| **Criterios de Aceptación** | 1. La información se mantiene consistente a lo largo de los 3 pasos del checkout. |

---

### RF20: Selección de fechas y lugar (Paso 1 del Flujo)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF20.1** Renderizar Paso 1 del Checkout (`/checkout/step-1`).
2. **RF20.2** Incluir selectores de fecha y hora de recogida y devolución del vehículo.
3. **RF20.3** Validar que la fecha de recogida sea igual o posterior a la fecha actual y que la fecha de devolución sea posterior a la de recogida (mínimo 24 horas de alquiler).
4. **RF20.4** Seleccionar sucursal de origen y permitir opcionalmente seleccionar una sucursal de devolución diferente (con recargo por devolución en otra ciudad).
5. **RF20.5** Calcular automáticamente el número total de días de alquiler.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF20 Selección de fechas y lugar (Paso 1 del Flujo) |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Ruta `/checkout/step-1` -> `CheckoutStep1DatesPage.jsx` |
| **Descripción** | Definición del periodo y las ubicaciones operativas del alquiler de vehículo. |
| **Entrada** | 1. Fechas y horas de inicio y fin.<br>2. Sucursal de recogida y sucursal de entrega. |
| **Salida** | 1. Verificación de disponibilidad del vehículo para las fechas indicadas.<br>2. Cómputo del subtotal por días de alquiler. |
| **Acción** | 1. Consultar `POST /api/v1/reservations/check-availability`.<br>2. Avanzar al Paso 2 al validar disponibilidad. |
| **Manejo de Situaciones Anormales** | 1. Si el vehículo no está disponible en el rango elegido, la interfaz resalta el calendario en rojo y sugiere fechas alternativas cercanas. |
| **Criterios de Aceptación** | 1. No se permite seleccionar fechas pasadas o rangos menores a 1 día. |

---

### RF21: Resumen de la reserva (Panel Persistente Lateral)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF21.1** Renderizar panel lateral dinámico de resumen financiero (`ReservationSummaryPanel.jsx`).
2. **RF21.2** Desglosar tarifa base por días, cobro de coberturas de seguro, servicios adicionales, impuestos (IVA) y descuentos aplicados.
3. **RF21.3** Incluir campo para ingresar y validar cupones de descuento promocionales.
4. **RF21.4** Actualizar el total general en tiempo real ante cualquier modificación de extras o cupones.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF21 Resumen de la reserva (Panel Persistente Lateral) |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `ReservationSummaryPanel.jsx` en todo el checkout |
| **Descripción** | Calculadora financiera en tiempo real que proporciona transparencia total sobre la liquidación del valor de la reserva. |
| **Entrada** | 1. Modificación de opciones en los pasos 1, 2 o 3.<br>2. Inserción de código de cupón promocional. |
| **Salida** | 1. Desglose detallado de ítems y costo total final a pagar. |
| **Acción** | 1. Aplicar reglas de cálculo de impuestos y descuentos sobre la tarifa. |
| **Manejo de Situaciones Anormales** | 1. Si un cupón expiró o no cumple con el monto mínimo, se muestra la razón exacta de invalidez. |
| **Criterios de Aceptación** | 1. El desglose especifica claramente el valor correspondiente al IVA (19%). |

---

### RF22: Selección de protección del vehículo (Paso 2 - Coberturas)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF22.1** Renderizar la selección de planes de cobertura en el Paso 2 (`/checkout/step-2`).
2. **RF22.2** Ofrecer tres niveles de protección: "Básica" (incluida, con deducible alto), "Intermedia" (cobertura a colisión y robo parcial) y "Total Premium" (cero deducible, daños a terceros y asistencia médica 24/7).
3. **RF22.3** Explicar detalladamente el alcance y valor diario adicional de cada paquete.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF22 Selección de protección del vehículo (Paso 2 - Coberturas) |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `CoverageSelectionGroup.jsx` en `/checkout/step-2` |
| **Descripción** | Permite al cliente elegir el nivel de protección de seguro deseado para mitigar responsabilidades financieras durante el alquiler. |
| **Entrada** | 1. Selección del plan de cobertura (Básica, Intermedia, Premium). |
| **Salida** | 1. Suma del valor diario del seguro seleccionado al total de la reserva. |
| **Acción** | 1. Actualizar el paquete de protección en `useReservationStore`. |
| **Manejo de Situaciones Anormales** | 1. Por norma legal, si se desmarca la protección premium, el sistema exige aceptar la cláusula de deducible básico. |
| **Criterios de Aceptación** | 1. La opción seleccionada resalta visualmente en la pantalla. |

---

### RF23: Tipo de kilometraje y servicios adicionales (Paso 2 - Extras)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF23.1** Ofrecer selección entre Kilometraje Limitado (con costo por km adicional) y Kilometraje Ilimitado.
2. **RF23.2** Desplegar catálogo de adicionales: Silla para bebé, Conductor adicional, GPS satelital, Portaequipajes de techo y Kit de asistencia en carretera.
3. **RF23.3** Permitir seleccionar la cantidad de unidades para adicionales que lo requieran (ej. 2 sillas de bebé).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF23 Tipo de kilometraje y servicios adicionales (Paso 2 - Extras) |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `ExtrasSelectionGroup.jsx` en `/checkout/step-2` |
| **Descripción** | Configuración de servicios complementarios y políticas de recorrido para adaptar el viaje a las necesidades del cliente. |
| **Entrada** | 1. Selección de kilometraje.<br>2. Checkboxes e incrementadores de adicionales. |
| **Salida** | 1. Incorporación de los aditivos a la liquidación financiera. |
| **Acción** | 1. Recomputar el gran total en el panel de resumen. |
| **Manejo de Situaciones Anormales** | 1. Si un adicional no tiene stock disponible en la sucursal, se deshabilita la opción notificando la indisponibilidad. |
| **Criterios de Aceptación** | 1. El cliente puede agregar y remover extras antes de confirmar la reserva. |

---

### RF24: Datos personales (Paso 3 - Formulario)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF24.1** Renderizar formulario de datos del conductor en el Paso 3 (`/checkout/step-3`).
2. **RF24.2** Solicitar nombres, apellidos, tipo y número de documento de identidad, número de teléfono móvil y fecha de nacimiento.
3. **RF24.3** Auto-completar los datos conocidos del perfil del usuario autenticado.
4. **RF24.4** Validar que el conductor tenga la edad mínima legal requerida para alquilar (mínimo 21 años).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF24 Datos personales (Paso 3 - Formulario) |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `DriverDetailsForm.jsx` en `/checkout/step-3` |
| **Descripción** | Captura y verificación de la información personal del titular que conducirá el vehículo. |
| **Entrada** | 1. Datos personales del conductor. |
| **Salida** | 1. Formulario validado listo para la etapa documental. |
| **Acción** | 1. Verificar edad mediante cálculo de fecha de nacimiento. |
| **Manejo de Situaciones Anormales** | 1. Si la fecha de nacimiento indica una edad menor a 21 años, el sistema bloquea el avance con el mensaje "Debe ser mayor de 21 años para alquilar". |
| **Criterios de Aceptación** | 1. Los datos guardados previamente en la cuenta se cargan de forma automática. |

---

### RF25: Verificación documental y confirmación de reserva (Paso 3 - Documentos)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF25.1** Desplegar zona de carga de documentos obligatorios: foto frontal y trasera del Documento de Identidad y de la Licencia de Conducir vigente.
2. **RF25.2** Validar vigencia de la licencia de conducir con respecto a la fecha final del alquiler.
3. **RF25.3** Generar el pre-registro de la reserva en estado "Pendiente de Selección de Pago".
4. **RF25.4** Habilitar la transición hacia la pasarela de pagos virtual o la opción de pago en efectivo.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF25 Verificación documental y confirmación de reserva (Paso 3 - Documentos) |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `DocumentUploadStep.jsx` en `/checkout/step-3` |
| **Descripción** | Verificación reglamentaria de licencias y documentos requeridos por ley para autorizar el alquiler de vehículos. |
| **Entrada** | 1. Archivos de imagen (JPG, PNG) o PDF de documentos de identidad y licencia de conducir. |
| **Salida** | 1. Documentos cargados en el servidor de archivos seguros.<br>2. Creación de la reserva en la base de datos REST. |
| **Acción** | 1. Transmitir archivos a `POST /api/v1/reservations/documents`. |
| **Manejo de Situaciones Anormales** | 1. Si la licencia está vencida, el sistema rechaza el documento solicitando una licencia válida. |
| **Criterios de Aceptación** | 1. Es obligatorio adjuntar licencia y cédula antes de proceder al pago. |

---

# MÓDULO 5: MÉTODOS DE PAGO (PASARELA VIRTUAL WOMPI Y EFECTIVO EN SUCURSAL)

---

### RF26: Pago Virtual con Wompi

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF26.1** Integrar el widget oficial de pagos de Wompi en el flujo de confirmación.
2. **RF26.2** Soporte para pagos con Tarjeta de Crédito (Visa, Mastercard, American Express), Débito PSE y Nequi.
3. **RF26.3** Recibir la respuesta de la pasarela mediante Webhook backend para actualizar el estado de la reserva a "PAGADA y CONFIRMADA".
4. **RF26.4** Redirigir al cliente a la pantalla de éxito con la emisión inmediata del comprobante de reserva.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF26 Pago Virtual con Wompi |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `WompiPaymentWidget.jsx` en `/checkout/payment` |
| **Descripción** | Procesamiento seguro de pagos electrónicos mediante la pasarela certificada Wompi. |
| **Entrada** | 1. Selección de método de pago electrónico.<br>2. Confirmación en pasarela Wompi. |
| **Salida** | 1. Transacción aprobada/rechazada por la entidad bancaria.<br>2. Actualización de estado de la reserva a `PAID`. |
| **Acción** | 1. Generar firma de integridad de la transacción en backend (`SHA-256`).<br>2. Procesar Webhook de confirmación de Wompi. |
| **Manejo de Situaciones Anormales** | 1. Si la transacción es declinada, se notifica el motivo bancario y se permite seleccionar otro medio de pago. |
| **Criterios de Aceptación** | 1. La confirmación de pago actualiza el sistema en menos de 3 segundos vía Webhook. |

---

### RF27: Pago en Efectivo (en Sucursal Autorizada) con Vencimiento Dinámico

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF27.1** Ofrecer la opción "Pago en efectivo en sucursal" durante el checkout.
2. **RF27.2** Asignar automáticamente un plazo límite de pago calculado dinámicamente según la cercanía de la fecha de recogida:
   - Si la reserva es para más de 72 horas después: plazo de pago de 24 horas.
   - Si la reserva es para dentro de las próximas 24 a 72 horas: plazo de pago de 6 horas.
   - Si la reserva es para el mismo día (dentro de las próximas 24 horas): plazo de pago dinámico de 2 horas.
3. **RF27.3** Generar comprobante con código de reserva de pago en efectivo y reloj regresivo visible en el perfil del usuario.
4. **RF27.4** Cancelar automáticamente la reserva y liberar el vehículo en la flota si el plazo expira sin registro de pago por parte del encargado de sucursal.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF27 Pago en Efectivo (en Sucursal Autorizada) con Vencimiento Dinámico |
| **Tipo / Actor** | Cliente Autenticado / Sistema Autómata |
| **Ruta / Componente (UI)** | Componente `CashPaymentOption.jsx`, `ExpirationTimerBadge.jsx` |
| **Descripción** | Permite reservar vehículos pagando en caja física de la sucursal, regulado por un temporizador de vencimiento dinámico para evitar bloqueos prolongados de la flota. |
| **Entrada** | 1. Selección de opción de pago en efectivo. |
| **Salida** | 1. Reserva guardada en estado `PENDING_CASH_PAYMENT` con marca de tiempo `expiration_date`.<br>2. Notificación con el plazo exacto otorgado al cliente. |
| **Acción** | 1. Calcular el límite dinámico en backend.<br>2. Ejecutar tarea programada de auditoría (`cron job`) para cancelar reservas impagas expiradas. |
| **Manejo de Situaciones Anormales** | 1. Si el plazo vence, la reserva pasa a estado `AUTO_CANCELLED` y se notifica al cliente por correo y push notification. |
| **Criterios de Aceptación** | 1. Las reservas no pagadas dentro del tiempo dinámico se cancelan automáticamente liberando el vehículo. |

---

# MÓDULO 6: CONTRATOS DIGITALES Y ENTREGA CON PIN

---

### RF28: Firma de contrato de alquiler y validación de PIN de entrega

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF28.1** Generar automáticamente el contrato digital de alquiler en PDF con la información legal, datos del vehículo, seguro, tarifa y términos de uso.
2. **RF28.2** Requerir la firma digital en pantalla (canvas táctil o con ratón) del cliente previa a la entrega.
3. **RF28.3** Asignar un PIN seguro de entrega Nequi de 4 a 6 dígitos enviado exclusivamente al cliente por SMS y correo.
4. **RF28.4** Exigir al cliente presentar el PIN de entrega al encargado de sucursal en el momento de la recogida física del vehículo.
5. **RF28.5** Validar el PIN en el sistema de la sucursal para autorizar el cambio de estado de la reserva a "EN CURSO" y liberar la entrega del vehículo.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF28 Firma de contrato de alquiler y validación de PIN de entrega |
| **Tipo / Actor** | Cliente Autenticado / Encargado de Sucursal |
| **Ruta / Componente (UI)** | Componente `DigitalSignatureCanvas.jsx`, Modal `DeliveryPinDisplayModal.jsx` |
| **Descripción** | Formalización jurídica del alquiler mediante firma digital y protocolo de seguridad de entrega por PIN único para prevenir suplantaciones. |
| **Entrada** | 1. Trazos de firma digital en canvas.<br>2. Inserción del PIN de entrega por parte del personal de sucursal. |
| **Salida** | 1. Documento PDF firmado legalmente y estampado con sello de tiempo.<br>2. Entrega del vehículo autorizada. |
| **Acción** | 1. Convertir la firma en SVG/PNG e incrustar en el documento PDF en backend.<br>2. Generar el PIN seguro de un solo uso. |
| **Manejo de Situaciones Anormales** | 1. Si el PIN ingresado por la sucursal es erróneo, el sistema niega la entrega y emite una alerta de seguridad al cliente. |
| **Criterios de Aceptación** | 1. No se entrega ningún vehículo sin la validación previa del PIN correcto. |

---

# MÓDULO 7: PERFIL DE USUARIO Y SEGURIDAD

---

### RF29: Ver y editar información personal

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF29.1** Renderizar la pantalla de Perfil de Usuario (`/perfil`).
2. **RF29.2** Mostrar datos personales: foto de perfil, nombres, apellidos, teléfono, correo y dirección de residencia.
3. **RF29.3** Permitir actualizar los campos de teléfono, dirección y foto de perfil mediante carga de archivo de imagen.
4. **RF29.4** Mantener bloqueados los campos de correo y número de documento por requerir validación oficial para cambios.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF29 Ver y editar información personal |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Ruta `/perfil` -> `UserProfilePage.jsx`, `EditProfileForm.jsx` |
| **Descripción** | Permite al usuario consultar y mantener actualizada su información de contacto y personal. |
| **Entrada** | 1. Nuevos datos en los campos editables.<br>2. Nueva imagen para la foto de perfil. |
| **Salida** | 1. Actualización inmediata del perfil en la base de datos y la interfaz de usuario. |
| **Acción** | 1. Enviar datos a `PUT /api/v1/customer/profile`. |
| **Manejo de Situaciones Anormales** | 1. Si la imagen supera los 5MB de tamaño, se notifica el límite de peso permitido. |
| **Criterios de Aceptación** | 1. La foto de perfil se actualiza instantáneamente en el menú superior. |

---

### RF30: Cambiar contraseña

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF30.1** Incluir pestaña de "Seguridad" en la vista de perfil de usuario.
2. **RF30.2** Solicitar contraseña actual, nueva contraseña y confirmación de la nueva contraseña.
3. **RF30.3** Validar que la contraseña actual ingresada coincida con la registrada en la base de datos.
4. **RF30.4** Exigir las reglas de fortaleza para la nueva contraseña.
5. **RF30.5** Guardar la nueva contraseña cifrada y notificar la actualización por correo electrónico.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF30 Cambiar contraseña |
| **Tipo / Actor** | Cliente Autenticado |
| **Ruta / Componente (UI)** | Componente `ChangePasswordTab.jsx` en `/perfil` |
| **Descripción** | Mecanismo de gestión de credenciales que permite al usuario actualizar su clave de acceso por razones de seguridad. |
| **Entrada** | 1. Contraseña actual.<br>2. Nueva contraseña y confirmación. |
| **Salida** | 1. Clave actualizada en la BD.<br>2. Correo de confirmación de cambio de contraseña. |
| **Acción** | 1. Comparar la contraseña actual con el hash BCrypt.<br>2. Cifrar la nueva contraseña y guardarla. |
| **Manejo de Situaciones Anormales** | 1. Si la contraseña actual no es correcta, se muestra el mensaje "La contraseña actual es incorrecta". |
| **Criterios de Aceptación** | 1. No se permite usar como nueva clave la misma contraseña que está actualmente activa. |

---

### RF31: Cerrar sesión

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF31.1** Incluir la opción "Cerrar sesión" en el menú desplegable del usuario.
2. **RF31.2** Eliminar el token JWT y los datos de perfil almacenados en el cliente (`localStorage`, `sessionStorage`, cookies).
3. **RF31.3** Invalidador del token en el backend si se utiliza lista negra de tokens (`token blacklist`).
4. **RF31.4** Redirigir al usuario a la Landing Page pública (`/`).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF31 Cerrar sesión |
| **Tipo / Actor** | Cliente / Administrador Autenticado |
| **Ruta / Componente (UI)** | Menú de Usuario -> `useAuthStore.js` |
| **Descripción** | Finalización segura de la sesión de usuario activa destruyendo las credenciales locales de la aplicación. |
| **Entrada** | 1. Clic en "Cerrar sesión". |
| **Salida** | 1. Eliminación del token JWT.<br>2. Redirección inmediata a la ruta raíz pública (`/`). |
| **Acción** | 1. Ejecutar la función `logout()` del estado global. |
| **Manejo de Situaciones Anormales** | 1. Incluso si la red falla, la eliminación de credenciales locales se completa de forma incondicional. |
| **Criterios de Aceptación** | 1. Tras cerrar sesión, accionar el botón "Atrás" del navegador no debe mostrar contenido privado. |

---

# MÓDULO 8: COMPONENTES TRANSVERSALES DEL CLIENTE

---

### RF32: Onboarding para nuevos usuarios

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF32.1** Desplegar modal interactivo de bienvenida (Onboarding) tras el primer inicio de sesión de un usuario recién registrado.
2. **RF32.2** Presentar recorrido guiado de 3 diapositivas ilustradas: "Cómo buscar un vehículo", "Entender las coberturas" y "Proceso de entrega con PIN".
3. **RF32.3** Incluir botón "Omitir" para cerrar el tutorial en cualquier momento y checkbox "No volver a mostrar".

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF32 Onboarding para nuevos usuarios |
| **Tipo / Actor** | Cliente Nuevo |
| **Ruta / Componente (UI)** | Componente `WelcomeOnboardingModal.jsx` |
| **Descripción** | Tutorial inicial de bienvenida que instruye a los usuarios nuevos en el uso óptimo de la plataforma Drivique. |
| **Entrada** | 1. Primer login detectado (`is_first_login = true`). |
| **Salida** | 1. Despliegue del modal de guía.<br>2. Marca de onboarding completado guardada en la cuenta. |
| **Acción** | 1. Consultar la propiedad de primer login del usuario. |
| **Manejo de Situaciones Anormales** | 1. Si el usuario cierra el modal abruptamente, el estado se guarda como visto para no saturar la navegación. |
| **Criterios de Aceptación** | 1. El onboarding solo se muestra una vez por usuario. |

---

### RF33: Chat flotante de soporte (Widget Tawk.to)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF33.1** Inyectar el widget de chat flotante de soporte en tiempo real (Tawk.to / LiveChat) en la esquina inferior derecha de la interfaz cliente.
2. **RF33.2** Inicializar el chat identificando automáticamente al usuario autenticado (nombre y correo).
3. **RF33.3** Permitir el intercambio de mensajes de texto y envío de capturas de pantalla con los agentes de atención al cliente.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF33 Chat flotante de soporte (Widget Tawk.to) |
| **Tipo / Actor** | Cliente / Visitante |
| **Ruta / Componente (UI)** | Componente `LiveChatWidget.jsx` |
| **Descripción** | Canal de atención personalizada por chat que permite a los clientes solicitar asistencia en vivo durante la navegación o el proceso de reserva. |
| **Entrada** | 1. Clic en la burbuja del chat flotante.<br>2. Mensajes digitados por el usuario. |
| **Salida** | 1. Apertura de la consola de chat en vivo.<br>2. Respuestas inmediatas de agentes de soporte Drivique. |
| **Acción** | 1. Cargar script asíncrono de Tawk.to.<br>2. Setear atributos de usuario mediante API de Tawk.to (`Tawk_API.setAttributes`). |
| **Manejo de Situaciones Anormales** | 1. Si no hay agentes disponibles, el widget cambia a modo "Dejar mensaje" para enviar un correo de soporte. |
| **Criterios de Aceptación** | 1. El widget no interfiere visualmente con los botones de checkout ni formularios. |

---

# MÓDULO 9: PANEL ADMINISTRATIVO Y GESTIÓN OPERATIVA DE SUCURSAL

---

### RF34: Dashboard del administrador y sucursal

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF34.1** Renderizar el panel de control principal (`/admin` para Super Admin, `/encargado` para Sucursal).
2. **RF34.2** Desplegar métricas clave (KPIs) en tiempo real: número total de reservas activas, ingresos acumulados del mes, porcentaje de ocupación de la flota, vehículos en mantenimiento y alertas pendientes.
3. **RF34.3** Mostrar gráficos interactivos de tendencias de ingresos por mes y alquileres por categoría de vehículo.
4. **RF34.4** Incluir tabla con los accesos directos a las últimas reservas realizadas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF34 Dashboard del administrador y sucursal |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Ruta / Componente (UI)** | Rutas `/admin` y `/encargado` -> `AdminDashboardPage.jsx`, `KPICardGroup.jsx`, `RevenueChart.jsx` |
| **Descripción** | Centro de mando gerencial y operativo que presenta resúmenes estadísticos e indicadores de rendimiento de Drivique. |
| **Entrada** | 1. Carga de la ruta del dashboard. |
| **Salida** | 1. Renderizado de tarjetas KPI, gráficos estadísticos y tablas de actividad reciente. |
| **Acción** | 1. Consultar `GET /api/v1/admin/dashboard-stats`. |
| **Manejo de Situaciones Anormales** | 1. Si la carga de gráficos falla, las tarjetas numéricas siguen funcionando de forma independiente. |
| **Criterios de Aceptación** | 1. Las cifras presentadas coinciden exactamente con los registros contables de la base de datos. |

---

### RF35: Gestión de ciudades

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF35.1** Renderizar la pantalla de administración de ciudades (`/admin/ciudades`).
2. **RF35.2** Permitir listar, crear, editar y desactivar ciudades donde opera Drivique.
3. **RF35.3** Capturar nombre de la ciudad, departamento, código postal y estado operativo (Activa/Inactiva).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF35 Gestión de ciudades |
| **Tipo / Actor** | Super Administrador |
| **Ruta / Componente (UI)** | Ruta `/admin/ciudades` -> `ManageCitiesPage.jsx`, `CityModal.jsx` |
| **Descripción** | Módulo para la configuración de la cobertura geográfica de la plataforma Drivique. |
| **Entrada** | 1. Formulario de datos de la ciudad. |
| **Salida** | 1. Lista de ciudades actualizada.<br>2. Habilitación de la ciudad en los filtros del catálogo de clientes. |
| **Acción** | 1. Transmitir a `POST/PUT /api/v1/admin/cities`. |
| **Manejo de Situaciones Anormales** | 1. No se permite desactivar una ciudad que tenga sucursales con reservas activas en curso. |
| **Criterios de Aceptación** | 1. La desactivación de una ciudad oculta automáticamente sus sucursales en el catálogo. |

---

### RF36: Gestión de Sucursales

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF36.1** Renderizar la vista de gestión de sucursales (`/admin/sucursales`).
2. **RF36.2** Permite crear, modificar y deshabilitar sucursales físicas.
3. **RF36.3** Capturar nombre de sucursal, ciudad asociada, dirección exacta, coordenadas de mapa (latitud/longitud), teléfono, correo y horarios de atención.
4. **RF36.4** Asignar el Encargado de Sucursal responsable de la sede.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF36 Gestión de Sucursales |
| **Tipo / Actor** | Super Administrador |
| **Ruta / Componente (UI)** | Ruta `/admin/sucursales` -> `ManageBranchesPage.jsx`, `BranchFormModal.jsx` |
| **Descripción** | Administración de las sedes operativas físicas donde se realiza la entrega y recepción de la flota de vehículos. |
| **Entrada** | 1. Información técnica de la sede y asignación de personal. |
| **Salida** | 1. Sucursal registrada e integrada en los mapas y buscadores de la app. |
| **Acción** | 1. Enviar datos a `POST/PUT /api/v1/admin/branches`. |
| **Manejo de Situaciones Anormales** | 1. Si se intenta borrar una sucursal con vehículos asignados, se exige primero reasignar la flota a otra sede. |
| **Criterios de Aceptación** | 1. La ubicación ingresada debe ser geolocalizada correctamente en el mapa de sucursales. |

---

### RF37: Gestión de vehículos (Flota)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF37.1** Renderizar la pantalla de gestión de flota (`/admin/vehiculos` / `/encargado/vehiculos`).
2. **RF37.2** Permitir registrar nuevos vehículos, editar especificaciones, actualizar tarifas por día y gestionar imágenes de la galería.
3. **RF37.3** Capturar placa, marca, modelo, año, categoría, color, tipo de transmisión, combustible, capacidad, kilometraje actual, sucursal asignada y precio por día.
4. **RF37.4** Administrar los estados del vehículo: *Disponible*, *Reservado*, *En Mantenimiento*, *Fuera de Servicio*.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF37 Gestión de vehículos (Flota) |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/admin/vehiculos` -> `ManageFleetPage.jsx`, `VehicleFormModal.jsx` |
| **Descripción** | Control integral de la flota vehicular de Drivique, incluyendo altas, bajas, fotos, precios y estados operativos. |
| **Entrada** | 1. Ficha técnica del vehículo y archivos de fotos en alta resolución. |
| **Salida** | 1. Vehículo creado o actualizado en el catálogo global de la plataforma. |
| **Acción** | 1. Transmitir datos multipart a `POST/PUT /api/v1/admin/vehicles`. |
| **Manejo de Situaciones Anormales** | 1. Si la placa ya está registrada, la API devuelve error impidiendo duplicados en la flota. |
| **Criterios de Aceptación** | 1. Todo vehículo disponible debe contar con al menos 3 imágenes y tarifa diaria válida. |

---

### RF38: Gestión de reservas

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF38.1** Renderizar el panel operativo de gestión de reservas (`/admin/reservas` / `/encargado/reservas`).
2. **RF38.2** Visualizar la totalidad de las reservas con filtros por estado, rango de fechas, sucursal, código o documento del cliente.
3. **RF38.3** Permite consultar el expediente completo de cada reserva: datos del cliente, vehículo, contrato PDF, pagos realizados y PIN de entrega.
4. **RF38.4** Permitir modificar estados de reserva, procesar devoluciones o autorizar cancelaciones administrativas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF38 Gestión de reservas |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/admin/reservas` -> `ManageReservationsPage.jsx`, `ReservationDetailModal.jsx` |
| **Descripción** | Consola de supervisión y gestión operativa del ciclo de vida de todas las reservas registradas en el sistema. |
| **Entrada** | 1. Parámetros de búsqueda o acciones de actualización de estado. |
| **Salida** | 1. Modificación del expediente de reserva y notificación automática al cliente. |
| **Acción** | 1. Transmitir a `PUT /api/v1/admin/reservations/:id/status`. |
| **Manejo de Situaciones Anormales** | 1. Toda modificación manual de estado por un administrador debe registrar la razón justificada en el log de auditoría. |
| **Criterios de Aceptación** | 1. Las búsquedas de reservas se ejecutan en tiempo real sobre la base de datos central. |

---

### RF39: Gestión de usuarios y clientes

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF39.1** Renderizar la lista de clientes registrados (`/admin/usuarios`).
2. **RF39.2** Permite buscar usuarios por correo, nombre o documento de identidad.
3. **RF39.3** Visualizar el historial de reservas de un cliente, estado de cuenta y documentos adjuntos.
4. **RF39.4** Permitir bloquear o deshabilitar cuentas de usuarios por incumplimiento de términos o fraude.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF39 Gestión de usuarios y clientes |
| **Tipo / Actor** | Super Administrador |
| **Ruta / Componente (UI)** | Ruta `/admin/usuarios` -> `ManageUsersPage.jsx`, `UserProfileDetailModal.jsx` |
| **Descripción** | Módulo de administración de la base de usuarios y clientes de la plataforma Drivique. |
| **Entrada** | 1. Filtros de búsqueda o cambios de estado en la cuenta de usuario. |
| **Salida** | 1. Bloqueo/desbloqueo de accesos de clientes. |
| **Acción** | 1. Enviar petición a `PUT /api/v1/admin/users/:id/block`. |
| **Manejo de Situaciones Anormales** | 1. Al bloquear un usuario, sus reservas activas futuras se cancelan automáticamente. |
| **Criterios de Aceptación** | 1. La desactivación de una cuenta impide el login inmediato del usuario. |

---

### RF40: Gestión de administradores, roles y permisos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF40.1** Renderizar la pantalla de gestión de administradores y seguridad (`/admin/roles`).
2. **RF40.2** Permite dar de alta a nuevos Super Administradores y Encargados de Sucursal.
3. **RF40.3** Configurar la matriz de permisos por rol asignando accesos específicos a módulos del sistema.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF40 Gestión de administradores, roles y permisos |
| **Tipo / Actor** | Super Administrador |
| **Ruta / Componente (UI)** | Ruta `/admin/roles` -> `ManageRolesPage.jsx`, `AdminUserModal.jsx` |
| **Descripción** | Control centralizado del acceso basado en roles (RBAC) para el personal operativo de Drivique. |
| **Entrada** | 1. Registro de personal administrativo y selección de permisos. |
| **Salida** | 1. Asignación de credenciales administrativas y roles en el sistema. |
| **Acción** | 1. Transmitir datos a `POST /api/v1/admin/staff`. |
| **Manejo de Situaciones Anormales** | 1. Un administrador no puede eliminarse a sí mismo ni revocar su propio rol de Super Administrador. |
| **Criterios de Aceptación** | 1. Los cambios en los permisos tienen efecto inmediato en la siguiente petición del usuario afectado. |

---

### RF41: Gestión de reportes de incidencias de vehículos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF41.1** Renderizar la consola de gestión de incidencias (`/admin/incidencias` / `/encargado/incidencias`).
2. **RF41.2** Permite registrar reportes de fallas mecánicas, accidentes, rayones o siniestros sufridos por la flota.
3. **RF41.3** Capturar descripción de la incidencia, fotos del daño, vehículo afectado, costo estimado de reparación y estado del reporte (*En Revisión*, *En Taller*, *Resuelto*).
4. **RF41.4** Cambiar automáticamente el estado del vehículo a "En Mantenimiento" si la incidencia invalida su uso.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF41 Gestión de reportes de incidencias de vehículos |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/admin/incidencias` -> `ManageIncidentsPage.jsx`, `IncidentReportModal.jsx` |
| **Descripción** | Módulo para el control de averías, siniestros y mantenimientos correctivos de la flota vehicular. |
| **Entrada** | 1. Reporte de avería con fotos y detalles técnicos. |
| **Salida** | 1. Registro de la incidencia y actualización del estado del vehículo a `MAINTENANCE`. |
| **Acción** | 1. Transmitir el informe a `POST /api/v1/incidents`. |
| **Manejo de Situaciones Anormales** | 1. Si el vehículo reportado tiene una reserva próxima en las siguientes 24 horas, el sistema alerta de inmediato para reasignar otro vehículo al cliente. |
| **Criterios de Aceptación** | 1. Todo reporte exige adjuntar soporte fotográfico del daño. |

---

### RF42: Gestión de contratos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF42.1** Renderizar la plantilla y repositorio de contratos de alquiler (`/admin/contratos`).
2. **RF42.2** Permite visualizar, buscar y volver a descargar todos los contratos digitales firmados por los clientes.
3. **RF42.3** Permite a los administradores actualizar las cláusulas legales y términos del contrato base de Drivique.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF42 Gestión de contratos |
| **Tipo / Actor** | Super Administrador |
| **Ruta / Componente (UI)** | Ruta `/admin/contratos` -> `ManageContractsPage.jsx` |
| **Descripción** | Custodia y administración de los documentos legales de alquiler generados por la plataforma. |
| **Entrada** | 1. Búsqueda de contratos por folio o actualización de plantilla legal. |
| **Salida** | 1. Repositorio de PDFs descargables y actualización de versión de contrato legal. |
| **Acción** | 1. Consultar `GET /api/v1/admin/contracts`. |
| **Manejo de Situaciones Anormales** | 1. Los contratos previamente firmados por clientes mantienen de forma inmutable la versión de cláusulas vigente al momento de su firma. |
| **Criterios de Aceptación** | 1. Los contratos se almacenan cifrados con sello de integridad temporal. |

---

### RF43: Gestión de promociones y cupones

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF43.1** Renderizar el panel de marketing y promociones (`/admin/promociones`).
2. **RF43.2** Permite crear cupones de descuento (porcentaje o monto fijo en COP).
3. **RF43.3** Definir código de cupón, fecha de inicio, fecha de vencimiento, límite de usos totales, límite de usos por usuario y monto mínimo de reserva requerido.
4. **RF43.4** Gestionar la sección de "Promociones destacadas" expuestas en la Landing Page y el catálogo.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF43 Gestión de promociones y cupones |
| **Tipo / Actor** | Super Administrador |
| **Ruta / Componente (UI)** | Ruta `/admin/promociones` -> `ManagePromotionsPage.jsx`, `CouponFormModal.jsx` |
| **Descripción** | Creación y administración de incentivos comerciales y cupones de descuento para fidelización de clientes. |
| **Entrada** | 1. Reglas de cupón promocional (código, descuento, vigencia). |
| **Salida** | 1. Cupón activo en el motor de cálculo de precios del checkout. |
| **Acción** | 1. Transmitir a `POST /api/v1/admin/coupons`. |
| **Manejo de Situaciones Anormales** | 1. No se permite crear dos cupones activos con el mismo código promocional. |
| **Criterios de Aceptación** | 1. Los cupones caducan automáticamente al alcanzar la fecha fin o el límite de usos. |

---

### RF44: Reportes administrativos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF44.1** Renderizar el centro de analítica y reportes (`/admin/reportes`).
2. **RF44.2** Permitir generar reportes consolidados de ingresos financieros, utilización de flota, efectividad de sucursales e historial de alquileres.
3. **RF44.3** Ofrecer filtros por rango de fechas personalizable y exportación de informes en formatos Excel (XLSX), CSV y PDF.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF44 Reportes administrativos |
| **Tipo / Actor** | Super Administrador |
| **Ruta / Componente (UI)** | Ruta `/admin/reportes` -> `ReportsPage.jsx`, `ReportExportWidget.jsx` |
| **Descripción** | Generación de informes financieros y operativos para la toma de decisiones estratégicas. |
| **Entrada** | 1. Tipo de reporte deseado y rango de fechas. |
| **Salida** | 1. Archivo descargable en formato Excel, CSV o PDF. |
| **Acción** | 1. Compilar datos relacionales y generar binario de reporte en backend. |
| **Manejo de Situaciones Anormales** | 1. Si la consulta de reporte abarca un periodo mayor a 1 año, el sistema encola la tarea y la envía al correo del administrador. |
| **Criterios de Aceptación** | 1. Los reportes financieros incluyen la discriminación exacta de impuestos e ingresos netos. |

---

### RF45: Configuración de marca e identidad visual

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF45.1** Renderizar el panel de personalización de marca (`/admin/configuracion`).
2. **RF45.2** Permitir actualizar el logo corporativo de Drivique, favicon, paleta de colores primarios y secundarios del sistema visual.
3. **RF45.3** Configurar datos de contacto globales, enlaces de redes sociales y texto de la propuesta de valor.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF45 Configuración de marca e identidad visual |
| **Tipo / Actor** | Super Administrador |
| **Ruta / Componente (UI)** | Ruta `/admin/configuracion` -> `BrandSettingsPage.jsx` |
| **Descripción** | Administración de los assets gráficos y parámetros de identidad de marca de la plataforma. |
| **Entrada** | 1. Archivos de logo, favicon y valores de color en hexadecimal. |
| **Salida** | 1. Actualización de la apariencia visual de la plataforma cliente y correos. |
| **Acción** | 1. Actualizar las variables globales de configuración en la BD. |
| **Manejo de Situaciones Anormales** | 1. El sistema conserva una copia de respaldo de la marca por defecto para restaurarla en caso de error. |
| **Criterios de Aceptación** | 1. Los cambios de logo se reflejan inmediatamente en el encabezado y pie de página. |

---

### RF46: Auditoría y registro de actividad

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF46.1** Renderizar la consola de auditoría de seguridad (`/admin/auditoria`).
2. **RF46.2** Registrar de forma inmutable todas las operaciones críticas realizadas en el sistema (inicios de sesión, cambios de precio, cancelaciones de reserva, modificaciones de roles, pagos aprobados).
3. **RF46.3** Grabar marca de tiempo exacto, dirección IP origen, usuario ejecutor, módulo afectado y detalle del cambio (valor anterior vs valor nuevo).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF46 Auditoría y registro de actividad |
| **Tipo / Actor** | Super Administrador / Auditor de Sistema |
| **Ruta / Componente (UI)** | Ruta `/admin/auditoria` -> `AuditLogsPage.jsx` |
| **Descripción** | Bitácora inalterable de eventos de seguridad y transacciones operativas para trazabilidad y cumplimiento legal. |
| **Entrada** | 1. Eventos del sistema registrados automáticamente. |
| **Salida** | 1. Tabla de logs con filtros por usuario, fecha o tipo de acción. |
| **Acción** | 1. Grabar registros en la tabla de auditoría en la base de datos sin permisos de modificación ni borrado. |
| **Manejo de Situaciones Anormales** | 1. Los registros de auditoría no pueden ser eliminados por ningún usuario del sistema, ni siquiera por el Super Administrador. |
| **Criterios de Aceptación** | 1. Cada transacción deja una huella digital no repudiable en la bitácora de auditoría. |

---

### RF47: Confirmación de pago en efectivo (sucursal)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF47.1** Renderizar el módulo de caja para el Encargado de Sucursal (`/encargado/caja`).
2. **RF47.2** Permitir al encargado buscar reservas en estado "Pendiente de Pago en Efectivo" por código de reserva o cédula del cliente.
3. **RF47.3** Registrar la recepción del dinero en efectivo en la caja de la sucursal.
4. **RF47.4** Cambiar el estado de la reserva a "PAGADA y CONFIRMADA", cancelando el temporizador de vencimiento dinámico y emitiendo el recibo de caja digital.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF47 Confirmación de pago en efectivo (sucursal) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/encargado/caja` -> `BranchCashierPage.jsx`, `CashPaymentReceiptModal.jsx` |
| **Descripción** | Registro en caja física de la recepción de dinero en efectivo para reservas con vencimiento dinámico. |
| **Entrada** | 1. Código de reserva o cédula del cliente.<br>2. Confirmación de recepción de dinero en efectivo. |
| **Salida** | 1. Reserva actualizada a `PAID`.<br>2. Recibo de caja emitido y enviado por correo al cliente. |
| **Acción** | 1. Transmitir a `POST /api/v1/branch/cash-payments/confirm`. |
| **Manejo de Situaciones Anormales** | 1. Si la reserva ya había sido cancelada automáticamente por vencimiento, el sistema advierte que el plazo caducó y exige reactivar la reserva si hay flota disponible. |
| **Criterios de Aceptación** | 1. La confirmación del pago en caja desactiva de inmediato el contador regresivo de expiración. |

---

### RF48: Centro de notificaciones operativas de sucursal (`BranchNotificationCenterPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF48.1** Renderizar la pantalla de notificaciones de la sucursal (`/encargado/notificaciones`).
2. **RF48.2** Mostrar alertas en tiempo real sobre nuevas reservas asignadas a la sede, devoluciones del día, vencimientos próximos de pagos en efectivo y reportes de averías.
3. **RF48.3** Filtrar alertas por nivel de urgencia (*Alta*, *Media*, *Informativa*).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF48 Centro de notificaciones operativas de sucursal (`BranchNotificationCenterPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/encargado/notificaciones` -> `BranchNotificationCenterPage.jsx` |
| **Descripción** | Tablero de alertas operativas para el personal de sucursal enfocado en las tareas diarias de entregas y recepciones. |
| **Entrada** | 1. Flujo de eventos operativos de la sucursal. |
| **Salida** | 1. Alertas visuales y sonoras en tiempo real para el encargado de la sede. |
| **Acción** | 1. Conexión a canal WebSocket de la sucursal. |
| **Manejo de Situaciones Anormales** | 1. Las notificaciones de devoluciones atrasadas se marcan en rojo persistente con sonido de alerta. |
| **Criterios de Aceptación** | 1. El encargado recibe la alerta de una nueva reserva en menos de 1 segundo tras ser creada. |

---

### RF49: Moderación y respuesta a reseñas de sucursal (`BranchReviewsPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF49.1** Renderizar el panel de calificaciones y comentarios de la sucursal (`/encargado/resenas`).
2. **RF49.2** Mostrar el listado de reseñas enviadas por los clientes que alquilaron vehículos en dicha sede, exhibiendo fotos adjuntas y puntuaciones.
3. **RF49.3** Permitir al Encargado de Sucursal emitir una respuesta oficial inmutable que se publicará debajo de la reseña del cliente en el catálogo público.
4. **RF49.4** Reportar al Super Administrador reseñas con lenguaje ofensivo para su moderación.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF49 Moderación y respuesta a reseñas de sucursal (`BranchReviewsPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/encargado/resenas` -> `BranchReviewsPage.jsx`, `OfficialResponseModal.jsx` |
| **Descripción** | Gestión de reputación donde la sucursal interactúa respondiendo a los comentarios y opiniones de los clientes. |
| **Entrada** | 1. Formulario de respuesta oficial de la sucursal. |
| **Salida** | 1. Publicación de la respuesta oficial en la ficha del vehículo y catálogo público. |
| **Acción** | 1. Transmitir a `POST /api/v1/branch/reviews/:id/reply`. |
| **Manejo de Situaciones Anormales** | 1. Una respuesta de sucursal no puede ser editada ni borrada tras ser publicada para garantizar transparencia. |
| **Criterios de Aceptación** | 1. La respuesta oficial se vincula de forma inmutable con la reseña original del cliente. |

---

### RF50: Inspección y entrega del vehículo (`DeliveryManagementPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF50.1** Renderizar el módulo de entrega de vehículos (`/encargado/entregas`).
2. **RF50.2** Desplegar la lista de entregas programadas para el día actual.
3. **RF50.3** Incluir formulario de acta de inspección inicial: nivel de combustible, kilometraje de salida, estado de llantas, kit de carretera y marcado visual de rayones previos en diagrama 3D/2D del auto.
4. **RF50.4** Capturar fotografías en tiempo real del estado de entrega del vehículo.
5. **RF50.5** Validar el PIN de entrega del cliente para formalizar el traspaso del vehículo.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF50 Inspección y entrega del vehículo (`DeliveryManagementPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/encargado/entregas` -> `DeliveryManagementPage.jsx`, `InspectionChecklist.jsx` |
| **Descripción** | Protocolo de entrega del vehículo que documenta rigurosamente su estado físico y mecánico antes de salir de la sede. |
| **Entrada** | 1. Datos de kilometraje, combustible, fotos de inspección y PIN de entrega. |
| **Salida** | 1. Acta de entrega firmada digitalmente y cambio de estado a `IN_PROGRESS`. |
| **Acción** | 1. Enviar checklist y fotos a `POST /api/v1/branch/deliveries/complete`. |
| **Manejo de Situaciones Anormales** | 1. Si el vehículo presenta una falla durante la inspección previa a la entrega, el sistema exige reasignar otra unidad de la flota. |
| **Criterios de Aceptación** | 1. El proceso requiere obligatoriamente tomar al menos 4 fotos de inspección de los 4 costados del vehículo. |

---

### RF51: Perfil Público y Operativo de Sucursal (`BranchProfilePage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF51.1** Renderizar la pantalla de perfil operativo de la sucursal (`/encargado/perfil-sucursal`).
2. **RF51.2** Permitir al encargado actualizar la información operativa de la sede: teléfonos de atención inmediata, fotos del local, instructivo de llegada y avisos a los clientes.
3. **RF51.3** Consultar el mapa de cobertura y el resumen de flota asignada a la sede.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF51 Perfil Público y Operativo de Sucursal (`BranchProfilePage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/encargado/perfil-sucursal` -> `BranchProfilePage.jsx` |
| **Descripción** | Configuración de la ficha informativa de la sucursal que se muestra a los clientes durante el proceso de reserva. |
| **Entrada** | 1. Datos de contacto, fotos de la fachada de la sucursal e instrucciones de entrega. |
| **Salida** | 1. Perfil de sucursal actualizado en la vista de cliente. |
| **Acción** | 1. Transmitir a `PUT /api/v1/branch/profile`. |
| **Manejo de Situaciones Anormales** | 1. Los cambios de ubicación geográfica o dirección física requieren la aprobación final del Super Administrador. |
| **Criterios de Aceptación** | 1. Las fotos de la sucursal se actualizan de forma inmediata en las guías de llegada del cliente. |

---

### RF52: Validación de Entrega con PIN Nequi (`BranchPinValidationModal`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF52.1** Renderizar modal de verificación de PIN en la consola de la sucursal (`BranchPinValidationModal.jsx`).
2. **RF52.2** Solicitar la digitación del PIN seguro de entrega presentado por el cliente en su teléfono móvil.
3. **RF52.3** Validar el PIN contra la base de datos central encriptada.
4. **RF52.4** Desbloquear la autorización de entrega del vehículo tras coincidencia exitosa del PIN.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF52 Validación de Entrega con PIN Nequi (`BranchPinValidationModal`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Ruta / Componente (UI)** | Modal `BranchPinValidationModal.jsx` en la vista de entregas |
| **Descripción** | Componente de seguridad que actúa como cerradura digital para autorizar la liberación física de las llaves del vehículo. |
| **Entrada** | 1. PIN de 4 a 6 dígitos ingresado en el teclado numérico del modal. |
| **Salida** | 1. Autorización concedida o rechazada de entrega. |
| **Acción** | 1. Validar el PIN seguro en `POST /api/v1/branch/validate-pin`. |
| **Manejo de Situaciones Anormales** | 1. Ante 3 intentos fallidos de PIN, la reserva se bloquea preventivamente notificando al cliente por seguridad. |
| **Criterios de Aceptación** | 1. La respuesta de validación del PIN debe ejecutarse en menos de 300 milisegundos. |

---

### RF53: Formulario de Inspección de Devolución (`ReturnInspectionPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF53.1** Renderizar el módulo de recepción de vehículos (`/encargado/devoluciones`).
2. **RF53.2** Registrar el recibo del vehículo comprobando: fecha y hora de entrega real, kilometraje final, nivel de combustible de retorno y limpiezas.
3. **RF53.3** Comparar el estado de devolución contra la inspección inicial (RF50) para detectar nuevos daños, rayones o faltantes.
4. **RF53.4** Calcular automáticamente cargos adicionales en caso de excedente de kilometraje, falta de combustible, entregas tardías o daños.
5. **RF53.5** Emitir el paz y salvo de devolución al cliente y cambiar el estado del vehículo a "Disponible".

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF53 Formulario de Inspección de Devolución (`ReturnInspectionPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/encargado/devoluciones` -> `ReturnInspectionPage.jsx`, `ReturnChecklist.jsx` |
| **Descripción** | Recepción oficial del vehículo alquilado, evaluación de estado de retorno y liquidación de posibles penalizaciones o cargos extra. |
| **Entrada** | 1. Datos de recepción: kilometraje, combustible, fotos de retorno y registro de novedades. |
| **Salida** | 1. Cierre definitivo de la reserva (`COMPLETED`), paz y salvo al cliente y retorno del auto a disponibilidad. |
| **Acción** | 1. Transmitir formulario a `POST /api/v1/branch/returns/complete`. |
| **Manejo de Situaciones Anormales** | 1. Si se detectan daños no reportados en la entrega inicial, se abre automáticamente un reporte de incidencia (RF41) vinculado a la reserva. |
| **Criterios de Aceptación** | 1. La liquidación de sobrantes o cobros por faltantes de combustible se calcula automáticamente según las tarifas estándar de Drivique. |

---

### RF54: Gestión de Cupones Promocionales por Sucursal (`BranchCouponsPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF54.1** Renderizar la pantalla de cupones específicos de la sucursal (`/encargado/cupones`).
2. **RF54.2** Permitir al Encargado de Sucursal gestionar y activar promociones locales exclusivas para la flota asignada a su sede.
3. **RF54.3** Monitorear el nivel de redención de cupones locales y su impacto en las reservas de la sucursal.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF54 Gestión de Cupones Promocionales por Sucursal (`BranchCouponsPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Ruta / Componente (UI)** | Ruta `/encargado/cupones` -> `BranchCouponsPage.jsx` |
| **Descripción** | Herramienta de gestión comercial descentralizada para impulsar la demanda local en sucursales específicas. |
| **Entrada** | 1. Parámetros de cupones locales para la flota de la sede. |
| **Salida** | 1. Cupones locales activos aplicables por los clientes que reserven en dicha sucursal. |
| **Acción** | 1. Enviar datos a `POST /api/v1/branch/coupons`. |
| **Manejo de Situaciones Anormales** | 1. Los cupones locales creados por una sucursal no pueden exceder los límites de descuento máximo autorizados por el Super Administrador. |
| **Criterios de Aceptación** | 1. El descuento local solo se aplica si la reserva se realiza para vehículos pertenecientes a la sucursal emisora. |

---

## 📊 TABLA RESUMEN CONSOLIDADORA DE REQUERIMIENTOS FUNCIONALES (RF1 AL RF54)

| ID | Nombre del Requerimiento | Módulo | Ámbito / Rol | Componente / Ruta Principal |
| :--- | :--- | :--- | :--- | :--- |
| **RF1** | Página de inicio (visitante sin sesión) | Landing Page | Visitante | `/` -> `LandingPage.jsx` |
| **RF2** | Redirección tras inicio de sesión | Landing Page | Cliente/Admin/Encargado | `ProtectedRoute.jsx`, `useAuthStore.js` |
| **RF3** | Registro de usuario | Autenticación | Visitante | `/registro` -> `RegisterPage.jsx` |
| **RF4** | Verificación de identidad 2FA (Código OTP) | Autenticación | Usuario en Registro | `/verify-2fa` -> `Verify2FAPage.jsx` |
| **RF5** | Inicio de sesión | Autenticación | Cliente | `/login` -> `LoginPage.jsx` |
| **RF6** | Recuperar contraseña | Autenticación | Cliente | `/forgot-password`, `/reset-password` |
| **RF7** | Inicio de sesión con rol | Autenticación | Super Admin / Encargado | Rúter Principal -> `RoleBasedGuard.jsx` |
| **RF8** | Acceso modo invitado sin registro | Autenticación | Visitante | `/catalogo`, `Modal Emergente -> VehicleDetailsModal.jsx` |
| **RF9** | Encabezado y buscador del catálogo | Catálogo | Cliente / Visitante | `/catalogo` -> `CatalogHeader.jsx` |
| **RF10** | Filtros del catálogo | Catálogo | Cliente / Visitante | `CatalogSidebarFilters.jsx` |
| **RF11** | Ordenar resultados del catálogo | Catálogo | Cliente / Visitante | `CatalogSortDropdown.jsx` |
| **RF12** | Tarjetas de vehículos | Catálogo | Cliente / Visitante | `VehicleCard.jsx` |
| **RF13** | Ver detalles de un vehículo | Catálogo | Cliente / Visitante | `Modal Emergente -> VehicleDetailsModal.jsx` -> `VehicleDetailsModal.jsx` |
| **RF14** | Menú de navegación principal catálogo | Catálogo | Cliente Autenticado | `CustomerNavbar.jsx` |
| **RF15** | Sección menú Mis Reservas | Catálogo | Cliente Autenticado | `/mis-reservas` -> `MyReservationsPage.jsx` |
| **RF16** | Sección menú Mis Favoritos | Catálogo | Cliente Autenticado | `/favoritos` -> `FavoritesPage.jsx` |
| **RF17** | Sección menú Notificaciones | Catálogo | Cliente Autenticado | `/notificaciones` -> `CustomerNotificationsPage.jsx` |
| **RF18** | Sección menú Soporte | Catálogo | Cliente / Visitante | `/soporte` -> `SupportCenterPage.jsx` |
| **RF19** | Ficha informativa del vehículo a reservar | Flujo Reservas | Cliente Autenticado | `CheckoutVehicleHeader.jsx` |
| **RF20** | Selección de fechas y lugar (Paso 1) | Flujo Reservas | Cliente Autenticado | `/checkout/step-1` -> `CheckoutStep1DatesPage.jsx` |
| **RF21** | Resumen de la reserva (Panel Lateral) | Flujo Reservas | Cliente Autenticado | `ReservationSummaryPanel.jsx` |
| **RF22** | Selección de protección (Paso 2 Coberturas) | Flujo Reservas | Cliente Autenticado | `CoverageSelectionGroup.jsx` |
| **RF23** | Tipo de kilometraje y extras (Paso 2 Extras) | Flujo Reservas | Cliente Autenticado | `ExtrasSelectionGroup.jsx` |
| **RF24** | Datos personales (Paso 3 Formulario) | Flujo Reservas | Cliente Autenticado | `DriverDetailsForm.jsx` |
| **RF25** | Verificación documental (Paso 3 Documentos)| Flujo Reservas | Cliente Autenticado | `DocumentUploadStep.jsx` |
| **RF26** | Pago Virtual con Wompi | Pagos | Cliente Autenticado | `WompiPaymentWidget.jsx` |
| **RF27** | Pago en Efectivo con Vencimiento Dinámico | Pagos | Cliente / Sistema | `CashPaymentOption.jsx`, `TimerBadge.jsx` |
| **RF28** | Firma de contrato y PIN de entrega | Contratos & PIN | Cliente / Encargado | `DigitalSignatureCanvas.jsx`, Modal PIN |
| **RF29** | Ver y editar información personal | Perfil Cliente | Cliente Autenticado | `/perfil` -> `UserProfilePage.jsx` |
| **RF30** | Cambiar contraseña | Perfil Cliente | Cliente Autenticado | `ChangePasswordTab.jsx` |
| **RF31** | Cerrar sesión | Perfil Cliente | Cliente / Admin | Menú de Usuario -> `useAuthStore.js` |
| **RF32** | Onboarding para nuevos usuarios | Transversal | Cliente Nuevo | `WelcomeOnboardingModal.jsx` |
| **RF33** | Chat flotante de soporte (Tawk.to) | Transversal | Cliente / Visitante | `LiveChatWidget.jsx` |
| **RF34** | Dashboard del administrador y sucursal | Admin Web | Super Admin / Encargado | `/admin`, `/encargado` |
| **RF35** | Gestión de ciudades | Admin Web | Super Admin | `/admin/ciudades` -> `ManageCitiesPage.jsx` |
| **RF36** | Gestión de Sucursales | Admin Web | Super Admin | `/admin/sucursales` -> `ManageBranchesPage.jsx` |
| **RF37** | Gestión de vehículos (Flota) | Admin Web | Super Admin / Encargado | `/admin/vehiculos` -> `ManageFleetPage.jsx` |
| **RF38** | Gestión de reservas | Admin Web | Super Admin / Encargado | `/admin/reservas` -> `ManageReservationsPage.jsx` |
| **RF39** | Gestión de usuarios y clientes | Admin Web | Super Admin | `/admin/usuarios` -> `ManageUsersPage.jsx` |
| **RF40** | Gestión de administradores y permisos | Admin Web | Super Admin | `/admin/roles` -> `ManageRolesPage.jsx` |
| **RF41** | Gestión de reportes de incidencias | Admin Web | Super Admin / Encargado | `/admin/incidencias` -> `ManageIncidentsPage.jsx` |
| **RF42** | Gestión de contratos | Admin Web | Super Admin | `/admin/contratos` -> `ManageContractsPage.jsx` |
| **RF43** | Gestión de promociones y cupones | Admin Web | Super Admin | `/admin/promociones` -> `ManagePromotionsPage.jsx` |
| **RF44** | Reportes administrativos | Admin Web | Super Admin | `/admin/reportes` -> `ReportsPage.jsx` |
| **RF45** | Configuración de marca e identidad visual | Admin Web | Super Admin | `/admin/configuracion` -> `BrandSettingsPage.jsx` |
| **RF46** | Auditoría y registro de actividad | Admin Web | Super Admin / Auditor | `/admin/auditoria` -> `AuditLogsPage.jsx` |
| **RF47** | Confirmación de pago en efectivo (sucursal)| Sucursal Web | Encargado de Sucursal | `/encargado/caja` -> `BranchCashierPage.jsx` |
| **RF48** | Centro de notificaciones operativas | Sucursal Web | Encargado de Sucursal | `/encargado/notificaciones` |
| **RF49** | Moderación y respuesta a reseñas | Sucursal Web | Encargado de Sucursal | `/encargado/resenas` -> `BranchReviewsPage.jsx` |
| **RF50** | Inspección y entrega del vehículo | Sucursal Web | Encargado de Sucursal | `/encargado/entregas` -> `DeliveryManagementPage` |
| **RF51** | Perfil Público y Operativo de Sucursal | Sucursal Web | Encargado de Sucursal | `/encargado/perfil-sucursal` |
| **RF52** | Validación de Entrega con PIN Nequi | Sucursal Web | Encargado de Sucursal | Modal `BranchPinValidationModal.jsx` |
| **RF53** | Formulario Inspección de Devolución | Sucursal Web | Encargado de Sucursal | `/encargado/devoluciones` -> `ReturnInspectionPage`|
| **RF54** | Gestión de Cupones Promocionales Sucursal| Sucursal Web | Encargado de Sucursal | `/encargado/cupones` -> `BranchCouponsPage.jsx` |

---
*Especificación Completa de Requerimientos Funcionales (`functional-requirements.md`) elaborada bajo el Estándar IEEE 830-1998 para el proyecto Drivique.*
