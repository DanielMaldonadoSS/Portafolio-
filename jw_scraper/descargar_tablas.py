import pandas as pd

# URLs de cada año de servicio
urls = {
    2017: "https://www.jw.org/es/biblioteca/libros/informe-mundial-2017/paises-territorios-2017/",
    2018: "https://www.jw.org/es/biblioteca/libros/informe-mundial-2018/paises-territorios-2018/",
    2019: "https://www.jw.org/es/biblioteca/libros/informe-mundial-2019/paises-territorios-2019/",
    2020: "https://www.jw.org/es/biblioteca/libros/informe-mundial-2020/paises-territorios-2020/",
    2021: "https://www.jw.org/es/biblioteca/libros/informe-mundial-2021/paises-territorios-2021/",
    2022: "https://www.jw.org/es/biblioteca/libros/Informe-mundial-de-los-testigos-de-Jehov%C3%A1-del-a%C3%B1o-de-servicio-2022/Informe-del-2022-por-pa%C3%ADses-y-territorios/",
    2023: "https://www.jw.org/es/biblioteca/libros/Informe-mundial-de-los-testigos-de-Jehov%C3%A1-del-a%C3%B1o-de-servicio-2023/Informe-del-2023-por-pa%C3%ADses-y-territorios/",
    2024: "https://www.jw.org/es/biblioteca/libros/Informe-mundial-de-los-testigos-de-Jehov%C3%A1-del-a%C3%B1o-de-servicio-2024/Informe-del-2024-por-pa%C3%ADses-y-territorios//"
}

for year, url in urls.items():
    print(f"Procesando año {year}...")
    try:
        tablas = pd.read_html(url)  # leer todas las tablas
        df = tablas[0]              # normalmente la primera tabla es la principal

        # 🔹 limpiar encabezados dobles
        if isinstance(df.columns, pd.MultiIndex):
            df.columns = df.columns.get_level_values(0)

        # 🔹 eliminar filas vacías y totales
        df = df.dropna(how="all")
        df = df[~df.iloc[:,0].str.contains("Total", na=False)]

        # 🔹 limpiar espacios en nombres de columnas
        df.columns = [col.strip() for col in df.columns]

        # 🔹 agregar columna Año
        df["Año"] = year

        # 🔹 guardar CSV limpio
        df.to_csv(f"jw_{year}_limpio.csv", index=False, encoding="utf-8-sig")
        print(f"✅ CSV generado: jw_{year}_limpio.csv")
    except Exception as e:
        print(f"⚠️ Error procesando {year}: {e}")

print("✅ Todos los años procesados.")
