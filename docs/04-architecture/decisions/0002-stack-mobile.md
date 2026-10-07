# ADR 0002: Stack móvil de Drivique

| Campo | Valor |
| --- | --- |
| Estado | Decisión documentada sobre el código existente; pendiente de revisión del equipo |
| Fecha | 2026-10-06 |
| Responsable | Danna Valentina Barrios Penagos |
| Historia | HU-DOC-003 |
| Alcance | App para clientes; no incluye panel administrativo |

## Contexto

El cliente necesita consultar vehículos, configurar reservas, gestionar su cuenta, pagar y consultar contrato y seguimiento desde un dispositivo móvil. La lógica de disponibilidad, pagos y autorización debe compartirse con la web mediante el mismo backend. El proyecto dispone de una aplicación React Native organizada con Expo Router y módulos de negocio.

La **web contiene portal cliente y panel administrativo**, mientras la **app se limita al cliente**. La capacidad de Expo para otras plataformas o la presencia de un script `ios` no comprometen una entrega iOS ni habilitan administración móvil.

## Decisión

Mantener **React Native con Expo y Expo Router**, **TypeScript en modo estricto**, módulos y hooks por dominio, y **i18next con react-i18next** para internacionalización reactiva. Compartir contratos API y reglas de negocio con el backend; mantener separadas la navegación móvil y las vistas administrativas web.

### Versiones declaradas

| Dependencia / configuración | Declaración revisada | Responsabilidad |
| --- | --- | --- |
| Expo | `~57.0.21` | Herramientas e integración del proyecto móvil. |
| Expo Router | `~57.0.20`; entrada `expo-router/entry` | Navegación a partir de archivos. |
| React Native / React | `0.86.3` / `19.2.3` | Componentes y ejecución de la app. |
| TypeScript | `~5.9.2`; `strict: true` | Comprobación estática de tipos. |
| i18next / react-i18next | `^26.1.0` / `^17.0.7` | Recursos y actualización de traducciones. |
| Expo Localization | `~57.0.1` | Consulta de configuración regional del dispositivo. |
| AsyncStorage | `2.2.0` | Persistencia local utilizada según necesidad del módulo. |
| Expo Secure Store | `~57.0.0` | Herramienta declarada para almacenamiento seguro nativo; verificar uso en cada flujo. |
| Axios | `^1.7.9` | Comunicación HTTP con API. |
| Zustand | `^5.0.13` | Estado compartido de aplicación. |

Las declaraciones no prueban compatibilidad ni una instalación concreta. Deben validarse contra el lockfile y controles del entorno móvil de la rama.

## Justificación

### React Native y Expo Router

La app ya separa rutas dentro de `app/` y responsabilidades en módulos como autenticación, catálogo, reserva y perfil. Mantener esa organización permite evolucionar pantallas y servicios existentes sin introducir un cliente administrativo. Expo Router está definido como punto de entrada y los layouts conectan navegación con preferencias de tema.

### TypeScript estricto

`tsconfig.json` extiende la configuración base de Expo y activa `strict: true`. El tipado ayuda a mantener contratos, propiedades y estados de los módulos. Se conserva `skipLibCheck: true`, por lo que no se presenta la configuración como una comprobación exhaustiva de todas las declaraciones de dependencias. La comprobación estática tampoco reemplaza validaciones de entradas en el servidor.

### Idiomas y actualización reactiva

La fuente `modules/i18n/index.ts` registra cinco variantes:

| Variante de producto | Clave de la implementación revisada | Recurso |
| --- | --- | --- |
| Español | `es` | `translations/es.ts` |
| Inglés | `en` | `translations/en.ts` |
| Francés | `fr` | `translations/fr.ts` |
| Portugués | `pt` | `translations/pt.ts` |
| Portugués de Brasil | `br` | `translations/br.ts` |

Se utiliza `initReactI18next` y fallback a español. `useIdioma` y `useTemaColores`, exportados desde el hook de idioma/tema, conectan preferencias y colores con las pantallas; los layouts y pantallas los consumen. El cambio de idioma debe conservar el estado del formulario y reflejarse en los componentes suscritos.

La variante brasileña corresponde conceptualmente a `pt-BR`, pero el código usa la clave interna `br`. La normalización de esa clave en API/BD se debe validar explícitamente. Las cinco variantes corresponden a la aclaración de Danna y a RNF3.

La inicialización detecta `languageCode`; la distinción automática de región brasileña requiere revisar la configuración regional completa. La presencia de cinco archivos no acredita cobertura total de traducciones ni detección regional probada.

### Hooks y servicios

`useAuth`, `useCatalog`, `useProfile`, `useIdioma`, `useTemaColores` y `useCurrency` representan capacidades reutilizables. Las pantallas consumen estado y servicios; las reglas críticas permanecen en el backend. Preferencias locales y borradores no deben convertirse en fuente de verdad de disponibilidad, pago o autorización de entrega.

## Alternativas evaluadas para documentar la decisión

| Alternativa | Evaluación para esta entrega |
| --- | --- |
| Mantener React Native + Expo Router | Seleccionada: coincide con la implementación modular disponible. |
| App nativa Android con Kotlin | Requeriría una reescritura y otro conjunto de componentes para las funciones existentes. |
| Flutter | Implicaría migrar pantallas y servicios a otro stack sin una necesidad de producto acordada. |
| Solo portal web/PWA | No representa la app React Native actual ni los entregables móviles del plan. |

La evaluación considera continuidad del proyecto; no afirma superioridad general ni resultados de benchmark.

## Consecuencias y controles

- Las rutas de cliente no deben incluir pantallas ni operaciones administrativas.
- API, sesión y errores se centralizan en servicios; configuración por ambiente mediante `EXPO_PUBLIC_API_URL` según el contrato de integración.
- Se revisa compatibilidad de dependencias Expo/React Native con build, comprobación de tipos y pruebas relevantes de la rama.
- Idiomas, tema, estado de formularios y recuperación de desconexión requieren pruebas específicas RNF3/RNF4/RNF12.
- El alcance Android mínimo se concilia con RNF5 y con los dispositivos probados; este ADR no acredita una matriz de dispositivos ejecutada.
- Firma, carga documental y documentos PDF se verifican por flujo; la librería declarada no demuestra disponibilidad de todo el recorrido.

## Evidencia y trazabilidad

Fuentes consultadas en el clon local, rama `HU-INT-04-dev`, commit `3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4`:

- [app-drivique/package.json](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/package.json)
- [app-drivique/tsconfig.json](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/tsconfig.json)
- [app-drivique/app/_layout.tsx](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/app/_layout.tsx)
- [app-drivique/modules/i18n/index.ts](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/modules/i18n/index.ts)
- [app-drivique/modules/i18n/hooks/useLanguage.ts](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/modules/i18n/hooks/useLanguage.ts)
- [app-drivique/modules/auth/hooks/useAuth.ts](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/modules/auth/hooks/useAuth.ts)
- [app-drivique/modules/catalog/hooks/useCatalog.ts](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/modules/catalog/hooks/useCatalog.ts)
- [app-drivique/modules/profile/hooks/useProfile.ts](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/modules/profile/hooks/useProfile.ts)
- [app-drivique/hooks/useCurrency.ts](https://github.com/project-drivique/front-end_movil/blob/3374d4c8a9ca1286f79dfcc63019b9ef3ba5b4b4/app-drivique/hooks/useCurrency.ts)

Relacionados: [ADR web](0001-stack-web.md), [arquitectura C4](../overview.md), [RNF](../../01-srs/non-functional-requirements.md) y [SRS](../../01-srs/srs.md). Esta HU documenta decisiones y no modifica la app ni certifica sus pruebas.
