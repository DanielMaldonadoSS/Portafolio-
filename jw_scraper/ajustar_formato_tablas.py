import pandas as pd

# Lista de archivos
archivos = [f"jw_{anio}_limpio.csv" for anio in range(2017, 2025)]

for archivo in archivos:
    # Leer todo como texto para no perder ceros
    df = pd.read_csv(archivo, dtype=str)

    # Limpiar columnas numéricas (asumo que la primera columna es país y la última es año)
    for col in df.columns[1:-1]:
        df[col] = df[col].str.replace(".", "", regex=False).astype("Int64")

    # Guardar archivo limpio
    salida = archivo.replace("_limpio.csv", "_clean.csv")
    df.to_csv(salida, index=False, encoding="utf-8-sig")

    print(f"✅ {archivo} procesado → {salida}")
