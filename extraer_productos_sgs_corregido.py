"""
================================================================================
EXTRACTOR DE PRODUCTOS SGS - CATÁLOGO PDF
================================================================================

Descripción:
    Script profesional para extraer productos de catálogos PDF SGS.
    Convierte datos del PDF en formato CSV para importar en Google Sheets.

Autor: Claude Code
Versión: 2.0
Fecha: 2026-01-21

Características:
    ✓ Detección inteligente de precios
    ✓ Extracción precisa de códigos y nombres
    ✓ Limpieza automática de formatos chilenos (32.400 -> 32400)
    ✓ Categorización automática
    ✓ Validación de datos
    ✓ Mensajes de progreso detallados

Uso en Google Colab:
    1. Ejecuta: !pip install pdfplumber pandas -q
    2. Copia y ejecuta este script completo
    3. Sube tu archivo PDF
    4. Descarga el CSV generado
    5. Importa en Google Sheets

================================================================================
"""

# ============================================================================
# IMPORTACIONES
# ============================================================================

import pdfplumber
import re
import pandas as pd
from google.colab import files
from typing import Tuple, Optional, List, Dict
import warnings

warnings.filterwarnings('ignore')


# ============================================================================
# CONFIGURACIÓN
# ============================================================================

class Config:
    """Configuración centralizada del extractor"""

    # Páginas a extraer (0-indexed)
    # Para páginas 49-54 del PDF, usar 48-53 (0-indexed)
    PAGINA_INICIO = 48
    PAGINA_FIN = 54

    # Configuración de detección de categorías
    MIN_LONGITUD_CATEGORIA = 10      # Longitud mínima del texto de categoría
    MAX_PALABRAS_CATEGORIA = 5       # Máximo de palabras en categoría

    # Configuración de validación de productos
    MIN_LONGITUD_CODIGO = 1          # Longitud mínima del código
    MIN_LONGITUD_NOMBRE = 2          # Longitud mínima del nombre

    # Configuración de exportación
    ARCHIVO_SALIDA = "productos_sgs_extraidos.csv"
    ENCODING_CSV = "utf-8-sig"

    # Categoría por defecto
    CATEGORIA_DEFAULT = "Sin categoría"

    # Símbolos para UI
    SEPARADOR = "=" * 70
    SIMBOLO_EXITO = "✓"
    SIMBOLO_INFO = "ℹ"
    SIMBOLO_FLECHA = "└─"


# ============================================================================
# FUNCIONES DE UTILIDAD
# ============================================================================

def es_precio(texto: str) -> bool:
    """
    Determina si un texto representa un precio.

    Args:
        texto: String a evaluar

    Returns:
        True si el texto parece ser un precio, False en caso contrario

    Ejemplos:
        >>> es_precio("32.400")
        True
        >>> es_precio("12,50")
        True
        >>> es_precio("-")
        True
        >>> es_precio("Arduino")
        False
    """
    if not texto:
        return False

    texto = texto.strip()

    # Patrón para precio: números con puntos/comas/guiones
    return bool(re.match(r'^[\d\.,\-]+$', texto))


def limpiar_precio(precio_raw: str) -> float | str:
    """
    Limpia y formatea un precio al formato numérico correcto.

    Maneja diferentes formatos:
        - Formato chileno: "32.400" -> 32400.0
        - Con decimales: "32,50" -> 32.5
        - Sin precio: "-" -> "-"

    Args:
        precio_raw: Precio en formato string

    Returns:
        Float con el precio numérico o string "-" si no hay precio
    """
    if not precio_raw or precio_raw.strip() == '-':
        return "-"

    precio = precio_raw.strip()

    # Formato chileno: punto como separador de miles
    if '.' in precio and ',' not in precio:
        precio = precio.replace(".", "")
    # Formato con coma decimal
    elif ',' in precio:
        precio = precio.replace(".", "").replace(",", ".")

    try:
        return float(precio)
    except ValueError:
        return precio_raw


def es_encabezado_categoria(line: str) -> bool:
    """
    Determina si una línea es un encabezado de categoría.

    Criterios:
        - Todo en mayúsculas
        - Sin números
        - Longitud apropiada
        - Pocas palabras

    Args:
        line: Línea de texto a evaluar

    Returns:
        True si es un encabezado de categoría
    """
    if not line:
        return False

    return (
        line.isupper() and
        len(line) > Config.MIN_LONGITUD_CATEGORIA and
        not re.search(r'\d', line) and
        len(line.split()) <= Config.MAX_PALABRAS_CATEGORIA
    )


def extraer_producto_de_linea(line: str) -> Optional[Tuple[str, str, float | str]]:
    """
    Extrae información del producto de una línea del PDF.

    Estrategia:
        1. Tokeniza la línea
        2. Identifica el código (primer token alfanumérico)
        3. Busca el precio (token numérico)
        4. Asigna el resto como nombre

    Args:
        line: Línea de texto del PDF

    Returns:
        Tupla (codigo, nombre, precio) o None si no es un producto válido

    Ejemplos:
        >>> extraer_producto_de_linea("AR1001 Arduino UNO R3 32.400")
        ('AR1001', 'Arduino UNO R3', 32400.0)

        >>> extraer_producto_de_linea("SEN01 Sensor CNY70 -")
        ('SEN01', 'Sensor CNY70', '-')
    """
    line = line.strip()

    # Validación básica
    if len(line) < 3:
        return None

    # Tokenizar
    tokens = line.split()
    if len(tokens) < 2:
        return None

    # Extraer código (primer token)
    codigo_candidato = tokens[0]

    # Validar formato del código
    if not re.match(r'^[A-Z0-9\-]+$', codigo_candidato, re.IGNORECASE):
        return None

    # Buscar el precio en los tokens
    precio_idx = None
    precio = "-"

    for i in range(1, len(tokens)):
        if es_precio(tokens[i]):
            precio_idx = i
            precio = tokens[i]
            break

    # Extraer nombre del producto
    if precio_idx is not None:
        # Nombre está entre código y precio
        nombre = ' '.join(tokens[1:precio_idx])

        # Verificar si hay información adicional después del precio
        if precio_idx < len(tokens) - 1:
            resto = ' '.join(tokens[precio_idx + 1:])
            if len(resto) > 3 and not es_precio(resto):
                nombre = f"{nombre} {resto}".strip() if nombre else resto
    else:
        # No hay precio, todo después del código es nombre
        nombre = ' '.join(tokens[1:])

    # Limpiar espacios
    nombre = nombre.strip()
    codigo = codigo_candidato.strip()

    # Validar datos mínimos
    if not codigo or not nombre or len(nombre) < Config.MIN_LONGITUD_NOMBRE:
        return None

    # Limpiar precio
    precio_limpio = limpiar_precio(precio)

    return (codigo, nombre, precio_limpio)


# ============================================================================
# FUNCIONES DE EXTRACCIÓN
# ============================================================================

def extraer_productos_de_pdf(pdf_path: str) -> List[Dict[str, str | float]]:
    """
    Extrae todos los productos del PDF.

    Args:
        pdf_path: Ruta al archivo PDF

    Returns:
        Lista de diccionarios con los productos extraídos
    """
    data = []
    current_category = Config.CATEGORIA_DEFAULT
    lineas_procesadas = 0
    lineas_extraidas = 0

    print(f"\n{Config.SEPARADOR}")
    print("EXTRAYENDO DATOS DEL PDF")
    print(Config.SEPARADOR)

    with pdfplumber.open(pdf_path) as pdf:
        total_paginas = Config.PAGINA_FIN - Config.PAGINA_INICIO

        for idx, page_num in enumerate(range(Config.PAGINA_INICIO, Config.PAGINA_FIN), 1):
            print(f"\nProcesando página {page_num + 1} ({idx}/{total_paginas})...")

            try:
                page = pdf.pages[page_num]
                text = page.extract_text()

                if not text:
                    print(f"  {Config.SIMBOLO_FLECHA} Página vacía o sin texto extraíble")
                    continue

                lines = text.split('\n')
                productos_en_pagina = 0

                for line in lines:
                    lineas_procesadas += 1
                    line = line.strip()

                    if not line:
                        continue

                    # Detectar categoría
                    if es_encabezado_categoria(line):
                        current_category = line.strip().title()
                        print(f"  {Config.SIMBOLO_FLECHA} Categoría: {current_category}")
                        continue

                    # Extraer producto
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

                print(f"  {Config.SIMBOLO_FLECHA} {productos_en_pagina} productos extraídos")

            except Exception as e:
                print(f"  {Config.SIMBOLO_FLECHA} Error en página {page_num + 1}: {str(e)}")
                continue

    print(f"\n{Config.SEPARADOR}")
    print("RESUMEN DE EXTRACCIÓN")
    print(Config.SEPARADOR})
    print(f"Líneas procesadas: {lineas_procesadas}")
    print(f"Productos extraídos: {lineas_extraidas}")

    return data


def procesar_dataframe(data: List[Dict]) -> pd.DataFrame:
    """
    Procesa y limpia el DataFrame de productos.

    Args:
        data: Lista de diccionarios con productos

    Returns:
        DataFrame limpio y sin duplicados
    """
    df = pd.DataFrame(data)

    if df.empty:
        print("\n⚠ ADVERTENCIA: No se extrajeron productos")
        return df

    registros_iniciales = len(df)
    print(f"\nRegistros iniciales: {registros_iniciales}")

    # Eliminar duplicados por código
    df = df.drop_duplicates(subset=['Código'], keep='first')

    registros_finales = len(df)
    duplicados_eliminados = registros_iniciales - registros_finales

    print(f"Duplicados eliminados: {duplicados_eliminados}")
    print(f"Registros finales: {registros_finales}")

    return df


def mostrar_muestra(df: pd.DataFrame, n: int = 15):
    """
    Muestra una muestra de los datos extraídos.

    Args:
        df: DataFrame con productos
        n: Número de registros a mostrar
    """
    if df.empty:
        return

    print(f"\n{Config.SEPARADOR}")
    print(f"MUESTRA DE DATOS (Primeros {min(n, len(df))} registros)")
    print(Config.SEPARADOR}\n")
    print(df.head(n).to_string(index=False))


def exportar_csv(df: pd.DataFrame) -> str:
    """
    Exporta el DataFrame a CSV y lo descarga.

    Args:
        df: DataFrame a exportar

    Returns:
        Nombre del archivo exportado
    """
    if df.empty:
        print("\n⚠ No hay datos para exportar")
        return ""

    df.to_csv(Config.ARCHIVO_SALIDA, index=False, encoding=Config.ENCODING_CSV)
    files.download(Config.ARCHIVO_SALIDA)

    return Config.ARCHIVO_SALIDA


def mostrar_instrucciones_finales(archivo: str, total_productos: int):
    """
    Muestra las instrucciones finales para el usuario.

    Args:
        archivo: Nombre del archivo CSV generado
        total_productos: Número total de productos exportados
    """
    print(f"\n{Config.SEPARADOR}")
    print("EXPORTACIÓN COMPLETADA")
    print(Config.SEPARADOR})
    print(f"{Config.SIMBOLO_EXITO} Archivo: {archivo}")
    print(f"{Config.SIMBOLO_EXITO} Total de productos: {total_productos}")

    print("\n📋 PRÓXIMOS PASOS:")
    print("   1. Descarga el archivo CSV (ya iniciado)")
    print("   2. Abre Google Sheets (https://sheets.google.com)")
    print("   3. Archivo > Importar > Subir")
    print("   4. Selecciona el archivo descargado")
    print("   5. Configuración de importación:")
    print("      • Tipo de separador: Detectar automáticamente")
    print("      • Convertir texto a números: Sí")
    print("   6. Click en 'Importar datos'")
    print(f"\n{Config.SEPARADOR}\n")


# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================

def main():
    """Función principal del extractor"""

    # Banner inicial
    print(Config.SEPARADOR)
    print("EXTRACTOR DE PRODUCTOS SGS - VERSIÓN 2.0")
    print(Config.SEPARADOR)
    print(f"\n{Config.SIMBOLO_INFO} Configuración:")
    print(f"   • Páginas a extraer: {Config.PAGINA_INICIO + 1} a {Config.PAGINA_FIN}")
    print(f"   • Archivo de salida: {Config.ARCHIVO_SALIDA}")

    # Subir archivo
    print(f"\n{Config.SIMBOLO_INFO} Sube el archivo PDF del catálogo SGS")
    uploaded = files.upload()

    if not uploaded:
        print("\n❌ No se subió ningún archivo")
        return

    pdf_filename = list(uploaded.keys())[0]
    print(f"\n{Config.SIMBOLO_EXITO} Archivo recibido: {pdf_filename}")

    try:
        # Extraer productos
        data = extraer_productos_de_pdf(pdf_filename)

        if not data:
            print("\n❌ No se pudo extraer ningún producto")
            print("   • Verifica que el PDF tenga texto extraíble")
            print("   • Ajusta las páginas en Config.PAGINA_INICIO y Config.PAGINA_FIN")
            return

        # Procesar datos
        df = procesar_dataframe(data)

        # Mostrar muestra
        mostrar_muestra(df)

        # Exportar
        archivo = exportar_csv(df)

        if archivo:
            mostrar_instrucciones_finales(archivo, len(df))

    except Exception as e:
        print(f"\n❌ ERROR: {str(e)}")
        print("   • Verifica que el archivo PDF no esté corrupto")
        print("   • Asegúrate de que pdfplumber esté instalado correctamente")
        raise


# ============================================================================
# EJECUCIÓN
# ============================================================================

if __name__ == "__main__":
    main()
