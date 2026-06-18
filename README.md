# 📚 StackRuby

<div align="center">

![Ruby on Rails](https://img.shields.io/badge/Rails-6.1.7-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Ruby](https://img.shields.io/badge/Ruby-3.2.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-3-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![License](https://img.shields.io/badge/License-GPLv2-blue?style=for-the-badge&logo=gnu&logoColor=white)
![FreeJS](https://img.shields.io/badge/FreeJS-No_JavaScript-success?style=for-the-badge)

**Clon opensource y ligero de Stack Overflow**  
*Construido con Ruby on Rails, licenciado bajo GPLv2*

[Características](#-características) • [Instalación](#-instalación) • [Arquitectura](#-arquitectura) • [Contribuir](#-contribuir) • [Licencia](#-licencia)

</div>

---

## 📖 Descripción

**StackRuby** es un clon completo y funcional de Stack Overflow desarrollado en Ruby on Rails. El proyecto nació con el objetivo de crear una alternativa libre, ligera y totalmente opensource al sistema de preguntas y respuestas más popular del mundo.

### ¿Por qué otro clon de Stack Overflow?

- **Libertad total**: Código 100% abierto bajo GPLv2
- **Simplicidad**: Sin complejidad innecesaria, solo lo esencial
- **Privacidad**: Tu propia instancia, tus propias reglas
- **Aprendizaje**: Base de código limpia para estudiar y modificar
- **FreeJS**: Funciona sin JavaScript, compatible hasta con Emacs

---

## ✨ Características

### Core Features

#### 🔐 Sistema de Autenticación
- Registro e inicio de sesión con email y contraseña
- Encriptación de contraseñas con BCrypt
- Sesiones persistentes con cookies encrypted
- Perfiles de usuario personalizables

#### ❓ Preguntas y Respuestas
- Crear, editar y eliminar preguntas
- Sistema de comentarios anidados (hilos de conversación)
- Respuestas con soporte completo de Markdown
- Confirmación de eliminación (escribir título exacto)

#### ⭐ Sistema de Estrellas
- Una estrella por usuario por pregunta
- No puedes dar estrella a tus propias preguntas
- Sistema de favoritos: guarda preguntas con estrella
- Solo el autor ve quiénes le dieron estrella (privacidad)
- Contador público de estrellas

#### 📝 Soporte de Markdown (GFM)
- **GitHub Flavored Markdown** con Kramdown
- Preview server-side sin JavaScript
- Soporte de HTML raw (`<div>`, `<img>`, etc.)
- Bloques de código con syntax
- Tablas, listas, quotes, enlaces
- Botón "Ver Markdown" para ver código fuente original
- Compatible con arte ASCII

#### 💬 Sistema de Comentarios Avanzado
- **Comentarios en árbol** con respuestas anidadas
- **Algoritmo de Poda de Fantasmas™**:
  - Soft-delete si el comentario tiene hijos
  - Hard-delete si no tiene descendencia
  - Recolector en cascada reversa para limpiar fantasmas vacíos
- Edición inline de comentarios
- Respuestas a cualquier nivel de profundidad

#### 👤 Perfiles de Usuario
- Perfil público con biografía y foto (Base64)
- Estadísticas:
  - Preguntas realizadas
  - ⭐ Estrellas otorgadas (total, sin mostrar a quién)
  - ⭐ Estrellas recibidas (total)
- Grid de preguntas del usuario

#### 🔍 Búsqueda
- Búsqueda por título y cuerpo de pregunta
- Búsqueda de usuarios por nombre

#### 👁️ Sistema de Vistas
- Contador automático de vistas en preguntas
- Se incrementa cada vez que alguien abre la pregunta
- Visible para todos (pero no quién vio)

#### 📰 Novedades (Blog)
- Sistema de noticias/anuncios
- Solo lectura para usuarios
- Ordenadas por fecha

### 🎨 UI/UX

- **Dark theme nativo**: Inspirado en GitHub dark
- **Sidebar sticky**: Se mantiene visible al hacer scroll
- **Diseño responsive**: Grid layout moderno
- **CSS puro**: Sin frameworks CSS externos
- **Accesible**: Funciona en navegadores de texto (Lynx, w3m)
- **Compatible con Emacs**: Funciona con eww-mode

---

## 🛠️ Stack Técnico

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Ruby** | 3.2.3 | Lenguaje base |
| **Rails** | 6.1.7.10 | Framework web |
| **SQLite** | 3.x | Base de datos (desarrollo/producción ligera) |
| **BCrypt** | 3.1.7 | Encriptación de contraseñas |
| **Kramdown** | 2.4+ | Parser de Markdown |
| **kramdown-parser-gfm** | 1.1+ | GitHub Flavored Markdown |
| **Puma** | 6.0+ | Servidor de aplicaciones |

### Arquitectura MVC Clásica

```
StackRuby/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── sesiones_controller.rb       # Autenticación
│   │   ├── pregunta_controller.rb       # CRUD preguntas
│   │   ├── comentarios_controller.rb    # Sistema de comentarios
│   │   ├── usuarios_controller.rb       # Perfiles
│   │   └── novedades_controller.rb      # Blog
│   ├── models/
│   │   ├── preguntum.rb                 # Modelo de pregunta
│   │   ├── comentario.rb                # Árbol de comentarios
│   │   ├── usuario.rb                   # Usuario + autenticación
│   │   ├── estrella.rb                  # Sistema de estrellas
│   │   └── novedad.rb                   # Noticias
│   ├── views/
│   │   ├── layouts/
│   │   │   └── application.html.erb     # Layout principal + CSS
│   │   ├── pregunta/
│   │   ├── comentarios/
│   │   ├── usuarios/
│   │   └── sesiones/
│   └── helpers/
│       └── markdown_helper.rb           # Procesamiento Markdown
├── config/
│   ├── routes.rb                        # Rutas de la aplicación
│   └── database.yml                     # Configuración BD
├── db/
│   ├── migrate/                         # Migraciones
│   └── schema.rb                        # Esquema actual
└── test/                                # Tests (por implementar)
```

---

## 📊 Modelo de Datos

```
usuarios
├── id (PK)
├── nombre (unique)
├── contrasena (encrypted)
├── descripcion
├── foto_base64
└── timestamps

pregunta
├── id (PK)
├── usuario_id (FK)
├── titulo
├── cuerpo (deprecated)
├── cuerpo_markdown (source)
├── cuerpo_html (rendered)
├── votos (deprecated)
├── vistas
└── timestamps

comentarios
├── id (PK)
├── usuario_id (FK, nullable)
├── preguntum_id (FK)
├── comentario_padre_id (FK, self-ref)
├── cuerpo (deprecated)
├── cuerpo_markdown (source)
├── cuerpo_html (rendered)
└── timestamps

estrellas
├── id (PK)
├── usuario_id (FK)
├── preguntum_id (FK)
└── timestamps
└── UNIQUE(usuario_id, preguntum_id)

novedads
├── id (PK)
├── titulo
├── cuerpo
└── timestamps
```

### Relaciones

```ruby
Usuario
  has_many :pregunta
  has_many :comentarios
  has_many :estrellas
  has_many :preguntas_favoritas, through: :estrellas

Preguntum
  belongs_to :usuario
  has_many :comentarios
  has_many :estrellas
  has_many :usuarios_que_dieron_estrella, through: :estrellas

Comentario
  belongs_to :usuario (optional: true)  # Permite fantasmas
  belongs_to :preguntum
  belongs_to :padre, class_name: "Comentario" (optional: true)
  has_many :hijos, class_name: "Comentario"

Estrella
  belongs_to :usuario
  belongs_to :preguntum
```

---

## 🚀 Instalación

### Prerrequisitos

- Ruby 3.2.3
- Rails 6.1.7+
- SQLite3
- Bundler

### Instalación Local

```bash
# 1. Clonar el repositorio
git clone https://github.com/Qmaker-programmer/stackruby.git
cd stackruby

# 2. Instalar dependencias
bundle install

# 3. Crear y migrar la base de datos
rails db:create
rails db:migrate

# 4. (Opcional) Cargar datos de ejemplo
rails db:seed

# 5. Iniciar el servidor
rails server

# 6. Abrir en navegador
open http://localhost:3000
```

### Variables de Entorno (Producción)

```bash
# No hay variables críticas
# SQLite funciona out-of-the-box
# Para producción con PostgreSQL:
# DATABASE_URL=postgres://...
# RAILS_ENV=production
```

---

## 🔧 Uso

### Crear un usuario

1. Ve a http://localhost:3000/entrar
2. Haz clic en "Registrarse"
3. Ingresa nombre de usuario y contraseña
4. Listo, sesión iniciada automáticamente

### Publicar una pregunta

1. Desde el home, clic en "Hacer una Pregunta"
2. Escribe el título y cuerpo (con Markdown)
3. Haz clic en "Preview" para ver cómo se verá
4. Clic en "Publicar Pregunta"

### Dar una estrella

1. Abre cualquier pregunta (que no sea tuya)
2. Clic en "☆ Dar Estrella"
3. Para quitarla, clic en "★ Quitar Estrella"

### Ver favoritos

1. Menú lateral → "Favoritos"
2. Verás todas las preguntas a las que diste estrella

### Comentar

1. Abrir pregunta
2. Escribir comentario (Markdown soportado)
3. Para responder a un comentario → "Responder"
4. Para editar tu comentario → "Editar"

---

## 🏗️ Características Técnicas Avanzadas

### 1. Sistema de Soft-Delete Inteligente

El **Algoritmo de Poda de Fantasmas™** es una implementación recursiva que:

```ruby
def eliminar_con_poda!
  if hijos.any?
    # Soft-delete: Convierte en fantasma
    update(cuerpo: "[Este comentario fue eliminado]", usuario_id: nil)
  else
    # Hard-delete: Purga física
    destroy
  end
end
```

**Ventajas:**
- Preserva la estructura del árbol de comentarios
- No deja "huecos" visuales en la conversación
- Recolector de basura automático para fantasmas sin hijos

### 2. Procesamiento de Markdown Server-Side

Todo el Markdown se procesa en el servidor:

```ruby
# En el modelo, before_save callback
def procesar_markdown
  if cuerpo_markdown_changed?
    self.cuerpo_html = Kramdown::Document.new(
      cuerpo_markdown,
      input: 'GFM',
      parse_block_html: true
    ).to_html
  end
end
```

**Ventajas:**
- No depende de JavaScript del cliente
- Funciona en navegadores sin JS
- Preview sin AJAX, simple POST al servidor
- HTML sanitizado y seguro

### 3. Sistema de Estrellas con Validación Única

```ruby
class Estrella < ApplicationRecord
  validates :usuario_id, uniqueness: { 
    scope: :preguntum_id,
    message: "Ya diste una estrella a esta pregunta"
  }
end
```

Esto garantiza a nivel de base de datos que un usuario no pueda dar múltiples estrellas.

### 4. Encriptación de Contraseñas con BCrypt

```ruby
before_save :encriptar_contrasena, if: :will_save_change_to_contrasena?

def contrasena_valida?(password_ingresado)
  BCrypt::Password.new(self.contrasena) == password_ingresado
end
```

Las contraseñas nunca se almacenan en texto plano.

---

## 🧪 Testing

```bash
# Ejecutar tests (pendiente de implementar)
rails test

# Cobertura
rails test:coverage
```

**Estado actual**: Tests pendientes de implementación. Contribuciones bienvenidas.

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Este proyecto es 100% opensource.

### Proceso de Contribución

1. **Fork** el repositorio
2. Crea una **rama** para tu feature:
   ```bash
   git checkout -b feature/mi-mejora-epica
   ```
3. **Commit** tus cambios:
   ```bash
   git commit -m "feat: descripción clara del cambio"
   ```
4. **Push** a tu fork:
   ```bash
   git push origin feature/mi-mejora-epica
   ```
5. Abre un **Pull Request**

### Estilo de Código

- Sigue las convenciones de Ruby/Rails estándar
- Usa comentarios descriptivos en español
- Mantén los métodos cortos y con una sola responsabilidad
- Escribe tests para nuevas features (cuando el sistema de tests esté listo)

### Ideas de Contribución

- ✅ Sistema de badges/insignias para usuarios
- ✅ Búsqueda full-text con pg_search
- ✅ Sistema de tags/etiquetas en preguntas
- ✅ Notificaciones de respuestas
- ✅ Export de preguntas a PDF/Markdown
- ✅ API REST para integración externa
- ✅ Sistema de moderación
- ✅ Tests unitarios y de integración
- ✅ Docker setup
- ✅ Deploy con Heroku/Fly.io

---

## 📝 Roadmap

### v1.0 (Actual) ✅
- [x] Sistema de autenticación
- [x] CRUD de preguntas
- [x] Comentarios anidados
- [x] Sistema de estrellas
- [x] Soporte de Markdown (GFM)
- [x] Perfiles de usuario
- [x] Búsqueda básica

### v1.1 (Próximo)
- [ ] Sistema de tags/categorías
- [ ] Búsqueda avanzada con filtros
- [ ] Notificaciones por email
- [ ] Sistema de reputación ampliado
- [ ] Moderación de contenido

### v2.0 (Futuro)
- [ ] API REST completa
- [ ] PWA (Progressive Web App)
- [ ] Soporte multi-idioma (i18n)
- [ ] Sistema de badges
- [ ] Integración con OAuth (GitHub, Google)

---

## ⚖️ Licencia

Este proyecto está licenciado bajo la **GNU General Public License v2.0 (GPLv2)**.

### ¿Por qué GPLv2?

1. **Coherencia ideológica**: La misma licencia que usa el kernel Linux
2. **Copyleft fuerte**: Garantiza que el software siempre será libre
3. **No versión 3**: Por razones técnicas y filosóficas de compatibilidad
4. **Libertad total**: Puedes usar, modificar y distribuir libremente

Ver [LICENSE](LICENSE) para más detalles.

---

## 🙏 Créditos

### Tecnologías

- **Ruby on Rails** - El framework que hace posible todo esto
- **Kramdown** - Por el excelente soporte de Markdown
- **BCrypt** - Por mantener las contraseñas seguras
- **SQLite** - Por ser simple y funcionar perfectamente

### Inspiración

- **Stack Overflow** - Por crear el modelo de Q&A que todos conocemos
- **Reddit** - Por el sistema de comentarios anidados
- **GitHub** - Por el dark theme y el GFM
- **La comunidad opensource** - Por compartir conocimiento libremente

---

## 📧 Contacto

 **Proyecto**: [StackRuby en GitHub](https://github.com/Qmaker-programmer/stackruby)
- **Issues**: [Reportar un bug](https://github.com/Qmaker-programmer/stackruby/issues)
- **Autor**: Qmaker

---

<div align="center">

**StackRuby** - *El clon de Stack Overflow que necesitabas*

Hecho con mucho té y Ruby on Rails

[![GPLv2](https://img.shields.io/badge/License-GPLv2-blue?style=flat-square)](LICENSE)
[![Ruby](https://img.shields.io/badge/Ruby-3.2.3-red?style=flat-square)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-6.1.7-red?style=flat-square)](https://rubyonrails.org/)

[⬆ Volver arriba](#-stackruby)

</div>
