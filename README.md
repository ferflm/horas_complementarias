# 📚 Horas Complementarias

Una app móvil desarrollada en **Flutter** que permite a estudiantes universitarios registrar, visualizar y dar seguimiento a sus **horas de formación complementaria**, incluyendo actividades culturales, deportivas, de investigación y emprendimiento.

## 🎯 Funcionalidades

- Registro de actividades con:
    - Nombre, descripción, tipo y subtipo
    - Fechas de inicio y fin
    - Cantidad de horas
    - Comprobante adjunto (imagen o PDF)
- Dashboard con:
    - Conteo de horas completadas
    - Gráfica circular por tipo de actividad
    - Gráfica de líneas del progreso por día
- Historial de actividades
    - Edición y eliminación
    - Visualización de comprobantes
- Almacenamiento **local** con Hive
- Interfaz simple, responsiva y amigable

## 🛠️ Tecnologías

- Flutter 3.x
- [Hive (Community Edition)](https://pub.dev/packages/hive_ce)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [file_picker](https://pub.dev/packages/file_picker)
- [open_file](https://pub.dev/packages/open_file)

## 🧪 Instalación y ejecución

```bash
git clone https://github.com/tu_usuario/horas_complementarias.git
cd horas_complementarias
flutter pub get
flutter run