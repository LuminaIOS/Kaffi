# Kaffi

La aplicación Kaffi está destinada tanto a productores y agricultores de café de pequeña escala, para que puedan registrar datos de su ciclo de producción utilizando blockchain, incluyendo el origen y las prácticas agrícolas. El proyecto también está destinado a los consumidores, quienes podrán consultar datos sobre la producción de su café escaneando un código QR. Esta aplicación busca crear un registro transparente del proceso de producción a beneficio de los agricultores y mostrar el compromiso ecológico a los consumidores.

## ¿Qué hay en el stack?

- Desarrollo nativo iOS con Swift  
- SwiftUI para la interfaz gráfica  
- SwiftData para persistencia de datos local  
- Supabase como backend y base de datos  
- Xcode Simulator para pruebas locales

## Requisitos

- macOS con Xcode 16 o posterior  
- iOS 18.1 o posterior (para pruebas en el simulador)  
- Se recomienda una Mac con Apple Silicon (M1 o superior)

## Guía

### Configuración para desarrollo

1. Instalar Xcode desde la Mac App Store  
2. Clonar el repositorio y abrir el proyecto:  
3. Configurar Supabase (opcional):  
   - La app incluye datos simulados  
   - Para funcionalidad completa, configurar Supabase como se indica abajo

### Configuración de Supabase (Opcional)

1. Crear cuenta en Supabase  
2. Crear tablas:

- `Lote`  
- `Finca`  
- `usuario`  
- `Recordatorio`  
- `unionPyF`

3. Crear bucket `Finca_imagenes`  
4. Actualizar `Kaffi/Utils/Supabase.swift`:

```swift
let supabaseUrl = "https://your-project.supabase.co"
let supabaseKey = "your-anon-key"
