# Deployment tutorial

## 1 — Verificaciones obligatorias en el código
- Archivo clave: Kaffi/Utils/Supabase.swift
  - Confirma que supabase_URL y el client apunten al proyecto Supabase correcto (se usan en muchos servicios).
  - El repo ya incluye una supabaseKey en ese archivo; si cambias backend, actualízala.
- Revisa que el proyecto tenga acceso a:
  - Bucket: `Finca_imagenes` (path usado: `uploads/<fileName>`).
  - Tablas consultadas en el código: `Lote`, `Finca`, `usuario`, `Recordatorio`, `unionPyF`.
- Funcionalidades con requisitos de iOS:
  - `FincaSpeechParser` está marcado `@available(iOS 18.1, *)`.
  - El modelo `Finca` usa `SwiftData`.
  - AI transcriber requiere Apple Intelligence
  - Pagina web requiere browser moderno

## 2 — Preparar el backend (Supabase) 
- En el proyecto Supabase:
  - Asegura que existan las tablas: `Lote`, `Finca`, `usuario`, `Recordatorio`, `unionPyF` con las columnas que el código espera.
  - Crea el bucket `Finca_imagenes` y permite el acceso público si quieres usar la URL pública tal como el código la construye:
    - URL pública esperada: <supabase_URL>/storage/v1/object/public/Finca_imagenes/uploads/<file>
- No cambies nombres de tablas/buckets ni rutas, el código los referencia textualmente.

## 3 — Probar conectividad mínima (tests incluidos)
- Ejecuta las pruebas en Xcode.  
  - El test KaffiTests.testAPIFetch hace una petición a la tabla `Lote` y verifica respuesta; úsalo para validar conectividad con Supabase.

## 4 — Compilar, archivar y subir
1. Abrir proyecto en Xcode y seleccionar el target "Kaffi".
2. Verificar Signing & Capabilities (cuenta Apple y provisioning).  
   - Puedes usar firma automática si trabajas localmente.
3. Compilar (Product → Build).
4. Archivar (Product → Archive).
5. Subir a TestFlight o App Store (desde el Organizer → Upload) o exportar .ipa y usar Transporter.

## 5 — Checklist final (rápido)
- [ ] Kaffi/Utils/Supabase.swift apunta al Supabase correcto (supabase_URL y client).
- [ ] Bucket `Finca_imagenes` creado y accesible (ruta `uploads/`).
- [ ] Tablas en Supabase: `Lote`, `Finca`, `usuario`, `Recordatorio`, `unionPyF`.
- [ ] Ejecutadas las pruebas (KaffiTests) y pasan.
- [ ] Compilado, archivado y build subido desde Xcode.

