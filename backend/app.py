from flask import Flask, jsonify, request
from flask_cors import CORS
import pymysql
from config import Config

app = Flask(__name__)
CORS(app)

def get_db_connection():
    try:
        connection = pymysql.connect(
            host=Config.DB_HOST,
            user=Config.DB_USER,
            password=Config.DB_PASSWORD,
            database=Config.DB_NAME,
            cursorclass=pymysql.cursors.DictCursor,
            charset='utf8mb4'
        )
        return connection
    except pymysql.Error as e:
        print(f"❌ Error al conectar a la base de datos: {e}")
        return None

# -------------------- RUTA RAÍZ --------------------
@app.route('/')
def index():
    return jsonify({
        "mensaje": "Bienvenido a SmartCity Transport API",
        "version": "1.0",
        "estado": "OK" if get_db_connection() is not None else "ERROR DE CONEXIÓN A BD"
    })

# -------------------- USUARIOS --------------------

@app.route('/api/usuarios', methods=['GET'])
def get_usuarios():
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM usuario ORDER BY id_usuario")
            usuarios = cursor.fetchall()
        return jsonify(usuarios)
    except pymysql.Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        connection.close()

@app.route('/api/usuarios', methods=['POST'])
def crear_usuario():
    data = request.json
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO usuario (nombre, apellido, email, telefono, fecha_registro, saldo_tarjeta, estado_cuenta)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                data['nombre'], data['apellido'], data['email'], data.get('telefono'),
                data['fecha_registro'], data.get('saldo_tarjeta', 0.0), data.get('estado_cuenta', 'activo')
            ))
            connection.commit()
        return jsonify({"mensaje": "Usuario creado", "id": cursor.lastrowid}), 201
    except pymysql.Error as e:
        return jsonify({"error": str(e)}), 400
    finally:
        connection.close()

@app.route('/api/usuarios/<int:id>', methods=['PUT'])
def actualizar_usuario(id):
    data = request.json
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                UPDATE usuario SET
                    nombre = %s, apellido = %s, email = %s, telefono = %s,
                    fecha_registro = %s, saldo_tarjeta = %s, estado_cuenta = %s
                WHERE id_usuario = %s
            """, (
                data['nombre'], data['apellido'], data['email'], data.get('telefono'),
                data['fecha_registro'], data.get('saldo_tarjeta', 0.0), data.get('estado_cuenta', 'activo'),
                id
            ))
            connection.commit()
        return jsonify({"mensaje": "Usuario actualizado"})
    except pymysql.Error as e:
        return jsonify({"error": str(e)}), 400
    finally:
        connection.close()

@app.route('/api/usuarios/<int:id>', methods=['DELETE'])
def eliminar_usuario(id):
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

    try:
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM usuario WHERE id_usuario = %s", (id,))
            connection.commit()
        return jsonify({"mensaje": "Usuario eliminado"})
    except pymysql.Error as e:
        return jsonify({"error": str(e)}), 400
    finally:
        connection.close()

# -------------------- RUTAS --------------------

@app.route('/api/rutas', methods=['GET'])
def get_rutas():
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM ruta ORDER BY id_ruta")
            rutas = cursor.fetchall()
        return jsonify(rutas)
    except pymysql.Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        connection.close()

@app.route('/api/rutas', methods=['POST'])
def crear_ruta():
    data = request.json
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO ruta (nombre_ruta, origen, destino, distancia_km, tiempo_estimado, tarifa, estado_ruta)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                data['nombre_ruta'], data['origen'], data['destino'],
                data['distancia_km'], data['tiempo_estimado'], data['tarifa'],
                data.get('estado_ruta', 'activa')
            ))
            connection.commit()
        return jsonify({"mensaje": "Ruta creada", "id": cursor.lastrowid}), 201
    except pymysql.Error as e:
        return jsonify({"error": str(e)}), 400
    finally:
        connection.close()

@app.route('/api/rutas/<int:id>', methods=['PUT'])
def actualizar_ruta(id):
    data = request.json
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                UPDATE ruta SET
                    nombre_ruta = %s, origen = %s, destino = %s,
                    distancia_km = %s, tiempo_estimado = %s, tarifa = %s, estado_ruta = %s
                WHERE id_ruta = %s
            """, (
                data['nombre_ruta'], data['origen'], data['destino'],
                data['distancia_km'], data['tiempo_estimado'], data['tarifa'],
                data.get('estado_ruta', 'activa'), id
            ))
            connection.commit()
        return jsonify({"mensaje": "Ruta actualizada"})
    except pymysql.Error as e:
        return jsonify({"error": str(e)}), 400
    finally:
        connection.close()

@app.route('/api/rutas/<int:id>', methods=['DELETE'])
def eliminar_ruta(id):
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

    try:
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM ruta WHERE id_ruta = %s", (id,))
            connection.commit()
        return jsonify({"mensaje": "Ruta eliminada"})
    except pymysql.Error as e:
        return jsonify({"error": str(e)}), 400
    finally:
        connection.close()

# -------------------- ARRANQUE --------------------

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5000)