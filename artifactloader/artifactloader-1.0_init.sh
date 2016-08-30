#!/bin/sh
# ----------------------------------------------------------------------------
#  Octavio Sanchez Huerta | osanchezhuerta@gmail.com
# ----------------------------------------------------------------------------

#	Artifact Loader Example
#	ps -ef | grep 'org.osanchezhuerta.artifact.ArtifactloaderApplication'
#	ps -fea | grep 'org.osanchezhuerta.artifact.ArtifactloaderApplication'

BASEDIR=`dirname $0`/.
BASEDIR=`(cd "$BASEDIR"; pwd)`
file_prop="$BASEDIR/artifactloader-1.0_config.properties"

echo "0.1. Init artifactloader"
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


JAVAHOME=`sed '/^\#/d' $file_prop | grep 'bpmn.config.java.home'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
JAVAPATH=`sed '/^\#/d' $file_prop | grep 'bpmn.config.java.path'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
REPO=`sed '/^\#/d' $file_prop | grep 'bpmn.config.repo'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
JAVA_OPTS=`sed '/^\#/d' $file_prop | grep 'bpmn.config.java.opts'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
EXTRA_JVM_ARGUMENTS=`sed '/^\#/d' $file_prop | grep 'bpmn.config.java.arguments'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
JAR_ARTIFACT=`sed '/^\#/d' $file_prop | grep 'bpmn.config.jar.artifact'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
MAIN_ARTIFACT=`sed '/^\#/d' $file_prop | grep 'bpmn.config.jar.main'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
APPLICATION_NAME=`sed '/^\#/d' $file_prop | grep 'bpmn.config.application.name'  | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
APPLICATION_NAME_PID="$APPLICATION_NAME.pid"

PATH_JAVA="${JAVAHOME}${JAVAPATH}"

if [ ! -x "$PATH_JAVA" ] ; then
  echo "1.3. Error: JAVA_HOME=$PATH_JAVA no ha sido definida correctamente."
  echo "1.4. No se puede ejecutar $PATH_JAVA"
  exit 1
fi
echo "-----------------------------------------------------"

echo "2.1. Usando JAVA: $PATH_JAVA"
echo "2.2. Usando JAVA_OPTS: $JAVA_OPTS"
echo "2.3. Usando EXTRA_JVM_ARGUMENTS: $EXTRA_JVM_ARGUMENTS"

CLASSPATH_JAR="$REPO"/spring-data-commons-1.12.2.RELEASE.jar:"$REPO"/spring-core-4.2.7.RELEASE.jar:"$REPO"/spring-context-4.2.7.RELEASE.jar:"$REPO"/spring-expression-4.2.7.RELEASE.jar:"$REPO"/spring-aop-4.2.7.RELEASE.jar:"$REPO"/aopalliance-1.0.jar:"$REPO"/spring-context-support-4.2.7.RELEASE.jar:"$REPO"/spring-aspects-4.2.7.RELEASE.jar:"$REPO"/aspectjweaver-1.8.9.jar:"$REPO"/spring-orm-4.2.7.RELEASE.jar:"$REPO"/spring-test-4.2.7.RELEASE.jar:"$REPO"/spring-tx-4.2.7.RELEASE.jar:"$REPO"/spring-beans-4.2.7.RELEASE.jar:"$REPO"/spring-jdbc-4.2.7.RELEASE.jar:"$REPO"/spring-web-4.2.7.RELEASE.jar:"$REPO"/spring-webmvc-4.2.7.RELEASE.jar:"$REPO"/spring-jms-4.2.7.RELEASE.jar:"$REPO"/spring-messaging-4.2.7.RELEASE.jar:"$REPO"/db2jcc-4.17.29.jar:"$REPO"/db2java-4.17.29.jar:"$REPO"/db2jcc-4.17.29.jar:"$REPO"/db2jcc_license_cisuz-4.17.29.jar:"$REPO"/db2jcc_license_cu-4.17.29.jar:"$REPO"/db2policy-4.17.29.jar:"$REPO"/camel-spring-ws-2.14.4.jar:"$REPO"/spring-ws-core-2.1.4.RELEASE.jar:"$REPO"/spring-oxm-3.2.4.RELEASE.jar:"$REPO"/wsdl4j-1.6.1.jar:"$REPO"/spring-ws-support-2.1.4.RELEASE.jar:"$REPO"/spring-xml-2.2.2.RELEASE.jar:"$REPO"/camel-velocity-2.14.4.jar:"$REPO"/velocity-1.7.jar:"$REPO"/commons-lang-2.4.jar:"$REPO"/slf4j-api-1.6.4.jar:"$REPO"/jcl-over-slf4j-1.7.12.jar:"$REPO"/logback-classic-1.1.3.jar:"$REPO"/logback-core-1.1.3.jar:"$REPO"/joda-time-2.1.jar:"$REPO"/commons-pool2-2.4.2.jar:"$REPO"/com.ibm.mqjms-7.1.0.0.jar:"$REPO"/com.ibm.mq.jmqi-7.1.0.0.jar:"$REPO"/com.ibm.disthub2.dhbcore-7.5.0.0.jar:"$REPO"/ifxjdbc-4.10.JC1DE.jar:"$REPO"/cglib-3.1.jar:"$REPO"/asm-4.2.jar:"$REPO"/aspectjrt-1.7.4.jar:"$REPO"/dom4j-1.6.1.jar:"$REPO"/xml-apis-1.0.b2.jar:"$REPO"/commons-collections-3.2.1.jar:"$REPO"/commons-logging-1.1.1.jar:"$REPO"/commons-dbcp-1.3.jar:"$REPO"/commons-pool-1.5.4.jar:"$REPO"/camel-core-2.14.4.jar:"$REPO"/jaxb-impl-2.2.7.jar:"$REPO"/jaxb-core-2.2.7.jar:"$REPO"/jaxb-api-2.2.7.jar:"$REPO"/istack-commons-runtime-2.16.jar:"$REPO"/FastInfoset-1.2.12.jar:"$REPO"/jsr173_api-1.0.jar:"$REPO"/camel-spring-2.14.4.jar:"$REPO"/camel-jms-2.14.4.jar:"$REPO"/camel-jdbc-2.14.4.jar:"$REPO"/camel-cdi-2.14.4.jar:"$REPO"/deltaspike-core-api-1.0.2.jar:"$REPO"/deltaspike-core-impl-1.0.2.jar:"$REPO"/deltaspike-cdictrl-api-1.0.2.jar:"$REPO"/jms-1.1.jar:"$REPO"/activemq-camel-5.10.0.jar:"$REPO"/activemq-spring-5.10.0.jar:"$REPO"/xbean-spring-3.16.jar:"$REPO"/activemq-broker-5.10.0.jar:"$REPO"/activemq-openwire-legacy-5.10.0.jar:"$REPO"/geronimo-jta_1.0.1B_spec-1.0.1.jar:"$REPO"/activemq-pool-5.10.0.jar:"$REPO"/activemq-jms-pool-5.10.0.jar:"$REPO"/geronimo-jms_1.1_spec-1.1.1.jar:"$REPO"/activemq-client-5.10.0.jar:"$REPO"/hawtbuf-1.10.jar:"$REPO"/geronimo-j2ee-management_1.1_spec-1.0.1.jar:"$REPO"/commons-beanutils-1.9.2.jar:"$REPO"/spring-boot-starter-1.3.6.RELEASE.jar:"$REPO"/spring-boot-1.3.6.RELEASE.jar:"$REPO"/spring-boot-starter-logging-1.3.6.RELEASE.jar:"$REPO"/jul-to-slf4j-1.7.21.jar:"$REPO"/log4j-over-slf4j-1.7.21.jar:"$REPO"/snakeyaml-1.16.jar:"$REPO"/spring-boot-starter-security-1.3.6.RELEASE.jar:"$REPO"/spring-security-config-4.0.4.RELEASE.jar:"$REPO"/spring-security-core-4.0.4.RELEASE.jar:"$REPO"/spring-security-web-4.0.4.RELEASE.jar:"$REPO"/spring-boot-autoconfigure-1.3.6.RELEASE.jar:"$REPO"/spring-boot-starter-actuator-1.3.6.RELEASE.jar:"$REPO"/spring-boot-actuator-1.3.6.RELEASE.jar:"$REPO"/httpclient-4.1.1.jar:"$REPO"/httpcore-4.1.jar:"$REPO"/commons-codec-1.4.jar:"$REPO"/jackson-databind-2.6.7.jar:"$REPO"/jackson-datatype-joda-2.6.7.jar:"$REPO"/jackson-core-2.6.7.jar:"$REPO"/jackson-annotations-2.6.7.jar:"$REPO"/commons-io-2.5.jar:"$REPO"/ehcache-2.9.1.jar:"$REPO"/commons-math3-3.6.1.jar:"$REPO"/quartz-2.2.3.jar:"$REPO"/c3p0-0.9.1.1.jar

echo "2.4. CLASSPATH: $CLASSPATH_JAR"
echo "-----------------------------------------------------"

echo "3.1. ARTIFACT: $JAR_ARTIFACT"
echo "3.2. MAIN CLASS: $MAIN_ARTIFACT"
echo "3.3. APPLICATION NAME: $APPLICATION_NAME"

echo "-----------------------------------------------------"
echo "4.1 Ejecucion del artefacto"
exec "$PATH_JAVA" -classpath $JAVA_OPTS \
  $EXTRA_JVM_ARGUMENTS \
 -classpath "$CLASSPATH_JAR:$BASEDIR/$JAR_ARTIFACT" \
 -Dapp.name="$APPLICATION_NAME" \
 -Dapp.pid="$$" \
 -Dapp.repo="$REPO" \
 -Dbasedir="$BASEDIR" \
  "$MAIN_ARTIFACT" \
  "$APPLICATION_NAME" &
echo "-----------------------------------------------------"
echo "4.2 Fin ejecucion del artefacto"

