# Documentación del Proyecto: ChocoArt

Este documento proporciona una descripción detallada de la arquitectura, diseño, estructura de base de datos y flujos de trabajo implementados en el sistema web de **ChocoArt**.

---

## 1. Descripción General del Proyecto

**ChocoArt** es una aplicación web híbrida desarrollada en ASP.NET Web Forms. Cumple dos propósitos principales:
1. **Página de Aterrizaje (Landing Page):** Una interfaz pública, visualmente atractiva y premium, diseñada para atraer a clientes de Boca del Monte, mostrando la misión, visión, estrategias y una galería de las creaciones de chocofrutas.
2. **Sistema de Gestión Interna (Dashboard):** Un panel administrativo (protegido por inicio de sesión) que permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre Usuarios, Clientes, Productos y registrar Ventas nuevas e históricas. Todo controlado mediante arquitectura MVC ligera a través de un manejador genérico (AJAX + ASHX).

---

## 2. Páginas Creadas y Estructura

Las páginas del sistema se dividen en públicas y privadas (administrativas):

### Área Pública
- `Default.aspx`: Es la página de inicio que carga automáticamente. Aquí se integró el diseño personalizado de la *landing page*. Contiene las secciones de Inicio, Nosotros (Misión/Visión), Galería y Estrategias. También cuenta con el botón para acceder al sistema. Se reemplazaron las plantillas por defecto de ASP.NET (`About` y `Contact`) para dejar esta experiencia pura.
- `Pages/Login.aspx`: Pantalla de autenticación moderna (con efecto Glassmorphism) donde el personal ingresa su usuario y contraseña para acceder al sistema de gestión.

### Área Administrativa (Requieren Login)
Todas estas páginas comparten la plantilla gráfica de administrador definida en `Site.Master` y se encuentran en la carpeta `Pages/`:
- `Dashboard.aspx`: Panel principal informativo al que llega el usuario tras loguearse.
- `Usuarios.aspx`: Módulo para la gestión del personal con acceso al sistema (Alta, Baja, Modificación).
- `Clientes.aspx`: Módulo para registrar los datos de los compradores (Nombres, Apellidos, NIT, Teléfono).
- `Productos.aspx`: Módulo de inventario para gestionar los arreglos frutales y de chocolate, controlando descripción, precio de costo, precio de venta y existencias (stock).
- `Ventas.aspx`: El núcleo de transacciones. Permite visualizar las ventas históricas y abrir un modal complejo para registrar una factura nueva, descontar productos del inventario y calcular totales y el cambio en efectivo.

---

## 3. Arquitectura Backend: Controladores (Handlers)

En lugar de utilizar el paradigma clásico de postback de Web Forms, el sistema utiliza enfoques asíncronos y modernos mediante **AJAX** impulsado por JavaScript/jQuery.

El núcleo de la comunicación con la base de datos se realiza a través de un manejador genérico (.ashx):
- **Archivo:** `Handlers/ProjectHandler.ashx.cs`
- **Funcionamiento:** Actúa como una API ligera. Recibe por el método `POST` y `GET` un parámetro llamado `cmd` (comando). Mediante una estructura `switch`, enruta la petición a funciones específicas (`HandleLogin`, `HandleGetProductos`, `HandleSaveVenta`, etc.).
- **Ventaja:** Permite que la aplicación sea extremadamente rápida, ya que no recarga la página al guardar o eliminar registros, ofreciendo una experiencia Single Page Application (SPA) para los modales y tablas.

---

## 4. Estructura de la Base De Datos

La base de datos MySQL está diseñada con relaciones fundamentales para soportar inventarios y facturación.

### Tablas y Relaciones
1. **`usuarios`**
   - `idUsuario` (PK), `usuario`, `password`, `activo`, `fechaCreacion`.
   - Propósito: Controlar quién entra al sistema de administración.

2. **`clientes`**
   - `idCliente` (PK), `nombres`, `apellidos`, `NIT`, `genero`, `telefono`, `fechaingreso`.
   - Propósito: Guardar la cartera de clientes. El NIT es útil para la facturación.

3. **`productos`**
   - `idProducto` (PK), `producto`, `descripcion`, `precio_costo`, `precio_venta`, `existencia`, `fechaingreso`.
   - Propósito: Bodega e inventario. Al registrar una venta, la tabla `productos` reduce automáticamente su `existencia`.

4. **`ventas`**
   - `idVenta` (PK), `fechaFactura`, `idCliente` (FK), `fechaingreso`.
   - Propósito: Cabecera de la factura/venta.
   - **Relación:** Se relaciona con `clientes` mediante `idCliente` (llave foránea obligatoria). El sistema utiliza el `idVenta` auto-generado por MySQL como el correlativo físico de la factura (ej: #00018).

5. **`ventas_detalle`** (Tabla Pivote / Auxiliar)
   - `idVentaDetalle` (PK), `idVenta` (FK), `idProducto` (FK), `cantidad`, `precio_unitario`.
   - Propósito: Por cada `idVenta`, pueden existir muchos detalles dependiendo cuántas frutas distintas compró el cliente.
   - **Relación:** Enlaza a `ventas` (`idVenta`) y a `productos` (`idProducto`). Es vital para calcular el total de la venta y saber con precisión la cantidad a descontar de inventario.

---

## 5. Diseño, Estética y Animaciones 

Buscamos que ChocoArt se sintiera un proyecto "Premium", usando características visuales modernas, tipografías atractivas (`Outfit` Font) y microinteracciones.

### Achivos CSS y JS
- **Estilos Principales:** `Content/styles.css`.
- **Scripts del Frontend (Landing Page):** `Scripts/script.js`.
- **Librerías Extra:** `SweetAlert2` (alertas profesionales en CRUD) y `jQuery`.

### Efectos Visiales Implementados
1. **Glassmorphism:** En las tarjetas del "Acerca de" y el formulario de `Login.aspx`, se utilizó un estilo de cristal (fondos semi-transparentes con `backdrop-filter: blur()`) que da un toque de elegancia sobre el fondo degradado.
2. **Animaciones de Aparición (Scroll Reveal):** En `script.js` existe la función `revealOnScroll()`. Esta función detecta cuando bajas por la página y las secciones que tienen la clase CSS `.reveal` aparecen suavemente, dándole vida a la navegación.
3. **Imágenes Flotantes Giratorias (Floating Fruits System):**
   - Es uno de los detalles más dinámicos de la página de aterrizaje. En `script.js`, se encuentra un generador de elementos dinámico: `createFloatingFruits()`.
   - Esta función escoge de forma aleatoria diferentes imágenes de frutas presentes en tus **Assets** (`assets/1.png`, `assets/4.png`, `assets/fresa.jpg`).
   - Las inyecta dinámicamente en el fondo con tamaños aleatorios y posiciones `X` e `Y` aleatorias en toda la pantalla.
   - Usando clases CSS combinadas (`.floating-fruit.type-1` y `.type-2`), se aplican configuraciones `@keyframes` en `styles.css` (como `float-around` y `drift`) que hacen que las imágenes de fresas y chocolates roten 360 grados de manera infinita por toda tu ventana del navegador por detrás del contenido.
4. **Fondo de Color Vivo:** Usa un degradado en movimiento perpetuo (Gradient-bg) activado también por fotogramas clave en el CSS central de la Landing Page.

### Assets Utilizados
Todo gráfico vive en la carpeta `/assets/`:
- `LogoChocoArt.png`: Utilizado en la barra de navegación, el panel de administración, el login y el sidebar.
- Fotografías de producto sin fondo e ilustraciones (`1.png`, `4.png`, `fresa.jpg`): Usadas tanto para la Galería de Trabajos Estelares, como para inyectarlas dinámicamente en el fondo rotatorio.
