# 🚀 Despliegue Flutter Web en Vercel

Guía completa para desplegar tu aplicación Flutter en Vercel.

## 📋 Requisitos Previos

- Flutter 3.7+ instalado localmente
- Cuenta en [Vercel](https://vercel.com)
- Repositorio Git (GitHub, GitLab, Bitbucket)

## 🔧 Configuración Local

### 1. Construir la aplicación web localmente

```bash
flutter pub get
flutter build web --release
```

El output estará en `build/web/`

### 2. Probar localmente antes de desplegar

```bash
# Opción 1: Servidor Flutter integrado
flutter run -d web

# Opción 2: Servir desde build/web con cualquier servidor
cd build/web
python -m http.server 8000
# O con Node.js:
npx serve -s . -l 3000
```

## 🌐 Despliegue en Vercel

### Método 1: Usando la UI de Vercel (Recomendado)

1. **Conectar el repositorio**
   - Ve a [vercel.com/new](https://vercel.com/new)
   - Selecciona tu repositorio Git
   - Elige el proyecto Flutter

2. **Configurar el despliegue**
   - **Framework**: Elige "Other" (no es Node.js)
   - **Build Command**: `bash build.sh`
   - **Output Directory**: `build/web`
   - **Install Command**: `echo 'Skipping npm install - Flutter project'`

3. **Variables de entorno** (si es necesario)
   - Agregá las variables requeridas por tu API

4. **Desplegar**
   - Click en "Deploy"

### Método 2: Usando Vercel CLI

```bash
# Instalar Vercel CLI
npm i -g vercel

# Desplegar
vercel

# Desplegar a producción
vercel --prod
```

## 🔍 Verificar Configuración

- ✅ `vercel.json` - Configuración de build
- ✅ `build.sh` - Script de build para Flutter
- ✅ `package.json` - Metadatos del proyecto
- ✅ `.vercelignore` - Archivos a ignorar
- ✅ `web/index.html` - Punto de entrada web

## ⚠️ Problemas Comunes

### Error: "flutter: command not found"

Solución: El script `build.sh` instala Flutter automáticamente en el entorno de Vercel.

### Error: "flutter_secure_storage no funciona en web"

Solución: Usa `web: true` en tu `pubspec.yaml` para las plataformas web:

```yaml
flutter_secure_storage:
  version: ^9.0.2
  platforms:
    web: true
```

### Problema: Rutas no funcionan

Vercel está configurado con `rewrites` para servir `index.html` en todas las rutas. Asegúrate de usar `Navigator` de Flutter correctamente.

### Error de CORS

Si tu API está en un dominio diferente:
1. Configura CORS en tu backend
2. O configura un proxy en `vercel.json`

## 📊 Monitoreo y Logs

En el dashboard de Vercel:
- **Deployments** - Ver historial de despliegues
- **Logs** - Ver logs de build en tiempo real
- **Analytics** - Ver métricas de uso

## 🔐 Variables de Entorno

Para agregar variables de entorno en Vercel:

1. Ve a **Settings** > **Environment Variables**
2. Agrega tus variables (ej: `API_BASE_URL`)
3. Redeploya

En tu código Flutter:
```dart
// Lee variables de entorno si es necesario
const String apiUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000');
```

## 📱 Consideraciones de Responsive

Tu aplicación está diseñada para móvil. Para web:

1. Adapta los layouts con `MediaQuery`:
```dart
double screenWidth = MediaQuery.of(context).size.width;
if (screenWidth > 600) {
  // Layout para desktop
} else {
  // Layout para móvil
}
```

2. Considera usar `LayoutBuilder` para layouts responsive

## 🚀 Próximos Pasos

- [ ] Configurar dominio personalizado
- [ ] Configurar HTTPS automático (incluido por defecto)
- [ ] Agregar Analytics
- [ ] Configurar redirects si es necesario
- [ ] Optimizar imágenes para web

## 📚 Referencias

- [Flutter Web Documentation](https://flutter.dev/platform-integration/web)
- [Vercel Flutter Guide](https://vercel.com)
- [Flutter Web Best Practices](https://flutter.dev/docs/deployment/web)
