import pymysql

try:
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='',
        database='smartcity_transport',
        charset='utf8mb4'
    )
    print("✅ Conexión exitosa a la base de datos")
    with conn.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) as total FROM usuario")
        result = cursor.fetchone()
        print(f"📊 Total de usuarios: {result['total']}")
except Exception as e:
    print(f"❌ Error: {e}")
finally:
    if 'conn' in locals():
        conn.close()