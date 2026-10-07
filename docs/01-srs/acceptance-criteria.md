# Criterios de aceptación globales del SRS - Drivique

Las casillas distinguen **consistencia documental comprobada** de **implementación y pruebas pendientes de evidencia**. Una ficha o ruta API no certifica que todo el flujo esté terminado.

## 1. Consistencia documental

- [x] RF1 a RF54 están inventariados y sus nombres coinciden entre fichas, resumen y matriz.
- [x] RNF1 a RNF12 están identificados en la especificación y la matriz.
- [x] El alcance establece app exclusiva de cliente, sin panel administrativo, y web con portal cliente y panel administrativo.
- [x] RF27/RF52 establecen PIN de entrega de exactamente 4 dígitos numéricos; OTP de correo de RF4 permanece en 6 dígitos.
- [x] Los idiomas de producto son español (`es`), inglés (`en`), francés (`fr`), portugués (`pt`) y portugués de Brasil (`pt-BR`); el frontend revisado usa `br` como clave interna para la variante brasileña.
- [x] La matriz diferencia tablas/rutas observadas y capacidades pendientes en lugar de asignar relaciones no verificadas.

## 2. Implementación y validación

- [ ] Validar el recorrido de cliente en web y app, y la operación administrativa exclusivamente en web.
- [ ] Verificar cinco variantes de idioma, fallback a español y conservación de estado al cambiar idioma; normalizar `br` / `pt-BR` entre capas.
- [ ] Verificar temas claro/oscuro y contraste en todas las vistas incluidas.
- [ ] Verificar generación y validación de PIN de entrega de 4 dígitos, incluidos ceros iniciales, formato inválido y autorización; mantener separado el OTP de correo.
- [ ] Validar pagos Wompi, vencimiento de efectivo, contrato, entregas/devoluciones y sus escenarios de error.
- [ ] Completar y validar los requisitos de domicilios, reseñas con fotos y respuesta oficial inmutable donde la cobertura actual es insuficiente.
- [ ] Verificar autorización por usuario/rol/sucursal, protección de datos y controles de seguridad.
- [ ] Verificar migraciones de PostgreSQL/Liquibase y sus procedimientos de recuperación.

## 3. Trazabilidad y cierre

- [ ] Vincular cada RF con el caso de uso y secuencia reales, justificando interacciones que no requieran secuencia backend.
- [ ] Revisar las observaciones de cobertura de la matriz y completar contratos API/modelo físico donde falten.
- [ ] Adjuntar evidencia de pruebas y revisión del equipo antes de marcar una capacidad como cumplida.

Fuentes: [RF](functional-requirements.md), [RNF](non-functional-requirements.md), [SRS](srs.md), [matriz](matriz-trazabilidad.md) y [diccionario de datos](../04-architecture/database/data-dictionary.md). Decisiones de plataforma, PIN e idiomas confirmadas por Danna el 2026-10-06.
