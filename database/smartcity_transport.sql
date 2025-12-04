-- Archivo: smartcity_transport.sql
-- Base de datos para sistema de transporte urbano inteligente

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS smartcity_transport;
USE smartcity_transport;

-- Tabla USUARIO
CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  telefono VARCHAR(15),
  fecha_registro DATE NOT NULL,
  saldo_tarjeta DECIMAL(10,2) DEFAULT 0.00,
  estado_cuenta ENUM('activo', 'inactivo', 'suspendido') DEFAULT 'activo'
);

-- Tabla RUTA
CREATE TABLE ruta (
  id_ruta INT AUTO_INCREMENT PRIMARY KEY,
  nombre_ruta VARCHAR(100) NOT NULL,
  origen VARCHAR(100) NOT NULL,
  destino VARCHAR(100) NOT NULL,
  distancia_km DECIMAL(5,2) NOT NULL,
  tiempo_estimado INT NOT NULL,
  tarifa DECIMAL(6,2) NOT NULL,
  estado_ruta ENUM('activa', 'inactiva', 'mantenimiento') DEFAULT 'activa'
);

-- Tabla PARADERO
CREATE TABLE paradero (
  id_paradero INT AUTO_INCREMENT PRIMARY KEY,
  nombre_paradero VARCHAR(100) NOT NULL,
  direccion VARCHAR(200) NOT NULL,
  coordenada_lat DECIMAL(10,8),
  coordenada_lng DECIMAL(11,8),
  zona VARCHAR(50) NOT NULL
);

-- Tabla BUS
CREATE TABLE bus (
  id_bus INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10) UNIQUE NOT NULL,
  modelo VARCHAR(50) NOT NULL,
  capacidad INT NOT NULL,
  año_fabricacion YEAR NOT NULL,
  estado_bus ENUM('operativo', 'mantenimiento', 'fuera_servicio') DEFAULT 'operativo',
  id_ruta INT,
  FOREIGN KEY (id_ruta) REFERENCES ruta(id_ruta) ON DELETE SET NULL
);

-- Tabla HORARIO
CREATE TABLE horario (
  id_horario INT AUTO_INCREMENT PRIMARY KEY,
  id_ruta INT NOT NULL,
  id_paradero INT NOT NULL,
  hora_llegada TIME NOT NULL,
  dias_operacion SET('lunes','martes','miercoles','jueves','viernes','sabado','domingo') NOT NULL,
  FOREIGN KEY (id_ruta) REFERENCES ruta(id_ruta) ON DELETE CASCADE,
  FOREIGN KEY (id_paradero) REFERENCES paradero(id_paradero) ON DELETE CASCADE
);

-- Tabla RECARGA
CREATE TABLE recarga (
  id_recarga INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  monto DECIMAL(10,2) NOT NULL,
  fecha_recarga DATETIME DEFAULT CURRENT_TIMESTAMP,
  metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'pse') NOT NULL,
  estado_transaccion ENUM('exitosa', 'fallida', 'pendiente') DEFAULT 'exitosa',
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

-- Tabla VIAJE
CREATE TABLE viaje (
  id_viaje INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  id_ruta INT NOT NULL,
  id_bus INT NOT NULL,
  fecha_viaje DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME,
  tarifa_cobrada DECIMAL(6,2) NOT NULL,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
  FOREIGN KEY (id_ruta) REFERENCES ruta(id_ruta) ON DELETE CASCADE,
  FOREIGN KEY (id_bus) REFERENCES bus(id_bus) ON DELETE CASCADE
);

-- Tabla NOTIFICACION
CREATE TABLE notificacion (
  id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  tipo_notificacion ENUM('info', 'alerta', 'promocion', 'mantenimiento') NOT NULL,
  mensaje TEXT NOT NULL,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  leida BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

-- Inserciones: USUARIO (25 registros)
INSERT INTO usuario (nombre, apellido, email, telefono, fecha_registro, saldo_tarjeta, estado_cuenta) VALUES
('Juan', 'Pérez', 'juan.perez@email.com', '3101234567', '2024-01-15', 25000.00, 'activo'),
('María', 'González', 'maria.gonzalez@email.com', '3109876543', '2024-01-20', 15000.00, 'activo'),
('Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '3201234567', '2024-02-01', 30000.00, 'activo'),
('Ana', 'López', 'ana.lopez@email.com', '3209876543', '2024-02-05', 8000.00, 'activo'),
('Luis', 'Martínez', 'luis.martinez@email.com', '3151234567', '2024-02-10', 45000.00, 'activo'),
('Sofía', 'Ramírez', 'sofia.ramirez@email.com', '3112233445', '2024-02-12', 12000.00, 'activo'),
('Diego', 'Hernández', 'diego.hernandez@email.com', '3123344556', '2024-02-14', 33000.00, 'activo'),
('Valentina', 'Gómez', 'valentina.gomez@email.com', '3134455667', '2024-02-16', 7500.00, 'activo'),
('Javier', 'Díaz', 'javier.diaz@email.com', '3145566778', '2024-02-18', 28000.00, 'activo'),
('Camila', 'Moreno', 'camila.moreno@email.com', '3156677889', '2024-02-20', 19000.00, 'activo'),
('Andrés', 'Castro', 'andres.castro@email.com', '3167788990', '2024-02-22', 40000.00, 'activo'),
('Lucía', 'Álvarez', 'lucia.alvarez@email.com', '3178899001', '2024-02-24', 5000.00, 'activo'),
('Felipe', 'Ortiz', 'felipe.ortiz@email.com', '3189900112', '2024-02-26', 22000.00, 'activo'),
('Isabella', 'Gutiérrez', 'isabella.gutierrez@email.com', '3190011223', '2024-02-28', 35000.00, 'activo'),
('Mateo', 'Vargas', 'mateo.vargas@email.com', '3201122334', '2024-03-01', 11000.00, 'activo'),
('Valeria', 'Mendoza', 'valeria.mendoza@email.com', '3212233445', '2024-03-03', 27000.00, 'activo'),
('Sebastián', 'Cruz', 'sebastian.cruz@email.com', '3223344556', '2024-03-05', 31000.00, 'activo'),
('Martina', 'Rojas', 'martina.rojas@email.com', '3234455667', '2024-03-07', 9500.00, 'activo'),
('Emilio', 'Sánchez', 'emilio.sanchez@email.com', '3245566778', '2024-03-09', 18000.00, 'activo'),
('Renata', 'Torres', 'renata.torres@email.com', '3256677889', '2024-03-11', 24000.00, 'activo'),
('Daniel', 'Ruiz', 'daniel.ruiz@email.com', '3267788990', '2024-03-13', 36000.00, 'activo'),
('Paula', 'Méndez', 'paula.mendez@email.com', '3278899001', '2024-03-15', 13000.00, 'activo'),
('Tomás', 'Vega', 'tomas.vega@email.com', '3289900112', '2024-03-17', 21000.00, 'activo'),
('Luciana', 'Silva', 'luciana.silva@email.com', '3290011223', '2024-03-19', 29000.00, 'activo'),
('Nicolás', 'Ríos', 'nicolas.rios@email.com', '3301122334', '2024-03-21', 42000.00, 'activo');

-- Inserciones: RUTA (25 registros)
INSERT INTO ruta (nombre_ruta, origen, destino, distancia_km, tiempo_estimado, tarifa, estado_ruta) VALUES
('Ruta A1', 'Centro', 'Suba', 18.5, 45, 2800.00, 'activa'),
('Ruta B2', 'Engativá', 'Chapinero', 22.3, 55, 3200.00, 'activa'),
('Ruta C3', 'Kennedy', 'Zona Rosa', 25.1, 65, 3500.00, 'activa'),
('Ruta D4', 'Bosa', 'Centro', 19.8, 50, 2900.00, 'activa'),
('Ruta E5', 'Usaquén', 'San Cristóbal', 35.2, 80, 4200.00, 'activa'),
('Ruta F6', 'Fontibón', 'La Candelaria', 20.0, 52, 3000.00, 'activa'),
('Ruta G7', 'Puente Aranda', 'Salitre', 12.4, 35, 2500.00, 'activa'),
('Ruta H8', 'Ciudad Bolívar', 'Centro', 28.7, 70, 3800.00, 'activa'),
('Ruta I9', 'Barrios Unidos', 'El Dorado', 15.3, 40, 2700.00, 'activa'),
('Ruta J10', 'Antonio Nariño', 'Chapinero Alto', 17.8, 48, 2900.00, 'activa'),
('Ruta K11', 'Rafael Uribe', 'Las Américas', 22.0, 60, 3300.00, 'activa'),
('Ruta L12', 'San Cristóbal', 'Centro', 24.6, 62, 3400.00, 'activa'),
('Ruta M13', 'Sumapaz', 'Centro', 40.1, 95, 4500.00, 'activa'),
('Ruta N14', 'Suba', 'Engativá', 14.2, 38, 2600.00, 'activa'),
('Ruta O15', 'Chía', 'Centro', 32.0, 75, 4000.00, 'activa'),
('Ruta P16', 'La Calleja', 'Portal Norte', 8.5, 25, 2200.00, 'activa'),
('Ruta Q17', 'Cedritos', 'Centro', 19.0, 50, 2900.00, 'activa'),
('Ruta R18', 'Modelia', 'Salitre Mágico', 11.0, 30, 2400.00, 'activa'),
('Ruta S19', 'Tunal', 'Museo del Oro', 20.5, 55, 3000.00, 'activa'),
('Ruta T20', 'Perdomo', 'Centro', 26.3, 68, 3700.00, 'activa'),
('Ruta U21', 'Guaymaral', 'Centro', 30.0, 72, 3900.00, 'activa'),
('Ruta V22', 'Cajicá', 'Centro', 38.5, 88, 4400.00, 'activa'),
('Ruta W23', 'Sopó', 'Centro', 42.0, 92, 4600.00, 'activa'),
('Ruta X24', 'Mosquera', 'Centro', 35.8, 80, 4200.00, 'activa'),
('Ruta Y25', 'Funza', 'Centro', 33.2, 77, 4100.00, 'activa');

-- Inserciones: PARADERO (25 registros)
INSERT INTO paradero (nombre_paradero, direccion, coordenada_lat, coordenada_lng, zona) VALUES
('Paradero Central', 'Carrera 7 con Calle 26', 4.6097102, -74.0817547, 'Centro'),
('Portal Norte', 'Autopista Norte Km 5', 4.7109886, -74.0543671, 'Norte'),
('Terminal Sur', 'Avenida Boyacá con Autopista Sur', 4.5497157, -74.1469875, 'Sur'),
('Estación Suba', 'Calle 145 con Carrera 91', 4.7569847, -74.0836502, 'Suba'),
('Plaza de Bolívar', 'Carrera 8 No 7-27', 4.5980772, -74.0761028, 'La Candelaria'),
('Portal Sur', 'Autopista Sur con Calle 40 Sur', 4.5601234, -74.1502345, 'Sur'),
('Portal El Dorado', 'Avenida El Dorado con Carrera 50', 4.6701234, -74.1412345, 'Occidente'),
('Estación Calle 72', 'Calle 72 con Carrera 11', 4.6689123, -74.0612345, 'Chapinero'),
('Estación Virrey', 'Calle 85 con Carrera 13', 4.6801234, -74.0501234, 'Chapinero'),
('Estación Héroes', 'Avenida Caracas con Calle 38', 4.6301234, -74.0834567, 'Centro'),
('Portal Suba', 'Avenida Suba con Calle 145', 4.7589012, -74.0856789, 'Suba'),
('Estación Bosa', 'Avenida Bosa con Calle 63 Sur', 4.5612345, -74.1612345, 'Sur'),
('Estación Kennedy', 'Avenida Ciudad de Cali con Calle 38 Sur', 4.6012345, -74.1289012, 'Sur'),
('Estación San Cristóbal', 'Avenida Caracas con Calle 38 Sur', 4.5701234, -74.0834567, 'Sur'),
('Estación Usaquén', 'Calle 116 con Carrera 7', 4.7101234, -74.0401234, 'Norte'),
('Parque Simón Bolívar', 'Avenida 68 con Calle 63', 4.6189012, -74.1089012, 'Centro'),
('Museo del Oro', 'Calle 16 con Carrera 7', 4.5991234, -74.0745678, 'Centro'),
('Terminal de Transportes', 'Avenida 24 con Carrera 40', 4.6401234, -74.1234567, 'Centro'),
('Centro Comercial Andino', 'Calle 82 con Carrera 12', 4.6823456, -74.0489012, 'Norte'),
('Universidad Nacional', 'Carrera 30 con Calle 45', 4.6289012, -74.0701234, 'Centro'),
('Hospital San Ignacio', 'Carrera 7 con Calle 77', 4.6756789, -74.0601234, 'Norte'),
('Estación Ricaurte', 'Avenida Caracas con Calle 13', 4.6089012, -74.0801234, 'Centro'),
('Estación Floresta', 'Avenida Boyacá con Calle 53', 4.6189012, -74.1412345, 'Sur'),
('Estación Calle 187', 'Calle 187 con Autopista Norte', 4.7801234, -74.0501234, 'Norte'),
('Estación Calle 26', 'Calle 26 con Carrera 10', 4.6101234, -74.0801234, 'Centro');

-- Inserciones: BUS (25 registros)
INSERT INTO bus (placa, modelo, capacidad, año_fabricacion, estado_bus, id_ruta) VALUES
('ABC123', 'Mercedes-Benz O500', 80, 2020, 'operativo', 1),
('DEF456', 'Volvo B290R', 85, 2019, 'operativo', 1),
('GHI789', 'Scania K280', 75, 2021, 'operativo', 2),
('JKL012', 'Mercedes-Benz O500', 80, 2020, 'operativo', 2),
('MNO345', 'Volvo B290R', 85, 2019, 'operativo', 3),
('PQR678', 'Scania K280', 75, 2021, 'operativo', 3),
('STU901', 'Mercedes-Benz O500', 80, 2022, 'operativo', 4),
('VWX234', 'Volvo B290R', 85, 2020, 'operativo', 5),
('YZA567', 'Scania K280', 75, 2019, 'operativo', 6),
('BCD890', 'Mercedes-Benz O500', 80, 2021, 'operativo', 7),
('EFG123', 'Volvo B290R', 85, 2022, 'operativo', 8),
('HIJ456', 'Scania K280', 75, 2020, 'operativo', 9),
('KLM789', 'Mercedes-Benz O500', 80, 2019, 'operativo', 10),
('NOP012', 'Volvo B290R', 85, 2021, 'mantenimiento', 11),
('QRS345', 'Scania K280', 75, 2022, 'operativo', 12),
('TUV678', 'Mercedes-Benz O500', 80, 2020, 'operativo', 13),
('WXY901', 'Volvo B290R', 85, 2019, 'operativo', 14),
('ZAB234', 'Scania K280', 75, 2021, 'fuera_servicio', 15),
('CDE567', 'Mercedes-Benz O500', 80, 2022, 'operativo', 16),
('FGH890', 'Volvo B290R', 85, 2020, 'operativo', 17),
('IJK123', 'Scania K280', 75, 2019, 'operativo', 18),
('LMN456', 'Mercedes-Benz O500', 80, 2021, 'operativo', 19),
('OPQ789', 'Volvo B290R', 85, 2022, 'operativo', 20),
('RST012', 'Scania K280', 75, 2020, 'operativo', 21),
('UVW345', 'Mercedes-Benz O500', 80, 2019, 'operativo', 22);

-- Inserciones: HORARIO (25 registros)
INSERT INTO horario (id_ruta, id_paradero, hora_llegada, dias_operacion) VALUES
(1, 1, '06:00:00', 'lunes,martes,miercoles,jueves,viernes'),
(1, 4, '06:45:00', 'lunes,martes,miercoles,jueves,viernes'),
(1, 11, '07:15:00', 'lunes,martes,miercoles,jueves,viernes'),
(2, 1, '06:15:00', 'lunes,martes,miercoles,jueves,viernes'),
(2, 7, '06:30:00', 'lunes,martes,miercoles,jueves,viernes'),
(2, 10, '07:10:00', 'lunes,martes,miercoles,jueves,viernes'),
(3, 3, '06:30:00', 'lunes,martes,miercoles,jueves,viernes'),
(3, 13, '06:50:00', 'lunes,martes,miercoles,jueves,viernes'),
(3, 14, '07:20:00', 'lunes,martes,miercoles,jueves,viernes'),
(4, 12, '06:20:00', 'lunes,martes,miercoles,jueves,viernes'),
(4, 1, '07:00:00', 'lunes,martes,miercoles,jueves,viernes'),
(5, 15, '06:00:00', 'lunes,martes,miercoles,jueves,viernes'),
(5, 1, '07:20:00', 'lunes,martes,miercoles,jueves,viernes'),
(6, 6, '06:10:00', 'lunes,martes,miercoles,jueves,viernes'),
(6, 16, '06:40:00', 'lunes,martes,miercoles,jueves,viernes'),
(7, 18, '06:25:00', 'lunes,martes,miercoles,jueves,viernes'),
(7, 1, '06:50:00', 'lunes,martes,miercoles,jueves,viernes'),
(8, 12, '06:15:00', 'lunes,martes,miercoles,jueves,viernes'),
(8, 17, '07:15:00', 'lunes,martes,miercoles,jueves,viernes'),
(9, 22, '06:10:00', 'lunes,martes,miercoles,jueves,viernes'),
(9, 25, '06:35:00', 'lunes,martes,miercoles,jueves,viernes'),
(10, 20, '06:20:00', 'lunes,martes,miercoles,jueves,viernes'),
(10, 19, '06:55:00', 'lunes,martes,miercoles,jueves,viernes'),
(11, 13, '06:05:00', 'lunes,martes,miercoles,jueves,viernes'),
(11, 3, '06:35:00', 'lunes,martes,miercoles,jueves,viernes');

-- Inserciones: RECARGA (25 registros)
INSERT INTO recarga (id_usuario, monto, metodo_pago, estado_transaccion) VALUES
(1, 20000.00, 'tarjeta', 'exitosa'),
(1, 15000.00, 'pse', 'exitosa'),
(2, 10000.00, 'efectivo', 'exitosa'),
(2, 25000.00, 'tarjeta', 'exitosa'),
(3, 30000.00, 'transferencia', 'exitosa'),
(4, 8000.00, 'tarjeta', 'exitosa'),
(5, 45000.00, 'pse', 'exitosa'),
(6, 12000.00, 'efectivo', 'exitosa'),
(7, 33000.00, 'tarjeta', 'exitosa'),
(8, 7500.00, 'transferencia', 'exitosa'),
(9, 28000.00, 'pse', 'exitosa'),
(10, 19000.00, 'tarjeta', 'exitosa'),
(11, 40000.00, 'efectivo', 'exitosa'),
(12, 5000.00, 'pse', 'exitosa'),
(13, 22000.00, 'tarjeta', 'exitosa'),
(14, 35000.00, 'transferencia', 'exitosa'),
(15, 11000.00, 'efectivo', 'exitosa'),
(16, 27000.00, 'pse', 'exitosa'),
(17, 31000.00, 'tarjeta', 'exitosa'),
(18, 9500.00, 'transferencia', 'exitosa'),
(19, 18000.00, 'efectivo', 'exitosa'),
(20, 24000.00, 'tarjeta', 'exitosa'),
(21, 36000.00, 'pse', 'exitosa'),
(22, 13000.00, 'transferencia', 'exitosa'),
(23, 21000.00, 'tarjeta', 'exitosa');

-- Inserciones: VIAJE (25 registros)
INSERT INTO viaje (id_usuario, id_ruta, id_bus, fecha_viaje, hora_inicio, hora_fin, tarifa_cobrada) VALUES
(1, 1, 1, '2024-08-01', '07:30:00', '08:15:00', 2800.00),
(1, 2, 2, '2024-08-01', '18:45:00', '19:40:00', 3200.00),
(2, 3, 3, '2024-08-01', '08:15:00', '09:20:00', 3500.00),
(3, 1, 1, '2024-08-01', '07:45:00', '08:30:00', 2800.00),
(4, 4, 4, '2024-08-01', '09:00:00', '09:50:00', 2900.00),
(5, 5, 5, '2024-08-02', '07:00:00', '08:20:00', 4200.00),
(6, 6, 6, '2024-08-02', '08:00:00', '08:52:00', 3000.00),
(7, 7, 7, '2024-08-02', '08:30:00', '09:05:00', 2500.00),
(8, 8, 8, '2024-08-02', '07:45:00', '09:00:00', 3800.00),
(9, 9, 9, '2024-08-03', '09:15:00', '09:55:00', 2700.00),
(10, 10, 10, '2024-08-03', '10:00:00', '10:48:00', 2900.00),
(11, 11, 11, '2024-08-03', '07:30:00', '08:30:00', 3300.00),
(12, 12, 12, '2024-08-03', '08:15:00', '09:17:00', 3400.00),
(13, 13, 13, '2024-08-04', '07:00:00', '08:35:00', 4500.00),
(14, 14, 14, '2024-08-04', '09:00:00', '09:38:00', 2600.00),
(15, 15, 15, '2024-08-04', '08:30:00', '09:45:00', 4000.00),
(16, 16, 16, '2024-08-04', '07:45:00', '08:10:00', 2200.00),
(17, 17, 17, '2024-08-05', '08:00:00', '08:50:00', 2900.00),
(18, 18, 18, '2024-08-05', '09:15:00', '09:45:00', 2400.00),
(19, 19, 19, '2024-08-05', '10:00:00', '10:55:00', 3000.00),
(20, 20, 20, '2024-08-05', '07:30:00', '08:38:00', 3700.00),
(21, 21, 21, '2024-08-06', '08:15:00', '09:27:00', 3900.00),
(22, 22, 22, '2024-08-06', '09:00:00', '10:28:00', 4400.00),
(23, 23, 23, '2024-08-06', '10:00:00', '11:32:00', 4600.00),
(24, 24, 24, '2024-08-06', '08:30:00', '09:50:00', 4200.00);

-- Inserciones: NOTIFICACION (25 registros)
INSERT INTO notificacion (id_usuario, tipo_notificacion, mensaje, leida) VALUES
(1, 'info', 'Su recarga de $20,000 ha sido procesada exitosamente', TRUE),
(1, 'alerta', 'Su saldo es bajo: $5,200. Recargue pronto.', FALSE),
(2, 'promocion', '¡Oferta especial! 20% de descuento en recargas superiores a $30,000', TRUE),
(3, 'mantenimiento', 'La Ruta A1 tendrá mantenimiento el domingo 4 de agosto', FALSE),
(4, 'info', 'Bienvenido al sistema SmartCity Transport', TRUE),
(5, 'alerta', 'La Ruta E5 está en mantenimiento hoy', FALSE),
(6, 'info', 'Nuevo paradero agregado en Portal Norte', TRUE),
(7, 'promocion', 'Recarga $50,000 y llévate $5,000 gratis', FALSE),
(8, 'info', 'Tu viaje de hoy ha sido registrado', TRUE),
(9, 'alerta', 'Saldo insuficiente para próxima ruta', FALSE),
(10, 'info', 'Actualización del horario de la Ruta J10', TRUE),
(11, 'mantenimiento', 'El bus ABC123 está en mantenimiento', FALSE),
(12, 'info', 'Notificación de seguridad: revisa tus viajes', TRUE),
(13, 'promocion', '¡Primer viaje gratis para nuevos usuarios!', TRUE),
(14, 'alerta', 'Cambio de ruta programado para mañana', FALSE),
(15, 'info', 'Tu recarga fue completada', TRUE),
(16, 'info', 'Nueva ruta W23 disponible desde Sopó', FALSE),
(17, 'mantenimiento', 'Paradero Estación Calle 26 cerrado temporalmente', FALSE),
(18, 'alerta', 'Tu tarjeta vence en 7 días', TRUE),
(19, 'info', 'Gracias por usar SmartCity Transport', TRUE),
(20, 'promocion', 'Semana de movilidad sostenible: 15% dto', FALSE),
(21, 'info', 'Actualización de la app disponible', TRUE),
(22, 'alerta', 'Fallo en lectura de tarjeta – contacta soporte', FALSE),
(23, 'mantenimiento', 'Sistema en actualización – servicio normal en 1 hora', TRUE),
(24, 'info', 'Tu perfil ha sido actualizado', TRUE);

-- Vistas útiles
CREATE VIEW vista_viajes_completos AS
SELECT 
  v.id_viaje,
  u.nombre AS usuario_nombre,
  u.apellido AS usuario_apellido,
  r.nombre_ruta,
  b.placa AS bus_placa,
  v.fecha_viaje,
  v.hora_inicio,
  v.hora_fin,
  v.tarifa_cobrada
FROM viaje v
INNER JOIN usuario u ON v.id_usuario = u.id_usuario
INNER JOIN ruta r ON v.id_ruta = r.id_ruta
INNER JOIN bus b ON v.id_bus = b.id_bus;

CREATE VIEW vista_usuarios_activos AS
SELECT 
  u.id_usuario,
  u.nombre,
  u.apellido,
  u.email,
  u.saldo_tarjeta,
  u.fecha_registro,
  COUNT(v.id_viaje) AS total_viajes
FROM usuario u
LEFT JOIN viaje v ON u.id_usuario = v.id_usuario
WHERE u.estado_cuenta = 'activo'
GROUP BY u.id_usuario;

-- Mensaje final
SELECT '✅ Base de datos smartcity_transport creada y poblada exitosamente' AS mensaje;