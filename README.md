# jujuy.dev

Landing de la comunidad tech de Jujuy. HTML y CSS puro: sin frameworks, sin build, sin base de datos, sin dependencias que instalar.

Sitio publicado: https://jujuy.dev.ar/

## Ver el sitio en tu máquina

Abrí `index.html` con doble click. Listo. No hay nada que instalar.

> Con doble click se ven todas las páginas: las rutas son relativas y `assets/jd-nav.js` completa los links a carpetas con `index.html`. Lo único que no anda con `file://` son los JSON locales (el tren y la copia local del calendario); para eso levantá un servidor con `python3 -m http.server 8000` desde esta carpeta y abrí http://localhost:8000. `404.html` es la excepción: usa rutas absolutas porque GitHub Pages la sirve desde cualquier dirección.

## Contribuir

Los PRs son bienvenidos. Leé [CONTRIBUTING.md](CONTRIBUTING.md) antes de empezar: ahí está qué aceptamos, qué no, y cómo probar tus cambios. También tenemos un [código de conducta](CODE_OF_CONDUCT.md).

## Editar el contenido

La home vive en `index.html` y cada listado en su propia página. Buscá los comentarios que dicen `EDIT` para encontrar cada punto rápido:

| Qué                          | Dónde                                                                |
| ---------------------------- | -------------------------------------------------------------------- |
| Eventos                      | Sección `#eventos`. Lo que viene se arma desde el [calendario de Luma](https://luma.com/jujuydev) (`assets/calendario.js`). Las fichas son el archivo de encuentros que ya pasaron. |
| Canales de la comunidad      | Bloque `.jd-channels`, debajo del Tren Solar                         |
| Logos de colaboradores       | Sección `#colaboradores`, copiá una celda `.jd-logo`                 |
| Staff                        | Sección `#equipo`, una `.jd-person` por persona                      |
| Tren Solar (`#comunidad`)    | Se llena solo con quien autoriza con GitHub (ver «Tren Solar» abajo). A mano: bloque `jd-tren-miembros` en `index.html` |
| Números de la comunidad      | Sección `#somos`                                                     |
| Links del footer             | `<footer>` de cada página                                            |
| Proyectos de la comunidad    | `proyectos/index.html`: copiá una tarjeta (hay una plantilla en el comentario `EDIT`) |
| Ofertas laborales            | `oportunidades/index.html`, pestaña `#ofertas`                       |
| Perfiles abiertos a propuestas | `oportunidades/index.html`, pestaña `#talento`                     |
| Recursos para aprender       | `recursos/index.html`                                                |

## Diseño

La guía de marca y del sistema de diseño (colores, tipografías, formas, voz) está en [`assets/brand/DISENO.md`](assets/brand/DISENO.md). La home usa los componentes `.jd-*` de `css/jd.css` sobre los tokens de `css/tokens.css`; las páginas internas suman `css/pages.css`, que lleva los estilos de `styles.css` al mismo sistema.

## Tren Solar

En la home, «Sumate con GitHub» lleva a la pantalla de autorización de GitHub. Al aceptar, la persona vuelve a la home y su avatar ya viaja en el tren. Es el mismo esquema que usa CuyoConnect: Supabase hace el login con GitHub y guarda a cada persona en una tabla; el sitio sigue siendo estático.

Se configura una sola vez:

1. Crear un proyecto gratis en [supabase.com](https://supabase.com).
2. En GitHub → Settings → Developer settings → OAuth Apps → New OAuth App. Homepage: `https://jujuy.dev.ar`. Callback: `https://<tu-proyecto>.supabase.co/auth/v1/callback`. Copiar el Client ID y generar un Client secret.
3. En Supabase → Authentication → Sign In / Providers → GitHub: activarlo y pegar el Client ID y el secret.
4. En Supabase → Authentication → URL Configuration: Site URL `https://jujuy.dev.ar`, y en Redirect URLs sumar `https://jujuy.dev.ar/**` y `http://localhost:8000/**` para probar en tu máquina.
5. En Supabase → SQL Editor, correr `supabase/tren-solar.sql`.
6. En Supabase → Project Settings → API, copiar la URL del proyecto y la `anon` key a `assets/tren-config.js`.

La `anon` key es pública por diseño: con las reglas de `tren-solar.sql` sólo puede leer la tabla. Nadie escribe desde el navegador; un trigger crea la fila con los datos que manda GitHub, así que no se puede subir a otra persona. Quien quiera bajarse vuelve a entrar y toca «Bajarme del tren».

Entran tres personas por vagón: cada tres que se suman, el tren agrega un vagón, sin tope. Las personas sumadas a mano (bloque `jd-tren-miembros` de `index.html`, ver CONTRIBUTING.md) viajan siempre; si después autorizan con GitHub no se duplican.

Mientras `assets/tren-config.js` esté vacío, el tren muestra sólo a las personas sumadas a mano y el botón lleva a cómo contribuir.

## Cómo funcionan los buscadores y filtros

Los tres listados (proyectos, oportunidades y recursos) son HTML normal: cada tarjeta es un `<article>`. `assets/filtros.js` lee lo que está escrito en cada tarjeta y arma solo el buscador y los filtros. Quien suma una tarjeta no toca JavaScript.

- Cada valor filtrable lleva `data-facet="nombre"` (por ejemplo `data-facet="tech"`). En una lista `<ul>`, cada `<li>` es una opción.
- El contenedor del listado declara qué filtros hay con `data-facets="tech:Tecnología,tema:Temática"`.
- Si JavaScript no carga, la página se ve igual: es una lista de tarjetas.
- Los filtros se guardan en la URL, así que se puede compartir una búsqueda por WhatsApp.
- Una oferta con `data-cierre="AAAA-MM-DD"` se oculta sola pasada esa fecha.

El detalle completo está en el comentario del principio de `assets/filtros.js`.

## Publicación

El sitio se publica solo con GitHub Pages desde la rama `main`. Cada merge a `main` actualiza la página en un minuto.

El dominio `jujuy.dev.ar` está definido en el archivo `CNAME`. El DNS se administra desde el panel de dev.ar y apunta a `francoduran23.github.io`. No lo toques salvo que sepas lo que hacés.

## Archivos

```
index.html              la home
proyectos/              proyectos hechos en Jujuy, con buscador y filtros
oportunidades/          ofertas laborales y personas abiertas a propuestas
recursos/               recursos en español y skills de IA, con buscador y filtros
styles.css              estilos de las páginas internas (listados, eventos, FAQ)
css/tokens.css          tokens del sistema de diseño: colores (claro y Noche), espacios, radios, fuentes
css/jd.css              componentes .jd-* de la home y el nav/footer de todas las páginas
css/pages.css           lleva styles.css al sistema de diseño en las páginas internas
assets/jd-nav.js               menú móvil y año del footer, en todas las páginas
assets/jd-home.js              mosaico de fotos del hero y Tren Solar de la home
assets/calendario.js           próximos eventos desde el calendario de Luma
assets/fotos/                  fotos de eventos a color (hero, galería)
assets/brand/                  logos, isotipo, la llama y DISENO.md (guía de diseño)
assets/filtros.js              buscador, filtros y pestañas de los listados, sin dependencias
assets/hero-layers/hornocal-*.webp capas transparentes publicadas del parallax
assets/hero-parallax.js        parallax por scroll del hero anterior (la home ya no lo usa)
assets/hero-scene.md           composición, exportación y ajustes de las capas
assets/hornocal-prompts.md     prompts finales de las tres ilustraciones
assets/hero.webp               ilustración original, referencia de estilo
assets/hero-source.png         original en alta resolución
assets/logo.svg                logo de la marca, en el nav y como ícono de pestaña
assets/logo-white.svg          variante blanca del logo, para el footer oscuro
assets/og.jpg           imagen de vista previa para WhatsApp, LinkedIn y X
assets/logos/           logos de colaboradores
robots.txt              permite indexar y apunta al sitemap
sitemap.xml             lista de páginas para Google
CNAME                   dominio del sitio
CONTRIBUTING.md         cómo mandar un PR
CODE_OF_CONDUCT.md      normas de la comunidad
LICENSE                 MIT
```

La paleta sale de los pósters de la comunidad: papel cálido, tinta negra, un acento violeta y el orbe degradado magenta → azul. Está definida en `css/tokens.css`; la guía completa está en `assets/brand/DISENO.md`.
