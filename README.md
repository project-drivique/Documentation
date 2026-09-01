# Documentación del Proyecto Drivique

Bienvenido al repositorio central de documentación del proyecto **Drivique** (incluyendo Web, Móvil y Backend). 

Para garantizar un orden impecable y cumplir con los más altos estándares académicos y de la industria de la ingeniería de software, toda nuestra documentación está organizada dentro de la carpeta `docs/`. A continuación, explicamos cómo navegarla y qué tipo de información debes colocar en cada carpeta.

---

## 📂 Estructura de Directorios (`docs/`)

### `01-srs/` (Software Requirements Specification)
Contiene la base fundamental del proyecto. Aquí detallamos **qué** va a hacer el sistema.
- **`srs.md`**: Documento central de requerimientos (estándar IEEE 830).
- **`requisitos-funcionales.md / no-funcionales.md`**: Listas detalladas de lo que el sistema debe hacer y sus restricciones técnicas (rendimiento, seguridad).
- **`matriz-trazabilidad.md`**: Tabla que conecta cada requerimiento con su caso de uso o historia de usuario correspondiente.

### `02-product/`
Gestión ágil y visión del producto desde la perspectiva del negocio y del usuario final.
- **`vision-y-alcance.md`**: El "por qué" del proyecto y hasta dónde llega.
- **`user-stories/`**: Carpeta para guardar cada Historia de Usuario individual (usando el formato "Como [rol], quiero [acción] para [resultado]").
- **`backlog.md`**: Resumen de tareas priorizadas.
- **`glossary.md`**: Diccionario de términos de negocio para que todos hablemos el mismo idioma.

### `03-design/`
Diseño del sistema previo a la codificación (Diagramas UML y diseño de interfaz).
- **`use-cases/`**: Diagramas de casos de uso y su especificación detallada.
- **`uml/`**: Diagramas de clases, secuencias y componentes que modelan cómo funciona internamente el software.
- **`ui-ux/`**: Enlaces a Figma, paletas de colores, wireframes y sistemas de diseño.
- **`patrones/`**: Documentación sobre qué patrones de diseño (ej. Singleton, Factory, MVC) se están usando en cada frente.

### `04-architecture/`
Decisiones profundas de ingeniería y bases de datos.
- **`overview.md`**: Diagrama de arquitectura de alto nivel (cómo se conecta Web, App, Backend y BD).
- **`decisions/` (ADRs):** *Architecture Decision Records*. Archivos vitales donde justificamos por qué elegimos una tecnología (ej. ¿Por qué PostgreSQL y no MongoDB? ¿Por qué React y no Angular?).
- **`database/`**: Modelos Entidad-Relación, diccionario de datos (`data-dictionary.md`) y scripts/migraciones.
- **`reglas-negocio/`**: Lógica estricta de la aplicación (ej. cómo se calculan las reservas, tarifas).

### Específicos por Componente:
Estas tres carpetas detallan la implementación técnica particular de cada frente del proyecto. En cada una encontrarás su **Estructura de Carpetas (`folder-structure.md`)** y su **Stack Tecnológico (`tech-stack.md`)**:
- **`05-web/`**: Documentación exclusiva para el frontend web en navegador (Vite/React).
- **`06-mobile/`**: Documentación exclusiva para la aplicación móvil (Drivique App).
- **`07-backend/`**: Documentación exclusiva de la API, servicios, controladores y seguridad del lado del servidor.

### Desarrollo y Operaciones:
- **`08-development/`**: Manuales sobre cómo trabajamos. Incluye nuestro flujo de ramas en Git (`git-workflow.md`), convenciones de nombres, estándares de código y guías de Testing.
- **`09-deployment/`**: Instrucciones paso a paso sobre cómo compilar y subir el proyecto a servidores en entornos de `dev` (desarrollo), `qa` (pruebas) y `production` (producción).

### Otros Archivos:
- **`CHANGELOG.md`**: Registro de cambios importantes por versión.
- **`CONTRIBUTING.md`**: Guía para que nuevos desarrolladores sepan cómo empezar a contribuir al proyecto.
- **`assets/`**: Carpeta contenedora únicamente para imágenes y diagramas exportados (png, jpg, pdf) que son referenciados desde los demás `.md`.

---
> 💡 **Nota para el equipo de desarrollo:** Por favor, asegúrate de crear ramas específicas para modificar estos documentos y seguir el flujo de *Pull Requests* para revisión de pares. Nunca hagas commits directamente en la rama principal.