# Business Rules

- El cliente debe verificar su correo electrónico después del registro.
- El acceso al sistema utiliza autenticación JWT.
- El sistema maneja roles: cliente, administrador, encargado de sucursal, operador y supervisor.
- Un cliente puede explorar vehículos sin sesión, pero algunas acciones están restringidas.
- Para reservar, el usuario debe completar el proceso de reserva y aceptar el tratamiento de datos.
- El cliente debe tener licencia de conducir vigente.
- Los vehículos deben estar disponibles para poder ser reservados.
- La fecha de devolución debe ser posterior a la fecha de recogida.
- La reserva solo puede confirmarse si el pago fue aprobado o verificado en efectivo.
- El contrato solo se muestra cuando la reserva está confirmada.
- El pago en efectivo debe ser confirmado por el encargado de sucursal.
- Las reservas pueden cambiar de estado según el proceso del sistema.
- Cada acción relevante debe quedar registrada en auditoría.
- El sistema debe respetar las restricciones de alcance definidas en el SRS.
