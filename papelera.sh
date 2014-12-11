#!/bin/bash

OPCION=$1

case "$OPCION" in
"") 
	echo "Por favor elija una opción. Si no sabe usar el script use la opción de --help."
	echo "papelera.sh [ --help | --create | -r file [destino] | --info | --clean | file ]"
;;
--help)
	echo "Esta es la opción de ayuda. Opciones del script:"
	echo "papelera.sh [ --help | -r file [destino] | --info | --clean | file ]"
	echo "	--create	 			Crea la papelera en el HOME del usuario."
	echo "	-r file [destino]	 		Recupera un fichero o directorio de la papelera al directorio de destino. Si no se especifica el destino, se recupera en el directorio actual."
	echo "	--info					Se mostrará un pequeño informe indicando el número de ficheros que hay en la papelera y el número de directorios."
	echo "	--clean					Elimina todo el contenido de la papelera de forma definitiva."
	echo "	-i  					Menú que permite la eleccion de --clean o --info."
	echo "	file 					Nombre del fichero o directorio que queremos enviar a la papelera."
;;
--create)
	if	[ -a $HOME/.papelera ]; then 
		echo "La papelera existe."
	else
		mkdir $HOME/.papelera
		chmod 777 $HOME/.papelera
		echo "Papelera creada en el home del usuario."
	fi
;;
-r)
	echo "Ejecutando opción de recuperado..."
	OPCION2=$2
	OPCION3=$3
	if [ -a $HOME/.papelera ]; then
		if [ -a $HOME/.papelera/"$OPCION2" ]; then
			if [ "$OPCION3" == "" ]; then
				OPCION3=`pwd`
				mv $HOME/.papelera/"$OPCION2" "$OPCION3"/"$OPCION2"
				echo "Archivo o directorio $OPCION2 recuperado al directorio actual $OPCION3."
			else
				mv $HOME/.papelera/"$OPCION2" "$OPCION3"/"$OPCION2"
				echo "Archivo o directorio $OPCION2 recuperado al destino especificado $OPCION3."
			fi
		else
			echo "El fichero a recuperar no existe."
		fi
	else
		echo "Error, la papelera no existe."
	fi
;;
--info)
	if [ -a $HOME/.papelera ]; then
		echo "Esta es la opción de mostrar el número de ficheros y directorios."
		echo "Número de ficheros:"
		find $HOME/.papelera -type f | wc -l
		echo "Número de directorios:"
		find $HOME/.papelera -type d | wc -l
	else
		echo "La información no se puede mostrar porque no existe la papelera."
	fi
;;
--clean)
	echo "¿Desea realmente vaciar la papelera?"
	echo "(Si/No)"
	while true; do
		read valor
		if [ "$valor" == Si ]; then
			if	[ -a $HOME/.papelera ]; then 
				echo "Limpiando papelera..."
				rm -dfr $HOME/.papelera/*
				echo "Operación completada."
				break
			else
				echo "La papelera no se puede limpiar porque no existe."
				break
			fi
		elif [ "$valor" == No ]; then
			echo "Operación cancelada."
			break
		else
			echo "Por favor escriba 'Si' o 'No'."
		fi
	done
;;
-i)
	echo "Esta es la opción --clean o --info, especifique cual desea usar."
	read valor
	while true; do
		if [ "$valor" == --clean ]; then 
			echo "Limpiando papelera..."
			rm -dfr $HOME/.papelera/*
			echo "Operación completada."
			break
		elif [ "$valor" == --info ]; then
			echo "Esta es la opción de numero de ficheros y directorios."
			echo "Número de ficheros:"
			find $HOME/.papelera -type f | wc -l
			echo "Número de directorios:"
			find $HOME/.papelera -type d | wc -l
			break
		elif [ "$valor" == Cancelar ]; then
			echo "Operación cancelada"
			break
		else
			echo "La opción $valor no existe, elija '--clean' o '--info' o 'Cancelar' para salir."
			read valor
	fi
	done
;;
*)
	echo "Ejecutando opción de borrar archivo o directorio..."
	OPCION4=`pwd`
	if [ -a $HOME/.papelera ]; then
		if	[ -a "$OPCION4"/"$OPCION" ]; then
			mv "$OPCION4"/"$OPCION" $HOME/.papelera/"$OPCION"
			echo "Archivo o directorio con el nombre $OPCION borrado."
		else
			echo "El archivo o directorio no existe."
		fi
	else
		echo "La papelera no existe con lo cual no puede borrar el archivo o directorio, por favor ejecute el parámetro --create para crearla."
	fi
;;
esac
