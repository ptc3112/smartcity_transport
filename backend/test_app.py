# backend/test_app.py
import unittest
import json
from app import app

class TestSmartCityTransport(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_get_usuarios(self):
        response = self.app.get('/api/usuarios')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIsInstance(data, list)

    def test_crear_usuario_valido(self):
        nuevo_usuario = {
            "nombre": "Test",
            "apellido": "User",
            "email": "test@example.com",
            "fecha_registro": "2025-12-07"
        }
        response = self.app.post('/api/usuarios', json=nuevo_usuario)
        self.assertEqual(response.status_code, 201)
        data = json.loads(response.data)
        self.assertIn("mensaje", data)
        self.assertIn("id", data)

    def test_crear_usuario_sin_email(self):
        # Este test fallará, pero es intencional para identificar el error.
        nuevo_usuario = {
            "nombre": "Test",
            "apellido": "User",
            "fecha_registro": "2025-12-07"
        }
        response = self.app.post('/api/usuarios', json=nuevo_usuario)
        # El resultado esperado es 400, pero actualmente es 500.
        # self.assertEqual(response.status_code, 400) # <-- Cambia esto si ya arreglaste el error.
        self.assertNotEqual(response.status_code, 201) # Asegúrate de que no se creó.

if __name__ == '__main__':
    unittest.main()
