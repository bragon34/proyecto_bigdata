# FraudeCero · Proyecto Integrador Big Data · Grupo 6

**Caso:** detectar transacciones con tarjeta de crédito potencialmente fraudulentas sin bloquear a clientes legítimos (sector servicios financieros).
**Integrantes:** Juan David Montoya · William Conde Villamizar — Ingeniería de Sistemas, Uniciencia, 2026-II.
**Docente:** Ing. Jacksson Sonny Gonzalez Bayona.

## Fuentes de datos (sección 11 del protocolo)
| Fuente | URL | Formato | Actualización |
|---|---|---|---|
| F1 · Credit Card Fraud Detection (ULB/Worldline) | https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud | CSV · 150,8 MB · 284.807 filas | Estática |
| F2 · Tarjetas de crédito y débito (Superintendencia Financiera) | https://www.datos.gov.co/resource/h2jg-r3zg.csv | API REST SODA (CSV) | Mensual |

La fecha y hora exacta de cada descarga, el tamaño y el MD5 quedan en `99_evidencias/tablas/registro_fuentes.json` al ejecutar `00_ingesta`.

## Estructura del repositorio
```
00_ingesta/00_ingesta.ipynb          → capa BRONCE + validaciones + perfilado + 5 V
01_limpieza/01_limpieza.ipynb        → capa PLATA: 6 transformaciones con bitácora y unión de fuentes
02_analisis/02_analisis.ipynb        → 3 preguntas de negocio, 6 consultas Spark SQL (ventanas + join), capa ORO
02_analisis/02b_optimizacion.ipynb   → particionamiento, OPTIMIZE Z-ORDER, caché y broadcast (tiempos antes/después)
03_seguridad/03_seguridad.ipynb      → clasificación Ley 1581, SHA-256 + enmascaramiento, vistas por rol, muestra anonimizada
04_visualizacion/04a_modelo.ipynb    → Random Forest vs. regresión logística vs. línea base, análisis de umbral
04_visualizacion/04b_tablero.ipynb   → tablero HTML con 8 visualizaciones + exportación a 2 destinos + contrato de datos
04_visualizacion/05_monitoreo.ipynb  → tablero operativo (4 métricas) + regla de alerta
99_evidencias/                       → diagrama, desafíos, tablas de evidencia, tableros HTML, log de monitoreo, muestra anonimizada
.github/workflows/                   → job programado (GitHub Actions)
```

## Cómo reproducir el proyecto desde cero

### Opción A · Google Colab (recomendada)
1. Abrir Colab → **Archivo → Abrir notebook → GitHub** y pegar la URL de este repositorio (o subir los `.ipynb`).
2. Ejecutar los notebooks **en este orden**, cada uno con *Entorno de ejecución → Ejecutar todas*:
   `00_ingesta` → `01_limpieza` → `02_analisis` → `02b_optimizacion` → `03_seguridad` → `04a_modelo` → `04b_tablero` → `05_monitoreo`.
3. La primera celda instala PySpark 3.5.3 + Delta Lake 3.2.1 y pide autorizar Google Drive. El Lakehouse se respalda en `MyDrive/FraudeCero/lakehouse` y las evidencias en `MyDrive/FraudeCero/99_evidencias`.
4. Al terminar, abrir `99_evidencias/tablero_fraudecero.html` y `99_evidencias/monitoreo/tablero_operativo.html` en el navegador.

### Opción B · Jupyter local
```bash
git clone <URL-del-repositorio> && cd PI_BigData_G6
python -m venv .venv && source .venv/bin/activate     # Windows: .venv\Scripts\activate
pip install -r requirements.txt                         # requiere Java 11 o 17
jupyter notebook                                        # ejecutar los notebooks en el orden de la opción A
```

### Opción C · Job programado (GitHub Actions)
- Se ejecuta solo todos los días a las 06:17 (Colombia) y a mano desde **Actions → pipeline-fraudecero → Run workflow**.
- Secretos opcionales del repositorio: `FRAUDECERO_SAL` (sal del hash), `KAGGLE_USERNAME` y `KAGGLE_KEY` (si Kaggle pide autenticación).
- Cada ejecución agrega filas a `99_evidencias/monitoreo/log_ejecuciones.csv` y deja los tableros como artefacto descargable.
- **Para la evidencia A3.4 se necesitan al menos 2 ejecuciones registradas:** lanzar el workflow manualmente dos veces.

## Resultados principales (ejecución del 11-nov-2026 en Colab)
| Modelo | AUC-PR | AUC-ROC | Precisión | Recall | F1 |
|---|---|---|---|---|---|
| Regresión logística | 0,6751 | 0,9728 | 0,0573 | 0,8763 | 0,1076 |
| **Random Forest** | **0,6913** | **0,9766** | **0,7475** | **0,7629** | **0,7551** |

Umbral con mejor F1: **0,6** (F1 = 0,766; 72 de 97 fraudes detectados con 19 falsas alarmas). Variables más importantes: V14, V11, V12, V10, V4 y V17.

> Si al volver a ejecutar las cifras cambian levemente (por el orden de los ids o la versión de Spark), actualizar esta tabla, el documento y las diapositivas con los valores de `99_evidencias/tablas/metricas_modelos.csv`.

## Seguridad y privacidad
- La sal del hash SHA-256 **nunca se sube** al repositorio (`.gitignore` excluye `_secretos/`).
- El repositorio solo incluye una **muestra anonimizada** (`99_evidencias/muestra_anonimizada.csv`, < 10 MB); los datos completos se descargan de las fuentes oficiales.

## Declaración de uso de IA
Se usó **Claude (Anthropic)** como asistente para estructurar los notebooks, depurar errores y redactar borradores. Ver el anexo del documento APA para el detalle de tareas, prompts y revisiones hechas por el grupo.
