# ESPECIFICACIÓN DE REQUERIMIENTOS NO FUNCIONALES (RNF DRIVIQUE)

**Proyecto:** Drivique - Sistema Integral de Alquiler de Vehículos (Web & App Móvil)  
**Documento:** `non-functional-requirements.md`  
**Estándar:** IEEE 830-1998 / Formato Estándar de Especificación SENA  
**Ámbito de Aplicación:** Plataforma Web, Backend API (Spring Boot) y Aplicación Móvil Android  
**Fecha de Emisión:** 2026  

---

## 📌 ESTRUCTURA RESUMIDA DE REQUERIMIENTOS NO FUNCIONALES

- **RNF1. Rendimiento:** Tiempos de respuesta ultrarrápidos (<2s en peticiones HTTP comunes, <5s en procesos analíticos complejos) y tasa de procesamiento de hasta 1,000 req/seg.
- **RNF2. Utilización y Usabilidad:** Interfaz intuitiva basada en diseño centrado en el usuario (UX/UI), navegabilidad accesible en <3 clics y curva de aprendizaje cero.
- **RNF3. Internacionalización (i18n - 5 Idiomas):** Soporte multi-idioma nativo para 5 lenguas (Español `es`, Inglés `en`, Francés `fr`, Portugués `pt`, Portugués de Brasil `pt-BR`) con carga dinámica de llaves i18n y fallback a Español.
- **RNF4. Modo Oscuro Nativo:** Conmutación dinámica de temas visuales (Light/Dark Mode) mediante tokens de diseño CSS global (`data-theme`), cumpliendo contraste WCAG AAA.
- **RNF5. Compatibilidad y Movilidad:** Soporte nativo para dispositivos Android (API 26+ / Android 8.0+) y diseño web responsivo adaptativo (RWD) desde 320px hasta 4K.
- **RNF6. Seguridad y Cifrado:** Protección integral con HTTPS/TLS 1.3, autenticación con tokens JWT salteados, cifrado de contraseñas con BCrypt (work factor 12) y cumplimiento de ley de protección de datos (Habeas Data).
- **RNF7. Escalabilidad y Migraciones con Liquibase:** Control de versiones, evolución de esquemas relacionales (PostgreSQL/MySQL) y ejecuciones de migraciones automáticas cero-downtime usando scripts `changelog` de **Liquibase**.
- **RNF8. Disponibilidad Operativa:** Uptime garantizado del 99.9% anual (SLA) con redundancia activa, balanceo de carga y arquitectura de alta disponibilidad.
- **RNF9. Mantenibilidad y Clean Code:** Arquitectura desacoplada por capas (Frontend React, Backend Spring Boot, App Android), principios SOLID, modularidad extrema y 100% separación de incumbencias.
- **RNF10. Adaptabilidad y Elasticidad:** Capacidad de autorregulación y escalado horizontal/vertical automático para procesar picos repentinos de demanda durante temporadas altas.
- **RNF11. Documentación Técnica:** Documentación viva basada en estándar IEEE 830, especificación de endpoints con Swagger/OpenAPI 3.0 y manuales operativos detallados.
- **RNF12. Tolerancia a Fallos y Resiliencia:** Circuit Breakers, reintentos automáticos con backoff exponencial, recuperación de transacciones fallidas y persistencia local de estado offline.

---

# 📋 FICHAS TÉCNICAS DETALLADAS DE REQUERIMIENTOS NO FUNCIONALES

---

### RNF1: Rendimiento

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 1 |
| **Nombre** | Rendimiento y Tiempo de Respuesta |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | RF1 al RF54 (Portal Web, App Móvil Android, Microservicios REST y Pasarelas de Pago) |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Sección 3.1 / Reportes de Pruebas de Carga JMeter / Dashboard APM Grafana |
| **Entrada** | 1. Solicitudes HTTP/REST enviadas desde la app Android y portal Web.<br>2. Transacciones concurrentes de consulta de catálogo, generación de contratos PDF y pasarela Wompi.<br>3. Carga masiva de imágenes de entrega de vehículos. |
| **Salida** | 1. Tiempos de respuesta de la API REST inferiores a 200 milisegundos en peticiones de lectura (GET).<br>2. Tiempos de carga de página inicial (First Contentful Paint - FCP) menores a 1.5 segundos.<br>3. Procesamiento de checkout y confirmación de reserva en menos de 3 segundos. |
| **Descripción** | La plataforma Drivique debe ejecutar todas sus operaciones con un rendimiento óptimo bajo cualquier condición de red (3G, 4G, 5G, Wi-Fi). Se establece como norma que el 95% de las peticiones HTTP simples (búsqueda, catálogo, perfiles) respondan en menos de 2 segundos, mientras que las operaciones pesadas de cómputo (generación de contratos en PDF, verificación de documentos por IA, reportes de auditoría) no deben exceder los 5 segundos de procesamiento backend. |
| **Manejo de situaciones anormales** | 1. Si una petición supera el umbral de 5 segundos, la interfaz debe mostrar un indicador de carga animado (Skeleton Screen) informando al usuario.<br>2. Si la petición sobrepasa 10 segundos, se dispara un corte por *Time-Out*, se cancela la conexión de red y se muestra un modal amigable permitiendo al usuario reintentar la acción.<br>3. Se emite una alerta automática al sistema de monitoreo APM. |
| **Criterios de aceptación** | 1. **Dado** que un usuario navega en el catálogo de vehículos, **cuando** aplica filtros de búsqueda, **entonces** los resultados deben renderizarse en pantalla en menos de 2.0 segundos.<br>2. **Dado** que la API recibe 500 peticiones concurrentes por segundo, **entonces** el 99% de las respuestas deben mantener un estatus HTTP 200 con latencia < 300ms. |

---

### RNF2: Utilización y Usabilidad

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 2 |
| **Nombre** | Utilización, Usabilidad y Experiencia de Usuario (UX/UI) |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | RF1 al RF54 (Flujo de reserva del Cliente, Panel de Administración General y Panel de Sucursal) |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Sección de Usabilidad / Sistema de Diseño UI Drivique / Guía de Estilos Figma |
| **Entrada** | 1. Interacciones de entrada del usuario (clics, toques en pantalla táctil, gestos de deslizamiento, llenado de formularios).<br>2. Navegación por menús, modales, barras laterales y tarjetas interactivas. |
| **Salida** | 1. Interfaz fluida a 60 FPS con transiciones visuales agradables.<br>2. Retroalimentación táctil y visual inmediata (<50ms) en botones e inputs.<br>3. Mensajería de error descriptiva e instructiva en tiempo real. |
| **Descripción** | La plataforma Drivique debe construirse bajo los principios del diseño centrado en el usuario (Nielsen Norman Group), garantizando que cualquier usuario (cliente final, encargado de sucursal o super administrador) pueda realizar sus tareas operativas de manera intuitiva y sin necesidad de manuales ni capacitación previa. La navegación debe organizarse de forma que se pueda acceder a cualquier funcionalidad principal en un máximo de 3 clics o toques. |
| **Manejo de situaciones anormales** | 1. Si el usuario ingresa datos inválidos en un formulario (ej. correo sin formato o contraseña corta), la interfaz resalta el campo en rojo en tiempo real con un texto explicativo claro sin borrar la información previa.<br>2. Si un usuario se estanca en una pantalla por más de 60 segundos sin interactuar, se despliega una pequeña ayuda contextual (Tooltip instructivo). |
| **Criterios de aceptación** | 1. **Dado** que un usuario nuevo ingresa a la aplicación por primera vez, **cuando** realiza el proceso de búsqueda y reserva de un vehículo, **entonces** debe poder completar la reserva exitosamente en menos de 3 minutos.<br>2. **Dado** un formulario con campos erróneos, **cuando** el usuario intenta enviar los datos, **entonces** el foco visual salta automáticamente al primer campo inválido con una sugerencia de corrección. |

---

### RNF3: Internacionalización (i18n - 5 Idiomas)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 3 |
| **Nombre** | Internacionalización (i18n Multi-Idioma Nativo) |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | RF1 a RF33 (Portal del Cliente, Catálogo, Proceso de Reserva, Notificaciones y Perfil de Usuario) |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Módulo i18n / Archivos JSON de Traducción (Archivos de Recursos de Traducción i18n) |
| **Entrada** | 1. Selección explícita del idioma preferido desde el menú desplegable en la barra de navegación superior (`es`, `en`, `fr`, `pt`, `pt-BR`).<br>2. Detección automática del encabezado `Accept-Language` del navegador o configuración regional del sistema operativo Android. |
| **Salida** | 1. Re-renderizado instantáneo de la interfaz traduciendo el 100% de los elementos de texto (títulos, botones, formularios, modales, alertas y correos).<br>2. Formateo regional adecuado de valores numéricos, monedas (COP, USD, EUR) y fechas (DD/MM/AAAA vs MM/DD/AAAA). |
| **Descripción** | El sistema debe contar con un motor de internacionalización nativo (`react-i18next` en Web y `i18n-framework` en Android) que garantice el soporte completo para 5 idiomas oficiales: Español (`es`), Inglés (`en`), Francés (`fr`), Portugués (`pt`) y Portugués de Brasil (`pt-BR`). La conmutación de idioma debe realizarse en memoria sin provocar la recarga de la página ni perder el estado actual del formulario de reserva. |
| **Manejo de situaciones anormales** | 1. Si se solicita la traducción de un texto cuya clave (`i18n key`) no existe en el archivo JSON del idioma seleccionado, el motor debe aplicar de inmediato un mecanismo de *fallback* retornando el texto en Español (`es`).<br>2. Si un archivo de idioma falla al cargar, la aplicación funciona de forma estable utilizando el paquete base por defecto. |
| **Criterios de aceptación** | 1. **Dado** que un usuario selecciona la opción "English" en el selector de idioma, **cuando** navega por el catálogo, **entonces** todos los textos, filtros y descripciones cambian a inglés en menos de 100ms sin recargar la página.<br>2. **Dado** un cambio de idioma, **entonces** la clave elegida debe ser persistida en el `localStorage` del navegador o `SharedPreferences` del dispositivo móvil para mantener la preferencia en futuras visitas. |

---

### RNF4: Modo Oscuro Nativo (Light / Dark Theme)

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 4 |
| **Nombre** | Modo Oscuro Nativo y Gestión de Temas Visuales |
| **Tipo** | Necesario |
| **Requerimiento que lo utiliza o especializa** | RF1 al RF54 (Interfaz Global Web, App Móvil Android y Paneles Administrativos) |
| **¿Crítico?** | No |
| **Prioridad de desarrollo** | Medio |
| **Documentos de visualización asociados** | Documento SRS – Sistema de Temas / Tokens de Diseño CSS Globals (`variables.css`) |
| **Entrada** | 1. Pulsación manual del interruptor de cambio de tema (Sol / Luna) ubicado en el menú superior o barra de ajustes.<br>2. Evento del sistema operativo `prefers-color-scheme: dark` / `prefers-color-scheme: light`. |
| **Salida** | 1. Conmutación dinámica del atributo `data-theme="dark"` o `data-theme="light"` en la etiqueta raíz `<html>`.<br>2. Adaptación instantánea de los colores de fondo (`#121212` para dark mode), colores de tarjeta, textos (`#F5F5F5`), bordes y sombras en toda la aplicación. |
| **Descripción** | Drivique debe ofrecer una experiencia visual confortable tanto de día como de noche mediante la implementación de un Modo Oscuro Nativo. El motor de estilos debe apoyarse en variables CSS centralizadas (`--bg-primary`, `--text-primary`, `--accent-color`), eliminando colores estáticos acoplados. El tema debe respetar los estándares WCAG AAA en relación de contraste de color (mínimo 4.5:1 para texto normal y 3:1 para componentes de interfaz). |
| **Manejo de situaciones anormales** | 1. Si no existe una preferencia guardada ni se detecta la configuración del sistema operativo, el sistema asigna el "Modo Claro" (`light`) como valor por defecto.<br>2. Si un componente de terceros no soporta cambio de tema, se le aplica una máscara CSS atenuada para evitar deslumbramiento. |
| **Criterios de aceptación** | 1. **Dado** que el usuario presiona el botón de Modo Oscuro, **cuando** conmuta el tema, **entonces** la interfaz completa cambia de paleta cromática en un tiempo inferior a 50 milisegundos sin parpadeos (*flashes* de luz blanca).<br>2. **Dado** que el usuario cierra y vuelve a abrir el navegador o la App, **entonces** se restaura automáticamente el último tema seleccionado. |

---

### RNF5: Compatibilidad y Movilidad

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 5 |
| **Nombre** | Compatibilidad Multi-Navegador y Movilidad Responsiva |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | RF1 al RF54 (Acceso multiplataforma Web y App Android) |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Matriz de Compatibilidad / Guías de Diseño Responsivo (RWD) |
| **Entrada** | 1. Ejecución de la plataforma Web desde diversos navegadores (Google Chrome 100+, Mozilla Firefox 100+, Apple Safari 15+, Microsoft Edge 100+).<br>2. Ejecución de la App Móvil en dispositivos con sistema operativo Android 8.0 (Oreo / API Level 26) o superior. |
| **Salida** | 1. Renderizado correcto de maquetación responsiva adaptable a resoluciones móviles (320px - 767px), tablets (768px - 1024px) y pantallas de escritorio (1025px - 4K).<br>2. Operatividad completa de componentes táctiles y de ratón sin deformación de elementos. |
| **Descripción** | La arquitectura Frontend debe garantizar compatibilidad absoluta entre plataformas. El portal Web debe hacer uso de diseño web responsivo (Responsive Web Design - RWD) mediante esquemas CSS Flexbox y Grid sin depender de librerías propietarias rígidas. Para el entorno móvil, la App debe compilarse nativamente para el sistema operativo Android, garantizando acceso a sensores del dispositivo (Cámara para validación documental y lectura de PIN, GPS para geolocalización de sucursales). |
| **Manejo de situaciones anormales** | 1. Si la plataforma se ejecuta en un navegador web obsoleto (ej. Internet Explorer), se despliega un cartel bloqueante indicando que el navegador no es compatible y ofreciendo enlaces directos para actualizar a Chrome/Edge/Firefox.<br>2. En pantallas con ancho inferior a 320px, la interfaz habilita desplazamiento horizontal controlado para evitar superposición. |
| **Criterios de aceptación** | 1. **Dado** que un usuario ingresa al portal Web desde un teléfono móvil con pantalla de 375px de ancho, **cuando** visualiza el catálogo, **entonces** las tarjetas de vehículos se apilan verticalmente de forma óptima sin desbordamiento horizontal.<br>2. **Dado** un dispositivo con Android 8.0, **cuando** se instala el paquete APK de Drivique, **entonces** la aplicación inicia correctamente sin errores de compilación ni cierre inesperado (*Crash*). |

---

### RNF6: Seguridad y Cifrado de Información

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 6 |
| **Nombre** | Seguridad, Autenticación y Protección de Datos (Habeas Data) |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | RF1 al RF54 (Autenticación, Pasarela de Pagos, Almacenamiento de Documentos, Logs y Base de Datos) |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Política de Seguridad / Estándar OWASP Top 10 / Certificados HTTPS TLS 1.3 |
| **Entrada** | 1. Credenciales de autenticación (correo, contraseña, tokens 2FA).<br>2. Datos sensibles de clientes (número de documento, licencia de conducir, PIN de entrega Nequi, firmas digitales).<br>3. Peticiones HTTP enviadas a los endpoints del API Rest. |
| **Salida** | 1. Tráfico 100% cifrado de extremo a extremo en tránsito utilizando protocolo HTTPS con TLS 1.3.<br>2. Generación de tokens de sesión JWT cifrados con algoritmo HMAC SHA-256 o RSA con tiempo de expiración corto (60 minutos).<br>3. Almacenamiento de contraseñas mediante hashing BCrypt con factor de costo 12. |
| **Descripción** | Drivique debe cumplir rigurosamente con los estándares de seguridad informática y las normativas de protección de datos personales (Ley 1581 de Habeas Data). Toda la comunicación entre cliente web/móvil y el servidor backend debe viajar por canales seguros HTTPS. Las contraseñas jamás deben almacenarse en texto plano. Los endpoints del API deben implementar filtros CORS restringidos, protección contra ataques CSRF, prevención de inyecciones SQL (uso de Prepared Statements en ORM) y saneamiento de entradas contra Cross-Site Scripting (XSS). |
| **Manejo de situaciones anormales** | 1. Si se detectan 5 intentos fallidos consecutivos de inicio de sesión desde una misma dirección IP o cuenta de usuario, el sistema bloquea temporalmente el acceso por 15 minutos e inserta un evento de seguridad en la tabla de auditoría.<br>2. Si un token JWT expira o es manipulado, la API responde con un código `401 Unauthorized` borrando las credenciales guardadas en el cliente. |
| **Criterios de aceptación** | 1. **Dado** que un atacante intenta realizar una inyección SQL en el formulario de login, **cuando** envía caracteres maliciosos, **entonces** el backend invalida el input de forma segura sin revelar información de la base de datos.<br>2. **Dado** que un usuario ingresa una contraseña, **entonces** en la base de datos solo debe quedar registrado la cadena resultante del algoritmo BCrypt salteado. |

---

### RNF7: Escalabilidad y Migraciones con Liquibase

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 7 |
| **Nombre** | Escalabilidad de Base de Datos y Control de Versiones con Liquibase |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | Módulo de Persistencia del Backend, Esquema de Base de Datos Relacional (PostgreSQL / MySQL) |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Arquitectura de Datos / Scripts Master Changelog Liquibase (`db.changelog-master.xml`) |
| **Entrada** | 1. Archivos de migración de esquema versionados (`changelogs` en formato XML, YAML o SQL).<br>2. Ejecución automática de tareas de migración en el arranque del servicio Spring Boot (`liquibase:update`). |
| **Salida** | 1. Actualización automática, consistente e idéntica de las estructuras de tablas, llaves foráneas, índices y datos semilla en todos los entornos (Desarrollo, Pruebas, Staging y Producción).<br>2. Registro histórico del estado de la BD en la tabla interna `DATABASECHANGELOG`. |
| **Descripción** | El sistema Drivique debe soportar el crecimiento sostenido en cantidad de registros (vehículos, reservas, clientes, logs) y usuarios sin requerir reestructuraciones drásticas del sistema. Para garantizar la evolución controlada y transparente de la base de datos relacional sin caídas de servicio ni pérdida de información, **se exige obligatoriamente el uso de Liquibase** como herramienta de gestión y versionamiento de migraciones de BD. Todo cambio de esquema debe empaquetarse en un script desacoplado y revertible (`rollback`). |
| **Manejo de situaciones anormales** | 1. Si durante el despliegue una migración de Liquibase arroja un error de sintaxis o conflicto de llaves, Liquibase cancela inmediatamente la ejecución y realiza un *Rollback* automático al estado inmediatamente anterior, evitando dejar la BD corrupta.<br>2. Se notifica la falla al pipeline de CI/CD para detener el despliegue. |
| **Criterios de aceptación** | 1. **Dado** un nuevo cambio en la estructura de datos (ej. añadir columna de PIN Nequi a la tabla `reservas`), **cuando** se ejecuta el despliegue en producción, **entonces** Liquibase aplica la migración sin requerir intervención manual ni tiempo de inactividad.<br>2. **Dado** que se consulta el historial de migraciones en la tabla `DATABASECHANGELOG`, **entonces** cada script aplicado debe mostrar su autor, fecha, checksum y descripción de forma transparente. |

---

### RNF8: Disponibilidad y Alta Disponibilidad

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 8 |
| **Nombre** | Disponibilidad Operativa del Servicio (High Availability) |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | Infraestructura Cloud, Backend API, Base de Datos, Pasarelas de Pago |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Acuerdos de Nivel de Servicio (SLA) / Diagrama de Infraestructura Cloud |
| **Entrada** | 1. Peticiones continuas de usuarios las 24 horas del día, los 7 días de la semana, los 365 días del año.<br>2. Monitoreo constante de salud del sistema mediante comprobaciones de estado (Servicio de Monitoreo de Salud de la API). |
| **Salida** | 1. Operatividad ininterrumpida de los servicios core (Catálogo, Autenticación, Reservas y Pagos) con un Uptime garantizado del 99.9% anual.<br>2. Tiempo máximo de inactividad no planificada inferior a 8.76 horas por año. |
| **Descripción** | La plataforma Drivique es una solución crítica de alquiler de vehículos en tiempo real, por lo que debe mantenerse disponible permanentemente. La infraestructura backend debe estar desplegada en contenedores orquestados con balanceadores de carga y réplicas secundarias de base de datos con conmutación por error (*Failover*) automática. Los trabajos de mantenimiento programado deben realizarse en franjas horarias de mínimo tráfico (entre las 02:00 AM y las 04:00 AM) y ser notificados con previa anticipación. |
| **Manejo de situaciones anormales** | 1. Ante la caída imprevista del servidor principal de backend, el balanceador de carga redirige el tráfico en menos de 5 segundos hacia una instancia de respaldo activa.<br>2. Si la base de datos primaria se desconecta, la réplica de lectura asume el rol de primaria de forma automática sin pérdida de transacciones. |
| **Criterios de aceptación** | 1. **Dado** que el monitoreo de infraestructura evalúa el tiempo de actividad durante 30 días, **entonces** la disponibilidad del servicio debe registrar una cifra igual o superior al 99.9%.<br>2. **Dado** un fallo en una instancia del servidor, **cuando** los usuarios realizan peticiones, **entonces** no deben percibir interrupción ni errores de pantalla gracias al balanceo transparente. |

---

### RNF9: Mantenibilidad y Clean Code

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 9 |
| **Nombre** | Mantenibilidad, Calidad de Código y Modularidad |
| **Tipo** | Necesario |
| **Requerimiento que lo utiliza o especializa** | Repositorio de Código Fuente (`front-end_web/web-drivique`, Backend REST, App Android) |
| **¿Crítico?** | No |
| **Prioridad de desarrollo** | Medio |
| **Documentos de visualización asociados** | Documento SRS – Convenciones de Desarrollo / Reportes SonarQube |
| **Entrada** | 1. Solicitudes de cambio, refactorizaciones, corrección de errores o inclusión de nuevos requerimientos por el equipo de ingeniería de software. |
| **Salida** | 1. Código limpio, documentado, con bajo acoplamiento y alta cohesión.<br>2. Facilidad para incorporar nuevas funcionalidades sin degradar el funcionamiento preexistente (sin regresiones). |
| **Descripción** | El código fuente de Drivique debe estructurarse siguiendo las mejores prácticas de ingeniería de software, tales como arquitectura por capas, patrones de diseño (Repository, Factory, Singleton, Observer), principios SOLID y guías de desarrollo Clean Code. Los componentes del Frontend (React/Vite) deben ser altamente modulares y reutilizables. La lógica de negocio debe residir exclusivamente en la capa de servicios o estado global (`Zustand` / `Redux`), evitando que las vistas de interfaz contengan código de procesamiento de datos. |
| **Manejo de situaciones anormales** | 1. Si un desarrollador introduce código duplicado o violaciones de patrones, las herramientas de análisis estático (ESLint, SonarQube) bloquean el despliegue en la etapa de Integración Continua (CI).<br>2. Excepciones no controladas en un módulo no deben colapsar los demás módulos de la aplicación. |
| **Criterios de aceptación** | 1. **Dado** que el proyecto es analizado por SonarQube, **entonces** la cobertura de duplicación de código debe ser menor al 3% y el nivel de deuda técnica debe clasificarse en Grado A.<br>2. **Dado** un cambio en la API de pagos, **cuando** se refactoriza el servicio, **entonces** la vista del cliente no requiere modificaciones estructurales. |

---

### RNF10: Adaptabilidad y Manejo de Carga

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 10 |
| **Nombre** | Adaptabilidad, Elasticidad y Capacidad de Carga |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | Servidores de Aplicación Cloud, Servidores de Base de Datos y Balanceadores de Carga |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Especificaciones de Infraestructura Elastic Cloud |
| **Entrada** | 1. Incrementos bruscos y repentinos en la afluencia de usuarios concurrentes durante periodos festivos o promocionales (picos de carga). |
| **Salida** | 1. Ajuste elástico de los recursos de cómputo (CPU, Memoria RAM, instancias de contenedores) para mantener la velocidad de procesamiento constante. |
| **Descripción** | El sistema debe poseer la capacidad de adaptarse dinámicamente a variaciones extremas en el volumen de uso. Durante días de tráfico normal, el sistema opera con la infraestructura base para optimizar costos, pero ante eventos de alta demanda (temporadas de vacaciones o campañas masivas de descuentos en alquiler), la infraestructura debe escalar horizontalmente (agregando automáticamente nuevas instancias de servidores) sin requerir reinicios manuales ni interrumpir las transacciones activas. |
| **Manejo de situaciones anormales** | 1. Si el volumen de peticiones excede el límite máximo tolerable de la infraestructura escalada (ej. > 5,000 req/seg), el sistema activa una cola de espera virtual encolando las peticiones no prioritarias y mostrando un mensaje amigable al usuario.<br>2. Se preserva la integridad de las reservas en proceso. |
| **Criterios de aceptación** | 1. **Dado** un incremento del 300% en el tráfico de usuarios en menos de 10 minutos, **cuando** los servidores alcanzan el 75% de uso de CPU, **entonces** la infraestructura aprovisiona automáticamente 2 nuevas instancias de backend en menos de 3 minutos.<br>2. **Dado** el evento de alta carga, **entonces** el porcentaje de errores HTTP 5xx debe permanecer en 0%. |

---

### RNF11: Documentación Técnica y de Usuario

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 11 |
| **Nombre** | Documentación Técnica, Artefactos SRS y Manuales de Operación |
| **Tipo** | Necesario |
| **Requerimiento que lo utiliza o especializa** | Todo el ecosistema del proyecto Drivique (Desarrolladores, Administradores y Usuarios Finales) |
| **¿Crítico?** | No |
| **Prioridad de desarrollo** | Medio |
| **Documentos de visualización asociados** | Documento SRS IEEE 830 / Especificación OpenAPI 3.0 (Swagger) / Manuales SENA |
| **Entrada** | 1. Especificación de requerimientos funcionales y no funcionales.<br>2. Código fuente y contratos de endpoints REST del backend.<br>3. Diagramas de casos de uso, secuencia, entidad-relación y despliegue. |
| **Salida** | 1. Artefactos de documentación actualizados, estructurados y publicados en formato Markdown, PDF y Swagger UI interactivo. |
| **Descripción** | El proyecto Drivique debe contar con una documentación completa, rigurosa y permanentemente actualizada. Se requiere la entrega del documento de Especificación de Requerimientos de Software (SRS) ajustado a la norma IEEE 830-1998 y los formatos exigidos por la metodología SENA. Adicionalmente, el backend debe exponer una consola interactiva Swagger/OpenAPI para la prueba y consulta de endpoints REST, y se deben entregar manuales de usuario ilustrados para la App Móvil, Portal Web y Paneles Administrativos. |
| **Manejo de situaciones anormales** | 1. Si un endpoint de la API es modificado en el código pero no actualizado en la documentación de Swagger, las pruebas automatizadas de integración fallan indicando la discrepancia.<br>2. Se corrigen las anomalías documentales antes del release. |
| **Criterios de aceptación** | 1. **Dado** que un nuevo desarrollador se integra al equipo, **cuando** consulta la documentación del proyecto, **entonces** puede configurar e instalar el entorno local completo en menos de 2 horas siguiendo el Readme.<br>2. **Dado** el backend en ejecución, **cuando** se navega a `/swagger-ui.html`, **entonces** se visualiza la totalidad de endpoints documentados con sus esquemas DTO de entrada y salida. |

---

### RNF12: Tolerancia a Fallos y Resiliencia

| Campo | Detalle Técnico |
| :--- | :--- |
| **Identificador** | RNF 12 |
| **Nombre** | Tolerancia a Fallos, Resiliencia y Almacenamiento Local Offline |
| **Tipo** | Necesario / Crítico |
| **Requerimiento que lo utiliza o especializa** | RF1 al RF54 (Gestión de Sesión, Formularios de Reserva, Pagos con Pasarela, Sincronización) |
| **¿Crítico?** | Sí |
| **Prioridad de desarrollo** | Alto |
| **Documentos de visualización asociados** | Documento SRS – Estrategia de Resiliencia / Pruebas de Desconexión de Red |
| **Entrada** | 1. Pérdida o fluctuación de la conexión a internet en la app Android o cliente web durante la navegación.<br>2. Caídas temporales o errores de respuesta de servicios externos (Pasarela Wompi, API de envío de correos). |
| **Salida** | 1. Almacenamiento borrador del estado local (`IndexedDB` / `localStorage` / `Room Database`).<br>2. Notificación no intrusiva de pérdida de red con reconexión transparente.<br>3. Ejecución de reintentos automáticos con algoritmo de backoff exponencial. |
| **Descripción** | El sistema debe ser altamente resiliente ante fallas de hardware, caídas de servicios de terceros o interrupciones de conectividad en el dispositivo móvil del usuario. Ante una pérdida repentina de conexión a internet mientras el usuario completa un formulario de reserva de varios pasos, la aplicación debe guardar el progreso localmente y restablecer el flujo en el mismo punto exacto al recuperar la red, sin obligar al usuario a repetir la captura de datos. Para APIs externas, se deben implementar patrones *Circuit Breaker*. |
| **Manejo de situaciones anormales** | 1. Si la pasarela de pagos Wompi no responde tras 3 reintentos, el sistema marca la reserva en estado "Pendiente de Confirmación", notifica al cliente e impide cobros duplicados.<br>2. Ante fallas de base de datos, se envían respuestas degradadas amigables sin revelar excepciones de código. |
| **Criterios de aceptación** | 1. **Dado** que un usuario está en el Paso 3 del checkout y pierde el acceso a internet, **cuando** recupera la conectividad, **entonces** la aplicación restaura la sesión y los campos diligenciados sin pérdida de información.<br>2. **Dado** la indisponibilidad de la pasarela de pagos, **entonces** el sistema previene la corrupción de la reserva y permite al usuario seleccionar la opción de pago en efectivo en sucursal. |

---

## 📊 TABLA RESUMEN CONSOLIDADORA DE REQUERIMIENTOS NO FUNCIONALES (RNF1 AL RNF12)

| ID | Nombre del Requerimiento No Funcional | Prioridad | ¿Crítico? | Ámbito de Aplicación Principal | Estándar / Mecanismo de Control |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **RNF1** | Rendimiento y Tiempo de Respuesta | Alto | Sí | Todo el Ecosistema (App, Web, Backend) | IEEE 830 / Rest API < 200ms / FCP < 1.5s |
| **RNF2** | Utilización, Usabilidad y UX/UI | Alto | Sí | Interfaz de Usuario y Experiencia de Cliente | Diseños Nielsen Norman / Usabilidad en <3 Clics |
| **RNF3** | Internacionalización (i18n Multi-Idioma) | Alto | Sí | Cliente, Catálogo, Web & App Android | 5 Idiomas (`es`, `en`, `fr`, `pt`, `pt-BR`) / `i18next` |
| **RNF4** | Modo Oscuro Nativo y Temas Visuales | Medio | No | Sistema de Diseño Visual Global | Tokens CSS Globals (`data-theme`) / WCAG AAA |
| **RNF5** | Compatibilidad y Movilidad Responsiva | Alto | Sí | App Android (API 26+) y Portal Web RWD | Android Oreo 8.0+ / Mobile-First / RWD 320px-4K |
| **RNF6** | Seguridad, Cifrado y Habeas Data | Alto | Sí | Autenticación, Datos Sensibles, Pagos | HTTPS TLS 1.3 / JWT / BCrypt factor 12 / OWASP |
| **RNF7** | Escalabilidad y Migraciones con Liquibase | Alto | Sí | Base de Datos Relacional y Backend Spring | **Liquibase Changelogs** / Zero-Downtime Rollbacks |
| **RNF8** | Disponibilidad Operativa (High Availability) | Alto | Sí | Infraestructura Cloud, Servidores, BD | Uptime 99.9% SLA / Failover Automático |
| **RNF9** | Mantenibilidad, Clean Code y Quality | Medio | No | Repositorio `front-end_web/web-drivique` | Principios SOLID / Clean Architecture / SonarQube |
| **RNF10** | Adaptabilidad, Elasticidad y Carga | Alto | Sí | Servidores de Aplicación y Balanceadores | Escalado Horizontal Cloud / Picos > 1,000 req/s |
| **RNF11** | Documentación Técnica y Manuales | Medio | No | Artefactos del Proyecto Drivique | IEEE 830 / SENA SRS / Swagger OpenAPI 3.0 |
| **RNF12** | Tolerancia a Fallos y Resiliencia | Alto | Sí | Gestión de Estado, Sesión y Conexiones | IndexedDB offline / Circuit Breaker / Retries |

---
*Especificación Técnica de Requerimientos No Funcionales (`non-functional-requirements.md`) ajustada al Estándar IEEE 830-1998 y la Metodología SENA para el proyecto Drivique.*
