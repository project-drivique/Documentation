# 📋 Requerimientos Funcionales — Drivique

Este documento especifica los Requerimientos Funcionales (RF) de la plataforma **Drivique** (App Móvil y Panel Web de Administración), extraídos de la lógica de negocio y las interfaces del sistema. Cada requerimiento sigue el formato estándar oficial del SRS (`Tipo`, `Descripción`, `Entrada`, `Salida`, `Acción` y `Criterio de Aceptación`).

---

## 🟢 Módulo 1: Landing Page y Navegación Pública

### RF1: Página de inicio (visitante sin sesión)
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante (Sin Autenticar) |
| **Descripción** | Página pública para visitantes sin sesión activa: presenta la plataforma Drivique (sección Hero, vehículos destacados, pasos de cómo funciona, beneficios y footer) junto con un menú de navegación fijo. |
| **Entrada** | Carga de la URL raíz (`/`) sin sesión activa; clics en botones de acción y menú de navegación. |
| **Salida** | Renderizado de la Landing Page responsiva; menú desplegable hamburguesa en dispositivos móviles; modal de inicio de sesión o registro al hacer clic en los botones de conversión. |
| **Acción** | Cargar secciones promocionales adaptadas al dispositivo y restringir acciones privadas solicitando autenticación. |
| **Criterio de Aceptación** | 1. Carga inicial en menos de 3 segundos.<br>2. Interfaz adaptable a escritorio, tabletas y móviles.<br>3. Botones de conversión redirigen a modales/vistas de Login/Registro. |

### RF2: Redirección tras inicio de sesión
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Usuario Autenticado (Cliente / Administrador / Cajero) |
| **Descripción** | Controla la navegación del usuario con sesión activa: lo redirige al Catálogo de Vehículos (si es Cliente) o al Dashboard Administrativo (si es Administrador/Cajero), impidiendo visualizar la Landing Page pública mientras la sesión esté activa. |
| **Entrada** | Evento de inicio de sesión exitoso o intento de navegación hacia la ruta raíz (`/`) con token JWT activo. |
| **Salida** | Redirección automática al catálogo o panel administrativo; actualización de la barra de navegación con opciones de perfil y notificaciones. |
| **Acción** | Validar validez del token JWT y rol asignado; redirigir al área correspondiente. |
| **Criterio de Aceptación** | 1. Un usuario autenticado no puede acceder a la Landing Page pública.<br>2. La barra de navegación oculta los botones "Iniciar Sesión" y "Registrarse" y muestra la foto de perfil y notificaciones. |

---

## 🟢 Módulo 2: Autenticación, Roles y Seguridad (IAM)

### RF3: Registro de usuario cliente
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante |
| **Descripción** | Permite a nuevos clientes crear una cuenta personal ingresando nombres, apellidos, tipo y número de documento, correo electrónico, teléfono móvil y contraseña. |
| **Entrada** | Formulario de registro con validaciones en tiempo real (formato de correo, complejidad de contraseña y cédula). |
| **Salida** | Creación del registro en el esquema `iam.users`; emisión de código de verificación 2FA por SMS/Correo; notificación toast de éxito. |
| **Acción** | Validar que el correo y número de documento no existan previamente; cifrar la contraseña con BCrypt; enviar código de activación. |
| **Criterio de Aceptación** | 1. Rechaza correos duplicados o contraseñas débiles.<br>2. Genera automáticamente el perfil del usuario con rol `ROLE_CLIENT`. |

### RF4: Verificación de identidad con doble factor (2FA)
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente / Administrador |
| **Descripción** | Exige la introducción de un código OTP de 6 dígitos enviado por SMS o correo electrónico para completar el registro o inicios de sesión desde dispositivos no reconocidos. |
| **Entrada** | Código OTP de 6 dígitos introducido en la pantalla de verificación. |
| **Salida** | Activación definitiva de la cuenta y entrega del token JWT Bearer. |
| **Acción** | Comprobar que el código OTP coincida y no haya superado su tiempo de expiración (5 minutos). |
| **Criterio de Aceptación** | 1. El código expira tras 5 minutos.<br>2. Tras 3 intentos fallidos consecutivos, el código se invalida y requiere un nuevo reenvío. |

### RF5: Inicio de sesión
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Usuario Registrado |
| **Descripción** | Permite la autenticación de usuarios registrados mediante su correo electrónico y contraseña. |
| **Entrada** | Credenciales (Correo y Contraseña). |
| **Salida** | Almacenamiento seguro del token JWT en `localStorage`/`AsyncStorage`; sesión iniciada. |
| **Acción** | Autenticar credenciales en Backend; generar token JWT firmado con expiración de 24 horas. |
| **Criterio de Aceptación** | 1. Muestra mensajes de error genéricos para prevenir ataques de enumeración.<br>2. Permite mantener sesión activa. |

### RF6: Recuperar contraseña
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Usuario Registrado |
| **Descripción** | Envía un enlace seguro con token temporal al correo registrado del usuario para restablecer su contraseña olvidada. |
| **Entrada** | Correo electrónico registrado. |
| **Salida** | Mensaje de confirmación de envío; correo electrónico recibido con link de restablecimiento. |
| **Acción** | Generar token único de restablecimiento con vigencia de 15 minutos. |
| **Criterio de Aceptación** | 1. El enlace expira automáticamente en 15 minutos o tras el primer uso. |

### RF7: Inicio de sesión por roles (Administrador General y Encargado de Sucursal)
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Administrador / Encargado de Sucursal |
| **Descripción** | Autentica a usuarios administrativos restringiendo las vistas y acciones según su rol asignado (`ROLE_SUPER_ADMIN`, `ROLE_BRANCH_MANAGER`, `ROLE_CASHIER`). |
| **Entrada** | Credenciales de acceso administrativo. |
| **Salida** | Redirección al Panel de Administración Web con menú lateral filtrado según permisos. |
| **Acción** | Decodificar claims del JWT y habilitar o restringir módulos de gestión (ej. Encargado de sucursal solo ve su sede). |
| **Criterio de Aceptación** | 1. Encargados de sucursal solo pueden visualizar y modificar reservas/vehículos de su sede asignada. |

### RF8: Acceso en modo invitado sin registro
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante |
| **Descripción** | Permite explorar el catálogo completo de vehículos, precios, sucursales y características sin necesidad de haber iniciado sesión. |
| **Entrada** | Navegación por el catálogo. |
| **Salida** | Visualización libre de tarjetas de vehículos y calculadora de precios estimados. |
| **Acción** | Permitir consultas públicas en API; interceptar solicitud de reserva solicitando autenticación previo al checkout. |
| **Criterio de Aceptación** | 1. El visitante puede filtrar y ver detalles de cualquier auto sin restricciones. |

---

## 🟢 Módulo 3: Catálogo y Búsqueda de Vehículos

### RF9: Encabezado y buscador del catálogo
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante / Cliente |
| **Descripción** | Proporciona una barra de búsqueda principal para seleccionar la ciudad de origen, sucursal de retiro/entrega y rango de fechas con horas de alquiler. |
| **Entrada** | Ciudad, sucursal, fecha/hora inicio y fecha/hora fin. |
| **Salida** | Lista de vehículos disponibles que cumplen exactamente con la ubicación y fechas seleccionadas. |
| **Acción** | Consultar en base de datos la disponibilidad de la flota excluyendo vehículos reservados, en mantenimiento o inactivos. |
| **Criterio de Aceptación** | 1. No muestra vehículos que tengan traslape de fechas con reservas confirmadas. |

### RF10: Filtros avanzados del catálogo
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante / Cliente |
| **Descripción** | Permite filtrar los resultados del catálogo por tipo de transmisión (Manual/Automática), categoría (Económico, SUV, Lujo, Pickup), tipo de combustible (Gasolina, Híbrido, Eléctrico), rango de precio diario y cantidad de pasajeros. |
| **Entrada** | Selección de casillas de verificación y deslizadores de precio. |
| **Salida** | Actualización dinámica e instantánea del catálogo sin recargar la página. |
| **Acción** | Aplicar filtros combinados sobre la lista de vehículos activos en memoria/API. |
| **Criterio de Aceptación** | 1. Los filtros se aplican inmediatamente en tiempo real. |

### RF11: Ordenamiento de resultados
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante / Cliente |
| **Descripción** | Permite ordenar la lista de vehículos por: Menor Precio, Mayor Precio, Calificación de Usuarios y Popularidad. |
| **Entrada** | Selección en menú desplegable de ordenamiento. |
| **Salida** | Reordenamiento visual de las tarjetas del catálogo. |
| **Acción** | Ordenar la colección de datos según la propiedad seleccionada. |
| **Criterio de Aceptación** | 1. Mantiene los filtros activos al aplicar el ordenamiento. |

### RF12: Tarjetas informativas de vehículos
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante / Cliente |
| **Descripción** | Muestra la tarjeta de cada vehículo con foto principal, marca, modelo, año, transmisión, capacidad de pasajeros, precio por día en moneda local/extranjera y botón "Reservar Ahora". |
| **Entrada** | Carga del catálogo. |
| **Salida** | Renderizado gráfico de tarjetas con distintivos de estado y precio. |
| **Acción** | Calcular el precio total estimado según la duración de la búsqueda. |
| **Criterio de Aceptación** | 1. Muestra la etiqueta de moneda adecuada según la preferencia del usuario (COP/USD/EUR). |

### RF13: Ver detalle completo del vehículo
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante / Cliente |
| **Descripción** | Despliega la ficha técnica completa del vehículo: galería de fotos, equipamiento (aire acondicionado, GPS, Bluetooth), políticas de alquiler, opiniones de usuarios con fotos y términos de garantía. |
| **Entrada** | Clic en la tarjeta de un vehículo. |
| **Salida** | Vista/Modal detallado del vehículo seleccionado. |
| **Acción** | Obtener información detallada del vehículo y sus reseñas aprobadas. |
| **Criterio de Aceptación** | 1. Carga la galería de fotos interactiva y especificaciones técnicas completas. |

### RF14: Menú de navegación del cliente
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente Autenticado |
| **Descripción** | Proporciona acceso rápido a las secciones: Inicio, Catálogo, Mis Reservas, Favoritos, Notificaciones y Soporte. |
| **Entrada** | Clic en los ítems de la barra superior/inferior. |
| **Salida** | Navegación limpia entre módulos del cliente. |
| **Acción** | Renderizar vista objetivo preservando el estado de la sesión. |
| **Criterio de Aceptación** | 1. El menú resalta la sección activa actualmente. |

### RF15: Sección Mis Reservas
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente Autenticado |
| **Descripción** | Muestra el historial completo de reservas del cliente divididas en: En Curso, Próximas y Finalizadas/Canceladas, con opción de ver contrato PDF y comprobante de pago. |
| **Entrada** | Acceso a la sección Mis Reservas. |
| **Salida** | Listado de tarjetas de reserva con código de reserva, fechas, estado y acciones disponibles. |
| **Acción** | Consultar las reservas asociadas al ID del usuario autenticado. |
| **Criterio de Aceptación** | 1. Muestra el estado en tiempo real (Pendiente de Pago, Confirmada, En Curso, Finalizada). |

### RF16: Sección Favoritos
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente Autenticado |
| **Descripción** | Permite al cliente guardar vehículos de su preferencia marcando el ícono de corazón para consultarlos o reservarlos rápidamente después. |
| **Entrada** | Clic en el corazón de un vehículo. |
| **Salida** | Vehículo añadido o removido de la lista de favoritos; notificación flotante. |
| **Acción** | Guardar la asociación vehículo-usuario en almacenamiento local/BD. |
| **Criterio de Aceptación** | 1. Los favoritos persisten entre sesiones. |

### RF17: Sección Notificaciones del Cliente
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente Autenticado |
| **Descripción** | Muestra un centro de notificaciones con avisos de confirmación de reserva, asignación de conductor a domicilio, recordatorios de vencimiento de PIN y promociones. |
| **Entrada** | Clic en el ícono de campana de notificaciones. |
| **Salida** | Panel desplegable con la lista de notificaciones leídas y no leídas. |
| **Acción** | Marcar notificaciones como leídas al hacer clic en ellas. |
| **Criterio de Aceptación** | 1. Muestra un contador rojo con la cantidad de notificaciones sin leer. |

### RF18: Sección Soporte y Preguntas Frecuentes
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Visitante / Cliente |
| **Descripción** | Proporciona una sección de preguntas frecuentes (FAQ) categorizadas y un botón de chat flotante de asistencia inmediata. |
| **Entrada** | Acceso a la vista de Soporte. |
| **Salida** | Despliegue de acordeones con respuestas y widget de chat. |
| **Acción** | Cargar catálogo de preguntas frecuentes y canal de comunicación. |
| **Criterio de Aceptación** | 1. Permite realizar búsquedas por palabras clave en las FAQ. |

---

## 🟢 Módulo 4: Proceso de Reserva (Wizard de 3 Pasos)

### RF19: Ficha informativa de selección de vehículo
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente |
| **Descripción** | Inicio del flujo de reserva: confirma las fechas de alquiler, sucursal de recogida/devolución y tarifa base del vehículo seleccionado. |
| **Entrada** | Clic en "Reservar Ahora" desde la tarjeta del vehículo. |
| **Salida** | Vista del Paso 1 del Wizard con el resumen inicial de costos. |
| **Acción** | Validar que el vehículo continúe libre para las fechas elegidas. |
| **Criterio de Aceptación** | 1. Si el vehículo dejó de estar disponible, alerta al usuario antes de avanzar. |

### RF20: Selección de lugar y entrega a domicilio
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente |
| **Descripción** | Permite elegir si la entrega se realiza en la sucursal física o si se solicita **Entrega a Domicilio** (RF21b) en una dirección específica dentro de la ciudad. |
| **Entrada** | Selección de opción de entrega (En Sucursal o A Domicilio con dirección). |
| **Salida** | Cálculo automático del recargo por entrega a domicilio en la tarifa final. |
| **Acción** | Verificar cobertura geográfica de la sucursal y sumar costo de domicilio. |
| **Criterio de Aceptación** | 1. Si selecciona Domicilio, exige ingresar dirección exacta y barrio. |

### RF21: Resumen detallado de la reserva
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente |
| **Descripción** | Muestra el desglose transparente de costos: días de alquiler, tarifa por día, coberturas de seguro, adicionales y subtotal impuestos. |
| **Entrada** | Avance en el Wizard de reserva. |
| **Salida** | Tabla resumen de costos antes de proceder al pago. |
| **Acción** | Calcular sumatoria total dinámica en la moneda activa. |
| **Criterio de Aceptación** | 1. El resumen desglosa claramente el IVA y cargos adicionales. |

### RF22: Coberturas de protección y seguro
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente |
| **Descripción** | Permite seleccionar entre tres niveles de protección: Básica (incluida), Intermedia o Total (Cero Deducible por colisión o robo). |
| **Entrada** | Selección del plan de seguro deseado. |
| **Salida** | Actualización instantánea del costo total de la reserva. |
| **Acción** | Añadir el costo diario del seguro seleccionado a la tarifa base. |
| **Criterio de Aceptación** | 1. La protección básica viene seleccionada por defecto. |

### RF23: Selección de servicios adicionales y tipo de kilometraje
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente |
| **Descripción** | Permite agregar servicios adicionales (Silla de bebé, Conductor adicional, GPS portátil, Router Wi-Fi) y elegir entre kilometraje ilimitado o limitado. |
| **Entrada** | Casillas de selección de adicionales. |
| **Salida** | Inclusión de accesorios en el contrato y cálculo de valor adicional. |
| **Acción** | Registrar opcionales seleccionados en la reserva. |
| **Criterio de Aceptación** | 1. Muestra el precio diario de cada accesorio adicional. |

### RF24: Formulario de datos personales y del conductor
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente |
| **Descripción** | Recopila los datos legales del conductor principal: Nombre completo, Cédula/Pasaporte, Licencia de conducción, fecha de expedición y teléfono de contacto. |
| **Entrada** | Formulario con datos personales y de la licencia. |
| **Salida** | Guardado de la información del conductor asociado a la reserva. |
| **Acción** | Validar que la licencia de conducción esté vigente y corresponda a un conductor mayor de edad (21 años). |
| **Criterio de Aceptación** | 1. Impide continuar si la fecha de vencimiento de la licencia es anterior a la fecha de devolución del vehículo. |

### RF25: Verificación documental e subida de archivos
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente / Administrador (Web) |
| **Descripción** | Permite al cliente subir fotos legibles de su documento de identidad y licencia de conducción (frente y reverso) para validación antes de confirmar la reserva. |
| **Entrada** | Carga de archivos de imagen (JPG/PNG/PDF max 5MB). |
| **Salida** | Estado de la reserva en `PENDIENTE_VERIFICACION`; notificación al panel de administración `DocumentVerificationPage`. |
| **Acción** | Almacenar documentos de forma segura y habilitar módulo de revisión visual en el Web Admin. |
| **Criterio de Aceptación** | 1. El cliente puede previsualizar las fotos subidas antes de confirmar la reserva. |

---

## 🟢 Módulo 5: Métodos de Pago y Facturación

### RF26: Pago virtual en línea con pasarela Wompi
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente |
| **Descripción** | Integra la pasarela de pagos Wompi para procesar cobros electrónicos seguros mediante PSE, tarjetas de crédito/débito y botón Nequi. |
| **Entrada** | Selección de pago en línea y método (PSE/Tarjeta/Nequi). |
| **Salida** | Redirección/Widget de Wompi; recepción de webhook transaccional; cambio de estado de reserva a `CONFIRMADA`. |
| **Acción** | Generar referencia única de pago; validar firma de seguridad Hash Integrity de Wompi. |
| **Criterio de Aceptación** | 1. En caso de pago rechazado, informa el motivo y permite reintentar el pago sin perder la reserva. |

### RF27: Cobro en efectivo en sede con PIN dinámico (RF47)
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente (App) / Cajero (Web Admin `CashCollectionPage`) |
| **Descripción** | Genera un comprobante de pago presencial con un **PIN dinámico de 6 dígitos numéricos** para pagar en la caja registradora de la sucursal. |
| **Entrada** | Selección de método "Pago en Efectivo en Sucursal". |
| **Salida** | Pantalla con comprobante, código QR, PIN de 6 dígitos y temporizador regresivo de vencimiento. |
| **Acción** | Establecer temporizador de expiración (72 horas iniciales o hasta 2 horas antes del inicio del alquiler); permitir al cajero validar el PIN en el Web Admin. |
| **Criterio de Aceptación** | 1. El comprobante muestra la cuenta regresiva en tiempo real.<br>2. Si el cliente no paga antes del vencimiento del PIN, la reserva se cancela automáticamente. |

---

## 🟢 Módulo 6: Entregas a Domicilio, Choferes y Nuevos Módulos del Sistema

### RF21b: Asignación de entregas a domicilio y choferes con PIN Nequi
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Administrador (`DeliveryManagementPage`) / Cliente (App) / Conductor |
| **Descripción** | Permite a la sucursal asignar un chofer responsable para entregar el vehículo en la dirección acordada con el cliente. La App del cliente muestra el chofer, un **PIN Nequi de 4 dígitos** para la entrega y enlace a WhatsApp. |
| **Entrada** | Selección de conductor en la tabla `DeliveryManagementPage.jsx`. |
| **Salida** | Asignación en el sistema; generación del PIN Nequi de 4 dígitos; notificación push a la App del cliente con foto del chofer y botón de WhatsApp. |
| **Acción** | Crear registro en `delivery_assignments`; notificar al chofer y al cliente; verificar PIN Nequi al momento de la entrega física. |
| **Criterio de Aceptación** | 1. La App Móvil permite ocultar/mostrar el PIN Nequi mediante un botón con ícono de ojo.<br>2. El cliente puede dar clic en el botón para abrir un chat directo de WhatsApp con el conductor asignado. |

### RF43: Gestión de promociones y cupones de descuento
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Administrador (`PromotionManagementPage`) / Cliente |
| **Descripción** | Módulo administrativo para crear y gestionar cupones de descuento (porcentuales o monto fijo), estableciendo fecha de vigencia, tope máximo de uso y código alfanumérico. |
| **Entrada** | Creación de cupón en Web Admin; ingreso del código de cupón por parte del cliente en el checkout. |
| **Salida** | Descuento aplicado en el desglose de precios de la reserva; actualización del contador de uso del cupón. |
| **Acción** | Validar vigencia, límite de redenciones y acumulabilidad del cupón en la BD. |
| **Criterio de Aceptación** | 1. Si el cupón venció o superó el límite de usos, muestra un mensaje explícito de rechazo. |

### RF26b: Reseñas con fotos y respuesta oficial inmutable de sucursal
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Cliente (App) / Administrador de Sucursal (`BranchReviewsPage`) |
| **Descripción** | Permite a clientes que finalizaron un alquiler calificar la sucursal con 1 a 5 estrellas y subir hasta 3 fotos. El Encargado de Sucursal puede publicar una **Respuesta Oficial Inmutable** (no editable). |
| **Entrada** | Calificación y fotos subidas por cliente; respuesta redactada por el Administrador. |
| **Salida** | Publicación de la reseña en la ficha de la sucursal con la respuesta oficial destacada. |
| **Acción** | Almacenar hasta 3 fotos; registrar la respuesta del admin con bandera `is_immutable = true` impidiendo modificaciones posteriores. |
| **Criterio de Aceptación** | 1. Solo clientes con reservas completadas pueden emitir reseñas.<br>2. La respuesta oficial de la sucursal no se puede editar ni borrar una vez enviada. |

---

## 🟢 Módulo 7: Panel Administrativo Web (`web-drivique/src/modules/admin/pages`)

### RF34: Dashboard administrativo de indicadores (KPIs)
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Administrador General (`ReportsManagementPage`) |
| **Descripción** | Panel de control principal con gráficos interactivos que resumen: ingresos totales, tasa de ocupación de vehículos, reservas activas, solicitudes de domicilio y cobros en caja. |
| **Entrada** | Filtros de rango de fechas (Hoy, Esta Semana, Este Mes, Año). |
| **Salida** | Renderizado de tarjetas de KPIs y gráficos estadísticos. |
| **Acción** | Calcular métricas financieras y operativas agregadas en tiempo real. |
| **Criterio de Aceptación** | 1. Permite exportar los datos mostrados en formatos Excel y PDF. |

### RF35: Gestión de ciudades y sucursales
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Administrador (`CityManagementPage`, `BranchManagementPage`) |
| **Descripción** | Permite crear, editar, activar/desactivar ciudades de operación y sucursales físicas, definiendo dirección, teléfono, coordenadas GPS y horario de atención. |
| **Entrada** | Formulario de datos de sucursal y mapa de ubicación. |
| **Salida** | Actualización de la lista de sedes disponibles para alquiler. |
| **Acción** | Gestionar catálogo de locaciones con borrado lógico (`is_active`). |
| **Criterio de Aceptación** | 1. No permite eliminar una sucursal si tiene reservas activas asociadas. |

### RF37: Gestión de flota de vehículos e incidencias
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Administrador (`VehicleManagementPage`, `IncidentManagementPage`) |
| **Descripción** | Registro y control individual de cada auto de la flota: placa, marca, modelo, kilometraje, estado de mantenimiento e historial de averías o rayones reportados. |
| **Entrada** | Datos del vehículo, fotos y reportes de incidentes. |
| **Salida** | Ficha técnica del auto y cambio de estado a `EN_MANTENIMIENTO` si registra fallas. |
| **Acción** | Actualizar catálogo de autos e inhabilitar vehículos con incidentes graves. |
| **Criterio de Aceptación** | 1. Un auto marcado `EN_MANTENIMIENTO` se remueve automáticamente del catálogo público. |

### RF42: Gestión de contratos y firma digital
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Administrador (`ContractManagementPage`) / Cliente |
| **Descripción** | Módulo de generación, visualización y descarga de contratos de arrendamiento en formato PDF con soporte para firma digital en pantalla. |
| **Entrada** | Confirmación de reserva y firma del cliente en lienzo táctil/mouse. |
| **Salida** | Generación del contrato PDF firmado y almacenado con sello de tiempo. |
| **Acción** | Ensamblar contrato PDF dinámico incluyendo cláusulas legales, inventario del auto y firmas. |
| **Criterio de Aceptación** | 1. Permite descargar el contrato PDF firmado en cualquier momento desde el Web Admin o la App. |

### RF46: Bitácora de auditoría forense e historial de cambios
| Campo | Detalle |
| :--- | :--- |
| **Tipo / Actor** | Super Administrador (`AuditLogManagementPage`) |
| **Descripción** | Registro inmutable de auditoría que guarda cada acción crítica realizada en el sistema (creación de usuarios, cambios de precios, aprobaciones de pago, eliminación de datos) con dirección IP, usuario y captura JSONB de datos anteriores y nuevos. |
| **Entrada** | Consultas y búsquedas en el registro de auditoría. |
| **Salida** | Tabla con el historial forense de operaciones con filtros por usuario, fecha y módulo. |
| **Acción** | Registrar eventos en la tabla `audit_logs` con snapshots `old_data` y `new_data`. |
| **Criterio de Aceptación** | 1. Los registros de auditoría son de solo lectura y no pueden ser modificados ni borrados por ningún rol. |
