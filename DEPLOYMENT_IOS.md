# Despliegue en iPhone y Apple Watch

Esta guía te ayudará a instalar GymTrack en tu iPhone y Apple Watch.

## Requisitos Previos

### Software Necesario
1. **macOS**: Necesitas una Mac para desarrollar aplicaciones iOS
2. **Xcode 12.0 o superior**: Descarga desde la App Store
3. **Flutter SDK 3.0+**: Instalado y configurado
4. **CocoaPods**: Para gestionar dependencias iOS
   ```bash
   sudo gem install cocoapods
   ```

### Hardware Necesario
- iPhone con iOS 12.0 o superior
- Apple Watch (opcional) - compatible con watchOS
- Cable USB para conectar el iPhone a la Mac

### Cuenta de Apple
- **Para pruebas en dispositivo**: Cuenta gratuita de Apple Developer
- **Para distribución en App Store**: Apple Developer Program ($99/año)

## Pasos de Instalación

### 1. Preparar el Proyecto

```bash
# Navega al directorio del proyecto
cd gymtrack

# Instala las dependencias de Flutter
flutter pub get

# Navega a la carpeta iOS e instala pods
cd ios
pod install
cd ..
```

### 2. Configurar Xcode

#### A. Abrir el Proyecto en Xcode
```bash
open ios/Runner.xcworkspace
```

⚠️ **Importante**: Abre `Runner.xcworkspace`, NO `Runner.xcodeproj`

#### B. Configurar el Bundle Identifier
1. En Xcode, selecciona el proyecto "Runner" en el navegador
2. Selecciona el target "Runner"
3. Ve a la pestaña "Signing & Capabilities"
4. Cambia el **Bundle Identifier** a algo único:
   - Ejemplo: `com.tunombre.gymtrack`
   - Debe ser único en todo el ecosistema de Apple

#### C. Configurar el Team (Equipo de Desarrollo)
1. En "Signing & Capabilities"
2. Marca "Automatically manage signing"
3. Selecciona tu Team (tu cuenta de Apple)
   - Si no aparece, haz clic en "Add Account..." e inicia sesión

### 3. Preparar tu iPhone

#### A. Habilitar Modo Desarrollador
1. En tu iPhone, ve a **Ajustes** → **Privacidad y Seguridad**
2. Desplázate hasta el final y busca **Modo de Desarrollador**
3. Activa el **Modo de Desarrollador**
4. Reinicia el iPhone cuando se te solicite

#### B. Confiar en tu Mac
1. Conecta tu iPhone a la Mac con un cable USB
2. En el iPhone, verás un mensaje "¿Confiar en este ordenador?"
3. Toca **Confiar** e introduce tu código de acceso

### 4. Desplegar en iPhone

#### Método 1: Desde Flutter CLI
```bash
# Conecta tu iPhone y verifica que aparece
flutter devices

# Debería aparecer algo como:
# iPhone de [Tu Nombre] • 00008030-XXXXXXXXXXXX • ios • iOS 17.0

# Despliega la aplicación
flutter run

# O para una versión específica de dispositivo:
flutter run -d "iPhone de [Tu Nombre]"
```

#### Método 2: Desde Xcode
1. Conecta tu iPhone a la Mac
2. Abre `ios/Runner.xcworkspace` en Xcode
3. En la barra superior, selecciona tu iPhone como destino
4. Presiona el botón ▶️ (Play) o Cmd+R
5. Espera a que se compile e instale

### 5. Primera Ejecución en el iPhone

Cuando instales la app por primera vez:

1. **Mensaje de "Desarrollador No Confiable"**
   - Ve a **Ajustes** → **General** → **VPN y Gestión de Dispositivos**
   - Toca tu cuenta de Apple Developer
   - Toca **Confiar en "[Tu Email]"**
   - Confirma tocando **Confiar**

2. **Ahora puedes abrir la app** desde tu iPhone

### 6. Desplegar en Apple Watch

El Apple Watch usa la misma compilación de iOS. Para usar GymTrack en tu Apple Watch:

#### Preparación
1. **Empareja tu Apple Watch** con el iPhone si aún no lo has hecho
2. El Apple Watch debe tener **watchOS actualizado**

#### Opción A: Uso Directo (Limitado)
La aplicación iOS se puede ejecutar en el Apple Watch a través de:
- Notificaciones reflejadas desde el iPhone
- Control de música y notificaciones básicas
- Para funcionalidad completa, necesitarías un target watchOS dedicado

#### Opción B: Crear Target WatchOS (Avanzado)

Para una experiencia completa en Apple Watch, necesitas agregar un target watchOS:

1. En Xcode, ve a **File** → **New** → **Target**
2. Selecciona **watchOS** → **Watch App**
3. Configura:
   - Product Name: `GymTrack Watch`
   - Bundle Identifier: `com.tunombre.gymtrack.watchkitapp`
   - Language: Swift

4. Modifica el código para usar la interfaz wear:
   - Usa diseños adaptados para pantallas pequeñas
   - Implementa `WKInterfaceController`
   - Sincroniza datos con el iPhone usando WatchConnectivity

**Nota**: La aplicación actual está optimizada para WearOS. Para Apple Watch nativo, se requeriría desarrollo adicional con SwiftUI o WatchKit.

### 7. Build de Producción

#### Para Distribución Personal (TestFlight o Ad Hoc)

```bash
# Crear build de release
flutter build ios --release

# Luego en Xcode:
# 1. Product → Archive
# 2. Distribuir como Ad Hoc o TestFlight
```

#### Para App Store
1. Prepara los recursos necesarios:
   - Iconos de la app (todos los tamaños)
   - Screenshots del iPhone
   - Descripción de la app
   - Política de privacidad

2. Crea el build:
   ```bash
   flutter build ios --release
   ```

3. En Xcode:
   - **Product** → **Archive**
   - Espera a que termine
   - Click en **Distribute App**
   - Selecciona **App Store Connect**
   - Sigue el asistente

4. En App Store Connect (https://appstoreconnect.apple.com):
   - Completa la información de la app
   - Sube capturas de pantalla
   - Envía para revisión

## Solución de Problemas

### Error: "Code signing failed"
**Solución**: 
- Verifica que el Bundle Identifier sea único
- Asegúrate de haber seleccionado un Team válido
- Prueba con "Automatically manage signing"

### Error: "Unable to install [app name]"
**Solución**:
- Verifica que el Modo de Desarrollador esté activado
- Confía en el certificado en Ajustes → General → VPN y Gestión de Dispositivos

### Error: "Failed to prepare device for development"
**Solución**:
```bash
# Limpia y reconstruye
flutter clean
cd ios
pod install
cd ..
flutter pub get
flutter run
```

### La app se cierra inmediatamente
**Solución**:
- Verifica los logs en Xcode: Window → Devices and Simulators
- Selecciona tu dispositivo y mira el Console

### Error de CocoaPods
**Solución**:
```bash
cd ios
pod repo update
pod install
cd ..
```

## Actualizaciones

Para actualizar la app en tu iPhone después de cambios:

```bash
# Método rápido con hot reload durante desarrollo
flutter run

# Para reinstalar completamente
flutter clean
flutter run
```

## Diferencias entre iPhone y Apple Watch

| Característica | iPhone | Apple Watch |
|---------------|---------|-------------|
| Interfaz completa | ✅ Sí | ⚠️ Limitada* |
| Crear rutinas | ✅ Sí | ❌ No |
| Ver rutinas | ✅ Sí | ✅ Sí (limitado) |
| Tracking entrenos | ✅ Sí | ⚠️ Básico* |
| Notificaciones | ✅ Sí | ✅ Sí |

*La versión actual está optimizada para WearOS. Para funcionalidad completa en Apple Watch, se requiere desarrollo adicional con watchOS SDK.

## Comandos Útiles

```bash
# Ver dispositivos conectados
flutter devices

# Ver logs en tiempo real
flutter logs

# Instalar en dispositivo específico
flutter install -d [device-id]

# Ejecutar en modo release
flutter run --release

# Generar IPA para distribución
flutter build ipa
```

## Recursos Adicionales

- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [Xcode Documentation](https://developer.apple.com/xcode/)
- [Apple Developer Portal](https://developer.apple.com/)
- [TestFlight Guide](https://developer.apple.com/testflight/)

## Notas Importantes

1. **Certificados Gratuitos**: Los certificados de desarrollo gratuitos expiran cada 7 días. Necesitarás reinstalar la app periódicamente o suscribirte al Apple Developer Program.

2. **Apple Watch Nativo**: Para una experiencia completa en Apple Watch, considera desarrollar un target watchOS dedicado usando SwiftUI y el framework Watch Connectivity para sincronización.

3. **Versiones WearOS vs watchOS**: 
   - `lib/main_wear.dart` está diseñado para WearOS (Android)
   - Para Apple Watch, usa el mismo `lib/main.dart` pero considera crear interfaces adaptadas

4. **TestFlight**: Para compartir con testers antes de publicar en la App Store, usa TestFlight (incluido con Apple Developer Program).

## Próximos Pasos

Una vez que tengas la app funcionando en tu iPhone:

1. ✅ Prueba todas las funcionalidades
2. ✅ Crea algunas rutinas de prueba
3. ✅ Verifica el tracking de progressive overload
4. 🔄 Considera feedback para mejoras
5. 🚀 Comparte con amigos usando TestFlight

---

**¿Problemas?** Revisa la sección de Solución de Problemas o abre un issue en el repositorio.
