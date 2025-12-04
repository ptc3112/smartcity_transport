const API_URL = 'http://127.0.0.1:5000/api';

// ========== USUARIOS ==========

async function cargarUsuarios() {
  try {
    const res = await fetch(`${API_URL}/usuarios`);
    const usuarios = await res.json();
    const contenedor = document.getElementById('lista-usuarios');
    if (usuarios.length === 0) {
      contenedor.innerHTML = '<p>No hay usuarios registrados.</p>';
      return;
    }
    contenedor.innerHTML = `
      <table>
        <thead>
          <tr>
            <th>ID</th><th>Nombre</th><th>Email</th><th>Saldo</th><th>Estado</th><th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          ${usuarios.map(u => `
            <tr>
              <td>${u.id_usuario}</td>
              <td>${u.nombre} ${u.apellido}</td>
              <td>${u.email}</td>
              <td>$${Number(u.saldo_tarjeta).toLocaleString()}</td>
              <td>${u.estado_cuenta}</td>
              <td>
                <button onclick="editarUsuario(${u.id_usuario})">✏️</button>
                <button onclick="eliminarUsuario(${u.id_usuario})">🗑️</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  } catch (e) {
    document.getElementById('lista-usuarios').innerHTML = '<p>❌ Error al cargar usuarios.</p>';
  }
}

document.getElementById('usuario-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const id = document.getElementById('usuario-id').value;
  const data = {
    nombre: document.getElementById('usuario-nombre').value,
    apellido: document.getElementById('usuario-apellido').value,
    email: document.getElementById('usuario-email').value,
    telefono: document.getElementById('usuario-telefono').value || null,
    fecha_registro: document.getElementById('usuario-fecha').value,
    saldo_tarjeta: parseFloat(document.getElementById('usuario-saldo').value) || 0,
    estado_cuenta: document.getElementById('usuario-estado').value
  };

  try {
    if (id) {
      await fetch(`${API_URL}/usuarios/${id}`, { method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) });
      alert('✅ Usuario actualizado');
    } else {
      await fetch(`${API_URL}/usuarios`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) });
      alert('✅ Usuario creado');
    }
    document.getElementById('usuario-form').reset();
    document.getElementById('usuario-id').value = '';
    document.getElementById('btn-cancelar-usuario').style.display = 'none';
    cargarUsuarios();
  } catch (e) {
    alert('⚠️ Error al guardar usuario');
  }
});

function editarUsuario(id) {
  fetch(`${API_URL}/usuarios/${id}`)
    .then(res => res.json())
    .then(u => {
      document.getElementById('usuario-id').value = u.id_usuario;
      document.getElementById('usuario-nombre').value = u.nombre;
      document.getElementById('usuario-apellido').value = u.apellido;
      document.getElementById('usuario-email').value = u.email;
      document.getElementById('usuario-telefono').value = u.telefono || '';
      document.getElementById('usuario-fecha').value = u.fecha_registro;
      document.getElementById('usuario-saldo').value = u.saldo_tarjeta;
      document.getElementById('usuario-estado').value = u.estado_cuenta;
      document.getElementById('btn-cancelar-usuario').style.display = 'inline-block';
      window.scrollTo(0, 0);
    });
}

document.getElementById('btn-cancelar-usuario').addEventListener('click', () => {
  document.getElementById('usuario-form').reset();
  document.getElementById('usuario-id').value = '';
  document.getElementById('btn-cancelar-usuario').style.display = 'none';
});

async function eliminarUsuario(id) {
  if (confirm('¿Eliminar usuario?')) {
    await fetch(`${API_URL}/usuarios/${id}`, { method: 'DELETE' });
    cargarUsuarios();
  }
}

// ========== RUTAS ==========

async function cargarRutas() {
  try {
    const res = await fetch(`${API_URL}/rutas`);
    const rutas = await res.json();
    const contenedor = document.getElementById('lista-rutas');
    if (rutas.length === 0) {
      contenedor.innerHTML = '<p>No hay rutas registradas.</p>';
      return;
    }
    contenedor.innerHTML = `
      <table>
        <thead>
          <tr>
            <th>ID</th><th>Ruta</th><th>Origen → Destino</th><th>Tarifa</th><th>Estado</th><th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          ${rutas.map(r => `
            <tr>
              <td>${r.id_ruta}</td>
              <td>${r.nombre_ruta}</td>
              <td>${r.origen} → ${r.destino}</td>
              <td>$${Number(r.tarifa).toLocaleString()}</td>
              <td>${r.estado_ruta}</td>
              <td>
                <button onclick="editarRuta(${r.id_ruta})">✏️</button>
                <button onclick="eliminarRuta(${r.id_ruta})">🗑️</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  } catch (e) {
    document.getElementById('lista-rutas').innerHTML = '<p>❌ Error al cargar rutas.</p>';
  }
}

document.getElementById('ruta-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const id = document.getElementById('ruta-id').value;
  const data = {
    nombre_ruta: document.getElementById('ruta-nombre').value,
    origen: document.getElementById('ruta-origen').value,
    destino: document.getElementById('ruta-destino').value,
    distancia_km: parseFloat(document.getElementById('ruta-distancia').value),
    tiempo_estimado: parseInt(document.getElementById('ruta-tiempo').value),
    tarifa: parseFloat(document.getElementById('ruta-tarifa').value),
    estado_ruta: document.getElementById('ruta-estado').value
  };

  try {
    if (id) {
      await fetch(`${API_URL}/rutas/${id}`, { method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) });
      alert('✅ Ruta actualizada');
    } else {
      await fetch(`${API_URL}/rutas`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) });
      alert('✅ Ruta creada');
    }
    document.getElementById('ruta-form').reset();
    document.getElementById('ruta-id').value = '';
    document.getElementById('btn-cancelar-ruta').style.display = 'none';
    cargarRutas();
  } catch (e) {
    alert('⚠️ Error al guardar ruta');
  }
});

function editarRuta(id) {
  fetch(`${API_URL}/rutas/${id}`)
    .then(res => res.json())
    .then(r => {
      document.getElementById('ruta-id').value = r.id_ruta;
      document.getElementById('ruta-nombre').value = r.nombre_ruta;
      document.getElementById('ruta-origen').value = r.origen;
      document.getElementById('ruta-destino').value = r.destino;
      document.getElementById('ruta-distancia').value = r.distancia_km;
      document.getElementById('ruta-tiempo').value = r.tiempo_estimado;
      document.getElementById('ruta-tarifa').value = r.tarifa;
      document.getElementById('ruta-estado').value = r.estado_ruta;
      document.getElementById('btn-cancelar-ruta').style.display = 'inline-block';
      window.scrollTo(0, 0);
    });
}

document.getElementById('btn-cancelar-ruta').addEventListener('click', () => {
  document.getElementById('ruta-form').reset();
  document.getElementById('ruta-id').value = '';
  document.getElementById('btn-cancelar-ruta').style.display = 'none';
});

async function eliminarRuta(id) {
  if (confirm('¿Eliminar ruta?')) {
    await fetch(`${API_URL}/rutas/${id}`, { method: 'DELETE' });
    cargarRutas();
  }
}

// ========== INICIALIZAR ==========
document.addEventListener('DOMContentLoaded', () => {
  cargarUsuarios();
  cargarRutas();
});