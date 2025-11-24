# Kaffi
La aplicación Kaffi está destinada tanto a productores y agricultores de café de pequeña escala, para que puedan registrar su ciclo de producción utilizando blockchain. También irá destinada a los consumidores para que puedan consultar los datos de producción del café que consumen, incluyendo el origen y las prácticas de agricultura de su producción. Esta aplicación busca crear un registro del proceso de producción de café a beneficio de los agricultores y mostrar con transparencia el proceso a los consumidores, y mostrando el compromiso ecológico. 

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
```

## Desarrollo

### Ejecutar en el simulador

1. Abrir el proyecto en Xcode:

```sh
open Kaffi.xcodeproj
```

2. Seleccionar un simulador:
   - iPhone 16 Pro o superior (iOS 18.1+)

3. Compilar y ejecutar


### Funcionalidades que se pueden probar

- Gestión de fincas y lotes  
- Registro del ciclo de producción  
- Navegación y formularios  
- Persistencia de datos con SwiftData  
- Reconocimiento de voz (simulado)


### XCTest

Las pruebas se ejecutan desde `KaffiTests`:


### Cobertura actual

Incluye pruebas para:

- Conectividad API (`testAPIFetch`)  
- Validación de ViewModel (`FincaCamposOb`)  
- UI con datos simulados (`testDetailsViewWithMockData`)  
- Carga de datos (`testLoteDetailViewModel`)

### Añadir pruebas nuevas

```swift
@Test func testNewFeature() async throws {
    // Preparación
    // Ejecución  
    // Validaciones con #expect
}
```


## Notas para simulador

- Reconocimiento de voz simulado  
- Cámara simulada  
- Blockchain simulado  
- Algunas funciones de IA simuladas

