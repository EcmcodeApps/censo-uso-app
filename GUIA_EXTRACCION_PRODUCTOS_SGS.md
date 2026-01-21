# 🔧 Guía de Extracción de Productos SGS - Script Corregido

## 📋 Problema Identificado

El script original tenía problemas con el regex que causaban:
- ✗ Precios quedaban en la columna "Nombre del Producto"
- ✗ Partes del nombre quedaban en la columna "Precio"
- ✗ Códigos mal extraídos

### Ejemplo del problema:
```
Línea PDF: "AR1001 Arduino UNO R3 32.400"

❌ ANTES (Incorrecto):
Código: AR1001
Nombre: 32.400
Precio: AR1001A 1 9.60

✅ AHORA (Correcto):
Código: AR1001
Nombre: Arduino UNO R3
Precio: 32400.0
```

---

## 🚀 Mejoras Implementadas

### 1. **Detección Inteligente de Precios**
```python
def es_precio(texto):
    """Identifica si un campo es un precio"""
    return bool(re.match(r'^[\d\.,\-]+$', texto.strip()))
```

- Reconoce números con puntos (separador de miles chileno)
- Reconoce comas (separador decimal)
- Reconoce guión "-" (producto sin precio)

### 2. **Estrategia de Tokenización**
En lugar de un regex único, ahora:
1. Divide la línea en tokens (palabras)
2. Identifica el código (primer token alfanumérico)
3. Busca el precio (token que es número)
4. Asigna todo lo demás como nombre

### 3. **Limpieza de Precios**
```python
def limpiar_precio(precio_raw):
    """Convierte '32.400' -> 32400.0"""
    precio = precio_raw.replace(".", "")  # Quita separador de miles
    return float(precio)
```

### 4. **Mejor Detección de Categorías**
- Detecta encabezados en mayúsculas
- Sin números
- Longitud apropiada (>10 caracteres)

---

## 📝 Paso a Paso: Cómo Usar el Script

### **PASO 1: Preparar Google Colab**

1. Abre Google Colab: https://colab.research.google.com/
2. Crea un nuevo notebook
3. Copia el contenido completo de `extraer_productos_sgs_corregido.py`

---

### **PASO 2: Instalar Dependencias**

En la primera celda del notebook, ejecuta:

```python
!pip install pdfplumber pandas -q
```

✓ Espera a que termine la instalación (≈10 segundos)

---

### **PASO 3: Copiar el Script Completo**

En una nueva celda, pega todo el contenido del script (desde `import pdfplumber` hasta el final)

---

### **PASO 4: Ejecutar el Script**

1. Ejecuta la celda con el script
2. Aparecerá un botón **"Choose Files"** o **"Seleccionar archivos"**
3. Selecciona tu PDF del catálogo SGS (ej: `00 SGS2026 Enero.pdf`)
4. Haz clic en **"Upload"** o **"Subir"**

---

### **PASO 5: Monitorear la Extracción**

Verás en pantalla:
```
============================================================
EXTRACTOR DE PRODUCTOS SGS - VERSIÓN MEJORADA
============================================================

✓ Archivo recibido: 00 SGS2026 Enero.pdf

============================================================
EXTRAYENDO DATOS DEL PDF
============================================================

Procesando página 49 (1/6)...
  └─ Categoría detectada: Arduino
  └─ 12 productos extraídos de esta página

Procesando página 50 (2/6)...
  └─ Categoría detectada: Sensores Y Modulos
  └─ 18 productos extraídos de esta página

...
```

---

### **PASO 6: Verificar Resultados**

El script mostrará una tabla con los primeros 15 productos:

```
Código    Nombre del Producto           Precio    Categoria
UNO       Arduino UNO R3                32400.0   Arduino
AR1001    Arduino MEGA                  45000.0   Arduino
ESP32     Modulo ESP32                  12500.0   Arduino
...
```

🔍 **Verifica que**:
- ✓ Códigos estén correctos (ej: UNO, AR1001, ESP32)
- ✓ Nombres sean completos y legibles
- ✓ Precios sean números (o "-" si no hay precio)
- ✓ Categorías estén asignadas

---

### **PASO 7: Descargar el CSV**

Automáticamente se descargará un archivo:
```
productos_sgs_extraidos.csv
```

💾 Guárdalo en tu computadora

---

### **PASO 8: Importar a Google Sheets**

1. Abre Google Sheets: https://sheets.google.com/
2. Crea una nueva hoja o abre la existente
3. Ve a **Archivo > Importar**
4. Haz clic en la pestaña **"Subir"**
5. Arrastra el archivo `productos_sgs_extraidos.csv` o haz clic en "Seleccionar archivo"

**Configuración de importación**:
- **Ubicación de importación**: "Reemplazar hoja actual" o "Insertar nuevas hojas"
- **Tipo de separador**: "Detectar automáticamente" ✓
- **Convertir texto a números y fechas**: ✓ Activado

6. Haz clic en **"Importar datos"**

---

### **PASO 9: Verificar en Google Sheets**

Verifica que las columnas estén correctas:

| Código | Nombre del Producto | Precio  | Categoria |
|--------|---------------------|---------|-----------|
| UNO    | Arduino UNO R3      | 32400   | Arduino   |
| AR1001 | Arduino MEGA        | 45000   | Arduino   |

✅ **Todo correcto si**:
- Códigos en columna A
- Nombres completos en columna B
- Precios numéricos en columna C
- Categorías en columna D

---

## 🔍 Solución de Problemas Comunes

### Problema 1: "No se extraen productos"
**Causa**: Las páginas del PDF son diferentes
**Solución**: Modifica la línea:
```python
for page_num in range(48, 54):  # Cambia estos números
```
- Si quieres páginas 1-10: `range(0, 10)`
- Si quieres página 20: `range(19, 20)` (0-indexed)

### Problema 2: "Categorías incorrectas"
**Causa**: Formato de encabezados diferente
**Solución**: Ajusta la detección en:
```python
if (line.isupper() and len(line) > 10 and ...):
```
- Reduce `len(line) > 10` a `len(line) > 5` para encabezados más cortos

### Problema 3: "Precios como texto en Sheets"
**Causa**: Formato de columna
**Solución**:
1. Selecciona la columna C (Precio)
2. Ve a Formato > Número > Número
3. Aplica el formato

### Problema 4: "Algunos nombres incluyen precio"
**Causa**: Formato de línea especial en PDF
**Solución**: Revisa la línea específica en el PDF
- Puede tener tabuladores o espacios especiales
- Ajusta la función `extraer_producto_de_linea()` según el caso

---

## 🧪 Cómo Probar Cambios

Para probar la extracción de una sola línea:

```python
# Agregar al final del script
print("\n=== PRUEBA DE LÍNEA INDIVIDUAL ===")
linea_prueba = "AR1001 Arduino UNO R3 32.400"
resultado = extraer_producto_de_linea(linea_prueba)
print(f"Entrada: {linea_prueba}")
print(f"Código: {resultado[0]}")
print(f"Nombre: {resultado[1]}")
print(f"Precio: {resultado[2]}")
```

---

## 📊 Comparación: Antes vs Ahora

| Aspecto | ❌ Script Anterior | ✅ Script Mejorado |
|---------|-------------------|-------------------|
| Regex | Simple, falla con variaciones | Tokenización inteligente |
| Precios | Mal ubicados | Detección automática |
| Nombres | Cortados | Completos |
| Categorías | Básica | Mejorada |
| Debug | No | Mensajes detallados |
| Limpieza | Básica | Formatos chilenos |

---

## 💡 Próximas Mejoras Posibles

1. **Extracción de imágenes**: Guardar fotos de productos
2. **OCR**: Para PDFs escaneados
3. **Validación**: Detectar productos duplicados o errores
4. **Export directo**: Subir directamente a Google Sheets vía API

---

## 📞 Soporte

Si encuentras errores:
1. Copia el mensaje de error completo
2. Indica la página del PDF con problema
3. Comparte la línea específica que falla

---

## ✅ Checklist Final

Antes de importar a Sheets, verifica:

- [ ] CSV descargado correctamente
- [ ] Número de productos es razonable (>50, <500)
- [ ] No hay códigos duplicados
- [ ] Precios son números o "-"
- [ ] Nombres están completos
- [ ] Categorías tienen sentido

**¡Listo! Ahora tienes tus productos extraídos correctamente.**
