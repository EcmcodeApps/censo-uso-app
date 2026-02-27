# Configuración de entorno para Google IDX / Firebase Studio
# Este archivo configura automáticamente Flutter, Android SDK y todas las herramientas necesarias

{ pkgs, ... }: {

  # Canal de Nix — stable-24.05 es el más compatible
  channel = "stable-24.05";

  # Paquetes del sistema que se instalarán automáticamente
  packages = [
    pkgs.jdk17          # Java necesario para Android
    pkgs.unzip          # Para descomprimir archivos
    pkgs.curl           # Para descargas
    pkgs.git            # Control de versiones
  ];

  # Variables de entorno del workspace
  env = {
    # Puerto por defecto para Flutter Web
    FLUTTER_WEB_PORT = "3000";
  };

  # Extensiones de VS Code que se instalarán automáticamente en IDX
  idx.extensions = [
    "Dart-Code.dart-code"      # Soporte oficial de Dart
    "Dart-Code.flutter"        # Soporte oficial de Flutter
    "usernamehw.errorlens"     # Muestra errores en línea
    "streetsidesoftware.code-spell-checker"  # Corrector ortográfico
    "PKief.material-icon-theme"  # Iconos bonitos para los archivos
  ];

  # Configuración de previsualizaciones (emuladores en el navegador)
  idx.previews = {
    enable = true;
    previews = {

      # Previsualización en Android (emulador en el navegador)
      android = {
        manager = "android";
      };

      # Previsualización en Web (para probar la app en el navegador)
      web = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "web-server"
          "--web-port"
          "$PORT"
          "--web-hostname"
          "0.0.0.0"
        ];
        manager = "web";
      };
    };
  };

  # Comandos que se ejecutan automáticamente cuando el workspace inicia
  idx.workspace.onCreate = {
    # Instalar dependencias del proyecto al crear el workspace
    flutter-pub-get = {
      openFiles = [ "lib/main.dart" ];
    };
  };

  # Comandos que se ejecutan cuando el workspace ya existe y se abre
  idx.workspace.onStart = {
    # Mensaje de bienvenida en la terminal
    welcome = {
      command = [
        "echo"
        "🍽️ Restaurant Ecommerce App cargada. Usa el panel de Preview para ver el emulador Android!"
      ];
    };
  };
}
