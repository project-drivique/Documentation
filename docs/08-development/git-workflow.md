# Flujo de Trabajo Git y Convenciones (Git Workflow)



## 2. Convención de Commits (Conventional Commits)

Es estrictamente obligatorio seguir el estándar de **Conventional Commits** para mantener un historial limpio y autogenerar Changelogs.

**Formato:**
```text
<tipo>[ámbito opcional]: <descripción breve>

[cuerpo opcional]
```

**Tipos permitidos:**
* `feat:` Nueva funcionalidad o característica (ej. `feat(auth): agrega login con Google`).
* `fix:` Corrección de un bug (ej. `fix(cart): resuelve error al calcular el total`).
* `docs:` Cambios exclusivos en la documentación (ej. `docs(uml): actualiza diagrama de clases`).
* `refactor:` Cambio en el código que no corrige un bug ni añade una funcionalidad.
* `test:` Añadir o corregir pruebas (ej. `test(api): añade pruebas unitarias para reservas`).
* `chore:` Actualizaciones de tareas de construcción, gestor de paquetes, etc.

**Reglas adicionales:**
* Usar verbos en imperativo ("agrega", "corrige", "cambia").
* No usar punto final en el título.
* Mantener la primera línea bajo 72 caracteres.
