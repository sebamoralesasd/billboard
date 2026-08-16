# Billboard
Billboard es un programa con comandos para consultar la cartelera de distintos cines.

Los resultados se obtienen a través de la [API de El Cairo](api.json) con el endpoint [/events](events.json) y se guardan en una base de datos. En cada corrida de comando, se consulta primero a la base de datos y luego a la API en caso de que las películas de la fecha no estén disponibles localmente.  

## Comandos

```shell
# Setup
bundle install

# Correr aplicación
billboard           # Películas de los últimos 30 días
    --week          # Películas de la semana
    --month         # Películas del mes
    --from DATE     # Películas desde DATE
    --to DATE       # Películas hasta DATE
    --short         # Información básica (título, fecha y hora)
    --no-cache      # Ignorar el caché y volver a pedir el rango a la API

# Depuración
BILLBOARD_LOG_LEVEL=DEBUG billboard   # Logs detallados de las requests HTTP
```

## Code style
- Respetar separación de responsabilidades
- snake_case para métodos y variables, CamelCase para clases y módulos
- Definir errores heredando `StandardError`
- Usar `Logger` para logs sobre puntos relevantes
- Usar patrón `ENV.fetch('KEY', default)` para variables de entorno
- Usar `attr_*` en lugar de getters explícitos
- Usar Faraday para requests HTTP, con 5 segundos de timeout
- Usar SQLite3 para la base de datos
- No comentar las funciones

## Misc
- Priorizar plan sobre ejecución. Realizar las preguntas necesarias
- Seguir los cuatro principios de calidad de escritura de Zinsser:
1. Simplicidad
2. Brevedad
3. Claridad
4. Humanidad
