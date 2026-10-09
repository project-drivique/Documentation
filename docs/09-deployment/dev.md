# Despliegue en Desarrollo (DEV)

El entorno de desarrollo está diseñado para ser ágil y económico, priorizando la velocidad de iteración sobre la alta disponibilidad.

## Componentes y Servicios

1. **Base de Datos (Local/Nube)**
   * **Tecnología:** Docker Compose (PostgreSQL).
   * **Configuración:** Despliegue local rápido o en un VPS económico.
   * **Comando típico:** `docker-compose -f docker-compose.dev.yml up -d`

2. **Aplicación Web (Frontend)**
   * **Tecnología:** Netlify (Branch Previews).
   * **Flujo:** Cualquier push a la rama `dev` genera un despliegue automático (Preview URL).

3. **Aplicación Móvil (App)**
   * **Tecnología:** Expo EAS (Canal Development) / Expo Go.
   * **Flujo:** Distribución interna mediante códigos QR para los desarrolladores.

4. **Backend (API)**
   * **Tecnología:** VPS (Virtual Private Server) económico con Docker.
   * **CI/CD:** Pipeline básico que compila, crea la imagen y reinicia el contenedor al detectar cambios en `dev`.
