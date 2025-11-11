# 📋 Checklist Pre-Despliegue Vercel

## ✅ Verificaciones Locales

- [ ] `flutter pub get` ejecutado sin errores
- [ ] `flutter build web --release` se completa exitosamente
- [ ] La aplicación funciona en `localhost` (sin errores de consola)
- [ ] No hay dependencias Android/iOS en uso
- [ ] Las imágenes en `assets/images/` están optimizadas para web
- [ ] El `main.dart` no tiene referencias a plataformas específicas (Android/iOS)

## 🔧 Verificaciones de Configuración

- [ ] `vercel.json` existe y está en el root del proyecto
- [ ] `build.sh` tiene permisos de ejecución
- [ ] `package.json` existe
- [ ] `.vercelignore` está configurado
- [ ] `pubspec.yaml` no tiene dependencias incompatibles con web

## 🌍 Verificaciones de Git

- [ ] Proyecto commiteado en Git
- [ ] Repositorio conectado a Vercel
- [ ] `build/` no está en el .gitignore (Vercel lo construye)
- [ ] Rama correcta seleccionada en Vercel

## 🚀 Verificaciones de Despliegue

- [ ] Build Command: `bash build.sh`
- [ ] Output Directory: `build/web`
- [ ] Install Command: `echo 'Skipping npm install - Flutter project'`
- [ ] Node.js version >= 18
- [ ] Variables de entorno agregadas (si aplica)

## 🔒 Verificaciones de Seguridad

- [ ] No hay API keys hardcodeadas en el código
- [ ] Variables sensibles están en Environment Variables de Vercel
- [ ] URLs de API apuntan a endpoints correctos
- [ ] HTTPS está habilitado (automático en Vercel)

## 📱 Verificaciones de Funcionalidad

- [ ] Navegación funciona correctamente
- [ ] APIs se conectan correctamente
- [ ] No hay errores en la consola del navegador
- [ ] La interfaz es responsive en diferentes tamaños

## 🐛 Verificaciones de Debugging

En caso de problemas:

```bash
# 1. Ver logs de build de Vercel
vercel logs

# 2. Reconstruir localmente
flutter clean
flutter pub get
flutter build web --release

# 3. Servir build/web localmente
cd build/web && python -m http.server 8000

# 4. Abrir DevTools en el navegador (F12) y ver Console
```

## ⚡ Optimizaciones Recomendadas

- [ ] Ejecutar `flutter analyze` sin warnings
- [ ] Usar `--release` en builds (ya configurado)
- [ ] Comprimir imágenes
- [ ] Lazy load de imágenes si es posible
- [ ] Caché de assets
