# =========================================
# SCRIPT MEJORADO PARA EXTRAER PRODUCTOS DE PDF CATÁLOGO SGS
# Páginas 49 a 54 (index 48 a 53)
# Corrige problemas de alineación de datos
# =========================================

# Paso 1: Instalar librerías necesarias
# !pip install pdfplumber pandas -q

import pdfplumber
import re
import pandas as pd
from google.colab import files

def es_precio(texto):
    """
    Determina si un texto parece ser un precio.
    Retorna True si contiene solo números, puntos, comas o guión.
    """
    if not texto:
        return False
    # Eliminar espacios
    texto = texto.strip()
    # Patrón para precio: números con puntos/comas opcional y posible guión
    return bool(re.match(r'^[\d\.,\-]+$', texto))

def limpiar_precio(precio_raw):
    """
    Limpia y formatea un precio.
    """
    if not precio_raw or precio_raw.strip() == '-':
        return "-"

    precio = precio_raw.strip()
    # Quitar puntos como separadores de miles y convertir comas a puntos
    # Formato chileno: 32.400 -> 32400
    if '.' in precio and ',' not in precio:
        # Si tiene puntos pero no comas, los puntos son separadores de miles
        precio = precio.replace(".", "")
    elif ',' in precio:
        # Si tiene comas, son decimales
        precio = precio.replace(".", "").replace(",", ".")

    try:
        return float(precio)
    except:
        return precio_raw

def extraer_producto_de_linea(line):
    """
    Extrae código, nombre y precio de una línea usando múltiples estrategias.
    Retorna (codigo, nombre, precio) o None si no es una línea de producto.
    """
    line = line.strip()

    # Ignorar líneas muy cortas
    if len(line) < 3:
        return None

    # Estrategia 1: Dividir la línea en tokens
    tokens = line.split()
    if len(tokens) < 2:
        return None

    # El primer token generalmente es el código (alphanumerico)
    codigo_candidato = tokens[0]

    # Verificar que el código tenga formato válido (letras y/o números)
    if not re.match(r'^[A-Z0-9\-]+$', codigo_candidato, re.IGNORECASE):
        return None

    # Buscar el precio en los tokens (generalmente es un número)
    precio_idx = None
    precio = "-"

    for i in range(1, len(tokens)):
        if es_precio(tokens[i]):
            precio_idx = i
            precio = tokens[i]
            break

    # Determinar el nombre basado en dónde está el precio
    if precio_idx is not None:
        # El nombre está entre el código y el precio
        nombre = ' '.join(tokens[1:precio_idx])
        # Si hay tokens después del precio, pueden ser parte del nombre
        if precio_idx < len(tokens) - 1:
            resto = ' '.join(tokens[precio_idx + 1:])
            # Solo agregar al nombre si no parece ser otra información
            if len(resto) > 3 and not es_precio(resto):
                nombre = nombre + ' ' + resto if nombre else resto
    else:
        # No se encontró precio, todo después del código es nombre
        nombre = ' '.join(tokens[1:])

    # Limpiar espacios extras
    nombre = nombre.strip()
    codigo = codigo_candidato.strip()

    # Validar que tengamos al menos código y nombre
    if not codigo or not nombre or len(nombre) < 2:
        return None

    # Limpiar precio
    precio_limpio = limpiar_precio(precio)

    return (codigo, nombre, precio_limpio)

# Paso 2: Subir el archivo PDF
print("=" * 60)
print("EXTRACTOR DE PRODUCTOS SGS - VERSIÓN MEJORADA")
print("=" * 60)
print("\nSube el archivo PDF (00 SGS2026 Enero.pdf o similar)")
uploaded = files.upload()

# Obtener el nombre del archivo subido
pdf_filename = list(uploaded.keys())[0]
print(f"\n✓ Archivo recibido: {pdf_filename}")

# Paso 3: Abrir el PDF y extraer texto de las páginas deseadas
print("\n" + "=" * 60)
print("EXTRAYENDO DATOS DEL PDF")
print("=" * 60)

data = []
current_category = "Sin categoría"
lineas_procesadas = 0
lineas_extraidas = 0

with pdfplumber.open(pdf_filename) as pdf:
    total_paginas = len(range(48, 54))

    for idx, page_num in enumerate(range(48, 54), 1):
        print(f"\nProcesando página {page_num + 1} ({idx}/{total_paginas})...")

        page = pdf.pages[page_num]
        text = page.extract_text()

        if text:
            lines = text.split('\n')
            productos_en_pagina = 0

            for line in lines:
                lineas_procesadas += 1
                line = line.strip()

                if not line:
                    continue

                # Detectar encabezados de categoría
                # Generalmente son líneas en mayúsculas, sin números, más largas
                if (line.isupper() and
                    len(line) > 10 and
                    not re.search(r'\d', line) and
                    len(line.split()) <= 5):
                    current_category = line.strip().title()
                    print(f"  └─ Categoría detectada: {current_category}")
                    continue

                # Intentar extraer producto de la línea
                resultado = extraer_producto_de_linea(line)

                if resultado:
                    codigo, nombre, precio = resultado
                    data.append({
                        "Código": codigo,
                        "Nombre del Producto": nombre,
                        "Precio": precio,
                        "Categoria": current_category
                    })
                    productos_en_pagina += 1
                    lineas_extraidas += 1

            print(f"  └─ {productos_en_pagina} productos extraídos de esta página")

print(f"\n{'=' * 60}")
print(f"RESUMEN DE EXTRACCIÓN")
print(f"{'=' * 60}")
print(f"Líneas procesadas: {lineas_procesadas}")
print(f"Productos extraídos: {lineas_extraidas}")

# Paso 4: Crear DataFrame y limpiar duplicados
df = pd.DataFrame(data)

print(f"\nAntes de limpieza: {len(df)} registros")

# Eliminar duplicados por código
df = df.drop_duplicates(subset=['Código'], keep='first')

print(f"Después de eliminar duplicados: {len(df)} registros")

# Paso 5: Mostrar muestra de datos
print(f"\n{'=' * 60}")
print("MUESTRA DE DATOS EXTRAÍDOS (Primeros 15 registros)")
print(f"{'=' * 60}\n")
print(df.head(15).to_string(index=False))

# Paso 6: Exportar a CSV
csv_filename = "productos_sgs_extraidos.csv"
df.to_csv(csv_filename, index=False, encoding='utf-8-sig')
files.download(csv_filename)

print(f"\n{'=' * 60}")
print("EXPORTACIÓN COMPLETADA")
print(f"{'=' * 60}")
print(f"✓ Archivo generado: {csv_filename}")
print(f"✓ Total de productos: {len(df)}")
print("\n📋 PRÓXIMOS PASOS:")
print("1. Descarga el archivo CSV")
print("2. Abre Google Sheets")
print("3. Ve a Archivo > Importar > Subir")
print("4. Selecciona el archivo descargado")
print("5. Configura:")
print("   - Tipo de separador: Detectar automáticamente")
print("   - Convertir texto a números: Sí")
print("6. Importar datos")
print(f"{'=' * 60}\n")
