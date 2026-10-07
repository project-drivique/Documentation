# ADR 0001: Stack web de Drivique

| Campo | Valor |
| --- | --- |
| Estado | Decisión documentada sobre el código existente; pendiente de revisión del equipo |
| Fecha | 2026-10-06 |
| Responsable | Danna Valentina Barrios Penagos |
| Historia | HU-DOC-003 |
| Alcance | Portal web cliente y panel administrativo dentro de la misma aplicación web |

## Contexto

Drivique necesita una interfaz web para clientes y personal administrativo. El cliente consulta vehículos, reserva, paga y sigue su alquiler; el Administrador general y el Encargado de sucursal gestionan la operación según permisos. Ambas áreas deben compartir identidad visual y contratos con el backend, manteniendo módulos y navegación por rol.

La app móvil es otro cliente de la misma API y no tiene panel administrativo. El alcance web se establece conforme a la aclaración de Danna: **web para clientes y con panel administrativo**. Esta decisión está sincronizada con el SRS y los requisitos funcionales.

## Decisión

Mantener **React con Vite** como base web, organización modular por dominio, React Router para navegación, CSS por componentes/áreas y variables compartidas de diseño. Reutilizar lógica mediante Custom Hooks y concentrar comunicación HTTP en servicios. Mantener la autorización efectiva y las reglas de negocio críticas en el backend.

### Versiones declaradas en la fuente revisada

| Dependencia | Declaración en package.json | Responsabilidad |
| --- | --- | --- |
| React / React DOM | `^19.2.5` / `^19.2.5` | Componentes y renderizado web. |
| Vite / plugin React | `^8.0.10` / `^6.0.1` | Desarrollo y compilación del frontend. |
| React Router DOM | `^7.15.0` | Rutas públicas, cliente y administración. |
| Axios | `^1.16.0` | Cliente HTTP compartido con API. |
| Zustand | `^5.0.13` | Estado de aplicación y autenticación. |
| TanStack React Query | `^5.100.9` | Dependencia declarada para gestión de consultas; revisar uso por módulo. |
| i18next / react-i18next | `^26.3.1` / `^17.0.8` | Traducciones y actualización de interfaz. |
| Tailwind CSS / plugin Vite | `^4.2.4` / `^4.2.4` | Herramientas de estilos que conviven con el CSS del proyecto. |
| Recharts | `^3.10.1` | Gráficas de interfaz. |

Son rangos declarados, no versiones instaladas certificadas. La versión exacta se determina con el lockfile usado por la rama y CI. El nombre interno antiguo del paquete no altera la marca de esta documentación.

## Justificación

### React y Vite

La aplicación ya utiliza componentes React, rutas y módulos de autenticación, catálogo, reservas, pagos y administración. Mantener esta base permite evolucionar esos módulos sin reescribir el frontend ni cambiar los contratos del producto. Vite está incorporado a los scripts de desarrollo y build; su elección se fundamenta en la estructura y herramientas del repositorio, no en un benchmark comparativo.

### CSS modular por responsabilidad y tokens

La fuente contiene CSS por módulos y componentes, además de `index.css`, `styles/brand-system.css`, `styles/admin-system.css` y `styles/responsive.css`. Las variables `--brand-primary`, `--brand-secondary`, `--brand-accent` y variantes de texto, bordes y superficies centralizan el diseño y el tema. La implementación revisada usa valores **hexadecimales y RGB/RGBA** y activa variantes mediante `html.dark`.

El plan original solicita Vanilla CSS con tokens HSL. Se conserva el objetivo de estilos por responsabilidad y tokens compartidos; **HSL no se presenta como implementado** porque no corresponde al código revisado. Si se acuerda normalizar colores a HSL, será un cambio específico del sistema de estilos con validación visual. Los CSS existentes tampoco se describen como CSS Modules (`*.module.css`), porque no utilizan esa forma de encapsulación.

### Custom Hooks y separación de responsabilidades

| Hook existente | Responsabilidad que representa |
| --- | --- |
| `useBranchScope` | Obtener contexto del usuario/sucursal para la interfaz; no reemplaza autorización del servidor. |
| `useManagementTable` | Reutilizar estado y operaciones de tablas de gestión. |
| `useManagementModal` | Reutilizar apertura, cierre y estado de modales. |
| `useManagementExport` | Centralizar acciones de exportación de gestión. |

Los hooks reducen repetición entre páginas de administración. Los servicios de módulos y `httpClient.js` separan llamadas API del renderizado. La interfaz puede restringir navegación para mejorar la experiencia, pero el servidor valida permisos en cada operación.

## Alternativas evaluadas para documentar la decisión

| Alternativa | Evaluación para esta entrega |
| --- | --- |
| Mantener React + Vite | Seleccionada: coincide con módulos y herramientas existentes. |
| Migrar a Angular o Vue | Requeriría reescribir componentes y navegación sin una necesidad de producto que justifique ese alcance. |
| Adoptar un framework con renderizado en servidor | Exigiría una decisión adicional sobre SEO, hosting y arquitectura; no está requerida para completar esta HU. |
| Reemplazar todos los estilos por una biblioteca de componentes | Exigiría migración visual y validación; los tokens y estilos actuales permiten continuar la entrega. |

Estas alternativas no representan pruebas de rendimiento ni una evaluación universal de superioridad.

## Consecuencias

- El equipo mantiene componentes, rutas, servicios y hooks coherentes entre portal cliente y panel.
- Los cambios de dependencias se validan con el lockfile, lint/build y pruebas relevantes; no se fija React 18 si el repositorio declara React 19.
- Los estilos globales requieren cuidado para evitar efectos entre módulos; tokens, convenciones y revisión visual reducen ese riesgo.
- La API se configura por ambiente mediante `VITE_API_URL`. El código conserva fallback local solo de desarrollo y opción mock; esta ADR no certifica que todos los módulos estén integrados sin simulación.
- El cliente HTTP revisado adjunta Bearer y maneja renovación de sesión. La seguridad del almacenamiento y la sesión se evalúa en las HU de autenticación; una declaración de arquitectura no acredita pruebas de seguridad.
- Las prioridades de accesibilidad, tema e idiomas se contrastan con RNF2–RNF6.

## Diferencias con el plan

El plan menciona React 18 y tokens HSL. El código revisado declara React 19 y tokens hex/RGB con Tailwind además de CSS propio. Documentar estas diferencias mantiene una decisión verificable; no se cambia el stack del producto para hacerlo coincidir con una descripción anterior.

## Evidencia y trazabilidad

Fuentes consultadas en el clon local, rama `HU-INT-04-dev`, commit `701c61b5cefa1da259fe99d80b7a89bcffdcbdea`. Los enlaces siguientes fijan esa revisión:

- [web-drivique/package.json](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/package.json)
- [web-drivique/src/routes/AppRouter.jsx](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/src/routes/AppRouter.jsx)
- [web-drivique/src/styles/brand-system.css](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/src/styles/brand-system.css)
- [web-drivique/src/index.css](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/src/index.css)
- [web-drivique/src/hooks/useBranchScope.js](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/src/hooks/useBranchScope.js)
- [web-drivique/src/hooks/useManagementTable.js](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/src/hooks/useManagementTable.js)
- [web-drivique/src/hooks/useManagementModal.js](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/src/hooks/useManagementModal.js)
- [web-drivique/src/hooks/useManagementExport.js](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/src/hooks/useManagementExport.js)
- [web-drivique/src/services/httpClient.js](https://github.com/project-drivique/front-end_web/blob/701c61b5cefa1da259fe99d80b7a89bcffdcbdea/web-drivique/src/services/httpClient.js)

Relacionados: [arquitectura C4](../overview.md), [ADR móvil](0002-stack-mobile.md), [SRS](../../01-srs/srs.md) y [RNF](../../01-srs/non-functional-requirements.md). El plan de actualización define esta entrega como HU-DOC-003; no se modifican dependencias ni código web en esta HU.
