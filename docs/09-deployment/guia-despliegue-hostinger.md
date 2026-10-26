# Guía de despliegue de Drivique en Hostinger (VPS KVM 1)

Guía paso a paso para publicar **Drivique** (base de datos + backend + web + app) en un VPS de Hostinger con HTTPS, respaldos automáticos y APK de la app. Está escrita para que la siga alguien que no ha visto el proyecto. Lee las secciones 1 y 2 completas antes de empezar.

> **Esta guía es autocontenida:** todos los archivos que hacen falta (Docker, Caddy, scripts) están al final, en los **Anexos**, para copiarlos y pegarlos en el servidor. No depende de ninguna carpeta del repositorio.
>
> **Aviso de honestidad:** los scripts y el `docker-compose` se validaron (sintaxis y configuración), pero la guía **no se probó de punta a punta en un servidor real**. Si algo del entorno de quien despliega es distinto (versión de Ubuntu, memoria, proveedor), usa la tabla de *Problemas comunes* (sección 12) y adapta lo necesario.

> **Regla de oro:** se despliega **siempre desde la rama `main`** de los 4 repositorios. Antes de desplegar, confirma que `main` tiene los últimos cambios (ver sección 3).

---

## 1. Qué se va a instalar y cómo funciona

Un solo servidor (el VPS) con 6 contenedores de Docker. Cada pieza va en su propia "caja", así que se pueden actualizar por separado.

```
Internet ──► Caddy (puertos 80/443, HTTPS automático)
               ├─ https://TU-DOMINIO         ──► web  (React, archivos estáticos)
               ├─ https://app.TU-DOMINIO     ──► app  (versión web de la App móvil)
               └─ .../api/*  (en ambos)      ──► api  (Spring Boot, puerto interno 8080)
                                                  │
                                                  └─► postgres (base de datos, SIN puerto público)
```

| Pieza | Qué es | Se actualiza con |
|---|---|---|
| `postgres` | Base de datos PostgreSQL 17. Sus datos viven en un volumen de Docker. | No se toca; se respalda |
| `migrate` | Liquibase. Aplica los cambios de la base **sin borrar datos**. Corre una vez por despliegue. | `deploy.sh` |
| `api` | Backend Java (Spring Boot). Guarda los archivos subidos (KYC, contratos) en un volumen. | `deploy.sh` |
| `web` | Sitio web (React/Vite) compilado a archivos estáticos. | `deploy.sh` |
| `app` | La App móvil en su **versión web** (para abrirla desde el navegador). | `deploy.sh` |
| `caddy` | Recibe a los visitantes, pone el candado HTTPS y reparte el tráfico. | Se renueva solo |

**El APK no corre en el servidor.** Es un archivo que se instala en el celular Android y se conecta al backend del servidor. Se genera **después** de desplegar (sección 11).

### Qué necesitas tener antes de empezar

- [ ] El **VPS KVM 1** de Hostinger y el **dominio** que Hostinger te dio.
- [ ] La **cuenta de Gmail y su contraseña de aplicación (16 letras)** que **ya usa el proyecto** para enviar correos. **No hay que crear otra:** son las mismas que están en el `Back-end/.env` de quien corre el proyecto en su computador (variables `SPRING_MAIL_USERNAME` y `SPRING_MAIL_PASSWORD`) y en las variables de Render. El servidor nuevo es otra máquina y **no las trae solas**, porque el `.env` no se sube a Git; por eso hay que copiarlas una vez. Solo si no las tienen a la mano, se crea una nueva: cuenta Google → Seguridad → Verificación en 2 pasos (activada) → *Contraseñas de aplicaciones*.
- [ ] Las **claves de Wompi (sandbox)**: `WOMPI_PUBLIC_KEY`, `WOMPI_INTEGRITY_SECRET`, `WOMPI_EVENT_SECRET`. Están en el `Back-end/.env` de quien ya corre el proyecto en su computador.
- [ ] Acceso de lectura a los 4 repositorios de GitHub (`Back-end`, `database`, `front-end_web`, `front-end_movil`).
- [ ] Un computador con **Windows PowerShell** o terminal, para conectarte por SSH.

---

## 2. Configuración del VPS en Hostinger (pantalla "Elige qué instalar")

En el panel de Hostinger, el VPS aparece en *Tus tareas pendientes* como **"La configuración de tu KVM 1 – aún no se ha terminado"** → botón **Configurar**. La pantalla **"Elige qué instalar"** tiene 3 pestañas. Esto es lo que se elige:

| Pestaña | Qué hacer | Por qué |
|---|---|---|
| **Sistema operativo simple** | ✅ **Ubuntu → versión 24.04 LTS** | Es el sistema estable y con soporte hasta 2029. Es el que usa esta guía. |
| Panel de control (cPanel, Plesk, CloudPanel, Coolify, Dokploy…) | ❌ No elegir | cPanel/Plesk piden licencia y consumen memoria que necesitamos. Coolify/Dokploy duplicarían lo que ya hace Caddy. |
| Aplicaciones (n8n, Nextcloud, Docker and Traefik…) | ❌ No elegir | Son programas ya armados. **"Docker and Traefik"** tampoco: Traefik chocaría con Caddy por los puertos 80/443. |

Luego, en los pasos siguientes de Hostinger:

1. **Contraseña de root:** una larga y única. Guárdala en un gestor de contraseñas.
2. **Llave SSH:** si la pantalla ofrece subir una, súbela (sección 5, paso 1 explica cómo crearla). Es más segura que la contraseña.
3. **Respaldos automáticos / snapshots del VPS:** actívalos si el plan los incluye. Son un seguro **adicional** al respaldo diario de la base de datos que hacen los scripts.
4. **Monitoreo:** actívalo si es gratis.
5. Al terminar, Hostinger muestra la **dirección IP del servidor**. Anótala (en esta guía se llama `IP_DEL_SERVIDOR`).

> El plan KVM 1 tiene poca memoria (4 GB). El script de preparación agrega 2 GB de *swap* para que la compilación no falle. No lo omitas.

---

## 3. Antes de desplegar: confirmar que `main` está al día

Los 4 repositorios deben tener en `main` todo lo de `HU-INT-21-dev`. Verifícalo desde un computador con los repos clonados (cada uno debe imprimir `0`):

```bash
git fetch origin
git rev-list --count origin/main..origin/HU-INT-21-dev
```

Si algún repo imprime un número mayor que 0, falta hacer el pull request `HU-INT-21-main` → `main` en ese repo. (Flujo del equipo: `HU-INT-21-dev` → `HU-INT-21-qa` → `HU-INT-21-main` → `main`.)

---

## 4. DNS: apuntar el dominio al servidor

En Hostinger: **Dominios → tu dominio → DNS / Zona DNS**. Crea (o edita) estos 3 registros **tipo A**, todos con valor `IP_DEL_SERVIDOR`:

| Tipo | Nombre | Valor |
|---|---|---|
| A | `@` | `IP_DEL_SERVIDOR` |
| A | `app` | `IP_DEL_SERVIDOR` |
| A | `www` | `IP_DEL_SERVIDOR` |

Borra cualquier otro registro **A** o **AAAA** del `@` que apunte a otra dirección (por ejemplo, la página de "sitio en construcción" de Hostinger), porque Let's Encrypt usaría la equivocada.

Comprueba que ya resuelve (puede tardar de minutos a 1 hora). Desde tu computador:

```bash
nslookup TU-DOMINIO
nslookup app.TU-DOMINIO
```

Ambos deben mostrar `IP_DEL_SERVIDOR`. **No sigas hasta que lo hagan**: sin DNS correcto, el candado HTTPS no se genera.

---

## 5. Conectarse y preparar el servidor

### Paso 1. Llave SSH (recomendado)

En tu computador (PowerShell):

```bash
ssh-keygen -t ed25519 -C "drivique-deploy"
```

Acepta la ruta por defecto. Se crean `id_ed25519` (privada, **no la compartas**) e `id_ed25519.pub` (pública). La pública es la que se sube a Hostinger.

### Paso 2. Entrar al servidor

```bash
ssh root@IP_DEL_SERVIDOR
```

(Si Hostinger te dio el terminal en el navegador, también sirve. Sale con `exit`.)

### Paso 3. Crear y ejecutar el script de preparación

Ya en el servidor, como **root**, crea el archivo y pega dentro el contenido del **Anexo F** (`bootstrap-server.sh`). En `nano`: pegas, `Ctrl+O`, Enter, `Ctrl+X`.

```bash
nano /root/bootstrap-server.sh
bash /root/bootstrap-server.sh
```

Esto: actualiza Ubuntu, pone la zona horaria de Colombia, crea 2 GB de swap, instala Docker, crea el usuario **`deploy`**, activa el firewall (solo puertos 22, 80 y 443), instala **fail2ban** (bloquea quien intente adivinar la clave SSH) y activa las actualizaciones de seguridad automáticas. Si hay llave SSH copiada, **desactiva el acceso por contraseña**.

> Si el script avisa que no copió llaves SSH, agrega tu llave pública a `/home/deploy/.ssh/authorized_keys` y vuelve a ejecutarlo.

A partir de aquí **entra siempre como `deploy`** (no como root):

```bash
ssh deploy@IP_DEL_SERVIDOR
```

---

## 6. Bajar el código de los 4 repositorios

Los repositorios son privados. La forma más simple es un **token de acceso personal de GitHub, de solo lectura**:

1. En GitHub: *Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token*.
2. **Repository access:** *Only select repositories* → los 4 repos. **Permissions → Contents: Read-only.** Caducidad: 90 días.
3. Copia el token (solo se muestra una vez).

En el servidor, como `deploy`:

```bash
cd /opt/drivique
git config --global credential.helper store
for r in Back-end database front-end_web front-end_movil; do
  git clone --branch main https://github.com/project-drivique/$r.git
done
```

La primera vez pide usuario (tu usuario de GitHub) y contraseña (**pega el token**); lo recuerda para las siguientes. Al terminar:

```bash
ls /opt/drivique
```

Deben aparecer los 4 directorios, uno junto al otro.

---

## 6.1 Crear la carpeta de despliegue con sus archivos

Los archivos de despliegue viven en `/opt/drivique/deploy`, **junto** a los 4 repositorios. Como `deploy`:

```bash
mkdir -p /opt/drivique/deploy/scripts
cd /opt/drivique/deploy
```

Crea cada archivo con `nano` y pega el contenido del anexo indicado:

| Archivo (en `/opt/drivique/deploy`) | Anexo |
|---|---|
| `docker-compose.yml` | A |
| `Caddyfile` | B |
| `web.Dockerfile` | C |
| `app.Dockerfile` | D |
| `.env.example` | E |
| `scripts/init-env.sh` | G |
| `scripts/deploy.sh` | H |
| `scripts/backup.sh` | I |
| `scripts/restore.sh` | J |
| `scripts/set-password.sh` | K |

Después, da permiso de ejecución a los scripts y crea la regla para que `.env` no se suba a Git por error:

```bash
chmod +x scripts/*.sh
printf '.env\n' > .gitignore
```

---

## 7. Crear el archivo de configuración (`.env`)

```bash
cd /opt/drivique/deploy
./scripts/init-env.sh
```

Te pregunta (ten las respuestas a la mano):

| Pregunta | Qué responder |
|---|---|
| Dominio | `tudominio.com` (sin `https://`) |
| Correo para los certificados | Un correo real tuyo |
| Gmail que envía los mensajes | **El mismo** correo que ya usa el proyecto (`SPRING_MAIL_USERNAME`) |
| Contraseña de aplicación de Gmail | **La misma que ya usa el proyecto** (`SPRING_MAIL_PASSWORD` del `Back-end/.env` local o de Render), 16 letras sin espacios |
| `WOMPI_PUBLIC_KEY`, `WOMPI_INTEGRITY_SECRET`, `WOMPI_EVENT_SECRET` | Las claves **sandbox** de Wompi |
| `TURNSTILE_SITE_KEY` y `TURNSTILE_SECRET_KEY` | Las crea gratis en Cloudflare → Turnstile (agrega `tudominio.com` y `app.tudominio.com` como hostnames). **Obligatorias**: sin ellas la API no arranca |
| Contraseña del super admin y de los encargados | Mínimo 12 caracteres. Son las contraseñas **reales** con las que se entra al panel; no existe ninguna contraseña por defecto |
| Google / Facebook ID | Enter para omitir, o los IDs públicos |

El script **genera solo** las contraseñas de la base de datos, la clave de las sesiones (JWT) y la clave que cifra los documentos de identidad, largas y aleatorias, y deja el archivo con permisos `600` (solo lo lee `deploy`).

> ⚠️ **Guarda una copia de `deploy/.env` en un lugar seguro y privado** (gestor de contraseñas). Si se pierde, se pierde la clave de la base de datos. **Nunca** lo subas a Git (ya está en `.gitignore`).

---

## 8. Desplegar

```bash
cd /opt/drivique/deploy
./scripts/deploy.sh
```

El script, en orden: baja `main` de los 4 repos → respalda la base (si ya existe) → compila las imágenes → inicia PostgreSQL → **aplica Liquibase** (crea tablas y datos iniciales) → levanta todo → espera a que el backend esté "healthy".

- **La primera vez tarda 10–25 minutos** (compila backend, web y app). Las siguientes, bastante menos.
- Si termina con `DESPLIEGUE LISTO`, mostrará las 3 direcciones.
- Si falla, copia las últimas líneas del error. La sección 12 explica los casos comunes.

---

## 9. Verificar que quedó bien

Haz estas pruebas **una por una**:

| # | Prueba | Resultado esperado |
|---|---|---|
| 1 | Abrir `https://TU-DOMINIO` | Carga la web, con **candado** HTTPS (sin avisos) |
| 2 | Abrir `https://app.TU-DOMINIO` | Carga la App en versión web |
| 3 | Abrir `https://TU-DOMINIO/api/v1/vehicles/search?size=1` | Un JSON con un carro, que incluya `imageUrls`, `averageRating` y `reviewCount` |
| 4 | En el catálogo | Se ven los 6 carros con sus fotos (varias por carro) |
| 5 | Registrar una cuenta nueva | Llega el **correo de verificación** al Gmail |
| 6 | Iniciar sesión | Entra sin errores |
| 7 | Cerrar sesión y entrar a la sección de vehículos | Se ve como invitado; "Reservar" muestra la alerta de iniciar sesión |
| 8 | Estado de los contenedores | `docker compose ps` → todos `running` y `api` en `healthy` |

```bash
cd /opt/drivique/deploy
docker compose ps
```

---

## 10. Después del primer despliegue (obligatorio)

### 10.1 Contraseñas del super admin y de los encargados

Las semillas de la base crean estas cuentas **bloqueadas**: no existe ninguna contraseña por defecto en el repositorio. Al arrancar, la API les asigna las contraseñas que pusiste en `.env` (`BOOTSTRAP_ADMIN_PASSWORD` y `BOOTSTRAP_BRANCH_ADMIN_PASSWORD`) y **solo** a las cuentas que sigan bloqueadas o con una clave que estuvo publicada: nunca pisa una contraseña que una persona ya cambió.

Comprueba que se aplicaron:

```bash
docker compose logs api | grep -i "Contraseña de"
```

Para cambiar la contraseña de una cuenta más adelante (pide la contraseña sin mostrarla):

```bash
./scripts/set-password.sh admin@drivique.com
```

> Si aparece `[SEGURIDAD] La cuenta ... está bloqueada`, falta definir la variable en `.env`; defínela y reinicia: `docker compose up -d api`.

### 10.1.1 Servidor que ya estaba desplegado antes de este cambio

Agrega a `deploy/.env` las variables nuevas **antes** de actualizar (si no, la API se detiene al arrancar a propósito): `APP_DOCUMENT_ENCRYPTION_KEY`, `BOOTSTRAP_ADMIN_PASSWORD`, `BOOTSTRAP_BRANCH_ADMIN_PASSWORD`, `TURNSTILE_SITE_KEY` y `TURNSTILE_SECRET_KEY` (valores en el Anexo E). Los documentos ya guardados con la clave anterior se siguen leyendo y los que estaban sin cifrar se cifran solos en el primer arranque.

### 10.2 Configurar Wompi

En el panel de Wompi (sandbox), en **Desarrolladores → Eventos / URL de eventos**, pega:

```
https://TU-DOMINIO/api/v1/payments/wompi/webhook
```

Así Wompi avisa al servidor cuando un pago se aprueba. (En un computador local esto no funciona porque Wompi no puede llegar a `localhost`; en el servidor sí.)

### 10.3 Inicio de sesión con Google / Facebook (solo si lo usan)

En la consola de Google y en Facebook Developers, agrega `https://TU-DOMINIO` y `https://app.TU-DOMINIO` como **orígenes / dominios autorizados**, y los redirect URIs correspondientes.

### 10.4 Activar los respaldos automáticos

```bash
crontab -e
```

Agrega al final (respaldo todas las noches a las 2:30 a. m., conserva 7 días):

```
30 2 * * * /opt/drivique/deploy/scripts/backup.sh >> /opt/drivique/backups/backup.log 2>&1
```

Haz un respaldo de prueba ahora mismo y confirma que se crea el archivo:

```bash
./scripts/backup.sh
ls -lh /opt/drivique/backups
```

Los respaldos quedan en el mismo servidor. **Copia de vez en cuando uno a otro lugar** (tu computador, Drive) con `scp`, porque si el servidor se pierde, se pierden también.

---

## 11. Generar el APK de la App (Android)

> **Hazlo después de la sección 9**, cuando `https://app.TU-DOMINIO/api/v1/...` ya responda. El APK guarda la dirección del servidor al compilarse, y Android bloquea direcciones sin HTTPS.

Se usa **EAS Build** (Expo): compila en la nube, no hace falta Android Studio. Ya están listos `app.json` (nombre "Drivique", paquete `com.drivique.app`) y `eas.json`.

1. **Cuenta gratuita** en <https://expo.dev> (si no tienen).
2. En el repo `front-end_movil/app-drivique`, abre `eas.json` y cambia **las dos** apariciones de `https://app.TU-DOMINIO/api/v1` por la dirección real, por ejemplo `https://app.midominio.com/api/v1`. Guarda.
3. En la terminal, dentro de `front-end_movil/app-drivique`:

```bash
npx eas-cli login
npx eas-cli build --platform android --profile preview
```

   La primera vez pregunta si crear el proyecto y si generar las llaves de firma: **responde que sí**. EAS guarda esas llaves; **no se pierden** y sirven para futuras versiones.
4. Tarda unos **10–20 minutos** (puede haber cola en el plan gratis). Al terminar muestra un **enlace y un código QR** con el APK.
5. Abre el enlace en el celular, descarga el APK e instálalo. Android pedirá *permitir instalar apps de fuentes desconocidas*: es normal.
6. **Prueba en el celular:** abrir la app, ver el catálogo con fotos, iniciar sesión.

Notas:
- **Solo Android.** iPhone requiere una cuenta de Apple Developer de pago.
- Para una **nueva versión del APK:** repetir el comando (`versionCode` sube solo con el perfil `production`; en `preview` basta volver a compilar).
- El plan gratuito de Expo tiene un límite de compilaciones al mes.
- El perfil `production` genera un `.aab` para subir a Google Play (requiere cuenta de desarrollador de Google).

---

## 12. Operación diaria

| Quiero… | Comando (desde `/opt/drivique/deploy`) |
|---|---|
| **Actualizar** con lo nuevo de `main` | `./scripts/deploy.sh` |
| Ver el estado | `docker compose ps` |
| Ver los registros del backend | `docker compose logs --tail=100 -f api` |
| Reiniciar solo el backend | `docker compose restart api` |
| Respaldar ahora | `./scripts/backup.sh` |
| Restaurar un respaldo | `./scripts/restore.sh /opt/drivique/backups/db-AAAAMMDD-HHMMSS.sql.gz` |
| Ver espacio en disco | `df -h /` y `docker system df` |

**Antes de cada actualización** `deploy.sh` hace un respaldo automático de la base.

### Volver a una versión anterior (rollback)

1. Restaurar el respaldo de la base anterior al despliegue (`restore.sh`).
2. En cada repo, volver al commit anterior (`git -C /opt/drivique/Back-end reset --hard <commit>` y lo mismo en los otros) y ejecutar `SKIP_PULL=1 ./scripts/deploy.sh`.

### Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| El navegador dice "conexión no segura" / no hay candado | El DNS aún no apunta al servidor, o los puertos 80/443 están cerrados | `nslookup TU-DOMINIO`; revisar que el firewall del VPS permite 80 y 443; `docker compose logs caddy` |
| Error **502 Bad Gateway** | El backend aún arranca o se cayó | Esperar 1–2 min; `docker compose logs --tail=100 api` |
| `deploy.sh` termina con "backend no quedó saludable" | Falta una variable en `.env` o la base no respondió | `docker compose logs --tail=120 api`; revisar `.env` |
| La compilación se corta ("Killed", sin memoria) | No hay swap | `swapon --show` debe mostrar 2 GB; ejecutar de nuevo el script de preparación |
| Las fotos de los carros no cargan | La URL de la foto bloquea el uso en otros sitios o no es una imagen directa | Probar la URL en una pestaña nueva; debe abrir solo la imagen |
| No llegan los correos | La contraseña de Gmail se copió mal al `.env` del servidor (pegada con espacios o incompleta) | Revisar `SPRING_MAIL_*` en `.env`; `docker compose logs api \| grep -i mail`; reiniciar `api` |
| Error de CORS en el navegador | `CORS_ALLOWED_ORIGINS` no incluye el dominio | Corregir en `.env` y `docker compose up -d api` |
| Wompi dice "error desconocido" con PSE | El banco de pruebas de PSE falla de forma intermitente | Probar con tarjeta de prueba `4242 4242 4242 4242` o Nequi `3991111111` |
| El pago se cobra pero la reserva no se confirma | El aviso (webhook) de Wompi no llega | Revisar la URL del paso 10.2 y que sea HTTPS |

---

## 13. Lista de seguridad (revisar al terminar)

- [ ] Se entra al servidor solo como `deploy`, con llave SSH; la contraseña de SSH está desactivada.
- [ ] `sudo ufw status` muestra solo 22, 80 y 443.
- [ ] La base de datos **no** tiene puerto publicado (`docker compose ps` no muestra `5432->`).
- [ ] Las cuentas del super admin y de los encargados tienen sus contraseñas reales (10.1) y `.env` tiene `APP_DOCUMENT_ENCRYPTION_KEY`, `JWT_SECRET` y las claves de Turnstile.
- [ ] `deploy/.env` tiene copia segura y permisos `600`; **no** está en Git.
- [ ] Los respaldos diarios corren y se hizo al menos una prueba de restauración.
- [ ] El token de GitHub es de **solo lectura** y con fecha de caducidad.
- [ ] Hay respaldos/snapshots activados en el panel de Hostinger.

---

## 14. Resumen de archivos de despliegue

Todo vive en `/opt/drivique/deploy/` (contenido en los Anexos):

| Archivo | Para qué |
|---|---|
| `docker-compose.yml` | Define los 6 servicios, la memoria de cada uno y los volúmenes |
| `Caddyfile` | HTTPS automático y reparto de tráfico por dominio |
| `web.Dockerfile`, `app.Dockerfile` | Compilan la web y la app a archivos estáticos |
| `.env.example` | Lista de todas las variables (el `.env` real no se sube a Git) |
| `scripts/bootstrap-server.sh` | Prepara el VPS: seguridad, Docker, swap |
| `scripts/init-env.sh` | Crea el `.env` con contraseñas aleatorias |
| `scripts/deploy.sh` | Despliega o actualiza todo |
| `scripts/backup.sh` / `restore.sh` | Respaldo y restauración |
| `scripts/set-password.sh` | Cambia la contraseña de un usuario |

---

# Anexos: archivos para copiar y pegar

## Anexo A: `docker-compose.yml`

Ubicación: `/opt/drivique/deploy/docker-compose.yml`

```yaml
# Drivique en produccion: PostgreSQL + API (Spring Boot) + web + app web + Caddy (HTTPS automatico).
# Se ejecuta desde /opt/drivique/deploy. Los 4 repos deben estar uno junto al otro:
#   /opt/drivique/{deploy, Back-end, database, front-end_web, front-end_movil}
#
#   docker compose --profile migrate run --rm migrate     # aplica los cambios de la base (Liquibase)
#   docker compose up -d --build                          # levanta todo
name: drivique

x-logging: &logging
  driver: json-file
  options:
    max-size: "10m"
    max-file: "3"

services:
  postgres:
    image: postgres:17-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      APP_DB_USER: ${APP_DB_USER}
      APP_DB_PASSWORD: ${APP_DB_PASSWORD}
      TZ: America/Bogota
    # Solo se usa dentro de la red de Docker: NO se publica ningun puerto de la base de datos.
    command: >
      postgres
      -c shared_buffers=256MB
      -c effective_cache_size=768MB
      -c max_connections=60
      -c work_mem=8MB
      -c log_min_duration_statement=2000
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ../database/docker/initdb:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 12
    mem_limit: 768m
    logging: *logging

  # Tarea puntual: aplica los changesets de Liquibase sobre la base existente (nunca borra datos).
  migrate:
    image: liquibase/liquibase:4.33
    profiles: ["migrate"]
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      LIQUIBASE_COMMAND_URL: jdbc:postgresql://postgres:5432/${POSTGRES_DB}
      LIQUIBASE_COMMAND_USERNAME: ${POSTGRES_USER}
      LIQUIBASE_COMMAND_PASSWORD: ${POSTGRES_PASSWORD}
      LIQUIBASE_COMMAND_CHANGELOG_FILE: changelog/db.changelog-master.yaml
      LIQUIBASE_HUB_MODE: "off"
    command: update
    volumes:
      - ../database:/workspace:ro
    working_dir: /workspace

  api:
    build:
      context: ../Back-end
      dockerfile: Dockerfile
    restart: unless-stopped
    depends_on:
      postgres:
        condition: service_healthy
    env_file: .env
    environment:
      SPRING_PROFILES_ACTIVE: main
      DB_HOST: postgres
      DB_PORT: "5432"
      DB_NAME: ${POSTGRES_DB}
      DB_USERNAME: ${APP_DB_USER}
      DB_PASSWORD: ${APP_DB_PASSWORD}
      TZ: America/Bogota
      JAVA_TOOL_OPTIONS: "-XX:MaxRAMPercentage=70 -XX:+UseSerialGC -Xss512k"
    volumes:
      # Documentos KYC, firmas, contratos y comprobantes: deben sobrevivir a los reinicios.
      - uploads:/app/uploads
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:8080/api/v1/mileage-plans >/dev/null || exit 1"]
      interval: 20s
      timeout: 10s
      retries: 10
      start_period: 90s
    mem_limit: 1536m
    logging: *logging

  web:
    build:
      context: ../front-end_web/web-drivique
      dockerfile: ../../deploy/web.Dockerfile
      args:
        VITE_API_URL: https://${DOMAIN}/api/v1
        VITE_GOOGLE_CLIENT_ID: ${VITE_GOOGLE_CLIENT_ID:-}
        VITE_FACEBOOK_APP_ID: ${VITE_FACEBOOK_APP_ID:-}
    restart: unless-stopped
    mem_limit: 64m
    logging: *logging

  app:
    build:
      context: ../front-end_movil/app-drivique
      dockerfile: ../../deploy/app.Dockerfile
      args:
        EXPO_PUBLIC_API_URL: https://app.${DOMAIN}/api/v1
    restart: unless-stopped
    mem_limit: 64m
    logging: *logging

  caddy:
    image: caddy:2-alpine
    restart: unless-stopped
    depends_on:
      - api
      - web
      - app
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    environment:
      DOMAIN: ${DOMAIN}
      ACME_EMAIL: ${ACME_EMAIL}
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
    mem_limit: 128m
    logging: *logging

volumes:
  postgres_data:
  uploads:
  caddy_data:
  caddy_config:
```

## Anexo B: `Caddyfile`

Ubicación: `/opt/drivique/deploy/Caddyfile`

```caddyfile
# Caddy obtiene y renueva solo los certificados HTTPS (Let's Encrypt).
# DOMAIN y ACME_EMAIL vienen del archivo .env
{
	email {$ACME_EMAIL}
}

(seguridad) {
	encode zstd gzip
	header {
		Strict-Transport-Security "max-age=31536000; includeSubDomains"
		X-Content-Type-Options "nosniff"
		X-Frame-Options "SAMEORIGIN"
		-Server
	}
}

# Web principal: https://DOMAIN  (el backend responde en /api)
{$DOMAIN} {
	import seguridad
	request_body {
		max_size 25MB
	}
	handle /api/* {
		reverse_proxy api:8080
	}
	handle {
		reverse_proxy web:80
	}
}

# App movil en version web: https://app.DOMAIN
app.{$DOMAIN} {
	import seguridad
	request_body {
		max_size 25MB
	}
	handle /api/* {
		reverse_proxy api:8080
	}
	handle {
		reverse_proxy app:80
	}
}

# www redirige al dominio principal
www.{$DOMAIN} {
	redir https://{$DOMAIN}{uri} permanent
}
```

## Anexo C: `web.Dockerfile`

Ubicación: `/opt/drivique/deploy/web.Dockerfile`

```dockerfile
# Web (React + Vite): se compila una vez y se sirve como archivos estaticos con nginx.
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
ARG VITE_API_URL
ARG VITE_GOOGLE_CLIENT_ID=
ARG VITE_FACEBOOK_APP_ID=
ENV VITE_API_URL=$VITE_API_URL \
    VITE_GOOGLE_CLIENT_ID=$VITE_GOOGLE_CLIENT_ID \
    VITE_FACEBOOK_APP_ID=$VITE_FACEBOOK_APP_ID
RUN npm run build

FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
RUN printf 'server {\n  listen 80;\n  root /usr/share/nginx/html;\n  index index.html;\n  location /assets/ { expires 1y; add_header Cache-Control "public, immutable"; try_files $uri =404; }\n  location / { add_header Cache-Control "no-cache"; try_files $uri /index.html; }\n}\n' > /etc/nginx/conf.d/default.conf
EXPOSE 80
```

## Anexo D: `app.Dockerfile`

Ubicación: `/opt/drivique/deploy/app.Dockerfile`

```dockerfile
# App movil (Expo / React Native) en su version web: se exporta como sitio estatico y se sirve con nginx.
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
ARG EXPO_PUBLIC_API_URL
ENV EXPO_PUBLIC_API_URL=$EXPO_PUBLIC_API_URL \
    CI=1 \
    EXPO_NO_TELEMETRY=1 \
    NODE_OPTIONS=--max-old-space-size=2048
RUN npx expo export --platform web --output-dir dist

FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
RUN printf 'server {\n  listen 80;\n  root /usr/share/nginx/html;\n  index index.html;\n  location /_expo/ { expires 1y; add_header Cache-Control "public, immutable"; try_files $uri =404; }\n  location / { add_header Cache-Control "no-cache"; try_files $uri $uri.html /index.html; }\n}\n' > /etc/nginx/conf.d/default.conf
EXPOSE 80
```

## Anexo E: `.env.example`

Ubicación: `/opt/drivique/deploy/.env.example`

```bash
# Copia este archivo a ".env" (cp .env.example .env) o, mejor, usa ./scripts/init-env.sh que lo crea con
# claves aleatorias. El archivo .env NUNCA se sube a Git.

# --- Direccion publica (sin https://) ---
DOMAIN=midominio.com
ACME_EMAIL=correo@midominio.com

# --- Base de datos (PostgreSQL dentro de Docker, sin puerto publico) ---
POSTGRES_DB=drivique
POSTGRES_USER=drivique_migrator
POSTGRES_PASSWORD=CAMBIAR
APP_DB_USER=drivique_app
APP_DB_PASSWORD=CAMBIAR

# --- Backend ---
# Clave que firma las sesiones (JWT). Larga y secreta: openssl rand -base64 48
JWT_SECRET=CAMBIAR
# Clave que cifra los documentos de identidad (AES-256). NO la cambies despues: openssl rand -base64 48
APP_DOCUMENT_ENCRYPTION_KEY=CAMBIAR
# Contrasenas iniciales del super administrador y de los 6 encargados (minimo 12 caracteres)
BOOTSTRAP_ADMIN_PASSWORD=CAMBIAR
BOOTSTRAP_BRANCH_ADMIN_PASSWORD=CAMBIAR
# Origenes permitidos por CORS (la app y la web usan el mismo servidor, pero se dejan explicitos)
CORS_ALLOWED_ORIGINS=https://midominio.com,https://app.midominio.com
APP_FRONTEND_URL=https://midominio.com
APP_BACKEND_URL=https://midominio.com

# --- Correo (Gmail con contrasena de aplicacion de 16 letras, sin espacios) ---
SPRING_MAIL_HOST=smtp.gmail.com
SPRING_MAIL_PORT=587
SPRING_MAIL_USERNAME=correo@gmail.com
SPRING_MAIL_PASSWORD=CAMBIAR
SPRING_MAIL_SMTP_AUTH=true
SPRING_MAIL_STARTTLS=true
APP_AUTH_MAIL_FROM=correo@gmail.com

# --- Wompi (sandbox): copia estos valores de tu Back-end/.env local ---
WOMPI_PUBLIC_KEY=pub_test_CAMBIAR
WOMPI_INTEGRITY_SECRET=test_integrity_CAMBIAR
WOMPI_EVENT_SECRET=test_events_CAMBIAR
WOMPI_CHECKOUT_URL=https://checkout.wompi.co/p/

# --- Captcha anti-bots (Cloudflare Turnstile, gratis): https://dash.cloudflare.com -> Turnstile ---
# Agrega tu dominio (y app.tudominio) como "hostname" del widget. Sin estas claves la API NO arranca.
TURNSTILE_SITE_KEY=CAMBIAR
TURNSTILE_SECRET_KEY=CAMBIAR

# --- Inicio de sesion social (obligatorio si se usa) ---
# GOOGLE_CLIENT_ID admite varios separados por coma (web, Android, iOS)
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
FACEBOOK_APP_ID=
FACEBOOK_APP_SECRET=
# Los mismos IDs publicos para compilar la web
VITE_GOOGLE_CLIENT_ID=
VITE_FACEBOOK_APP_ID=
```

## Anexo F: `scripts/bootstrap-server.sh`

Ubicación: `/root/bootstrap-server.sh` (como root, antes de crear el usuario `deploy`)

```bash
#!/usr/bin/env bash
# Prepara un VPS Ubuntu 24.04 NUEVO para Drivique. Se ejecuta UNA vez, como root:
#   bash bootstrap-server.sh
# Hace: usuario "deploy", firewall, proteccion contra fuerza bruta, actualizaciones de seguridad,
# memoria de intercambio (swap), zona horaria y Docker.
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then echo "Ejecutalo como root (sudo -i)"; exit 1; fi

DEPLOY_USER="${DEPLOY_USER:-deploy}"
APP_DIR="/opt/drivique"

echo "==> Actualizando el sistema"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install -y ca-certificates curl git ufw fail2ban unattended-upgrades gnupg openssl wget

echo "==> Zona horaria"
timedatectl set-timezone America/Bogota

echo "==> Swap de 2 GB (evita que el servidor se quede sin memoria al compilar)"
if ! swapon --show | grep -q swapfile; then
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
  echo 'vm.swappiness=10' > /etc/sysctl.d/99-swap.conf
  sysctl -p /etc/sysctl.d/99-swap.conf
fi

echo "==> Docker"
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi
systemctl enable --now docker

echo "==> Usuario $DEPLOY_USER (sin contrasena, entra solo con llave SSH)"
if ! id "$DEPLOY_USER" >/dev/null 2>&1; then
  adduser --disabled-password --gecos "" "$DEPLOY_USER"
fi
usermod -aG docker "$DEPLOY_USER"
mkdir -p "/home/$DEPLOY_USER/.ssh"
if [ -f /root/.ssh/authorized_keys ]; then
  cp /root/.ssh/authorized_keys "/home/$DEPLOY_USER/.ssh/authorized_keys"
fi
chown -R "$DEPLOY_USER:$DEPLOY_USER" "/home/$DEPLOY_USER/.ssh"
chmod 700 "/home/$DEPLOY_USER/.ssh"
chmod 600 "/home/$DEPLOY_USER/.ssh/authorized_keys" 2>/dev/null || true
mkdir -p "$APP_DIR" "$APP_DIR/backups"
chown -R "$DEPLOY_USER:$DEPLOY_USER" "$APP_DIR"

echo "==> Firewall: solo SSH (22), HTTP (80) y HTTPS (443)"
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 443/udp
ufw --force enable

echo "==> fail2ban (bloquea IPs que intentan adivinar la clave de SSH)"
cat > /etc/fail2ban/jail.d/sshd.local <<'EOF'
[sshd]
enabled = true
maxretry = 5
findtime = 10m
bantime = 1h
EOF
systemctl enable --now fail2ban
systemctl restart fail2ban

echo "==> Actualizaciones de seguridad automaticas"
dpkg-reconfigure -f noninteractive unattended-upgrades

echo "==> SSH: solo con llave (se desactiva la contrasena) y sin root directo"
if [ -s "/home/$DEPLOY_USER/.ssh/authorized_keys" ]; then
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
  systemctl reload ssh || systemctl reload sshd
else
  echo "!! No hay llaves SSH copiadas: NO se desactivo la contrasena para no dejarte afuera."
  echo "   Agrega tu llave a /home/$DEPLOY_USER/.ssh/authorized_keys y vuelve a ejecutar este script."
fi

echo "==> Rotacion de logs de Docker ya viene configurada por contenedor en docker-compose.yml"
echo
echo "LISTO. Siguiente paso: entra como '$DEPLOY_USER' y sigue la guia (deploy/README-DEPLOY.md, paso 5)."
```

## Anexo G: `scripts/init-env.sh`

Ubicación: `/opt/drivique/deploy/scripts/init-env.sh`

```bash
#!/usr/bin/env bash
# Crea deploy/.env con claves aleatorias seguras. Pregunta solo lo que no se puede inventar.
#   ./scripts/init-env.sh
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -f .env ]; then
  echo ".env ya existe. Si quieres volver a crearlo, renombralo primero (mv .env .env.old)."
  exit 1
fi

rand() { openssl rand -base64 "$1" | tr -d '=+/\n' | cut -c1-"$2"; }

read -rp "Dominio publico, sin https:// (ej. drivique.com): " DOMAIN
read -rp "Correo para los certificados HTTPS (Let's Encrypt): " ACME_EMAIL
read -rp "Correo de Gmail que envia los mensajes: " MAIL_USER
read -rsp "Contrasena de APLICACION de Gmail (16 letras, sin espacios): " MAIL_PASS; echo
read -rp "WOMPI_PUBLIC_KEY (pub_test_...): " WOMPI_PUBLIC_KEY
read -rsp "WOMPI_INTEGRITY_SECRET (test_integrity_...): " WOMPI_INTEGRITY_SECRET; echo
read -rsp "WOMPI_EVENT_SECRET (test_events_...): " WOMPI_EVENT_SECRET; echo
read -rp "TURNSTILE_SITE_KEY (clave del sitio de Cloudflare Turnstile): " TURNSTILE_SITE_KEY
read -rsp "TURNSTILE_SECRET_KEY (clave secreta de Turnstile): " TURNSTILE_SECRET_KEY; echo
read -rsp "Contrasena del SUPER ADMIN (min. 12 caracteres): " ADMIN_PASS; echo
read -rsp "Contrasena de los 6 ENCARGADOS (min. 12 caracteres): " BRANCH_PASS; echo
[ "${#ADMIN_PASS}" -ge 12 ] && [ "${#BRANCH_PASS}" -ge 12 ] || { echo "Las contrasenas deben tener al menos 12 caracteres."; exit 1; }
read -rp "VITE_GOOGLE_CLIENT_ID (Enter para omitir): " GOOGLE_ID
read -rp "VITE_FACEBOOK_APP_ID (Enter para omitir): " FB_ID

cp .env.example .env
set_var() { # nombre valor
  local k="$1" v="$2"
  v="${v//\\/\\\\}"; v="${v//&/\\&}"; v="${v//|/\\|}"
  sed -i "s|^${k}=.*|${k}=${v}|" .env
}
set_var DOMAIN "$DOMAIN"
set_var ACME_EMAIL "$ACME_EMAIL"
set_var POSTGRES_PASSWORD "$(rand 36 32)"
set_var APP_DB_PASSWORD "$(rand 36 32)"
set_var JWT_SECRET "$(openssl rand -base64 64 | tr -d '\n')"
set_var APP_DOCUMENT_ENCRYPTION_KEY "$(openssl rand -base64 48 | tr -d '\n')"
set_var BOOTSTRAP_ADMIN_PASSWORD "$ADMIN_PASS"
set_var BOOTSTRAP_BRANCH_ADMIN_PASSWORD "$BRANCH_PASS"
set_var TURNSTILE_SITE_KEY "$TURNSTILE_SITE_KEY"
set_var TURNSTILE_SECRET_KEY "$TURNSTILE_SECRET_KEY"
set_var CORS_ALLOWED_ORIGINS "https://$DOMAIN,https://app.$DOMAIN"
set_var APP_FRONTEND_URL "https://$DOMAIN"
set_var APP_BACKEND_URL "https://$DOMAIN"
set_var SPRING_MAIL_USERNAME "$MAIL_USER"
set_var SPRING_MAIL_PASSWORD "$MAIL_PASS"
set_var APP_AUTH_MAIL_FROM "$MAIL_USER"
set_var WOMPI_PUBLIC_KEY "$WOMPI_PUBLIC_KEY"
set_var WOMPI_INTEGRITY_SECRET "$WOMPI_INTEGRITY_SECRET"
set_var WOMPI_EVENT_SECRET "$WOMPI_EVENT_SECRET"
set_var VITE_GOOGLE_CLIENT_ID "$GOOGLE_ID"
set_var VITE_FACEBOOK_APP_ID "$FB_ID"
set_var GOOGLE_CLIENT_ID "$GOOGLE_ID"
set_var FACEBOOK_APP_ID "$FB_ID"

chmod 600 .env
echo
echo "Creado deploy/.env (permisos 600). Guarda una copia de este archivo en un lugar seguro:"
echo "si se pierde, se pierde la clave de la base de datos y las sesiones."
```

## Anexo H: `scripts/deploy.sh`

Ubicación: `/opt/drivique/deploy/scripts/deploy.sh`

```bash
#!/usr/bin/env bash
# Despliega (o actualiza) Drivique. Se ejecuta como el usuario "deploy" dentro de /opt/drivique/deploy:
#   ./scripts/deploy.sh                      # baja main y despliega
#   BRANCH=HU-INT-21-main ./scripts/deploy.sh
#   SKIP_PULL=1 ./scripts/deploy.sh          # no baja codigo (pruebas)
set -euo pipefail

DEPLOY_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="$(cd "$DEPLOY_DIR/.." && pwd)"
BRANCH="${BRANCH:-main}"
PROJECT="${COMPOSE_PROJECT_NAME:-drivique}"
cd "$DEPLOY_DIR"

[ -f .env ] || { echo "Falta deploy/.env. Ejecuta primero ./scripts/init-env.sh"; exit 1; }
dc() { docker compose -p "$PROJECT" "$@"; }

if [ -z "${SKIP_PULL:-}" ]; then
  echo "==> Bajando el codigo (rama $BRANCH)"
  for repo in Back-end database front-end_web front-end_movil; do
    echo "   - $repo"
    git -C "$ROOT/$repo" fetch --quiet origin
    git -C "$ROOT/$repo" checkout --quiet "$BRANCH"
    git -C "$ROOT/$repo" reset --hard --quiet "origin/$BRANCH"
  done
fi

echo "==> Respaldo de la base de datos antes de tocar nada"
if dc ps --status running --services 2>/dev/null | grep -qx postgres; then
  ./scripts/backup.sh
else
  echo "   (primer despliegue: aun no hay base de datos que respaldar)"
fi

echo "==> Compilando imagenes (la primera vez tarda varios minutos)"
dc build

echo "==> Base de datos: iniciando PostgreSQL"
dc up -d postgres
echo "==> Base de datos: aplicando cambios de Liquibase (agrega lo nuevo, nunca borra datos)"
dc --profile migrate run --rm migrate

echo "==> Levantando los servicios"
dc up -d --remove-orphans

echo "==> Esperando a que el backend responda (puede tardar 1-2 minutos)"
status="starting"
for i in $(seq 1 48); do
  status="$(docker inspect -f '{{.State.Health.Status}}' "$(dc ps -q api)" 2>/dev/null || echo starting)"
  [ "$status" = "healthy" ] && break
  sleep 5
done
dc ps
if [ "$status" != "healthy" ]; then
  echo "!! El backend no quedo saludable. Revisa:  docker compose -p $PROJECT logs --tail=120 api"
  exit 1
fi

docker image prune -f >/dev/null
DOMAIN="$(grep '^DOMAIN=' .env | cut -d= -f2-)"
echo
echo "DESPLIEGUE LISTO"
echo "  Web:  https://$DOMAIN"
echo "  App:  https://app.$DOMAIN"
echo "  API:  https://$DOMAIN/api/v1/vehicles/search?size=1"
```

## Anexo I: `scripts/backup.sh`

Ubicación: `/opt/drivique/deploy/scripts/backup.sh`

```bash
#!/usr/bin/env bash
# Respaldo de la base de datos y de los archivos subidos (documentos, firmas, contratos).
# Guarda en /opt/drivique/backups (o BACKUP_DIR) y conserva los ultimos 7 dias.
#   ./scripts/backup.sh
# Para que corra solo cada noche a las 2:30 a. m.:  crontab -e  y agregar:
#   30 2 * * * /opt/drivique/deploy/scripts/backup.sh >> /opt/drivique/backups/backup.log 2>&1
set -euo pipefail

DEPLOY_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="$(cd "$DEPLOY_DIR/.." && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$ROOT/backups}"
PROJECT="${COMPOSE_PROJECT_NAME:-drivique}"
KEEP_DAYS="${KEEP_DAYS:-7}"
cd "$DEPLOY_DIR"
mkdir -p "$BACKUP_DIR"

set -a; . ./.env; set +a
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "[$(date '+%F %T')] Respaldando la base de datos..."
docker compose -p "$PROJECT" exec -T postgres pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --no-owner | gzip -9 > "$BACKUP_DIR/db-$STAMP.sql.gz"
test -s "$BACKUP_DIR/db-$STAMP.sql.gz"

echo "[$(date '+%F %T')] Respaldando los archivos subidos..."
docker compose -p "$PROJECT" exec -T api tar -C /app -cz uploads > "$BACKUP_DIR/uploads-$STAMP.tar.gz" 2>/dev/null || echo "   (sin archivos subidos todavia)"

chmod 600 "$BACKUP_DIR"/*-"$STAMP".* 2>/dev/null || true
find "$BACKUP_DIR" -type f \( -name 'db-*.sql.gz' -o -name 'uploads-*.tar.gz' \) -mtime +"$KEEP_DAYS" -delete
echo "[$(date '+%F %T')] Listo: $BACKUP_DIR/db-$STAMP.sql.gz"
ls -lh "$BACKUP_DIR" | tail -n 6
```

## Anexo J: `scripts/restore.sh`

Ubicación: `/opt/drivique/deploy/scripts/restore.sh`

```bash
#!/usr/bin/env bash
# Restaura la base de datos desde un respaldo .sql.gz. BORRA los datos actuales y pone los del respaldo.
#   ./scripts/restore.sh /opt/drivique/backups/db-20261021-023000.sql.gz
set -euo pipefail

FILE="${1:-}"
[ -f "$FILE" ] || { echo "Uso: ./scripts/restore.sh <archivo db-....sql.gz>"; exit 1; }

DEPLOY_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${COMPOSE_PROJECT_NAME:-drivique}"
cd "$DEPLOY_DIR"
set -a; . ./.env; set +a

echo "ATENCION: esto reemplaza TODA la base de datos '$POSTGRES_DB' por el contenido de:"
echo "  $FILE"
read -rp "Escribe RESTAURAR para continuar: " OK
[ "$OK" = "RESTAURAR" ] || { echo "Cancelado."; exit 1; }

echo "==> Deteniendo la API"
docker compose -p "$PROJECT" stop api
echo "==> Recreando la base de datos"
docker compose -p "$PROJECT" exec -T postgres psql -U "$POSTGRES_USER" -d postgres -v ON_ERROR_STOP=1 \
  -c "DROP DATABASE IF EXISTS \"$POSTGRES_DB\" WITH (FORCE);" -c "CREATE DATABASE \"$POSTGRES_DB\" OWNER \"$POSTGRES_USER\";"
echo "==> Cargando el respaldo"
gunzip -c "$FILE" | docker compose -p "$PROJECT" exec -T postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 -q
echo "==> Levantando la API"
docker compose -p "$PROJECT" up -d api
echo "Restauracion terminada."
```

## Anexo K: `scripts/set-password.sh`

Ubicación: `/opt/drivique/deploy/scripts/set-password.sh`

```bash
#!/usr/bin/env bash
# Cambia la contrasena de un usuario (para reemplazar las contrasenas de los usuarios de ejemplo del repo).
#   ./scripts/set-password.sh admin@drivique.com
# La contrasena se guarda cifrada (bcrypt), igual que la que genera el backend.
set -euo pipefail

EMAIL="${1:-}"
[ -n "$EMAIL" ] || { echo "Uso: ./scripts/set-password.sh <correo>"; exit 1; }

DEPLOY_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${COMPOSE_PROJECT_NAME:-drivique}"
cd "$DEPLOY_DIR"
set -a; . ./.env; set +a

read -rsp "Nueva contrasena para $EMAIL (minimo 12 caracteres, con mayuscula, minuscula, numero y simbolo): " PASS; echo
read -rsp "Repitela: " PASS2; echo
[ "$PASS" = "$PASS2" ] || { echo "No coinciden."; exit 1; }
[ "${#PASS}" -ge 12 ] || { echo "Muy corta (minimo 12)."; exit 1; }

# La contrasena viaja como variable de entorno solo dentro del contenedor y el SQL entra por la entrada estandar.
SQL="UPDATE iam.users SET password_hash = crypt(:'pw', gen_salt('bf', 10)) WHERE lower(email) = lower(:'email') RETURNING email;"
echo "$SQL" | docker compose -p "$PROJECT" exec -T -e PW="$PASS" -e EM="$EMAIL" postgres sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 -At -v pw="$PW" -v email="$EM"'
echo "Si arriba aparece el correo, la contrasena se cambio."
```

