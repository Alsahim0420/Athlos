# ⚡ ATHLOS

![ATHLOS](https://via.placeholder.com/400x200/1a1a1a/ffffff?text=ATHLOS+APP)

---

**ATHLOS** es una aplicación móvil desarrollada en Flutter para gestionar y explorar ejercicios físicos de manera inteligente, con funcionalidades offline-first y una experiencia de usuario moderna.

---

## ✨ Características Principales

### 🏠 **Home Page Inteligente**
- **Lista de ejercicios** con diseño de tarjetas moderno
- **Búsqueda y filtrado** de ejercicios por categoría
- **Skeleton loading** adaptativo para ambos temas
- **Banner de conectividad** en tiempo real
- **Logo ATHLOS** con icono de rayo personalizado

### 📱 **Sistema de Temas Avanzado**
- **Tres modos de tema**: Claro, Oscuro y Sistema
- **Persistencia automática** usando Hive
- **Transición suave** entre temas
- **Adaptación automática** de todos los componentes
- **Skeletons adaptativos** para ambos temas

### 🔄 **Arquitectura Offline-First**
- **Carga instantánea** desde cache local (Hive)
- **Sincronización automática** cuando hay conexión
- **Datos persistentes** entre sesiones
- **Funcionamiento completo** sin internet
- **Refresh inteligente** en background

### 🌐 **Detección de Conectividad**
- **Monitoreo en tiempo real** del estado de la red
- **Banners informativos** para cambios de conectividad
- **Auto-refresh** cuando se restaura la conexión
- **Indicadores visuales** del estado de la red
- **Persistencia de banner** offline

### 💪 **Detalle de Ejercicios Completo**
- **Información completa** de cada ejercicio
- **Instrucciones numeradas** con diseño mejorado
- **Músculos objetivo** y secundarios
- **Categorías y dificultad** claramente definidas
- **Datos desde Hive** para acceso offline

### 🔐 **Autenticación Robusta**
- **Firebase Authentication** con email/password
- **Firestore** para datos de usuario
- **Sesiones persistentes** con Hive
- **Manejo de errores** específicos de Firebase
- **Recuperación automática** de sesiones

---

## 🖼️ Capturas de Pantalla

### **Tema Claro**
![Tema Claro - Home](https://via.placeholder.com/300x600/f5f5f5/333333?text=Home+Tema+Claro)

### **Tema Oscuro**
![Tema Oscuro - Home](https://via.placeholder.com/300x600/1a1a1a/ffffff?text=Home+Tema+Oscuro)

### **Detalle de Ejercicio**
![Detalle Ejercicio](https://via.placeholder.com/300x600/ffffff/333333?text=Detalle+Ejercicio)

### **Perfil de Usuario**
![Perfil Usuario](https://via.placeholder.com/300x600/f0f0f0/333333?text=Perfil+Usuario)

---

## 🚀 Instalación y Configuración

### **Prerrequisitos**
- **Flutter SDK 3.32.8** o superior
- **Dart SDK 3.32.8** o superior
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### **Clonar y Configurar**
```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/athlos.git
cd athlos

# Instalar dependencias
flutter pub get

# Configurar Firebase (opcional para desarrollo local)
# Copiar google-services.json a android/app/
# Copiar GoogleService-Info.plist a ios/Runner/

# Ejecutar la aplicación
flutter run
```

### **Configuración de Firebase**
1. Crear proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Habilitar Authentication y Firestore
3. Descargar archivos de configuración
4. Configurar Remote Config para API keys

---

## 🛠️ Tecnologías y Arquitectura

### **Frontend & UI**
- **Flutter 3.32.8** - Framework principal ⭐
- **Material Design 3** - Sistema de diseño
- **GetX 4.6.6** - Gestión de estado y navegación ⭐
- **Responsive Design** - Adaptable a diferentes pantallas

### **Backend & Servicios**
- **Firebase Core 2.24.2** - Servicios base de Firebase ⭐
- **Firebase Auth 4.15.3** - Autenticación de usuarios ⭐
- **Cloud Firestore 4.13.6** - Base de datos en la nube ⭐
- **Firebase Remote Config 4.3.8** - Configuración dinámica ⭐
- **ExerciseDB API** - Base de datos de ejercicios

### **Almacenamiento Local**
- **Hive 2.2.3** - Base de datos local rápida ⭐
- **Hive Flutter 1.1.0** - Integración con Flutter ⭐
- **Hive Generator 2.0.1** - Generación de código ⭐
- **Type Adapters** - Serialización personalizada
- **Offline-First** - Datos persistentes localmente
- **Cache inteligente** - Gestión automática de datos

### **Gestión de Estado**
- **GetX 4.6.6** - State management reactivo ⭐
- **Controllers** - Lógica de negocio separada
- **Services** - Servicios inyectables
- **Bindings** - Inyección de dependencias

### **Conectividad & APIs**
- **HTTP 1.1.0** - Cliente HTTP para APIs externas ⭐
- **Connectivity Plus 5.0.2** - Detección de estado de red ⭐
- **RapidAPI** - Acceso a ExerciseDB
- **Error Handling** - Manejo robusto de errores

---

## 🏗️ Arquitectura del Proyecto

### **Estructura de Carpetas**
```
lib/
├── core/                          # Funcionalidades core
│   ├── config/                    # Configuraciones
│   ├── controllers/               # Controladores globales
│   ├── routes/                    # Rutas y navegación
│   ├── services/                  # Servicios core
│   └── adapters/                  # Adaptadores Hive
├── features/                      # Características de la app
│   ├── auth/                      # Autenticación
│   ├── home/                      # Página principal
│   ├── profile/                   # Perfil de usuario
│   └── splash/                    # Pantalla de carga
└── shared/                        # Componentes compartidos
```

### **Patrón de Diseño**
- **Clean Architecture** - Separación de responsabilidades
- **Repository Pattern** - Abstracción de datos
- **Dependency Injection** - Inyección de dependencias
- **Observer Pattern** - Reactividad con GetX

---

## 🔧 Funcionalidades Técnicas

### **Sistema de Temas**
```dart
class ThemeService extends GetxService {
  final Rx<ThemeMode> _currentTheme = ThemeMode.system.obs;
  
  // Persistencia automática con Hive
  Future<void> changeTheme(ThemeMode themeMode) async {
    _currentTheme.value = themeMode;
    Get.changeThemeMode(themeMode);
    await _saveThemeToHive(themeMode);
  }
}
```

### **Gestión Offline-First**
```dart
// Carga primero desde cache, luego intenta red
if (_exerciseRepository.hasCachedData) {
  final cachedExercises = _exerciseRepository.getCachedExercises();
  exercises.assignAll(cachedExercises);
}

// Refresh en background
try {
  final exerciseList = await _exerciseRepository.fetchExercises();
  exercises.assignAll(exerciseList);
} catch (e) {
  // Fallback a cache si falla la red
}
```

### **Detección de Conectividad**
```dart
// Monitoreo en tiempo real
_connectivitySubscription = Connectivity()
    .onConnectivityChanged
    .listen(_handleConnectivityChange);

// Banners automáticos
void _showConnectivityBanner({required bool isOnline}) {
  isConnectivityBannerVisible.value = true;
  isConnectivityBannerOnline.value = isOnline;
}
```

---

## 📱 Características de UX/UI

### **Skeleton Loading**
- **Indicadores visuales** durante la carga
- **Adaptación automática** a ambos temas
- **Transiciones suaves** entre estados
- **Feedback inmediato** para el usuario

### **Banners de Conectividad**
- **Posicionamiento inteligente** sobre el contenido
- **No interfiere** con el scroll
- **Auto-ocultación** para estado online
- **Persistencia** para estado offline

### **Navegación Intuitiva**
- **Bottom Navigation** para secciones principales
- **Transiciones fluidas** entre páginas
- **Gestos nativos** de Android/iOS
- **Navegación con GetX** optimizada

---

## 🔒 Seguridad y Privacidad

### **Autenticación**
- **Firebase Auth** con tokens seguros
- **Validación de sesiones** en cada operación
- **Logout automático** por inactividad
- **Encriptación** de datos sensibles

### **Datos del Usuario**
- **Almacenamiento local** seguro con Hive
- **Sincronización** solo con Firebase
- **No compartición** de datos personales
- **Cumplimiento** con estándares de privacidad

---

## 🚀 Despliegue y Distribución

### **Build de Producción**
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### **Configuración de Release**
- **Proguard** para ofuscación de código
- **Signing** con keystore de producción
- **Optimizaciones** de rendimiento
- **Testing** en dispositivos reales

---

## 🧪 Testing y Calidad

### **Testing Unitario**
- **Flutter Lints 5.0.0** - Reglas de calidad de código ⭐
- **Build Runner 2.4.7** - Generación de código ⭐
- **Controllers** con GetX testing
- **Services** con mocks
- **Models** con validaciones
- **Repository** con tests de integración

### **Testing de UI**
- **Widget testing** para componentes
- **Integration testing** para flujos
- **Golden tests** para diseño
- **Performance testing** para rendimiento

---

## 📊 Métricas y Analytics

### **Firebase Analytics**
- **Eventos personalizados** de usuario
- **Métricas de rendimiento** de la app
- **Análisis de uso** por funcionalidad
- **Crashlytics** para estabilidad

### **Monitoreo de Rendimiento**
- **Tiempo de carga** de páginas
- **Uso de memoria** y CPU
- **Latencia** de operaciones
- **Optimizaciones** automáticas

---

## 🤝 Contribución

### **Guidelines**
1. **Fork** del repositorio
2. **Feature branch** para cambios
3. **Commit messages** descriptivos
4. **Pull Request** con descripción clara
5. **Code review** obligatorio

### **Estándares de Código**
- **Dart/Flutter** linting rules
- **Clean Code** principles
- **Documentación** inline
- **Testing** para nuevas funcionalidades

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

## 👨‍💻 Desarrollador

**Desarrollado con ⚡ y 💙 por Pablo Melo**

- **GitHub**: [@tu-usuario](https://github.com/tu-usuario)
- **LinkedIn**: [Pablo Melo](https://linkedin.com/in/pablo-melo)
- **Portfolio**: [pablomelo.dev](https://pablomelo.dev)

---

## 🙏 Agradecimientos

- **Flutter Team** por el framework increíble
- **GetX** por la gestión de estado
- **Firebase** por los servicios backend
- **ExerciseDB** por la base de datos de ejercicios
- **Comunidad Flutter** por el apoyo continuo

---

**⭐ Si te gusta ATHLOS, ¡dale una estrella al repositorio!**
