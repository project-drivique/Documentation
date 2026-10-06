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
9. **RF1.9** Redirigir al usuario al formulario de login (Formulario de Inicio de Sesión) o registro (Formulario de Registro) al interactuar con botones de conversión o intentar acciones restringidas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF1 Página de inicio (visitante sin sesión) |
| **Tipo / Actor** | Visitante (Usuario no autenticado sin sesión iniciada en la plataforma) |
| **Componente / Interfaz (UI)** | Interfaz LandingPage, HeroSection, FeaturedVehicles, HowItWorks, Footer |
| **Descripción** | Presenta la propuesta de valor comercial y la identidad de marca de Drivique a los visitantes públicos. Permite consultar la flota destacada en tiempo real, comprender los 4 pasos del flujo de alquiler, revisar beneficios corporativos y conducir la navegación hacia los formularios de registro de cuenta e inicio de sesión cuando se intentan realizar acciones restringidas. |
| **Entrada** | 1. Carga de la ruta raíz del dominio (Página de Inicio Principal) sin un token JWT activo en la sesión.<br>2. Clics del usuario en los botones principales de conversión ("Explorar vehículos", "Registrarse").<br>3. Clics en los ítems de la barra de navegación superior y pie de página (Footer).<br>4. Interacción con las tarjetas de la sección "Disponibles ahora". |
| **Salida** | 1. Renderizado de la estructura visual completa de la Landing Page con sus 5 secciones principales.<br>2. Despliegue de los botones "Iniciar sesión" y "Registrarse" en el encabezado fijo.<br>3. Redirección inmediata a las rutas protegidas de autenticación (Formulario de Inicio de Sesión o Formulario de Registro) ante cualquier interacción de conversión. |
| **Acción** | 1. Verificar la ausencia de token JWT en el estado global (`useAuthStore`).<br>2. Consultar y cargar en memoria el listado de vehículos destacados de la flota activa via `GET /api/v1/vehicles/featured`.<br>3. Interceptación de intentos de acceso a funcionalidades de usuario registrado y redirección al enrutador de autenticación. |
| **Manejo de Situaciones Anormales** | 1. Si la API de vehículos destacados falla (HTTP 500/503), la página renderiza un estado degradado mostrando una vista previa estática sin romper la maquetación.<br>2. Si la conexión a internet cae, se despliega una barra superior indicando estado offline. |
| **Criterios de Aceptación** | 1. La página pública debe renderizarse correctamente sin solicitar credenciales ni bloquear el acceso.<br>2. El botón "Explorar vehículos" debe llevar al catálogo en modo lectura.<br>3. El botón "Registrarse" debe redirigir al formulario de registro en dos pasos.<br>4. El menú superior debe exhibir de forma permanente los accesos a inicio de sesión y registro. |

---

### RF2: Redirección tras inicio de sesión

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF2.1** Redirigir automáticamente al catálogo de vehículos (Inicio del Cliente) tras la autenticación exitosa de un usuario con rol Cliente.
2. **RF2.2** Bloquear la visualización de la Landing Page pública (Página de Inicio Principal) cuando exista una sesión activa, redirigiendo al panel asignado al rol.
3. **RF2.3** Ocultar los botones de "Iniciar sesión" y "Registrarse" en el menú superior para usuarios autenticados, desplegando en su lugar el nombre de usuario, avatar e ícono de notificaciones.
4. **RF2.4** Permitir la libre navegación por el catálogo e iniciar procesos de reserva sin modales de bloqueo para el usuario autenticado.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF2 Redirección tras inicio de sesión |
| **Tipo / Actor** | Cliente / Super Administrador (`ROLE_SUPER_ADMIN`) / Encargado de Sucursal (`ROLE_BRANCH_MANAGER`) |
| **Componente / Interfaz (UI)** | Guardias de Navegación ProtectedRoute, GuestRoute, Almacén de Autenticación |
| **Descripción** | Administra el flujo de control de acceso y enrutamiento defensivo del sistema. Garantiza que cualquier usuario que posea un token de sesión activo (JWT) y pretenda ingresar a la ruta pública (Página de Inicio Principal) sea evaluado y redirigido automáticamente a la vista principal correspondiente a su rol de usuario sin exponer la Landing Page de visitante. |
| **Entrada** | 1. Evento de autenticación exitosa en el formulario de inicio de sesión.<br>2. Intento de navegación manual a la URL raíz (Página de Inicio Principal) teniendo una sesión activa persistida en el navegador. |
| **Salida** | 1. Redirección automática a la ruta Pantalla de Inicio del Cliente para usuarios con rol de Cliente.<br>2. Redirección a Panel del Administrador para usuarios con rol de Super Administrador.<br>3. Redirección a Panel del Encargado de Sucursal para el rol Encargado de Sucursal.<br>4. Menú de navegación actualizado con el perfil, avatar e insignias del usuario autenticado. |
| **Acción** | 1. Leer el estado del token JWT e hidratar el usuario desde `authStore`.<br>2. Ejecutar la función helper de control de acceso `getRoleHome(usuario.rol)`.<br>3. Reemplazar la entrada en el historial de navegación para evitar bucles de retorno al presionar el botón "Atrás" del navegador. |
| **Manejo de Situaciones Anormales** | 1. Si el token JWT ha expirado durante la verificación, el sistema destruye las credenciales guardadas y redirige a Formulario de Inicio de Sesión con un mensaje de expiración de sesión. |
| **Criterios de Aceptación** | 1. Un usuario autenticado no debe poder visualizar la Landing Page de visitantes bajo ninguna circunstancia.<br>2. El sistema debe redirigir exactamente al panel correspondiente al rol del token.<br>3. Los botones de inicio de sesión y registro no deben ser visibles para usuarios autenticados. |

---

# MÓDULO 2: AUTENTICACIÓN Y GESTIÓN DE CUENTA

---

### RF3: Registro de usuario

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF3.1** Renderizar pantalla dividida en dos paneles: panel informativo a la izquierda y formulario de registro a la derecha (Formulario de Registro).
2. **RF3.2** Solicitar los campos obligatorios: correo electrónico, contraseña y confirmación de contraseña.
3. **RF3.3** Validar cada campo del formulario en tiempo real conforme se digitan los caracteres.
4. **RF3.4** Aplicar política de contraseñas robustas (mínimo 8 caracteres, al menos una letra mayúscula, un número y un carácter especial).
5. **RF3.5** Comparar y validar que la contraseña y su confirmación sean exactamente idénticas.
6. **RF3.6** Desplegar indicador visual de fuerza de contraseña (Débil, Media, Fuerte) mediante barras de progreso y colores.
7. **RF3.7** Alternar la visibilidad de la contraseña (mostrar/ocultar texto) mediante ícono de ojo interactivo.
8. **RF3.8** Requerir la aceptación obligatoria de los Términos y Condiciones y Política de Privacidad mediante checkbox.
9. **RF3.9** Deshabilitar el botón "Registrarse" mientras existan errores de validación o campos obligatorios vacíos.
10. **RF3.10** Enviar petición de registro al servidor REST backend (`POST /api/v1/auth/register`).
11. **RF3.11** Redirigir automáticamente a la pantalla de verificación 2FA (Pantalla de Verificación 2FA) tras completar el envío inicial.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF3 Registro de usuario |
| **Tipo / Actor** | Visitante / Nuevo Usuario |
| **Componente / Interfaz (UI)** | Interfaz RegisterPage, RegisterForm, PasswordStrengthBar |
| **Descripción** | Permite el alta de nuevos usuarios en la plataforma Drivique mediante la captura de credenciales básicas de acceso. Garantiza la calidad de la información ingresada mediante validaciones reactivas, fortalece la seguridad exigiendo contraseñas complejas y asegura el consentimiento legal del usuario previo al envío de datos. |
| **Entrada** | 1. Correo electrónico válido (formato RFC 5322).<br>2. Contraseña y Confirmación de contraseña.<br>3. Marcado del checkbox de Aceptación de Términos y Condiciones. |
| **Salida** | 1. Feedback visual instantáneo sobre la validez de los campos.<br>2. Creación del registro temporal de usuario en estado "Pendiente de Verificación".<br>3. Envío de código OTP de 6 dígitos al correo electrónico registrado.<br>4. Redirección automática a la vista Verificación 2FA. |
| **Acción** | 1. Ejecutar validación de esquema con Zod / React Hook Form.<br>2. Transmitir payload JSON cifrado por HTTPS al backend.<br>3. Guardar temporalmente el correo electrónico en el estado de registro para la fase de 2FA. |
| **Manejo de Situaciones Anormales** | 1. Si el correo ya se encuentra registrado en el sistema, la API retorna error `409 Conflict` y el formulario resalta el campo de correo con el mensaje "Este correo electrónico ya está registrado".<br>2. Si falla el servidor, se notifica mediante un Toast rojo de error. |
| **Criterios de Aceptación** | 1. No se permite el registro si las contraseñas no coinciden o no cumplen la regla de fortaleza.<br>2. El botón de envío no se activa hasta haber aceptado los Términos y Condiciones.<br>3. Al completar el formulario, se redirige inmediatamente a la verificación de código OTP. |

---

### RF4: Verificación de identidad con doble factor (2FA / Código de Correo)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF4.1** Renderizar la pantalla de verificación de código OTP de 6 dígitos (Pantalla de Verificación 2FA).
2. **RF4.2** Desplegar 6 casillas numéricas independientes con avance automático de foco al digitar cada número.
3. **RF4.3** Mostrar el correo electrónico al cual fue enviado el código de confirmación.
4. **RF4.4** Implementar contador regresivo de tiempo de validez del código (ej. 05:00 minutos).
5. **RF4.5** Ofrecer botón "Reenviar código" que se habilita únicamente cuando el contador llega a cero.
6. **RF4.6** Validar automáticamente el código al completar el último dígito en la sexta casilla.
7. **RF4.7** Activar la cuenta de usuario en la base de datos tras la validación exitosa.
8. **RF4.8** Redirigir al usuario autenticado al catálogo (Inicio del Cliente) con el token JWT de sesión activo.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF4 Verificación de identidad con doble factor (2FA / Código de Correo) |
| **Tipo / Actor** | Usuario en Proceso de Registro |
| **Componente / Interfaz (UI)** | Interfaz Verify2FAPage, OTPInputGroup, CountdownTimer |
| **Descripción** | Mecanismo de seguridad de doble factor que exige la confirmación del correo electrónico registrado mediante la introducción de una clave de un solo uso (OTP) de 6 dígitos. Previene la creación de cuentas falsas o no autorizadas. |
| **Entrada** | 1. Código numérico OTP de 6 dígitos ingresado por el usuario.<br>2. Evento de clic en "Reenviar código". |
| **Salida** | 1. Activación de la cuenta de usuario en la base de datos (`is_active = true`).<br>2. Generación e inyección del token JWT de sesión en la plataforma.<br>3. Redirección automática a la vista Pantalla de Inicio del Cliente. |
| **Acción** | 1. Transmitir el código numérico a `POST /api/v1/auth/verify-otp`.<br>2. Comparar la clave ingresada contra el hash del código temporal en servidor.<br>3. Autenticar de forma transparente al usuario una vez validado. |
| **Manejo de Situaciones Anormales** | 1. Si el código ingresado es incorrecto, se limpia el input y se despliega la alerta "Código de verificación inválido".<br>2. Si el código ha expirado, se exige presionar "Reenviar código" para recibir uno nuevo. |
| **Criterios de Aceptación** | 1. El avance entre las 6 casillas numéricas debe ser automático e intuitivo.<br>2. La cuenta no puede iniciar sesión sin haber completado la verificación OTP.<br>3. El reenvió de código debe estar bloqueado mientras el contador regresivo se encuentre activo. |

---

### RF5: Inicio de sesión

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF5.1** Renderizar formulario de inicio de sesión (Formulario de Inicio de Sesión) con campos de correo electrónico y contraseña.
2. **RF5.2** Ofrecer la función "Recordarme" para mantener la sesión activa en el navegador.
3. **RF5.3** Incluir enlace "¿Olvidaste tu contraseña?" con redirección a la vista de recuperación (Pantalla de Recuperación de Contraseña).
4. **RF5.4** Alternar la visibilidad del texto de la contraseña mediante ícono interactivo.
5. **RF5.5** Enviar credenciales al backend (`POST /api/v1/auth/login`) cifradas en canal HTTPS.
6. **RF5.6** Almacenar el token JWT recibido en el almacenamiento del cliente (`localStorage` / Cookie HTTP-Only).
7. **RF5.7** Cargar el perfil de usuario en el estado global de la aplicación.
8. **RF5.8** Redirigir al usuario al catálogo (Inicio del Cliente) o al panel asignado según su rol.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF5 Inicio de sesión |
| **Tipo / Actor** | Usuario Registrado (Cliente) |
| **Componente / Interfaz (UI)** | Interfaz LoginPage, LoginForm |
| **Descripción** | Permite el acceso seguro de usuarios previamente registrados a la plataforma mediante la verificación de sus credenciales (correo y contraseña). Inicia la sesión de usuario y otorga el token JWT necesario para realizar operaciones autenticadas. |
| **Entrada** | 1. Correo electrónico del usuario.<br>2. Contraseña del usuario.<br>3. Selección del checkbox "Recordarme". |
| **Salida** | 1. Token JWT de autenticación retornado por el servidor.<br>2. Perfil del usuario cargado en memoria.<br>3. Redirección exitosa a la vista correspondiente. |
| **Acción** | 1. Validar el formato de los datos ingresados.<br>2. Invocar la API de autenticación backend.<br>3. Guardar el token y configurar los encabezados HTTP `Authorization: Bearer <token>` para peticiones futuras. |
| **Manejo de Situaciones Anormales** | 1. Si las credenciales son erróneas, se despliega la alerta "Correo o contraseña incorrectos".<br>2. Si la cuenta no está verificada (falta 2FA), redirige automáticamente a Verificación 2FA. |
| **Criterios de Aceptación** | 1. Las credenciales deben enviarse cifradas obligatoriamente.<br>2. Al autenticarse correctamente, el sistema redirige al catálogo sin demoras.<br>3. La opción "Recordarme" extiende la persistencia del token de sesión. |

---

### RF6: Recuperar contraseña

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF6.1** Renderizar la pantalla de solicitud de recuperación de contraseña (Pantalla de Recuperación de Contraseña).
2. **RF6.2** Solicitar el correo electrónico asociado a la cuenta.
3. **RF6.3** Enviar enlace con token de restablecimiento único al correo del usuario (`POST /api/v1/auth/forgot-password`).
4. **RF6.4** Renderizar la pantalla de restablecimiento de contraseña (Pantalla de Restablecimiento de Contraseña) al acceder desde el enlace del correo.
5. **RF6.5** Solicitar nueva contraseña y confirmación de la misma con validación de fortaleza.
6. **RF6.6** Actualizar la contraseña en la base de datos y revocar tokens de restablecimiento utilizados.
7. **RF6.7** Redirigir al usuario a la pantalla de login (Formulario de Inicio de Sesión) con mensaje de éxito.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF6 Recuperar contraseña |
| **Tipo / Actor** | Usuario Registrado |
| **Componente / Interfaz (UI)** | Rutas Recuperación de Contraseña y Restablecimiento de Contraseña -> ForgotPasswordPage, ResetPasswordPage |
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
2. **RF7.2** Redirigir al panel Panel del Administrador si el usuario posee el rol Super Administrador (`ROLE_SUPER_ADMIN`).
3. **RF7.3** Redirigir al panel Panel del Encargado de Sucursal si el usuario posee el rol Encargado de Sucursal (`ROLE_BRANCH_MANAGER`).
4. **RF7.4** Restringir el acceso a rutas administrativas a usuarios con rol Cliente (`ROLE_CUSTOMER`), retornando error 403 Forbidden.
5. **RF7.5** Cargar las variables de contexto específicas del rol en el almacenamiento de la aplicación.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF7 Inicio de sesión con rol (Administrador y Encargado de sucursal) |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Rúter Principal -> AppRoutes, RoleBasedGuard |
| **Descripción** | Control de acceso basado en roles (RBAC) que canaliza a los usuarios administrativos hacia sus respectivos paneles de control de acuerdo con sus permisos asignados en el sistema. |
| **Entrada** | 1. Token JWT validado con claims de rol (`ROLE_SUPER_ADMIN`, `ROLE_BRANCH_MANAGER`). |
| **Salida** | 1. Redirección al dashboard administrativo correspondiente (Panel del Administrador o Panel del Encargado de Sucursal).<br>2. Habilitación de menús y opciones de gestión administrativa. |
| **Acción** | 1. Decodificar payload JWT y extraer el arreglo de roles/permisos.<br>2. Comparar roles contra la matriz de permisos de la ruta solicitada.<br>3. Renderizar el layout administrativo o denegar el acceso. |
| **Manejo de Situaciones Anormales** | 1. Si un usuario intenta forzar la URL de un panel sin tener el rol adecuado, es redirigido inmediatamente a su panel correspondiente o a la página 403. |
| **Criterios de Aceptación** | 1. Los administradores ingresan directamente a su panel operativo.<br>2. Los clientes no pueden acceder visual ni lógicamente a ninguna vista de administración. |

---

### RF8: Acceso modo invitado sin registro

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF8.1** Permitir la libre navegación por el catálogo de vehículos (Catálogo de Vehículos) a usuarios no registrados (Visitantes).
2. **RF8.2** Habilitar el uso de buscadores, filtros de categorías, precios y ubicaciones en modo lectura.
3. **RF8.3** Permitir la visualización completa de los detalles de cualquier vehículo (Modal Emergente de Detalle de Vehículo).
4. **RF8.4** Interceptar el clic en el botón "Reservar ahora" desplegando modal de autenticación requerida.
5. **RF8.5** Redirigir al flujo de login/registro guardando el vehículo seleccionado para retomar la reserva tras autenticarse.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF8 Acceso modo invitado sin registro |
| **Tipo / Actor** | Visitante / Usuario no autenticado |
| **Componente / Interfaz (UI)** | Catálogo de Vehículos, Modal Emergente de Detalle de Vehículo |
| **Descripción** | Otorga libertad de navegación pública para explorar la oferta de vehículos y servicios de Drivique sin exigir registro previo, postergando la solicitud de credenciales hasta el momento exacto en que se desea iniciar una reserva. |
| **Entrada** | 1. Navegación libre por las rutas de catálogo y detalle.<br>2. Intento de interacción con acciones privilegiadas ("Reservar", "Guardar en favoritos"). |
| **Salida** | 1. Visualización completa de información de flota en modo lectura.<br>2. Despliegue de modal instructivo invitando a iniciar sesión o registrarse. |
| **Acción** | 1. Permitir peticiones GET públicas a la API de catálogo.<br>2. Capturar intención de reserva y almacenar la URL de retorno en la sesión temporal. |
| **Manejo de Situaciones Anormales** | 1. Si el visitante intenta saltar directamente a la URL de checkout (Wizard de Reserva), la guardia de ruta lo redirige inmediatamente a Formulario de Inicio de Sesión. |
| **Criterios de Aceptación** | 1. Los visitantes pueden consultar vehículos y precios sin restricción.<br>2. La acción de reservar requiere autenticación previa en el 100% de los casos. |

---

# MÓDULO 3: CATÁLOGO DE VEHÍCULOS Y EXPERIENCIA DEL CLIENTE

---

### RF9: Encabezado y buscador del catálogo

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF9.1** Renderizar barra de búsqueda principal en la cabecera del catálogo (Catálogo de Vehículos).
2. **RF9.2** Incluir campo de entrada de texto libre para buscar por marca, modelo o palabra clave.
3. **RF9.3** Incluir selectores desplegables de Ubicación/Sucursal, Fecha de Inicio y Fecha de Fin.
4. **RF9.4** Ejecutar búsqueda en tiempo real (debounce 300ms) conforme se escribe en el campo de texto.
5. **RF9.5** Filtrar dinámicamente las tarjetas de vehículos expuestas en el catálogo según los criterios ingresados.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF9 Encabezado y buscador del catálogo |
| **Tipo / Actor** | Cliente / Visitante |
| **Componente / Interfaz (UI)** | Interfaz CatalogHeader, SearchBar |
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
| **Componente / Interfaz (UI)** | Componente CatalogSidebarFilters en Catálogo de Vehículos |
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
| **Componente / Interfaz (UI)** | Componente CatalogSortDropdown |
| **Descripción** | Permite reorganizar la secuencia de presentación de las tarjetas de vehículos según los criterios de preferencia del usuario. |
| **Entrada** | 1. Selección de un criterio del menú desplegable de ordenamiento. |
| **Salida** | 1. Reordenamiento visual inmediato de la cuadrícula de vehículos. |
| **Acción** | 1. Ejecutar algoritmo de ordenación en memoria o solicitar datos ordenados a la API REST. |
| **Manejo de Situaciones Anormales** | 1. En caso de empate en precios o calificaciones, el sistema aplica un orden secundario por fecha de creación del vehículo. |
| **Criterios de Aceptación** | 1. El cambio de orden se ejecuta en menos de 100 milisegundos.<br>2. Se conserva el criterio de ordenamiento seleccionado al aplicar nuevos filtros. |

---

### RF12: Tarjetas de vehículos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF12.1** Renderizar tarjetas de vehículos (VehicleCard) con diseño visual atractivo y estructurado.
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
| **Componente / Interfaz (UI)** | Componente VehicleCard en catálogo y vistas principales |
| **Descripción** | Unidad visual fundamental de la interfaz que resume los atributos esenciales de cada vehículo para facilitar la toma de decisiones del cliente. |
| **Entrada** | 1. Objeto JSON con los datos del vehículo.<br>2. Clic en la tarjeta, botón de favorito o botón de reserva. |
| **Salida** | 1. Renderizado completo de la tarjeta con imagen, datos y acciones.<br>2. Redirección a la vista de detalle o inicio de flujo de reserva. |
| **Acción** | 1. Cargar imagen desde CDN con fallback de imagen en caso de falla de red.<br>2. Consultar estado de favorito en el estado global. |
| **Manejo de Situaciones Anormales** | 1. Si la imagen no se encuentra disponible, se muestra una imagen placeholder genérica de la marca Drivique. |
| **Criterios de Aceptación** | 1. Toda tarjeta debe exhibir de forma transparente la tarifa diaria y la calificación promedio.<br>2. El botón de favoritos responde al instante alternando el estado visual del corazón. |

---

### RF13: Ver detalles de un vehículo

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF13.1** Renderizar vista detallada del vehículo (Modal Emergente de Detalle de Vehículo).
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
| **Componente / Interfaz (UI)** | Ruta Modal Emergente de Detalle de Vehículo -> VehicleDetailsModal, ImageGallery, ReviewsSection |
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
| **Componente / Interfaz (UI)** | Componente CustomerNavbar |
| **Descripción** | Encabezado de control del cliente que centraliza el acceso a todos los módulos funcionales de la cuenta personal. |
| **Entrada** | 1. Clics en las secciones del menú.<br>2. Interacción con el menú desplegable de perfil. |
| **Salida** | 1. Navegación fluida entre pantallas del cliente.<br>2. Despliegue de insignias de notificación en tiempo real. |
| **Acción** | 1. Mantener sincronizado el estado global del usuario y sus notificaciones. |
| **Manejo de Situaciones Anormales** | 1. Si falla la carga de la foto de avatar, se muestran las iniciales del nombre del usuario dentro de un círculo con color corporativo. |
| **Criterios de Aceptación** | 1. El menú debe ser totalmente responsivo, colapsando en un menú lateral de hamburguesa en pantallas móviles. |

---

### RF15: Sección menú Mis Reservas

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF15.1** Renderizar la pantalla "Mis Reservas" (Mis Reservas) con el historial completo de alquileres del usuario.
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
| **Componente / Interfaz (UI)** | Interfaz MyReservationsPage, ReservationCard, LeaveReviewModal |
| **Descripción** | Módulo de gestión personal donde el cliente puede supervisar, administrar, descargar contratos o cancelar sus reservas de vehículos. |
| **Entrada** | 1. Clic en las pestañas de estado.<br>2. Solicitud de descarga de PDF.<br>3. Envío de formulario de cancelación o reseña. |
| **Salida** | 1. Listado ordenado de reservas.<br>2. Descarga de archivo PDF de contrato.<br>3. Registro de calificación con foto en la base de datos. |
| **Acción** | 1. Consultar `GET /api/v1/customer/reservations`.<br>2. Invocar endpoint de cancelación o publicación de reseña con adjuntos. |
| **Manejo de Situaciones Anormales** | 1. Si la reserva ya sobrepasó el límite de cancelación sin penalización, se advierte al usuario sobre el costo asociado antes de proceder. |
| **Criterios de Aceptación** | 1. El cliente puede descargar el PDF de su contrato firmado en cualquier momento.<br>2. Solo se permite publicar una reseña por reserva completada. |

---

### RF16: Sección menú Mis Favoritos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF16.1** Renderizar la pantalla "Mis Favoritos" (Catálogo de Favoritos) exhibiendo los vehículos guardados por el cliente.
2. **RF16.2** Permite remover vehículos del listado de favoritos haciendo clic en el ícono de corazón.
3. **RF16.3** Incluir botón directo de reserva en cada tarjeta del listado.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF16 Sección menú Mis Favoritos |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Interfaz FavoritesPage |
| **Descripción** | Espacio de lista de deseos donde el cliente conserva los vehículos de su interés para futuras cotizaciones o alquileres. |
| **Entrada** | 1. Interacción con los botones de remover o reservar. |
| **Salida** | 1. Cuadrícula de vehículos guardados.<br>2. Actualización inmediata del contador de favoritos. |
| **Acción** | 1. Sincronizar el arreglo de favoritos con el backend (`POST/DELETE /api/v1/customer/favorites`). |
| **Manejo de Situaciones Anormales** | 1. Si la lista está vacía, se despliega una vista informativa con un botón para explorar el catálogo. |
| **Criterios de Aceptación** | 1. Los favoritos se conservan entre diferentes sesiones del usuario. |

---

### RF17: Sección menú Notificaciones (Cliente)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF17.1** Renderizar el centro de notificaciones personal (Centro de Notificaciones).
2. **RF17.2** Mostrar alertas en tiempo real sobre confirmaciones de reserva, vencimiento de plazo de pago en efectivo, asignación de PIN de entrega y promociones.
3. **RF17.3** Permitir marcar notificaciones como leídas de forma individual o masiva ("Marcar todas como leídas").

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF17 Sección menú Notificaciones (Cliente) |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Interfaz CustomerNotificationsPage |
| **Descripción** | Canal de mensajería operativa que mantiene al cliente informado sobre el estado de sus transacciones y avisos importantes. |
| **Entrada** | 1. Eventos del sistema (cambios de estado de reserva).<br>2. Acciones del usuario para marcar como leídas. |
| **Salida** | 1. Lista cronológica de notificaciones con marca de tiempo y enlace a la acción relevante. |
| **Acción** | 1. Recepción de eventos vía WebSockets o Server-Sent Events (SSE). |
| **Manejo de Situaciones Anormales** | 1. Si la conexión de tiempo real falla, se aplica un mecanismo de sondeo (`polling`) cada 30 segundos. |
| **Criterios de Aceptación** | 1. Las notificaciones críticas (como código PIN o vencimiento de pago) se destacan con color distintivo. |

---

### RF18: Sección menú Soporte

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF18.1** Renderizar la página del Centro de Soporte (Centro de Soporte).
2. **RF18.2** Desplegar sección de Preguntas Frecuentes (FAQ) organizadas por categorías acordionadas (Reservas, Pagos, Seguros, Entregas).
3. **RF18.3** Incluir formulario de contacto para enviar solicitudes de ayuda o PQR al equipo de atención.
4. **RF18.4** Mostrar información de contacto directo: líneas de atención 24/7, correo electrónico e integración con WhatsApp Web.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF18 Sección menú Soporte |
| **Tipo / Actor** | Cliente / Visitante |
| **Componente / Interfaz (UI)** | Interfaz SupportCenterPage, FAQAccordion, ContactForm |
| **Descripción** | Portal de asistencia integral diseñado para resolver dudas operativas y ofrecer canales directos de contacto al cliente. |
| **Entrada** | 1. Interacción con acordeones FAQ.<br>2. Llenado del formulario de soporte. |
| **Salida** | 1. Despliegue de respuestas inmediatas.<br>2. Ticket de soporte generado con código de seguimiento enviado al correo. |
| **Acción** | 1. Transmitir el ticket a `POST /api/v1/support/tickets`. |
| **Manejo de Situaciones Anormales** | 1. Si el envío del ticket falla, se despliega el número telefónico directo de urgencias. |
| **Criterios de Aceptación** | 1. El cliente recibe una confirmación automática por correo tras enviar una solicitud de soporte. |

---

# MÓDULO 4: FLUJO MULTIPASOS DE RESERVAS (WIZARD DE RESERVA)

---

### RF19: Configuración de reserva, fechas, horarios y sucursales (Paso 1 del Wizard)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF19.1** Iniciar directamente la interfaz del Paso 1 del Wizard de Reserva (`/reservas/:vehiculoId` -> ReservationFlowPage) al presionar "Reservar Ahora" en el catálogo o modal de detalles para un usuario autenticado.
2. **RF19.2** Renderizar selector interactivo de fechas (fecha de recogida y devolución) con cálculo automático de días de alquiler.
3. **RF19.3** Renderizar selectores de horarios de recogida y entrega del vehículo.
4. **RF19.4** Permitir la selección de sucursal de recogida y sucursal de devolución (misma sucursal o sucursal diferente con recargo logístico).
5. **RF19.5** Incluir la opción de entrega/recogida a domicilio (DomicilioModal) permitiendo registrar dirección, barrio, ciudad y referencias para el conductor.
6. **RF19.6** Evaluar automáticamente la restricción vehicular de Pico y Placa (PicoYPlacaChecker) según el último dígito de la placa asignada al auto en las fechas elegidas.
7. **RF19.7** Permitir seleccionar la modalidad de kilometraje (Ilimitado sin recargo o Limitado con tarifa por km adicional).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF19 Configuración de reserva, fechas, horarios y sucursales (Paso 1 del Wizard) |
| **Tipo / Actor** | Cliente Autenticado (`ROLE_CUSTOMER`) |
| **Componente / Interfaz (UI)** | Interfaz ReservationFlowPage, UnifiedReservationConfigCard, DateStep, DomicilioModal, PicoYPlacaChecker |
| **Descripción** | Primer paso del asistente de reserva multipasos. Captura la parametrización espacio-temporal del alquiler, evalúa disponibilidad, aplica restricciones locales de movilidad e integra opciones logísticas a domicilio. |
| **Entrada** | 1. Fecha y hora de inicio de alquiler.<br>2. Fecha y hora de devolución del vehículo.<br>3. Sucursal de origen y sucursal destino.<br>4. Dirección de entrega a domicilio (opcional). |
| **Salida** | 1. Validación de disponibilidad del auto en el inventario.<br>2. Cálculo de días de alquiler y recargo por domicilio si aplica.<br>3. Alerta de Pico y Placa generada. |
| **Acción** | 1. Consultar disponibilidad en tiempo real vía `GET /api/v1/vehicles/{id}/availability`.<br>2. Hidratar el estado del flujo en `useReservationFlow`. |
| **Manejo de Situaciones Anormales** | 1. Si las fechas ingresadas no están disponibles, el calendario bloquea la selección e indica las fechas ocupadas en color rojo. |
| **Criterios de Aceptación** | 1. La fecha de devolución debe ser estrictamente posterior a la fecha de recogida.<br>2. Si se selecciona entrega a domicilio, la dirección y barrio son obligatorios. |

---

### RF20: Selección de coberturas de protección y servicios adicionales (Paso 2 del Wizard)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF20.1** Renderizar el Paso 2 del Wizard ofreciendo tres niveles de protección: Plan Básico (incluido, responsabilidad civil), Plan Estándar (cobertura parcial por colisión) y Plan Premium (cero deducible, cobertura 100% todo riesgo, cristales y llantas).
2. **RF20.2** Desplegar catálogo de equipamiento y servicios opcionales: Silla de bebé/niños, Conductor adicional autorizado, GPS satelital / Wi-Fi portátil, Asistencia en carretera VIP 24/7 y Tanque de combustible prepagado.
3. **RF20.3** Permitir seleccionar unidades para servicios adicionales y actualizar en tiempo real el desglose de costos en la barra lateral de resumen (SideSummary).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF20 Selección de coberturas de protección y servicios adicionales (Paso 2 del Wizard) |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Componentes ProtectionPlans, AdditionalServices, SideSummary en ReservationFlowPage |
| **Descripción** | Permite al cliente personalizar su nivel de protección de seguro y agregar extras logísticos antes de proceder al registro de datos de conductor. |
| **Entrada** | 1. Selección del nivel de protección (Básico, Estándar, Premium).<br>2. Inclusión de servicios adicionales por unidades. |
| **Salida** | 1. Sumatoria de valores diarios de coberturas y extras en el resumen financiero. |
| **Acción** | 1. Actualizar el estado de coberturas en el contexto de la reserva. |
| **Manejo de Situaciones Anormales** | 1. Si se desmarca una cobertura obligatoria, el sistema aplica por defecto la cobertura básica exigida por ley. |
| **Criterios de Aceptación** | 1. El usuario debe elegir obligatoriamente al menos el nivel de protección básico. |

---

### RF21: Datos del conductor, comprobación de licencia y cupones de descuento (Paso 3 del Wizard)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF21.1** Presentar el Paso 3 del Wizard precargando automáticamente los datos del usuario autenticado (Nombres, Apellidos, Tipo/Número de Documento, Teléfono, Correo).
2. **RF21.2** Requerir el ingreso de los datos de la Licencia de Conducción del conductor principal (Número, fecha de expedición, vencimiento y categoría).
3. **RF21.3** Permitir capturar los datos de un Conductor Adicional si el servicio fue incluido en el Paso 2.
4. **RF21.4** Ofrecer campo de texto para la validación y aplicación de **Cupones de Descuento** promocionales, recalculando automáticamente el subtotal y mostrando la rebaja en SideSummary.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF21 Datos del conductor, comprobación de licencia y cupones de descuento (Paso 3 del Wizard) |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Componentes PersonalData, SideSummary en ReservationFlowPage |
| **Descripción** | Registra y valida los datos legales del conductor principal y adicional, e integra la aplicación de cupones de descuento promocionales. |
| **Entrada** | 1. Datos personales y de licencia de conducción.<br>2. Código de cupón promocional (opcional). |
| **Salida** | 1. Validación de elegibilidad legal del conductor.<br>2. Descuento promocional aplicado y reflejado en el resumen. |
| **Acción** | 1. Validar el formato del código promocional vía `POST /api/v1/promotions/validate`. |
| **Manejo de Situaciones Anormales** | 1. Si el cupón ingresado no existe, está vencido o no alcanza el monto mínimo, se muestra la notificación de error descriptiva. |
| **Criterios de Aceptación** | 1. La confirmación exige aceptar explícitamente los Términos y Condiciones legales. |

---

### RF22: Resumen financiero final y selección de método de pago (Paso 4 del Wizard)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF22.1** Presentar el Paso 4 del Wizard con el desglose consolidado de la reserva: días de alquiler, valor de coberturas, extras, tarifa de envío a domicilio, descuento por cupón, impuestos (IVA 19%) y monto total final.
2. **RF22.2** Mostrar el valor del Depósito de Garantía reembolsable exigido en la tarjeta de crédito.
3. **RF22.3** Permitir elegir entre dos modalidades de pago: **Pago Digital en Línea (Pasarela Wompi)** o **Pago en Efectivo (Presencial en Sucursal)**.
4. **RF22.4** Generar el pre-registro de la reserva con código de reserva único (ej. `RES-2026-9842`).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF22 Resumen financiero final y selección de método de pago (Paso 4 del Wizard) |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Componentes PaymentMethodCard, SideSummary en ReservationFlowPage |
| **Descripción** | Cierre financiero del asistente de reserva donde se verifica la liquidación completa de valores y se elige la alternativa de pago preferida. |
| **Entrada** | 1. Selección del método de pago (Wompi o Efectivo en Sucursal). |
| **Salida** | 1. Creación de la reserva en estado `PENDIENTE` o `PENDIENTE_EFECTIVO`.<br>2. Generación del código único de reserva. |
| **Acción** | 1. Registrar la reserva en el backend mediante `POST /api/v1/reservations/create`. |
| **Manejo de Situaciones Anormales** | 1. Si falla el registro en la API, se conserva el estado del Wizard permitiendo reintentar la solicitud. |
| **Criterios de Aceptación** | 1. El cliente no puede finalizar la reserva sin seleccionar un método de pago válido. |

---

# MÓDULO 5: PASARELA DE PAGOS (PASARELA VIRTUAL Y EFECTIVO EN SUCURSAL)

---

### RF23: Procesamiento de pago digital en línea (Pasarela Virtual Wompi)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF23.1** Invocar el widget oficial de pagos de Wompi cifrado al seleccionar pago digital en el checkout (Estrategia de Pago Wompi).
2. **RF23.2** Admitir transacciones con Tarjetas de Crédito/Débito, PSE, Nequi y Botón Bancolombia.
3. **RF23.3** Procesar el evento Webhook retornado por Wompi para actualizar automáticamente el estado de la reserva a **`CONFIRMADA / PAGADA`**.
4. **RF23.4** Redirigir a la pantalla de confirmación (PaymentResponsePage) notificando el éxito de la transacción.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF23 Procesamiento de pago digital en línea (Pasarela Virtual Wompi) |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Interfaz PaymentResponsePage, Estrategia de Pago Wompi |
| **Descripción** | Integración con la pasarela de pagos virtual Wompi para el recaudo electrónico seguro con confirmación instantánea de reservas. |
| **Entrada** | 1. Datos bancarios o de tarjeta en el widget seguro de Wompi.<br>2. Transacción autorizada por la entidad financiera. |
| **Salida** | 1. Comprobante digital de pago emitido.<br>2. Cambio de estado de reserva a `CONFIRMADA`. |
| **Acción** | 1. Validar firma SHA-256 del Webhook en `POST /api/v1/payments/wompi/webhook`. |
| **Manejo de Situaciones Anormales** | 1. Si la transacción es rechazada, se mantiene la reserva en estado pendiente permitiendo pagar con otra tarjeta. |
| **Criterios de Aceptación** | 1. La confirmación del pago se procesa de forma asíncrona y segura. |

---

### RF24: Cobro presencial en efectivo en sucursal con plazo de vencimiento dinámico

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF24.1** Guardar la reserva en estado **`PENDIENTE_EFECTIVO`** al seleccionar pago presencial en sucursal (Estrategia de Pago en Efectivo).
2. **RF24.2** Aplicar la regla de **Vencimiento Dinámico**: Establecer un plazo de tiempo límite (máximo 72h o hasta 2h antes de la recogida si es de última hora) para que el cliente acuda a la sucursal a realizar el pago.
3. **RF24.3** Ejecutar proceso automatizado en backend que cancela automáticamente la reserva (`CANCELADA_POR_TIEMPO`) si el plazo expira sin registro de pago presencial.
4. **RF24.4** Permitir al Encargado de Sucursal registrar el recaudo de dinero en efectivo desde el módulo de caja (CashCollectionPage), cambiando el estado de la reserva a **`CONFIRMADA`** y emitiendo el comprobante de pago.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF24 Cobro presencial en efectivo en sucursal con plazo de vencimiento dinámico |
| **Tipo / Actor** | Cliente Autenticado / Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Cliente: ReservationsPage | Admin/Encargado: CashCollectionPage |
| **Descripción** | Mecanismo de pago presencial para clientes que prefieren pagar en efectivo en la sucursal física con temporizador de expiración preventiva. |
| **Entrada** | 1. Selección de pago en efectivo.<br>2. Recaudo de dinero en efectivo procesado en caja por el encargado. |
| **Salida** | 1. Comprobante de caja impreso/descargable.<br>2. Confirmación inmediata del vehículo. |
| **Acción** | 1. Ejecutar cronjob de expiración de reservas en estado `PENDIENTE_EFECTIVO`. |
| **Manejo de Situaciones Anormales** | 1. Si el cliente no se presenta dentro del plazo, el vehículo se libera automáticamente en el catálogo público. |
| **Criterios de Aceptación** | 1. El temporizador de vencimiento debe mostrarse claramente en el panel del cliente. |

---

# MÓDULO 6: CONTRATOS DIGITALES, FIRMA ELECTRÓNICA Y ENTREGA CON PIN

---

### RF25: Carga y verificación documental de identidad y licencia (Cédula y Licencia)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF25.1** Habilitar la carga de archivos en formato PDF del Documento de Identidad (Cédula/Pasaporte) y Licencia de Conducción.
2. **RF25.2** Almacenar los expedientes digitales cifrados asociados a la cuenta del usuario para reutilización en alquileres futuros.
3. **RF25.3** Permitir al Encargado de Sucursal inspeccionar, aprobar o rechazar la documentación (DocumentVerificationPage).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF25 Carga y verificación documental de identidad y licencia (Cédula y Licencia) |
| **Tipo / Actor** | Cliente Autenticado / Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Cliente: Perfil de Usuario | Admin: DocumentVerificationPage |
| **Descripción** | Módulo de gestión y auditoría documental de licencias y cédulas exigidas para autorizar la entrega de vehículos. |
| **Entrada** | 1. Archivos PDF de cédula y licencia.<br>2. Dictamen del encargado (Aprobar/Rechazar). |
| **Salida** | 1. Expediente en estado `APROBADO` o `RECHAZADO` con motivo notificado. |
| **Acción** | 1. Subir archivos a `POST /api/v1/documents/upload`. |
| **Manejo de Situaciones Anormales** | 1. Si los documentos son ilegibles o están vencidos, el sistema envía una alerta al cliente para reemplazarlos. |
| **Criterios de Aceptación** | 1. Los documentos aprobados quedan guardados en la cuenta para no exigir su resubida en reservas posteriores. |

---

### RF26: Generación y firma electrónica del contrato digital de alquiler

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF26.1** Compilar el contrato digital de alquiler (ContractSigningPage) con cláusulas legales, datos de las partes, vehículo asignado, coberturas y fechas.
2. **RF26.2** Renderizar lienzo interactivo de firma manuscrita digital (SignatureCanvas) para captura de trazado por mouse o pantalla táctil.
3. **RF26.3** Registrar la marca de tiempo (timestamp), dirección IP y hash criptográfico al firmar el contrato.
4. **RF26.4** Generar el documento PDF firmado con validez jurídica para consulta y descarga por parte del cliente y la sucursal.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF26 Generación y firma electrónica del contrato digital de alquiler |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Interfaz ContractSigningPage, SignatureCanvas |
| **Descripción** | Formalización legal y firma manuscrita digital del contrato de arrendamiento vehicular de Drivique. |
| **Entrada** | 1. Trazado de firma manuscrita en lienzo digital.<br>2. Aceptación explícita de cláusulas. |
| **Salida** | 1. Contrato firmado guardado en la reserva y PDF listo para descargar. |
| **Acción** | 1. Enviar payload de firma a `POST /api/v1/contracts/{id}/sign`. |
| **Manejo de Situaciones Anormales** | 1. Si el cliente no firma el contrato, la entrega del vehículo no puede ser autorizada por la sucursal. |
| **Criterios de Aceptación** | 1. El contrato firmado incluye la firma del cliente, firma digital de Drivique e IP de trazabilidad. |

---

### RF27: Generación y verificación del código PIN de seguridad para entrega y recogida

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF27.1** Generar automáticamente un **Código PIN numérico único de 6 dígitos** (o código PIN para Nequi/Domicilio) al confirmarse la reserva.
2. **RF27.2** Desplegar el PIN en el historial de reservas del cliente (ReservationsPage) con opción de ocultar/mostrar y reenvío a su correo.
3. **RF27.3** Requerir la validación del PIN por parte del personal de la sucursal o conductor de entrega (DeliveryManagementPage) para autorizar la entrega de las llaves.
4. **RF27.4** Cambiar el estado de la reserva a **`EN_CURSO / ACTIVA`** al validar el PIN de entrega.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF27 Generación y verificación del código PIN de seguridad para entrega y recogida |
| **Tipo / Actor** | Cliente Autenticado / Encargado / Conductor de Entrega |
| **Componente / Interfaz (UI)** | Cliente: ReservationsPage | Admin: DeliveryManagementPage |
| **Descripción** | Clave de seguridad de un solo uso que garantiza que únicamente el cliente titular o autorizado pueda recibir el vehículo. |
| **Entrada** | 1. Código PIN presentado por el cliente al momento de la entrega. |
| **Salida** | 1. Entrega autorizada y cambio de estado a `EN_CURSO`. |
| **Acción** | 1. Comparar PIN digitado contra el hash en backend vía `POST /api/v1/deliveries/verify-pin`. |
| **Manejo de Situaciones Anormales** | 1. Si se ingresa un PIN incorrecto 3 veces, el sistema alerta de posible suplantación de identidad. |
| **Criterios de Aceptación** | 1. Las llaves del vehículo no se entregan sin la previa validación correcta del PIN. |

---

# MÓDULO 7: GESTIÓN DE MIS RESERVAS Y PERFIL DEL CLIENTE

---

### RF28: Historial, consulta y seguimiento de reservas del cliente

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF28.1** Renderizar la pantalla "Mis Reservas" (Gestión de Reservas -> ReservationsPage) con el listado consolidado de alquileres.
2. **RF28.2** Filtrar reservas por mes de operación y por estado (*Pendiente*, *Confirmada*, *En curso*, *Finalizada*, *Cancelada*).
3. **RF28.3** Permitir ver el detalle completo de la reserva, descargar el contrato firmado PDF (validando cédula) y visualizar el PIN de entrega.
4. **RF28.4** Ofrecer botón de cancelación de reserva con registro del motivo de anulación.
5. **RF28.5** Permitir calificar el vehículo al finalizar el alquiler (`rateVehicle`) y reportar incidencias técnicas en cualquier momento (`makeReport`).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF28 Historial, consulta y seguimiento de reservas del cliente |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Interfaz ReservationsPage |
| **Descripción** | Panel de autogestión de viajes donde el cliente consulta el historial de sus reservas, administra contratos y realiza solicitudes de cancelación o soporte. |
| **Entrada** | 1. Filtros por mes o estado.<br>2. Clics en acciones ("Ver contrato", "Cancelar", "Calificar", "Reportar"). |
| **Salida** | 1. Lista filtrada de reservas.<br>2. Modal de cancelación o redirección a contratos/soporte. |
| **Acción** | 1. Consultar reservas via `GET /api/v1/customer/reservations`. |
| **Manejo de Situaciones Anormales** | 1. Si no hay reservas registradas, se despliega una tarjeta de estado vacío con botón para explorar el catálogo. |
| **Criterios de Aceptación** | 1. Las reservas finalizadas muestran habilitada la opción de calificación por estrellas. |

---


| **Título del RF** | RF26 Pago Virtual con Wompi |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Componente WompiPaymentWidget en el Paso de Pago del Wizard |
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
| **Componente / Interfaz (UI)** | Componente CashPaymentOption, ExpirationTimerBadge |
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
| **Componente / Interfaz (UI)** | Componente DigitalSignatureCanvas, Modal DeliveryPinDisplayModal |
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
1. **RF29.1** Renderizar la pantalla de Perfil de Usuario (Perfil de Usuario).
2. **RF29.2** Mostrar datos personales: foto de perfil, nombres, apellidos, teléfono, correo y dirección de residencia.
3. **RF29.3** Permitir actualizar los campos de teléfono, dirección y foto de perfil mediante carga de archivo de imagen.
4. **RF29.4** Mantener bloqueados los campos de correo y número de documento por requerir validación oficial para cambios.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF29 Ver y editar información personal |
| **Tipo / Actor** | Cliente Autenticado |
| **Componente / Interfaz (UI)** | Interfaz UserProfilePage, EditProfileForm |
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
| **Componente / Interfaz (UI)** | Componente ChangePasswordTab en Perfil de Usuario |
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
4. **RF31.4** Redirigir al usuario a la Landing Page pública (Página de Inicio Principal).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF31 Cerrar sesión |
| **Tipo / Actor** | Cliente / Administrador Autenticado |
| **Componente / Interfaz (UI)** | Menú de Usuario -> Almacén de Autenticación |
| **Descripción** | Finalización segura de la sesión de usuario activa destruyendo las credenciales locales de la aplicación. |
| **Entrada** | 1. Clic en "Cerrar sesión". |
| **Salida** | 1. Eliminación del token JWT.<br>2. Redirección inmediata a la ruta raíz pública (Página de Inicio Principal). |
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
| **Componente / Interfaz (UI)** | Componente WelcomeOnboardingModal |
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
| **Componente / Interfaz (UI)** | Componente LiveChatWidget |
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
1. **RF34.1** Renderizar el panel de control principal (Panel del Administrador para Super Admin, Panel del Encargado de Sucursal para Sucursal).
2. **RF34.2** Desplegar métricas clave (KPIs) en tiempo real: número total de reservas activas, ingresos acumulados del mes, porcentaje de ocupación de la flota, vehículos en mantenimiento y alertas pendientes.
3. **RF34.3** Mostrar gráficos interactivos de tendencias de ingresos por mes y alquileres por categoría de vehículo.
4. **RF34.4** Incluir tabla con los accesos directos a las últimas reservas realizadas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF34 Dashboard del administrador y sucursal |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Rutas Panel del Administrador y Panel del Encargado de Sucursal -> AdminDashboardPage, KPICardGroup, RevenueChart |
| **Descripción** | Centro de mando gerencial y operativo que presenta resúmenes estadísticos e indicadores de rendimiento de Drivique. |
| **Entrada** | 1. Carga de la ruta del dashboard. |
| **Salida** | 1. Renderizado de tarjetas KPI, gráficos estadísticos y tablas de actividad reciente. |
| **Acción** | 1. Consultar `GET /api/v1/admin/dashboard-stats`. |
| **Manejo de Situaciones Anormales** | 1. Si la carga de gráficos falla, las tarjetas numéricas siguen funcionando de forma independiente. |
| **Criterios de Aceptación** | 1. Las cifras presentadas coinciden exactamente con los registros contables de la base de datos. |

---

### RF35: Gestión de ciudades

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF35.1** Renderizar la pantalla de administración de ciudades (Módulo de Gestión de Ciudades).
2. **RF35.2** Permitir listar, crear, editar y desactivar ciudades donde opera Drivique.
3. **RF35.3** Capturar nombre de la ciudad, departamento, código postal y estado operativo (Activa/Inactiva).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF35 Gestión de ciudades |
| **Tipo / Actor** | Super Administrador |
| **Componente / Interfaz (UI)** | Interfaz ManageCitiesPage, CityModal |
| **Descripción** | Módulo para la configuración de la cobertura geográfica de la plataforma Drivique. |
| **Entrada** | 1. Formulario de datos de la ciudad. |
| **Salida** | 1. Lista de ciudades actualizada.<br>2. Habilitación de la ciudad en los filtros del catálogo de clientes. |
| **Acción** | 1. Transmitir a `POST/PUT /api/v1/admin/cities`. |
| **Manejo de Situaciones Anormales** | 1. No se permite desactivar una ciudad que tenga sucursales con reservas activas en curso. |
| **Criterios de Aceptación** | 1. La desactivación de una ciudad oculta automáticamente sus sucursales en el catálogo. |

---

### RF36: Gestión de Sucursales

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF36.1** Renderizar la vista de gestión de sucursales (Módulo de Gestión de Sucursales).
2. **RF36.2** Permite crear, modificar y deshabilitar sucursales físicas.
3. **RF36.3** Capturar nombre de sucursal, ciudad asociada, dirección exacta, coordenadas de mapa (latitud/longitud), teléfono, correo y horarios de atención.
4. **RF36.4** Asignar el Encargado de Sucursal responsable de la sede.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF36 Gestión de Sucursales |
| **Tipo / Actor** | Super Administrador |
| **Componente / Interfaz (UI)** | Interfaz ManageBranchesPage, BranchFormModal |
| **Descripción** | Administración de las sedes operativas físicas donde se realiza la entrega y recepción de la flota de vehículos. |
| **Entrada** | 1. Información técnica de la sede y asignación de personal. |
| **Salida** | 1. Sucursal registrada e integrada en los mapas y buscadores de la app. |
| **Acción** | 1. Enviar datos a `POST/PUT /api/v1/admin/branches`. |
| **Manejo de Situaciones Anormales** | 1. Si se intenta borrar una sucursal con vehículos asignados, se exige primero reasignar la flota a otra sede. |
| **Criterios de Aceptación** | 1. La ubicación ingresada debe ser geolocalizada correctamente en el mapa de sucursales. |

---

### RF37: Gestión de vehículos (Flota)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF37.1** Renderizar la pantalla de gestión de flota (Módulo de Gestión de Flota).
2. **RF37.2** Permitir registrar nuevos vehículos, editar especificaciones, actualizar tarifas por día y gestionar imágenes de la galería.
3. **RF37.3** Capturar placa, marca, modelo, año, categoría, color, tipo de transmisión, combustible, capacidad, kilometraje actual, sucursal asignada y precio por día.
4. **RF37.4** Administrar los estados del vehículo: *Disponible*, *Reservado*, *En Mantenimiento*, *Fuera de Servicio*.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF37 Gestión de vehículos (Flota) |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz ManageFleetPage, VehicleFormModal |
| **Descripción** | Control integral de la flota vehicular de Drivique, incluyendo altas, bajas, fotos, precios y estados operativos. |
| **Entrada** | 1. Ficha técnica del vehículo y archivos de fotos en alta resolución. |
| **Salida** | 1. Vehículo creado o actualizado en el catálogo global de la plataforma. |
| **Acción** | 1. Transmitir datos multipart a `POST/PUT /api/v1/admin/vehicles`. |
| **Manejo de Situaciones Anormales** | 1. Si la placa ya está registrada, la API devuelve error impidiendo duplicados en la flota. |
| **Criterios de Aceptación** | 1. Todo vehículo disponible debe contar con al menos 3 imágenes y tarifa diaria válida. |

---

### RF38: Gestión de reservas

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF38.1** Renderizar el panel operativo de gestión de reservas (Módulo de Gestión de Reservas).
2. **RF38.2** Visualizar la totalidad de las reservas con filtros por estado, rango de fechas, sucursal, código o documento del cliente.
3. **RF38.3** Permite consultar el expediente completo de cada reserva: datos del cliente, vehículo, contrato PDF, pagos realizados y PIN de entrega.
4. **RF38.4** Permitir modificar estados de reserva, procesar devoluciones o autorizar cancelaciones administrativas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF38 Gestión de reservas |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz ManageReservationsPage, ReservationDetailModal |
| **Descripción** | Consola de supervisión y gestión operativa del ciclo de vida de todas las reservas registradas en el sistema. |
| **Entrada** | 1. Parámetros de búsqueda o acciones de actualización de estado. |
| **Salida** | 1. Modificación del expediente de reserva y notificación automática al cliente. |
| **Acción** | 1. Transmitir a `PUT /api/v1/admin/reservations/:id/status`. |
| **Manejo de Situaciones Anormales** | 1. Toda modificación manual de estado por un administrador debe registrar la razón justificada en el log de auditoría. |
| **Criterios de Aceptación** | 1. Las búsquedas de reservas se ejecutan en tiempo real sobre la base de datos central. |

---

### RF39: Gestión de usuarios y clientes

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF39.1** Renderizar la lista de clientes registrados (Módulo de Lista de Clientes).
2. **RF39.2** Permite buscar usuarios por correo, nombre o documento de identidad.
3. **RF39.3** Visualizar el historial de reservas de un cliente, estado de cuenta y documentos adjuntos.
4. **RF39.4** Permitir bloquear o deshabilitar cuentas de usuarios por incumplimiento de términos o fraude.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF39 Gestión de usuarios y clientes |
| **Tipo / Actor** | Super Administrador |
| **Componente / Interfaz (UI)** | Interfaz ManageUsersPage, UserProfileDetailModal |
| **Descripción** | Módulo de administración de la base de usuarios y clientes de la plataforma Drivique. |
| **Entrada** | 1. Filtros de búsqueda o cambios de estado en la cuenta de usuario. |
| **Salida** | 1. Bloqueo/desbloqueo de accesos de clientes. |
| **Acción** | 1. Enviar petición a `PUT /api/v1/admin/users/:id/block`. |
| **Manejo de Situaciones Anormales** | 1. Al bloquear un usuario, sus reservas activas futuras se cancelan automáticamente. |
| **Criterios de Aceptación** | 1. La desactivación de una cuenta impide el login inmediato del usuario. |

---

### RF40: Gestión de administradores, roles y permisos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF40.1** Renderizar la pantalla de gestión de administradores y seguridad (Módulo de Roles y Seguridad).
2. **RF40.2** Permite dar de alta a nuevos Super Administradores y Encargados de Sucursal.
3. **RF40.3** Configurar la matriz de permisos por rol asignando accesos específicos a módulos del sistema.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF40 Gestión de administradores, roles y permisos |
| **Tipo / Actor** | Super Administrador |
| **Componente / Interfaz (UI)** | Interfaz ManageRolesPage, AdminUserModal |
| **Descripción** | Control centralizado del acceso basado en roles (RBAC) para el personal operativo de Drivique. |
| **Entrada** | 1. Registro de personal administrativo y selección de permisos. |
| **Salida** | 1. Asignación de credenciales administrativas y roles en el sistema. |
| **Acción** | 1. Transmitir datos a `POST /api/v1/admin/staff`. |
| **Manejo de Situaciones Anormales** | 1. Un administrador no puede eliminarse a sí mismo ni revocar su propio rol de Super Administrador. |
| **Criterios de Aceptación** | 1. Los cambios en los permisos tienen efecto inmediato en la siguiente petición del usuario afectado. |

---

### RF41: Gestión de reportes de incidencias de vehículos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF41.1** Renderizar la consola de gestión de incidencias (Módulo de Gestión de Incidencias).
2. **RF41.2** Permite registrar reportes de fallas mecánicas, accidentes, rayones o siniestros sufridos por la flota.
3. **RF41.3** Capturar descripción de la incidencia, fotos del daño, vehículo afectado, costo estimado de reparación y estado del reporte (*En Revisión*, *En Taller*, *Resuelto*).
4. **RF41.4** Cambiar automáticamente el estado del vehículo a "En Mantenimiento" si la incidencia invalida su uso.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF41 Gestión de reportes de incidencias de vehículos |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz ManageIncidentsPage, IncidentReportModal |
| **Descripción** | Módulo para el control de averías, siniestros y mantenimientos correctivos de la flota vehicular. |
| **Entrada** | 1. Reporte de avería con fotos y detalles técnicos. |
| **Salida** | 1. Registro de la incidencia y actualización del estado del vehículo a `MAINTENANCE`. |
| **Acción** | 1. Transmitir el informe a `POST /api/v1/incidents`. |
| **Manejo de Situaciones Anormales** | 1. Si el vehículo reportado tiene una reserva próxima en las siguientes 24 horas, el sistema alerta de inmediato para reasignar otro vehículo al cliente. |
| **Criterios de Aceptación** | 1. Todo reporte exige adjuntar soporte fotográfico del daño. |

---

### RF42: Gestión de contratos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF42.1** Renderizar la plantilla y repositorio de contratos de alquiler (Módulo de Contratos).
2. **RF42.2** Permite visualizar, buscar y volver a descargar todos los contratos digitales firmados por los clientes.
3. **RF42.3** Permite a los administradores actualizar las cláusulas legales y términos del contrato base de Drivique.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF42 Gestión de contratos |
| **Tipo / Actor** | Super Administrador |
| **Componente / Interfaz (UI)** | Interfaz ManageContractsPage |
| **Descripción** | Custodia y administración de los documentos legales de alquiler generados por la plataforma. |
| **Entrada** | 1. Búsqueda de contratos por folio o actualización de plantilla legal. |
| **Salida** | 1. Repositorio de PDFs descargables y actualización de versión de contrato legal. |
| **Acción** | 1. Consultar `GET /api/v1/admin/contracts`. |
| **Manejo de Situaciones Anormales** | 1. Los contratos previamente firmados por clientes mantienen de forma inmutable la versión de cláusulas vigente al momento de su firma. |
| **Criterios de Aceptación** | 1. Los contratos se almacenan cifrados con sello de integridad temporal. |

---

### RF43: Gestión de promociones, cupones y ofertas destacadas

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF43.1** Renderizar la consola de gestión de marketing, cupones y promociones (Módulo de Ofertas y Promociones).
2. **RF43.2** Creación y parametrización de **Cupones de Descuento**: Permitir al Super Administrador y al Encargado de Sucursal definir cupones por porcentaje o por monto fijo en COP, estableciendo el código alfanumérico, fecha de inicio, fecha de expiración, límite de usos acumulados, límite de canjes por usuario y monto mínimo de reserva.
3. **RF43.3** Creación y publicación de **Promociones Destacadas**: Gestionar campañas publicitarias visuales (banners dinámicos, tarjetas de oferta y viñetas promocionales) expuestas en la Landing Page principal y en las vitrinas del Catálogo de Vehículos.
4. **RF43.4** Conversión de Cupones a Promociones Destacadas: Permitir al administrador o encargado de sucursal seleccionar cualquier cupón existente y promoverlo dinámicamente al estado de "Promoción Destacada", generando la tarjeta de anuncio pública en la interfaz comercial para que los clientes puedan visualizar e interactuar directamente con el beneficio sin necesidad de ingresar manualmente el código alfanumérico.
5. **RF43.5** Control de ámbito territorial y sucursal: Permitir asociar la validez de los cupones y promociones destacadas a una sucursal física específica o habilitarlos para la operación nacional.
6. **RF43.6** Auditoría y métricas de rendimiento: Registrar el conteo en tiempo real de canjes por cupón, importe acumulado descontado y rentabilidad de las promociones destacadas activas.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF43 Gestión de promociones, cupones y ofertas destacadas |
| **Tipo / Actor** | Super Administrador / Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz ManagePromotionsPage, CouponFormModal, FeaturedPromoCard |
| **Descripción** | Creación, segmentación y administración de incentivos comerciales (cupones alfanuméricos) y promociones destacadas, permitiendo la transformación directa de cupones a ofertas visuales de alto impacto en las vitrinas públicas de la plataforma. |
| **Entrada** | 1. Parámetros de cupones (código, tipo de descuento, tope de uso, vigencia).<br>2. Acción de conversión "Destacar Cupón en Vitrina Principal".<br>3. Filtro por sucursal aplicable. |
| **Salida** | 1. Registro del cupón en la base de datos.<br>2. Banner o tarjeta promocional visible en la Landing Page y Catálogo.<br>3. Aplicación automática o manual del descuento en la pasarela del checkout. |
| **Acción** | 1. Transmitir reglas a la API REST de promociones (`POST/PUT /api/v1/promotions/coupons`).<br>2. Invocar endpoint de conversión a destacada (`PATCH /api/v1/promotions/coupons/{id}/feature`). |
| **Manejo de Situaciones Anormales** | 1. Si se intenta activar una promoción destacada con fecha expirada, el sistema la rechaza e indica la inconsistencia.<br>2. Si dos cupones activos poseen el mismo código alfanumérico en una misma sucursal, el sistema bloquea el duplicado. |
| **Criterios de Aceptación** | 1. Los cupones convertidos a "Promoción Destacada" se muestran de inmediato en la Landing Page y el Catálogo.<br>2. El Encargado de Sucursal solo puede crear o destacar cupones dentro del ámbito de su sucursal asignada.<br>3. Los cupones caducan automáticamente al agotar su cupo de usos o fecha límite. |

---

### RF44: Reportes administrativos

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF44.1** Renderizar el centro de analítica y reportes (Módulo de Reportes y Estadísticas).
2. **RF44.2** Permitir generar reportes consolidados de ingresos financieros, utilización de flota, efectividad de sucursales e historial de alquileres.
3. **RF44.3** Ofrecer filtros por rango de fechas personalizable y exportación de informes en formatos Excel (XLSX), CSV y PDF.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF44 Reportes administrativos |
| **Tipo / Actor** | Super Administrador |
| **Componente / Interfaz (UI)** | Interfaz ReportsPage, ReportExportWidget |
| **Descripción** | Generación de informes financieros y operativos para la toma de decisiones estratégicas. |
| **Entrada** | 1. Tipo de reporte deseado y rango de fechas. |
| **Salida** | 1. Archivo descargable en formato Excel, CSV o PDF. |
| **Acción** | 1. Compilar datos relacionales y generar binario de reporte en backend. |
| **Manejo de Situaciones Anormales** | 1. Si la consulta de reporte abarca un periodo mayor a 1 año, el sistema encola la tarea y la envía al correo del administrador. |
| **Criterios de Aceptación** | 1. Los reportes financieros incluyen la discriminación exacta de impuestos e ingresos netos. |

---

### RF45: Configuración de marca e identidad visual

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF45.1** Renderizar el panel de personalización de marca (Módulo de Configuración de Marca).
2. **RF45.2** Permitir actualizar el logo corporativo de Drivique, favicon, paleta de colores primarios y secundarios del sistema visual.
3. **RF45.3** Configurar datos de contacto globales, enlaces de redes sociales y texto de la propuesta de valor.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF45 Configuración de marca e identidad visual |
| **Tipo / Actor** | Super Administrador |
| **Componente / Interfaz (UI)** | Interfaz BrandSettingsPage |
| **Descripción** | Administración de los assets gráficos y parámetros de identidad de marca de la plataforma. |
| **Entrada** | 1. Archivos de logo, favicon y valores de color en hexadecimal. |
| **Salida** | 1. Actualización de la apariencia visual de la plataforma cliente y correos. |
| **Acción** | 1. Actualizar las variables globales de configuración en la BD. |
| **Manejo de Situaciones Anormales** | 1. El sistema conserva una copia de respaldo de la marca por defecto para restaurarla en caso de error. |
| **Criterios de Aceptación** | 1. Los cambios de logo se reflejan inmediatamente en el encabezado y pie de página. |

---

### RF46: Auditoría y registro de actividad

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF46.1** Renderizar la consola de auditoría de seguridad (Consola de Auditoría).
2. **RF46.2** Registrar de forma inmutable todas las operaciones críticas realizadas en el sistema (inicios de sesión, cambios de precio, cancelaciones de reserva, modificaciones de roles, pagos aprobados).
3. **RF46.3** Grabar marca de tiempo exacto, dirección IP origen, usuario ejecutor, módulo afectado y detalle del cambio (valor anterior vs valor nuevo).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF46 Auditoría y registro de actividad |
| **Tipo / Actor** | Super Administrador / Auditor de Sistema |
| **Componente / Interfaz (UI)** | Interfaz AuditLogsPage |
| **Descripción** | Bitácora inalterable de eventos de seguridad y transacciones operativas para trazabilidad y cumplimiento legal. |
| **Entrada** | 1. Eventos del sistema registrados automáticamente. |
| **Salida** | 1. Tabla de logs con filtros por usuario, fecha o tipo de acción. |
| **Acción** | 1. Grabar registros en la tabla de auditoría en la base de datos sin permisos de modificación ni borrado. |
| **Manejo de Situaciones Anormales** | 1. Los registros de auditoría no pueden ser eliminados por ningún usuario del sistema, ni siquiera por el Super Administrador. |
| **Criterios de Aceptación** | 1. Cada transacción deja una huella digital no repudiable en la bitácora de auditoría. |

---

### RF47: Confirmación de pago en efectivo (sucursal)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF47.1** Renderizar el módulo de caja para el Encargado de Sucursal (Módulo de Caja de Sucursal).
2. **RF47.2** Permitir al encargado buscar reservas en estado "Pendiente de Pago en Efectivo" por código de reserva o cédula del cliente.
3. **RF47.3** Registrar la recepción del dinero en efectivo en la caja de la sucursal.
4. **RF47.4** Cambiar el estado de la reserva a "PAGADA y CONFIRMADA", cancelando el temporizador de vencimiento dinámico y emitiendo el recibo de caja digital.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF47 Confirmación de pago en efectivo (sucursal) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz BranchCashierPage, CashPaymentReceiptModal |
| **Descripción** | Registro en caja física de la recepción de dinero en efectivo para reservas con vencimiento dinámico. |
| **Entrada** | 1. Código de reserva o cédula del cliente.<br>2. Confirmación de recepción de dinero en efectivo. |
| **Salida** | 1. Reserva actualizada a `PAID`.<br>2. Recibo de caja emitido y enviado por correo al cliente. |
| **Acción** | 1. Transmitir a `POST /api/v1/branch/cash-payments/confirm`. |
| **Manejo de Situaciones Anormales** | 1. Si la reserva ya había sido cancelada automáticamente por vencimiento, el sistema advierte que el plazo caducó y exige reactivar la reserva si hay flota disponible. |
| **Criterios de Aceptación** | 1. La confirmación del pago en caja desactiva de inmediato el contador regresivo de expiración. |

---

### RF48: Centro de notificaciones operativas de sucursal (`BranchNotificationCenterPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF48.1** Renderizar la pantalla de notificaciones de la sucursal (Centro de Notificaciones de Sucursal).
2. **RF48.2** Mostrar alertas en tiempo real sobre nuevas reservas asignadas a la sede, devoluciones del día, vencimientos próximos de pagos en efectivo y reportes de averías.
3. **RF48.3** Filtrar alertas por nivel de urgencia (*Alta*, *Media*, *Informativa*).

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF48 Centro de notificaciones operativas de sucursal (`BranchNotificationCenterPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz BranchNotificationCenterPage |
| **Descripción** | Tablero de alertas operativas para el personal de sucursal enfocado en las tareas diarias de entregas y recepciones. |
| **Entrada** | 1. Flujo de eventos operativos de la sucursal. |
| **Salida** | 1. Alertas visuales y sonoras en tiempo real para el encargado de la sede. |
| **Acción** | 1. Conexión a canal WebSocket de la sucursal. |
| **Manejo de Situaciones Anormales** | 1. Las notificaciones de devoluciones atrasadas se marcan en rojo persistente con sonido de alerta. |
| **Criterios de Aceptación** | 1. El encargado recibe la alerta de una nueva reserva en menos de 1 segundo tras ser creada. |

---

### RF49: Moderación y respuesta a reseñas de sucursal (`BranchReviewsPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF49.1** Renderizar el panel de calificaciones y comentarios de la sucursal (Moderación de Reseñas de Sucursal).
2. **RF49.2** Mostrar el listado de reseñas enviadas por los clientes que alquilaron vehículos en dicha sede, exhibiendo fotos adjuntas y puntuaciones.
3. **RF49.3** Permitir al Encargado de Sucursal emitir una respuesta oficial inmutable que se publicará debajo de la reseña del cliente en el catálogo público.
4. **RF49.4** Reportar al Super Administrador reseñas con lenguaje ofensivo para su moderación.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF49 Moderación y respuesta a reseñas de sucursal (`BranchReviewsPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz BranchReviewsPage, OfficialResponseModal |
| **Descripción** | Gestión de reputación donde la sucursal interactúa respondiendo a los comentarios y opiniones de los clientes. |
| **Entrada** | 1. Formulario de respuesta oficial de la sucursal. |
| **Salida** | 1. Publicación de la respuesta oficial en la ficha del vehículo y catálogo público. |
| **Acción** | 1. Transmitir a `POST /api/v1/branch/reviews/:id/reply`. |
| **Manejo de Situaciones Anormales** | 1. Una respuesta de sucursal no puede ser editada ni borrada tras ser publicada para garantizar transparencia. |
| **Criterios de Aceptación** | 1. La respuesta oficial se vincula de forma inmutable con la reseña original del cliente. |

---

### RF50: Inspección y entrega del vehículo (`DeliveryManagementPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF50.1** Renderizar el módulo de entrega de vehículos (Protocolo de Inspección y Entrega).
2. **RF50.2** Desplegar la lista de entregas programadas para el día actual.
3. **RF50.3** Incluir formulario de acta de inspección inicial: nivel de combustible, kilometraje de salida, estado de llantas, kit de carretera y marcado visual de rayones previos en diagrama 3D/2D del auto.
4. **RF50.4** Capturar fotografías en tiempo real del estado de entrega del vehículo.
5. **RF50.5** Validar el PIN de entrega del cliente para formalizar el traspaso del vehículo.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF50 Inspección y entrega del vehículo (`DeliveryManagementPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz DeliveryManagementPage, InspectionChecklist |
| **Descripción** | Protocolo de entrega del vehículo que documenta rigurosamente su estado físico y mecánico antes de salir de la sede. |
| **Entrada** | 1. Datos de kilometraje, combustible, fotos de inspección y PIN de entrega. |
| **Salida** | 1. Acta de entrega firmada digitalmente y cambio de estado a `IN_PROGRESS`. |
| **Acción** | 1. Enviar checklist y fotos a `POST /api/v1/branch/deliveries/complete`. |
| **Manejo de Situaciones Anormales** | 1. Si el vehículo presenta una falla durante la inspección previa a la entrega, el sistema exige reasignar otra unidad de la flota. |
| **Criterios de Aceptación** | 1. El proceso requiere obligatoriamente tomar al menos 4 fotos de inspección de los 4 costados del vehículo. |

---

### RF51: Perfil Público y Operativo de Sucursal (`BranchProfilePage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF51.1** Renderizar la pantalla de perfil operativo de la sucursal (Perfil Operativo de Sucursal).
2. **RF51.2** Permitir al encargado actualizar la información operativa de la sede: teléfonos de atención inmediata, fotos del local, instructivo de llegada y avisos a los clientes.
3. **RF51.3** Consultar el mapa de cobertura y el resumen de flota asignada a la sede.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF51 Perfil Público y Operativo de Sucursal (`BranchProfilePage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz BranchProfilePage |
| **Descripción** | Configuración de la ficha informativa de la sucursal que se muestra a los clientes durante el proceso de reserva. |
| **Entrada** | 1. Datos de contacto, fotos de la fachada de la sucursal e instrucciones de entrega. |
| **Salida** | 1. Perfil de sucursal actualizado en la vista de cliente. |
| **Acción** | 1. Transmitir a `PUT /api/v1/branch/profile`. |
| **Manejo de Situaciones Anormales** | 1. Los cambios de ubicación geográfica o dirección física requieren la aprobación final del Super Administrador. |
| **Criterios de Aceptación** | 1. Las fotos de la sucursal se actualizan de forma inmediata en las guías de llegada del cliente. |

---

### RF52: Validación de Entrega con PIN Nequi (`BranchPinValidationModal`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF52.1** Renderizar modal de verificación de PIN en la consola de la sucursal (BranchPinValidationModal).
2. **RF52.2** Solicitar la digitación del PIN seguro de entrega presentado por el cliente en su teléfono móvil.
3. **RF52.3** Validar el PIN contra la base de datos central encriptada.
4. **RF52.4** Desbloquear la autorización de entrega del vehículo tras coincidencia exitosa del PIN.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF52 Validación de Entrega con PIN Nequi (`BranchPinValidationModal`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Modal BranchPinValidationModal en la vista de entregas |
| **Descripción** | Componente de seguridad que actúa como cerradura digital para autorizar la liberación física de las llaves del vehículo. |
| **Entrada** | 1. PIN de 4 a 6 dígitos ingresado en el teclado numérico del modal. |
| **Salida** | 1. Autorización concedida o rechazada de entrega. |
| **Acción** | 1. Validar el PIN seguro en `POST /api/v1/branch/validate-pin`. |
| **Manejo de Situaciones Anormales** | 1. Ante 3 intentos fallidos de PIN, la reserva se bloquea preventivamente notificando al cliente por seguridad. |
| **Criterios de Aceptación** | 1. La respuesta de validación del PIN debe ejecutarse en menos de 300 milisegundos. |

---

### RF53: Formulario de Inspección de Devolución (`ReturnInspectionPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF53.1** Renderizar el módulo de recepción de vehículos (Formulario de Inspección de Devolución).
2. **RF53.2** Registrar el recibo del vehículo comprobando: fecha y hora de entrega real, kilometraje final, nivel de combustible de retorno y limpiezas.
3. **RF53.3** Comparar el estado de devolución contra la inspección inicial (RF50) para detectar nuevos daños, rayones o faltantes.
4. **RF53.4** Calcular automáticamente cargos adicionales en caso de excedente de kilometraje, falta de combustible, entregas tardías o daños.
5. **RF53.5** Emitir el paz y salvo de devolución al cliente y cambiar el estado del vehículo a "Disponible".

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF53 Formulario de Inspección de Devolución (`ReturnInspectionPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz ReturnInspectionPage, ReturnChecklist |
| **Descripción** | Recepción oficial del vehículo alquilado, evaluación de estado de retorno y liquidación de posibles penalizaciones o cargos extra. |
| **Entrada** | 1. Datos de recepción: kilometraje, combustible, fotos de retorno y registro de novedades. |
| **Salida** | 1. Cierre definitivo de la reserva (`COMPLETED`), paz y salvo al cliente y retorno del auto a disponibilidad. |
| **Acción** | 1. Transmitir formulario a `POST /api/v1/branch/returns/complete`. |
| **Manejo de Situaciones Anormales** | 1. Si se detectan daños no reportados en la entrega inicial, se abre automáticamente un reporte de incidencia (RF41) vinculado a la reserva. |
| **Criterios de Aceptación** | 1. La liquidación de sobrantes o cobros por faltantes de combustible se calcula automáticamente según las tarifas estándar de Drivique. |

---

### RF54: Gestión de Cupones Promocionales por Sucursal (`BranchCouponsPage`)

#### PARTE 1: DESGLOSE EXHAUSTIVO DE SUB-REQUERIMIENTOS
1. **RF54.1** Renderizar la pantalla de cupones específicos de la sucursal (Módulo de Cupones de Sucursal).
2. **RF54.2** Permitir al Encargado de Sucursal gestionar y activar promociones locales exclusivas para la flota asignada a su sede.
3. **RF54.3** Monitorear el nivel de redención de cupones locales y su impacto en las reservas de la sucursal.

#### PARTE 2: FICHA TÉCNICA DETALLADA (TABLA IEEE 830)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Título del RF** | RF54 Gestión de Cupones Promocionales por Sucursal (`BranchCouponsPage`) |
| **Tipo / Actor** | Encargado de Sucursal |
| **Componente / Interfaz (UI)** | Interfaz BranchCouponsPage |
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
| **RF1** | Página de inicio (visitante sin sesión) | Landing Page | Visitante | Página de Inicio -> LandingPage |
| **RF2** | Redirección tras inicio de sesión | Landing Page | Cliente/Admin/Encargado | ProtectedRoute, Almacén de Autenticación |
| **RF3** | Registro de usuario | Autenticación | Visitante | Formulario de Registro -> RegisterPage |
| **RF4** | Verificación de identidad 2FA (Código OTP) | Autenticación | Usuario en Registro | Pantalla de Verificación 2FA -> Verify2FAPage |
| **RF5** | Inicio de sesión | Autenticación | Cliente | Formulario de Inicio de Sesión -> LoginPage |
| **RF6** | Recuperar contraseña | Autenticación | Cliente | Pantalla de Recuperación de Contraseña -> ForgotPasswordPage |
| **RF7** | Inicio de sesión con rol | Autenticación | Super Admin / Encargado | Rúter Principal -> RoleBasedGuard |
| **RF8** | Acceso modo invitado sin registro | Autenticación | Visitante | Catálogo de Vehículos, Modal Emergente de Detalle de Vehículo |
| **RF9** | Encabezado y buscador del catálogo | Catálogo | Cliente / Visitante | Catálogo de Vehículos -> CatalogHeader |
| **RF10** | Filtros del catálogo | Catálogo | Cliente / Visitante | CatalogSidebarFilters |
| **RF11** | Ordenar resultados del catálogo | Catálogo | Cliente / Visitante | CatalogSortDropdown |
| **RF12** | Tarjetas de vehículos | Catálogo | Cliente / Visitante | VehicleCard |
| **RF13** | Ver detalles de un vehículo | Catálogo | Cliente / Visitante | Modal Emergente de Detalle de Vehículo -> VehicleDetailsModal |
| **RF14** | Menú de navegación principal catálogo | Catálogo | Cliente Autenticado | CustomerNavbar |
| **RF15** | Sección menú Mis Reservas | Catálogo | Cliente Autenticado | Mis Reservas -> MyReservationsPage |
| **RF16** | Sección menú Mis Favoritos | Catálogo | Cliente Autenticado | Catálogo de Favoritos -> FavoritesPage |
| **RF17** | Sección menú Notificaciones | Catálogo | Cliente Autenticado | Centro de Notificaciones -> CustomerNotificationsPage |
| **RF18** | Sección menú Soporte | Catálogo | Cliente / Visitante | Centro de Soporte -> SupportCenterPage |
| **RF19** | Ficha informativa del vehículo a reservar | Flujo Reservas | Cliente Autenticado | CheckoutVehicleHeader |
| **RF20** | Selección de fechas y lugar (Paso 1) | Flujo Reservas | Cliente Autenticado | Paso 1 del Wizard de Reserva -> CheckoutStep1DatesPage |
| **RF21** | Resumen de la reserva (Panel Lateral) | Flujo Reservas | Cliente Autenticado | ReservationSummaryPanel |
| **RF22** | Selección de protección (Paso 2 Coberturas) | Flujo Reservas | Cliente Autenticado | CoverageSelectionGroup |
| **RF23** | Tipo de kilometraje y extras (Paso 2 Extras) | Flujo Reservas | Cliente Autenticado | ExtrasSelectionGroup |
| **RF24** | Datos personales (Paso 3 Formulario) | Flujo Reservas | Cliente Autenticado | DriverDetailsForm |
| **RF25** | Verificación documental (Paso 3 Documentos)| Flujo Reservas | Cliente Autenticado | DocumentUploadStep |
| **RF26** | Pago Virtual con Wompi | Pagos | Cliente Autenticado | WompiPaymentWidget |
| **RF27** | Pago en Efectivo con Vencimiento Dinámico | Pagos | Cliente / Sistema | CashPaymentOption, TimerBadge |
| **RF28** | Firma de contrato y PIN de entrega | Contratos & PIN | Cliente / Encargado | DigitalSignatureCanvas, Modal PIN |
| **RF29** | Ver y editar información personal | Perfil Cliente | Cliente Autenticado | Perfil de Usuario -> UserProfilePage |
| **RF30** | Cambiar contraseña | Perfil Cliente | Cliente Autenticado | ChangePasswordTab |
| **RF31** | Cerrar sesión | Perfil Cliente | Cliente / Admin | Menú de Usuario -> Almacén de Autenticación |
| **RF32** | Onboarding para nuevos usuarios | Transversal | Cliente Nuevo | WelcomeOnboardingModal |
| **RF33** | Chat flotante de soporte (Tawk.to) | Transversal | Cliente / Visitante | LiveChatWidget |
| **RF34** | Dashboard del administrador y sucursal | Admin Web | Super Admin / Encargado | Consola Principal -> AdminDashboard |
| **RF35** | Gestión de ciudades | Admin Web | Super Admin | Módulo de Gestión de Ciudades -> ManageCitiesPage |
| **RF36** | Gestión de Sucursales | Admin Web | Super Admin | Módulo de Gestión de Sucursales -> ManageBranchesPage |
| **RF37** | Gestión de vehículos (Flota) | Admin Web | Super Admin / Encargado | Módulo de Gestión de Flota -> ManageFleetPage |
| **RF38** | Gestión de reservas | Admin Web | Super Admin / Encargado | Módulo de Gestión de Reservas -> ManageReservationsPage |
| **RF39** | Gestión de usuarios y clientes | Admin Web | Super Admin | Módulo de Lista de Clientes -> ManageUsersPage |
| **RF40** | Gestión de administradores y permisos | Admin Web | Super Admin | Módulo de Roles y Seguridad -> ManageRolesPage |
| **RF41** | Gestión de reportes de incidencias | Admin Web | Super Admin / Encargado | Módulo de Gestión de Incidencias -> ManageIncidentsPage |
| **RF42** | Gestión de contratos | Admin Web | Super Admin | Módulo de Contratos -> ManageContractsPage |
| **RF43** | Gestión de promociones y cupones | Admin Web | Super Admin | Módulo de Ofertas y Promociones -> ManagePromotionsPage |
| **RF44** | Reportes administrativos | Admin Web | Super Admin | Módulo de Reportes y Estadísticas -> ReportsPage |
| **RF45** | Configuración de marca e identidad visual | Admin Web | Super Admin | Módulo de Configuración de Marca -> BrandSettingsPage |
| **RF46** | Auditoría y registro de actividad | Admin Web | Super Admin / Auditor | Consola de Auditoría -> AuditLogsPage |
| **RF47** | Confirmación de pago en efectivo (sucursal)| Sucursal Web | Encargado de Sucursal | Módulo de Caja de Sucursal -> BranchCashierPage |
| **RF48** | Centro de notificaciones operativas | Sucursal Web | Encargado de Sucursal | Centro de Notificaciones de Sucursal -> BranchNotificationCenterPage |
| **RF49** | Moderación y respuesta a reseñas | Sucursal Web | Encargado de Sucursal | Moderación de Reseñas de Sucursal -> BranchReviewsPage |
| **RF50** | Inspección y entrega del vehículo | Sucursal Web | Encargado de Sucursal | Protocolo de Inspección y Entrega -> DeliveryManagementPage |
| **RF51** | Perfil Público y Operativo de Sucursal | Sucursal Web | Encargado de Sucursal | Perfil Operativo de Sucursal -> BranchProfilePage |
| **RF52** | Validación de Entrega con PIN Nequi | Sucursal Web | Encargado de Sucursal | Modal BranchPinValidationModal |
| **RF53** | Formulario Inspección de Devolución | Sucursal Web | Encargado de Sucursal | Formulario Inspección de Devolución -> ReturnInspectionPage |
| **RF54** | Gestión de Cupones Promocionales Sucursal| Sucursal Web | Encargado de Sucursal | Módulo de Cupones de Sucursal -> BranchCouponsPage |

---
*Especificación Completa de Requerimientos Funcionales (`functional-requirements.md`) elaborada bajo el Estándar IEEE 830-1998 para el proyecto Drivique.*
