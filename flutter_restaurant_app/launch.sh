#!/bin/bash
# Script de inicio para Google IDX / Firebase Studio
# Ejecuta: bash launch.sh

echo "🍽️  Restaurant Ecommerce App - Iniciando..."
echo ""

# 1. Verificar que Flutter esté disponible
echo "📋 Verificando Flutter..."
flutter --version

# 2. Instalar dependencias
echo ""
echo "📦 Instalando dependencias..."
flutter pub get

# 3. Verificar el entorno
echo ""
echo "🔍 Verificando entorno..."
flutter doctor

# 4. Mostrar dispositivos disponibles
echo ""
echo "📱 Dispositivos disponibles:"
flutter devices

echo ""
echo "✅ Todo listo! Puedes:"
echo "   • En IDX: click en el botón ▶ del panel Preview"
echo "   • En terminal: flutter run -d chrome  (para web)"
echo "   • En terminal: flutter run             (para el emulador Android)"
