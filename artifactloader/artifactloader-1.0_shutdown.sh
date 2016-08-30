#!/bin/sh
# ----------------------------------------------------------------------------
#  Octavio Sanchez Huerta | osanchezhuerta@gmail.com
# ----------------------------------------------------------------------------

#   Artifact Loader Example
#	ps -ef | grep 'org.osanchezhuerta.artifact.ArtifactloaderApplication'
#	ps -fea | grep 'org.osanchezhuerta.artifact.ArtifactloaderApplication'

BASEDIR=`dirname $0`/.
BASEDIR=`(cd "$BASEDIR"; pwd)`
file_prop="$BASEDIR/artifactloader-1.0_config.properties"

echo "0.1. Shutdown artifactloader"
DIA=`date +"%d/%m/%Y"`
HORA=`date +"%H:%M"`

echo "0.2. Fecha inicio=$DIA:$HORA"
echo "0.3. Directorio base:$BASEDIR"
echo "-----------------------------------------------------"
if [ -f "$file_prop" ]
then
  echo "1.1. Archivo:$file_prop encontrado."

else
  echo "1.2. Archivo:$file_prop no encontrado."
  exit 1
fi
echo "-----------------------------------------------------"

APPLICATION_NAME=`sed '/^\#/d' $file_prop | grep 'bpmn.config.application.name'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
APPLICATION_NAME_PID="$APPLICATION_NAME.pid"


PID_FILE="$BASEDIR/$APPLICATION_NAME.pid"
if [ ! -f $APPLICATION_NAME_PID ]
    then
	  echo "1.3.1 Archivo PID:$APPLICATION_NAME_PID no se encuentra."
      echo "1.3.2.Proceso $APPLICATION_NAME_PID revise book json en caso de encontrar el ${APPLICATION_NAME} ejecutandose."
      exit 1
    fi

function check_if_pid_file_exists {
    if [ ! -f $APPLICATION_NAME_PID ]
    then
        echo "1.3. Archivo PID no encontrado: $APPLICATION_NAME_PID"
        exit 1
    fi
}

function check_if_process_is_running {
 if ps -p $(print_process) > /dev/null
 then
     return 0
 else
     return 1
 fi
}
 
function print_process {
    echo $(<"$APPLICATION_NAME_PID")
}
kill -TERM `cat $PID_FILE`
echo "EXIT_STATUS:$EXIT_STATUS"

echo "1.4 Fin ejecucion del artefacto"

