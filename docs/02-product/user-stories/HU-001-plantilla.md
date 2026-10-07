# Plantilla oficial de historias de usuario - Drivique

**Historia documental de origen:** HU-DOC-002 · **Responsable:** Danna Valentina Barrios Penagos · **Fecha:** 2026-10-06

## 1. Uso y convenciones

Copiar la estructura de la sección 2 a un archivo nuevo y reemplazar los campos entre corchetes. No se considera una HU lista mientras conserve campos sin resolver. El identificador debe ser único en el repositorio; `HU-DOC-*` identifica trabajo documental y `HU-*` identifica una historia del producto según la convención que acuerde el equipo. El nombre de esta plantilla no crea una historia funcional HU-001 ni reemplaza historias existentes.

Cada HU incluye DoR, DoD y un Checklist de ejecución y cierre: el DoR define si puede comenzar, el DoD define si puede terminar y el checklist organiza las tareas para lograrlo.

La historia expresa una necesidad de un actor y un beneficio; el detalle técnico va en notas y dependencias. Debe ser suficientemente pequeña para validar un resultado. Si mezcla distintos actores o resultados, dividirla conservando los vínculos RF.

## 2. Estructura para copiar

### [ID]: [Título orientado al resultado]

| Campo | Valor |
| --- | --- |
| ID | [Identificador único] |
| Módulo / elemento del backlog | [BL-xx y nombre] |
| Responsable | [Persona asignada] |
| Actor | [Cliente / Administrador general / Encargado de sucursal / otro actor especificado] |
| Plataforma | [App cliente / Web cliente / Panel web / Documentación] |
| Prioridad MoSCoW | [Must / Should / Could / Won't en esta entrega] |
| Estado | [Propuesta / Lista / En curso / En revisión / Terminada] |
| RF y subrequisitos | [IDs y enlaces a fichas de functional-requirements.md] |
| RNF | [IDs aplicables y enlaces; justificar si no aplica] |
| Dependencias | [HU, datos, servicios o decisiones previas] |
| Estimación | [Acordada por el equipo; no estimada si aún no se evaluó] |

**Como** [actor], **quiero** [acción o capacidad], **para** [beneficio observable].

### Contexto y alcance

[Problema que resuelve, qué incluye y qué excluye esta historia. Indicar si afecta solo una sucursal o a toda la operación.]

### Reglas de negocio y datos

- [Regla referenciada a un RF; unidades, estados y límites cuando aplique.]
- [Datos de entrada, validación y resultado esperado.]
- [Reglas de autorización y protección de datos cuando aplique.]

### Criterios de aceptación

Un escenario por resultado verificable. Usar Gherkin con `# language: es` y las palabras `Dado`, `Cuando`, `Entonces` y `Y` (equivalentes a Given, When, Then y And). Cada escenario debe tener precondición, acción y resultado observable. Evitar criterios vagos como "funciona correctamente" y no escribir código de implementación como resultado.

```gherkin
# language: es
Característica: [Capacidad descrita por la historia]

  Escenario: [Resultado esperado del flujo principal]
    Dado [un actor y estado inicial concretos]
    Cuando [el actor ejecuta una acción]
    Entonces [se obtiene un resultado observable]
    Y [se cumple una segunda condición verificable]

  Escenario: [Entrada inválida o condición de negocio incumplida]
    Dado [la condición que provoca el rechazo]
    Cuando [el actor intenta la acción]
    Entonces [el sistema rechaza la acción con un mensaje definido]
    Y [los datos o estados que deben preservarse no cambian]

  Escenario: [Acceso sin autorización, cuando aplique]
    Dado [un usuario sin el permiso o ámbito requerido]
    Cuando [intenta la operación protegida]
    Entonces [se deniega la operación]
    Y [no se muestran ni modifican datos fuera de su autorización]
```

### Notas técnicas y trazabilidad

[Enlaces a diseño, diagrama, contrato API y modelo de datos existentes. No inventar endpoints, tablas, pantallas ni IDs de pruebas. Marcar como decisión pendiente si aún no existen.]

### DoR (Definition of Ready)

Condiciones que deben cumplirse antes de pasar la HU a Lista e iniciar su ejecución.

- [ ] Actor, necesidad, valor y alcance definidos, sin campos pendientes de diligenciar.
- [ ] RF/RNF y criterios de aceptación claros, trazables y revisados.
- [ ] Dependencias resueltas o disponibles para ejecutar la historia.
- [ ] Insumos necesarios disponibles: documentos, diseños, contratos API, datos o accesos, según aplique.
- [ ] Responsable, prioridad y estimación acordados por el equipo.
- [ ] Repositorios y rama de trabajo identificados conforme al flujo de la HU.

### DoD (Definition of Done)

Condiciones para considerar terminada la HU, junto con la Definition of Done del proyecto.

- [ ] Resultado solicitado entregado dentro del alcance acordado.
- [ ] Todos los criterios de aceptación cumplen y tienen evidencia verificable.
- [ ] Validaciones aplicables completadas, incluidos errores, permisos y regresiones cuando corresponda.
- [ ] Código o documentos claros, consistentes y sin información ficticia presentada como verificada.
- [ ] Documentación y trazabilidad actualizadas.
- [ ] Cambios revisados por el equipo y observaciones resueltas.
- [ ] PR y controles del flujo de integración de la HU completados, cuando aplique.

### Checklist de ejecución y cierre

Pasos concretos para realizar esta historia. Adaptar cada tarea al alcance; justificar los puntos que no apliquen y marcar únicamente acciones realizadas con evidencia.

- [ ] Revisar requisitos, fuentes y dependencias; comprobar el DoR.
- [ ] Preparar la rama de la HU y delimitar archivos o componentes que se modificarán.
- [ ] [Realizar la primera tarea específica de la historia].
- [ ] [Realizar la segunda tarea específica de la historia].
- [ ] [Completar la integración o consolidación del resultado].
- [ ] Validar cada escenario de aceptación y registrar resultados.
- [ ] Actualizar documentación y referencias afectadas.
- [ ] Revisar el diff y ejecutar los controles de calidad aplicables.
- [ ] Preparar commit y PR con descripción, validación y evidencia conforme al flujo acordado.
- [ ] Resolver observaciones de revisión y comprobar el DoD antes de cerrar la HU.

### Evidencia y revisión

**Evidencia:** [Enlaces verificables a pruebas, capturas, documentos o PR].
**Revisión:** [Revisor, fecha y resultado].

## 3. Ejemplo diligenciado (ilustrativo; no crea una HU adicional)

**Título:** Confirmar el recaudo presencial de una reserva.
**Actor:** Encargado de sucursal. **Plataforma:** Panel web.
**Backlog:** BL-05. **Prioridad propuesta:** Must.
**Referencias:** RF24.1 a RF24.4 y RF47; RNF6 y RNF11.
**Dependencias:** reserva pendiente de efectivo, plazo vigente y autorización para operar la sede.
**Estado:** ejemplo de redacción, sin implementación ni pruebas certificadas.

**Como** Encargado de sucursal, **quiero** registrar el pago en efectivo de una reserva de mi sede, **para** confirmar el alquiler y entregar al cliente su comprobante.

```gherkin
# language: es
Característica: Confirmación de pago presencial

  Escenario: Recaudo de una reserva con plazo vigente
    Dado que una reserva de mi sucursal está en estado PENDIENTE_EFECTIVO
    Y que su plazo de pago no ha vencido
    Y que tengo autorización para confirmar el recaudo
    Cuando registro el pago recibido conforme al total de la reserva
    Entonces la reserva queda en estado CONFIRMADA
    Y se emite un comprobante asociado al pago y a la reserva

  Escenario: Reserva cancelada por vencimiento
    Dado que la reserva está en estado CANCELADA_POR_TIEMPO
    Cuando intento registrar el recaudo como confirmación de esa reserva
    Entonces el sistema rechaza la confirmación e informa el vencimiento
    Y la reserva permanece en estado CANCELADA_POR_TIEMPO

  Escenario: Reserva de otra sucursal
    Dado que tengo permisos únicamente para mi sucursal
    Y que la reserva pertenece a otra sucursal
    Cuando intento confirmar su pago
    Entonces el sistema deniega la operación
    Y no modifica el pago ni la reserva
```

Los escenarios concretan resultados de RF24/RF47 y el límite de sucursal; el equipo debe revisarlos al crear la historia real. El ejemplo evita fijar la fórmula del vencimiento, que requiere reconciliación en el SRS.

### DoR (Definition of Ready)

- [ ] RF24/RF47 y permisos de caja revisados; regla de vencimiento acordada para la historia real.
- [ ] Reservas de prueba disponibles: vigente, vencida y de otra sucursal.
- [ ] Flujo de recaudo, contrato API y entorno de prueba disponibles.

### DoD (Definition of Done)

- [ ] El recaudo autorizado confirma la reserva vigente y emite su comprobante.
- [ ] Las reservas vencidas y las operaciones fuera del ámbito autorizado se rechazan sin modificar datos.
- [ ] Los escenarios Gherkin tienen evidencia y el equipo revisó el resultado.
- [ ] Documentación, trazabilidad y controles de integración aplicables completados.

### Checklist de ejecución y cierre

- [ ] Comprobar dependencias y preparar la rama de la historia real.
- [ ] Implementar o integrar el registro de recaudo con el backend.
- [ ] Aplicar validaciones de estado, vencimiento y autorización de sucursal.
- [ ] Conectar la confirmación y el comprobante con la reserva correspondiente.
- [ ] Validar los escenarios con los datos de prueba definidos.
- [ ] Registrar evidencia, actualizar documentación y preparar el PR.
- [ ] Resolver la revisión y comprobar el DoD antes de cerrar.

Las casillas del ejemplo permanecen sin marcar: ilustran la estructura y no representan trabajo ejecutado.

## 4. Referencias

- [Backlog MoSCoW](../backlog.md).
- [Requisitos funcionales](../../01-srs/functional-requirements.md) y [no funcionales](../../01-srs/non-functional-requirements.md).
- [Definition of Done](../../08-development/definition-of-done.md).
- [SRS consolidado y decisiones pendientes](../../01-srs/srs.md).
