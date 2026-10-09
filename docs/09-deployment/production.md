# Despliegue en Producción (PROD)

El entorno de Producción es crítico. Se prioriza la estabilidad, la alta disponibilidad, el monitoreo continuo y la seguridad estricta.

## Componentes y Servicios

1. **Base de Datos**
   * **Tecnología:** PostgreSQL Gestionado (ej. Supabase, AWS RDS, o un clúster propio bien configurado).
   * **Respaldo:** Backups automatizados diarios (Point-in-Time Recovery). Cifrado en reposo.

2. **Aplicación Web (Frontend)**
   * **Tecnología:** Netlify (Production Branch `main`).
   * **Flujo:** Todo push a `main` desencadena la construcción de producción. Red de Distribución de Contenidos (CDN) activada globalmente bajo el dominio oficial (ej. `www.drivique.com`).

3. **Aplicación Móvil (App)**
   * **Tecnología:** Expo EAS Build (Canal Production) y EAS Submit.
   * **Flujo:** 
     1. Se genera la compilación final firmada para producción (`.aab` para Android, `.ipa` para iOS).
     2. Se envía (Submit) a la **Google Play Store** y **Apple App Store** para revisión oficial.
     3. Actualizaciones menores (OTA - Over The Air) se gestionan a través de EAS Update si no tocan código nativo.

4. **Backend (API)**
   * **Tecnología:** VPS Dedicado (Alta capacidad) o Infraestructura Cloud Auto-escalable con contenedores Docker.
   * **Monitoreo:** Integración con herramientas de observabilidad (Logs, APM, alertas de caída).
   * **CI/CD:** Pipeline estricto. Solo administradores pueden aprobar despliegues en Producción (Gatekeeping). Incluye revisiones de seguridad y pruebas de humo (Smoke Tests) post-despliegue.
