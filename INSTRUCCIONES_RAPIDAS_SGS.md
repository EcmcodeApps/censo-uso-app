# ⚡ Instrucciones Rápidas - Extractor SGS

## 🎯 Uso Rápido (5 minutos)

### 1. Abre Google Colab
👉 https://colab.research.google.com/

### 2. Instala dependencias
```python
!pip install pdfplumber pandas -q
```

### 3. Copia el contenido de
📄 `extraer_productos_sgs_corregido.py` → Pégalo en una nueva celda

### 4. Ejecuta y sube tu PDF
- Click en ▶️ Run
- Sube el archivo PDF del catálogo SGS

### 5. Descarga el CSV
Automáticamente se descarga: `productos_sgs_extraidos.csv`

### 6. Importa en Google Sheets
**Archivo > Importar > Subir archivo CSV**

---

## ✅ Mejoras del Script Corregido

| Problema Anterior | ✓ Solucionado |
|-------------------|---------------|
| Precios en columna nombre | Detección inteligente de precios |
| Nombres cortados | Extracción completa de nombres |
| Datos desordenados | Tokenización correcta |
| Sin feedback | Mensajes de progreso detallados |

---

## 🔧 Ajustes Rápidos

### Cambiar páginas a extraer
```python
# Línea 82 del script
for idx, page_num in enumerate(range(48, 54), 1):  # Modifica aquí
```

**Ejemplos**:
- Páginas 1-10: `range(0, 10)`
- Páginas 20-30: `range(19, 30)`
- Solo página 5: `range(4, 5)`

---

## 📋 Formato Esperado en PDF

```
CATEGORIA EN MAYUSCULAS

CODIGO1 Nombre del producto 1 12.500
CODIGO2 Nombre del producto 2 35.000
CODIGO3 Nombre del producto 3 -
```

---

## 🆘 Problemas Comunes

**Q: No extrae nada**
- Verifica que las páginas sean correctas (`range(48, 54)`)

**Q: Categorías incorrectas**
- Ajusta la longitud mínima del encabezado (línea 140)

**Q: Precios como texto en Sheets**
- Selecciona columna → Formato > Número > Número

---

**📖 Guía completa:** Ver `GUIA_EXTRACCION_PRODUCTOS_SGS.md`
