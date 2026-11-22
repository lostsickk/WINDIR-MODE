# WINDIR MODE — proyecto de tweak visual

Este ZIP contiene **código fuente**, no una `.dylib` ya compilada.

## Contenido
- `Tweak.xm`: interfaz visual con botón de dragón arrastrable, panel y pestañas.
- `Makefile`: configuración de compilación Theos.
- `control`: metadatos del paquete.

## Compilación
Este proyecto requiere Theos, Logos, un SDK de iOS y un entorno de compilación compatible.

En un entorno con Theos instalado:
```sh
make clean
make package
```

El artefacto generado dependerá de la configuración y del entorno Theos. No se garantiza que una herramienta de inyección concreta acepte el binario.

## Importante
- No es una IPA.
- No incluye una `.dylib` precompilada.
- El menú y sus interruptores son demostrativos/visuales; no implementan aimbot, ESP ni modificaciones de Free Fire.
- iOS sin jailbreak no garantiza que un tweak tradicional pueda cargarse en otra aplicación. La compatibilidad depende del método de inyección, firma, arquitectura, versión de iOS y protecciones de la app.


## GitHub Actions incluido

Este proyecto ya incluye `.github/workflows/build.yml`.
Sube el contenido de esta carpeta a un repositorio GitHub nuevo o separado,
conservando la estructura de carpetas. Luego abre **Actions** y ejecuta
**Build WINDIR MODE dylib** (o haz push a `main`).

El workflow intenta compilar con Theos en macOS y publica los archivos
en **Artifacts**. La compilación puede requerir ajustes según los SDK y
las herramientas disponibles en GitHub Actions.

Este proyecto es una interfaz demostrativa. No implementa funciones reales
de aimbot/ESP ni garantiza carga dentro de Free Fire. Que Mango acepte
agregar una dylib no garantiza que iOS o el juego permitan cargarla.
