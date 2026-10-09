# Despliegue en Calidad (QA)

El entorno de Quality Assurance (QA) busca replicar las condiciones de Producción lo más cercanamente posible para garantizar que las pruebas sean válidas y confiables.

## Componentes y Servicios

1. **Base de Datos**
   * **Tecnología:** Instancia de PostgreSQL gestionada o Docker en VPS dedicado.
   * **Manejo de Datos:** Sembrado (Seeding) con datos sintéticos que cubren todos los casos borde (Edge Cases) detectados.

2. **Aplicación Web (Frontend)**
   * **Tecnología:** Netlify.
   * **Flujo:** Despliegue automático de la rama `qa`. Genera una URL estable (ej. `qa.drivique.com`) para que el equipo de pruebas automatizadas E2E pueda ejecutar sus scripts.

3. **Aplicación Móvil (App)**
   * **Tecnología:** Expo EAS (Canal Preview).
   * **Flujo:** Genera un archivo `.apk` (Android) y un `.tar.gz` o TestFlight interno (iOS) distribuido exclusivamente a los analistas de QA.

4. **Backend (API)**
   * **Tecnología:** VPS con Docker Compose (idéntico a la orquestación planeada para producción).
   * **CI/CD:** Pipeline automatizado ligado a la rama `qa`. Incluye pasos obligatorios de pruebas de integración antes de desplegar.
