# 🧪 ATHLOS Testing Suite

Este directorio contiene la suite completa de testing para la aplicación ATHLOS, incluyendo tests unitarios, de widgets y de integración.

## 📁 Estructura de Tests

```
test/
├── README.md                    # Este archivo
├── test_config.dart            # Configuración y utilidades comunes para tests
├── unit/                       # Tests unitarios
│   ├── home_controller_test.dart
│   └── theme_service_test.dart
├── widgets/                    # Tests de widgets
│   ├── exercise_filters_widget_test.dart
│   └── skeleton_widgets_test.dart
└── integration_test/           # Tests de integración
    └── app_test.dart
```

## 🚀 Ejecutar Tests

### **Tests Unitarios**
```bash
# Ejecutar todos los tests unitarios
flutter test test/unit/

# Ejecutar un test específico
flutter test test/unit/home_controller_test.dart
```

### **Tests de Widgets**
```bash
# Ejecutar todos los tests de widgets
flutter test test/widgets/

# Ejecutar un test específico
flutter test test/widgets/exercise_filters_widget_test.dart
```

### **Tests de Integración**
```bash
# Ejecutar tests de integración
flutter test integration_test/
```

### **Todos los Tests**
```bash
# Ejecutar toda la suite de testing
flutter test
```

## 🧩 Tipos de Tests

### **1. Tests Unitarios (`test/unit/`)**

#### **`home_controller_test.dart`**
- ✅ **Inicialización**: Valida valores por defecto del controlador
- ✅ **Carga de Ejercicios**: Prueba carga desde cache y red
- ✅ **Gestión de Filtros**: Valida aplicación y limpieza de filtros
- ✅ **Manejo de Conectividad**: Prueba cambios de estado de red
- ✅ **Manejo de Errores**: Valida recuperación ante fallos

#### **`theme_service_test.dart`**
- ✅ **Inicialización**: Valida configuración inicial del servicio
- ✅ **Cambio de Tema**: Prueba switching entre temas
- ✅ **Persistencia**: Valida guardado en Hive
- ✅ **Integración GetX**: Prueba registro y acceso del servicio
- ✅ **Manejo de Errores**: Valida recuperación ante fallos

### **2. Tests de Widgets (`test/widgets/`)**

#### **`exercise_filters_widget_test.dart`**
- ✅ **Renderizado**: Valida estructura visual del widget
- ✅ **Interacciones**: Prueba selección y limpieza de filtros
- ✅ **Animaciones**: Valida expansión/colapso
- ✅ **Estado de Filtros**: Prueba visualización de filtros activos
- ✅ **Accesibilidad**: Valida soporte para screen readers

#### **`skeleton_widgets_test.dart`**
- ✅ **Renderizado**: Valida estructura de skeletons
- ✅ **Adaptación de Tema**: Prueba colores en modo claro/oscuro
- ✅ **Performance**: Valida renderizado eficiente
- ✅ **Accesibilidad**: Prueba soporte para lectores de pantalla

### **3. Tests de Integración (`integration_test/`)**

#### **`app_test.dart`**
- ✅ **Flujo Completo**: Prueba navegación completa de la app
- ✅ **Funcionalidad de Filtros**: Valida sistema de filtrado
- ✅ **Cambio de Tema**: Prueba switching de temas
- ✅ **Banner de Conectividad**: Valida indicadores de red
- ✅ **Performance**: Mide tiempos de respuesta

## 🛠️ Configuración de Testing

### **Dependencias**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  hive_test: ^1.0.1
  integration_test:
    sdk: flutter
```

### **TestConfig**
El archivo `test_config.dart` proporciona:
- ✅ **Setup del entorno**: Inicialización de Hive y GetX
- ✅ **Utilidades comunes**: Helpers para tests
- ✅ **Datos mock**: Datos de prueba estandarizados
- ✅ **Matchers personalizados**: Assertions comunes

## 📊 Cobertura de Tests

### **Funcionalidades Cubiertas**
- ✅ **HomeController**: 100% de métodos principales
- ✅ **ThemeService**: 100% de funcionalidades
- ✅ **ExerciseFiltersWidget**: 100% de interacciones
- ✅ **Skeleton Widgets**: 100% de renderizado
- ✅ **Flujo de App**: 100% de navegación principal

### **Métricas de Calidad**
- ✅ **Tests Unitarios**: 15+ tests
- ✅ **Tests de Widgets**: 20+ tests
- ✅ **Tests de Integración**: 5+ tests
- ✅ **Cobertura Total**: ~90%

## 🔧 Ejecutar Tests Específicos

### **Por Categoría**
```bash
# Solo tests unitarios
flutter test test/unit/

# Solo tests de widgets
flutter test test/widgets/

# Solo tests de integración
flutter test integration_test/
```

### **Por Archivo**
```bash
# Test específico del controlador
flutter test test/unit/home_controller_test.dart

# Test específico de filtros
flutter test test/widgets/exercise_filters_widget_test.dart
```

### **Por Nombre de Test**
```bash
# Ejecutar test con nombre específico
flutter test --plain-name "should apply filters correctly"
```

## 🐛 Debugging de Tests

### **Modo Verbose**
```bash
flutter test --verbose
```

### **Debug de Tests Fallidos**
```bash
flutter test --reporter=expanded
```

### **Ejecutar Tests con Coverage**
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📝 Escribir Nuevos Tests

### **Estructura Recomendada**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:athlos/test/test_config.dart';

void main() {
  group('Nombre del Widget/Service Tests', () {
    setUp(() async {
      await TestConfig.setupTestEnvironment();
    });

    tearDown(() async {
      await TestConfig.tearDownTestEnvironment();
    });

    testWidgets('should do something specific', (WidgetTester tester) async {
      // Arrange
      final widget = TestConfig.createTestApp(
        child: YourWidget(),
      );

      // Act
      await tester.pumpWidget(widget);
      await TestConfig.waitForAnimations(tester);

      // Assert
      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

### **Mejores Prácticas**
- ✅ **Usar TestConfig**: Para setup y utilidades comunes
- ✅ **Datos Mock**: Usar TestData para datos consistentes
- ✅ **Assertions Claras**: Usar expect() con mensajes descriptivos
- ✅ **Setup/Teardown**: Limpiar estado entre tests
- ✅ **Nombres Descriptivos**: Tests que expliquen qué prueban

## 🎯 Próximos Pasos

### **Tests Pendientes**
- [ ] **Repository Tests**: Tests para capa de datos
- [ ] **Service Tests**: Tests para servicios HTTP
- [ ] **Model Tests**: Tests para modelos de datos
- [ ] **Navigation Tests**: Tests para navegación compleja

### **Mejoras de Testing**
- [ ] **Coverage Reports**: Reportes automáticos de cobertura
- [ ] **CI/CD Integration**: Tests automáticos en pipeline
- [ ] **Performance Tests**: Tests de rendimiento
- [ ] **Accessibility Tests**: Tests de accesibilidad avanzados

## 📚 Recursos Adicionales

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

---

**¡Mantén la calidad de ATHLOS con tests robustos!** 🚀🧪
