# 📦 Extractor de Productos SGS

Script profesional para extraer productos de catálogos PDF SGS y convertirlos a formato CSV para Google Sheets.

## 🚀 Inicio Rápido

### 1️⃣ Instalar Dependencias

```python
!pip install pdfplumber pandas -q
```

### 2️⃣ Ejecutar el Script

Copia y pega el contenido completo de `extraer_productos_sgs_corregido.py` en Google Colab y ejecuta.

### 3️⃣ Subir PDF

Cuando se solicite, sube tu archivo PDF del catálogo SGS.

### 4️⃣ Descargar CSV

El archivo `productos_sgs_extraidos.csv` se descargará automáticamente.

### 5️⃣ Importar en Google Sheets

**Archivo > Importar > Subir** → Selecciona el CSV descargado.

---

## ⚙️ Configuración

### Cambiar Páginas a Extraer

Edita la clase `Config` en el script:

```python
class Config:
    PAGINA_INICIO = 48  # Página 49 del PDF (0-indexed)
    PAGINA_FIN = 54     # Página 54 del PDF (0-indexed)
```

**Ejemplos**:
- Páginas 1-10: `PAGINA_INICIO = 0`, `PAGINA_FIN = 10`
- Páginas 20-30: `PAGINA_INICIO = 19`, `PAGINA_FIN = 30`
- Todo el PDF: Comenta las líneas de paginación y usa `for page in pdf.pages:`

### Ajustar Detección de Categorías

```python
class Config:
    MIN_LONGITUD_CATEGORIA = 10  # Reducir si las categorías son cortas
    MAX_PALABRAS_CATEGORIA = 5   # Aumentar para categorías más largas
```

### Cambiar Nombre del Archivo de Salida

```python
class Config:
    ARCHIVO_SALIDA = "mi_catalogo.csv"
```

---

## 📊 Estructura de Datos

### Entrada (PDF)
```
CATEGORIA EN MAYUSCULAS

CODIGO1 Nombre del producto 1 12.500
CODIGO2 Nombre del producto 2 35.000
CODIGO3 Nombre del producto 3 -
```

### Salida (CSV)
```csv
Código,Nombre del Producto,Precio,Categoria
CODIGO1,Nombre del producto 1,12500.0,Categoria En Mayusculas
CODIGO2,Nombre del producto 2,35000.0,Categoria En Mayusculas
CODIGO3,Nombre del producto 3,-,Categoria En Mayusculas
```

---

## 🔍 Características

### ✅ Detección Inteligente
- **Códigos**: Extrae códigos alfanuméricos (AR1001, ESP32, SEN01)
- **Nombres**: Captura nombres completos con espacios
- **Precios**: Detecta automáticamente números (32.400, 12,50, -)
- **Categorías**: Identifica encabezados en mayúsculas

### ✅ Limpieza Automática
- Formato chileno: `32.400` → `32400.0`
- Decimales: `12,50` → `12.5`
- Sin precio: `-` → `"-"`
- Duplicados: Elimina productos repetidos

### ✅ Validación
- Verifica códigos válidos
- Valida longitud de nombres
- Detecta líneas vacías o incorrectas
- Manejo robusto de errores

### ✅ Feedback Detallado
```
============================================================
EXTRAYENDO DATOS DEL PDF
============================================================

Procesando página 49 (1/6)...
  └─ Categoría: Arduino
  └─ 12 productos extraídos

Procesando página 50 (2/6)...
  └─ Categoría: Sensores Y Modulos
  └─ 18 productos extraídos
```

---

## 🛠️ Estructura del Código

### Módulos Principales

```python
# 1. Configuración
class Config:
    """Configuración centralizada"""

# 2. Utilidades
def es_precio(texto: str) -> bool
def limpiar_precio(precio_raw: str) -> float | str
def es_encabezado_categoria(line: str) -> bool
def extraer_producto_de_linea(line: str) -> Optional[Tuple]

# 3. Extracción
def extraer_productos_de_pdf(pdf_path: str) -> List[Dict]
def procesar_dataframe(data: List[Dict]) -> pd.DataFrame

# 4. Exportación
def exportar_csv(df: pd.DataFrame) -> str
def mostrar_instrucciones_finales(archivo: str, total: int)

# 5. Main
def main()
```

### Flujo de Ejecución

```
1. Subir PDF
    ↓
2. Extraer texto por página
    ↓
3. Detectar categorías
    ↓
4. Extraer productos (código, nombre, precio)
    ↓
5. Crear DataFrame
    ↓
6. Limpiar duplicados
    ↓
7. Exportar CSV
    ↓
8. Descargar archivo
```

---

## 🐛 Solución de Problemas

### ❌ No se extraen productos

**Causa**: Páginas incorrectas o formato diferente

**Solución**:
1. Verifica las páginas: Abre el PDF y cuenta manualmente
2. Ajusta `PAGINA_INICIO` y `PAGINA_FIN`
3. Usa `page.extract_text()` para ver el texto extraído:

```python
# Agregar después de extraer el texto
print("=== TEXTO DE LA PÁGINA ===")
print(text)
print("=" * 50)
```

### ❌ Categorías incorrectas

**Causa**: Formato de encabezados diferente

**Solución**:
Ajusta los criterios de detección:

```python
def es_encabezado_categoria(line: str) -> bool:
    return (
        line.isupper() and
        len(line) > 5 and  # Reducir de 10 a 5
        not re.search(r'\d', line)
    )
```

### ❌ Precios mal ubicados

**Causa**: Formato de línea inusual

**Solución**:
Prueba la extracción de una línea específica:

```python
# Agregar al final del script
linea_prueba = "AR1001 Arduino UNO R3 32.400"
resultado = extraer_producto_de_linea(linea_prueba)
print(f"Código: {resultado[0]}")
print(f"Nombre: {resultado[1]}")
print(f"Precio: {resultado[2]}")
```

### ❌ Precios como texto en Sheets

**Causa**: Formato de columna

**Solución**:
En Google Sheets:
1. Selecciona la columna C (Precio)
2. **Formato > Número > Número**

### ❌ Error de instalación

**Causa**: Paquetes no instalados

**Solución**:
```python
!pip install --upgrade pdfplumber pandas
!pip list | grep -E "pdfplumber|pandas"
```

---

## 📝 Ejemplos de Uso

### Ejemplo 1: Extraer Páginas Específicas

```python
class Config:
    PAGINA_INICIO = 10  # Página 11
    PAGINA_FIN = 15     # Página 15
```

### Ejemplo 2: Extraer Todo el PDF

Modifica la función `main()`:

```python
with pdfplumber.open(pdf_filename) as pdf:
    for idx, page in enumerate(pdf.pages, 1):
        print(f"Procesando página {idx}...")
        # ... resto del código
```

### Ejemplo 3: Cambiar Categoría por Defecto

```python
class Config:
    CATEGORIA_DEFAULT = "Productos Generales"
```

### Ejemplo 4: Exportar a Excel

```python
# Cambiar en exportar_csv()
df.to_excel("productos_sgs.xlsx", index=False, engine='openpyxl')
```

---

## 📦 Dependencias

```python
pdfplumber>=0.9.0    # Extracción de texto de PDF
pandas>=2.0.0        # Manipulación de datos
```

---

## 🎯 Casos de Uso

### ✅ Ideal Para:
- Catálogos de productos en PDF
- Listas de precios
- Inventarios digitalizados
- Documentos con estructura tabular

### ⚠️ No Recomendado Para:
- PDFs escaneados (sin OCR)
- PDFs con tablas complejas
- Documentos sin estructura clara

---

## 🔄 Actualizaciones

### Versión 2.0 (2026-01-21)
- ✅ Refactorización completa
- ✅ Configuración centralizada
- ✅ Type hints en todas las funciones
- ✅ Mejor manejo de errores
- ✅ Documentación completa
- ✅ Estructura modular

### Versión 1.0 (2026-01-20)
- Versión inicial con extracción básica

---

## 📞 Soporte

### Reportar Problemas

Si encuentras un error:
1. Copia el mensaje de error completo
2. Indica la página del PDF con problema
3. Comparte la línea específica que falla
4. Incluye la configuración usada

### Mejoras Futuras

- [ ] Soporte para PDFs escaneados (OCR)
- [ ] Extracción de imágenes de productos
- [ ] Exportación directa a Google Sheets vía API
- [ ] Interfaz web
- [ ] Detección automática de columnas

---

## 📄 Licencia

Código libre para uso personal y comercial.

---

## 👨‍💻 Autor

**Claude Code** - Sistema de IA de Anthropic

---

## ⭐ Agradecimientos

Gracias por usar el Extractor de Productos SGS.

Si te fue útil, considera compartirlo con otros usuarios.

---

**¿Listo para extraer tus productos? ¡Ejecuta el script y comienza!** 🚀
