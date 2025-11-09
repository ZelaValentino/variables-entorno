#!/bin/bash


echo
echo "=============================="
echo "  USO EN SCRIPT"
echo "=============================="

source ~/.bashrc

# Verificar las variables principales
if [ -z "$APP_MODE" ]; then
  echo "La variable APP_MODE no está definida. Se usará 'DESARROLLO' por defecto."
  APP_MODE="DESARROLLO"
fi

if [ -z "$DB_USER" ]; then
  echo "La variable DB_USER no está definida. Se usará 'admin' por defecto."
  DB_USER="admin"
fi

echo "APP_MODE: $APP_MODE"
echo "DB_USER: $DB_USER"

echo
echo "=============================="
echo "  LEER VARIABLES DESDE .env"
echo "=============================="

# Cargar el archivo .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
  echo "PORT: $PORT"
  echo "HOST: $HOST"
  echo "LOG_LEVEL: $LOG_LEVEL"
else
  echo "No se encontró el archivo .env. Creando uno por defecto..."
  cat <<EOF > .env
PORT=8080
HOST=localhost
LOG_LEVEL=debug
APP_MODE=DESARROLLO
EOF
  echo "Archivo .env creado con valores de desarrollo."
  source .env
fi

echo
echo "=============================="
echo "  SIMULAR ENTORNO DE PRODUCCIÓN"
echo "=============================="

read -p "¿Deseas cambiar al entorno de producción? (s/n): " RESPUESTA

if [ "$RESPUESTA" = "s" ]; then
  cat <<EOF > .env
PORT=80
HOST=myapp.com
LOG_LEVEL=info
APP_MODE=PRODUCCION
EOF
  echo "Entorno de producción configurado."
else
  cat <<EOF > .env
PORT=8080
HOST=localhost
LOG_LEVEL=debug
APP_MODE=DESARROLLO
EOF
  echo "Entorno de desarrollo restaurado."
fi

# Recargar el .env con los valores actualizados
source .env

echo
echo "=============================="
echo "  INFORME DEL ENTORNO ACTUAL"
echo "=============================="
echo "APP_MODE: $APP_MODE"
echo "DB_USER: $DB_USER"
echo "PORT: $PORT"
echo "HOST: $HOST"
echo "LOG_LEVEL: $LOG_LEVEL"

echo
if [ "$APP_MODE" = "PRODUCCION" ]; then
  echo "Ejecutando en modo PRODUCCIÓN"
  echo " - Servidor en: http://$HOST:$PORT"
  echo " - Nivel de logs: $LOG_LEVEL"
else
  echo "Ejecutando en modo DESARROLLO"
  echo " - Servidor local en: http://$HOST:$PORT"
  echo " - Nivel de logs: $LOG_LEVEL"
fi

echo
echo "=============================="
echo "  FIN DEL SCRIPT"
echo "=============================="
read -p "Presiona Enter para finalizar..."

