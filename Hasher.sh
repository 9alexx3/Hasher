#!/bin/bash

# Script realizado por: 9alexx3 || variant
# VERSIÓN:1

#ESTETICA DEL BASH.
# ESTABLECE EL COLOR POR DEFECTO.
reset="\e[0m"

#  COLORES NORMALES
   Negro="\e[30m" Rojo="\e[0;31m"   Verde="\e[32m" Amarillo="\e[33m"
   Azul="\e[34m"  Purpura="\e[35m"  Cian="\e[36m"  Blanco="\e[37m"
#  CLARO
   CNegro="\e[1;30m"   CRojo="\e[1;31m"   CVerde="\e[1;32m" CAmarillo="\e[1;33m"
   CPurpura="\e[1;35m"  CCian="\e[1;36m"
#  NEGRITA
   NAmarillo="\e[2;33m" NAzul="\e[2;34m"

# SUBRAYADO CON COLOR
   S_Rojo="\e[4;31m"

punto="${reset}${NAmarillo}.${reset}"


#*****************************************************************************************************************
#                                       CREACIÓN DE FUNCIONES
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function errorLog(){
   error="${Rojo}ERROR${reset}${CPurpura}.${reset}\a "

   case "$1" in
   1) id="Tienes que poner un número comprendido entre ${CPurpura}1${reset} ${CAmarillo}y${reset} ${CPurpura}$2"
   ;;
   2) id="Debes poner ${reset}${CPurpura}'${reset}S${reset}${CPurpura}'${reset}${CAmarillo} para aceptar o ${reset}${CPurpura}'${reset}${Rojo}N${reset}${CPurpura}'${reset}${CAmarillo} para negar ${CCian}[${reset}S${reset}${Amarillo}/${reset}${Rojo}n${reset}${CCian}]"
   ;;
   3) id="Lo que ha introducido ${reset}${CNegro}(${reset}${CCian}${2}${reset}${CNegro})${reset}${CAmarillo} no se corresponde al signed sum de ${reset}${CPurpura}${3}"
   ;;
   4) id="El sum del fichero NO es el mismo sum que el oficial"
   ;;
   5) id="No se ha encontrado el archivo ${reset}${CNegro}(${CCian}${2}${reset}${CNegro})${reset}${CAmarillo} seleccionado en la ruta ${reset}${CRojo}${3}"
   ;;
   6) id="No existe la ruta ${reset}${CRojo}$2 ${punto}${CAmarillo} Inserte una ruta exacta correcta"
   ;;
   7) id="La ruta introducida ${reset}${CNegro}(${reset}${CCian}$2${reset}${CNegro})${reset}${CAmarillo} no contiene ficheros"
   ;;
   8) id="Los parámetros conocidos por el script son: ${reset}${Blanco}-m${reset}${CAmarillo} (--manual) y ${reset}${Blanco}-sh${reset}${CAmarillo} (--soporte-hash)"
   ;;
   esac

   echo -e "${error}${CAmarillo}${id}${punto}"
}
para=$#
function ayuda(){
   if [ "${1}" == "-m" ] || [ "${1}" == "--manual" ];then
      echo -e "${S_Rojo}AYUDA PARA EL USO DEL SCRIPT${reset}${Blanco}:${reset}\n"
      echo -e "${Azul}Comparar${reset}${Blanco}:${reset}"
      echo -e "1.- Se te preguntará por la ruta exacta, si pones mal la ruta"
      echo -e "se te volverá a preguntar hasta que la introduzcas bien."
      echo -e "2.- A continuación, se mostrarán TODOS los ficheros de esa carpeta"
      echo -e "(NO recursivamente) y tendrás que elegir uno de los anteriores para"
      echo -e "seguir. En caso, de que no haya ficheros en la ruta, se te volverá a"
      echo -e "preguntar la ruta. También si pones un fichero que no se encuentra en"
      echo -e "la lista mencionada anteriormente, no podrás seguir. Se tiene que escoger"
      echo -e "uno de los anteriores obligatoriamente."
      echo -e "3.- Luego, tendrás que introducir el hash oficial de la página para comparar"
      echo -e "entre el tuyo y el original. Una vez terminado, se te avisará si son iguales"
      echo -e "o diferentes.\n"
      echo -e "${Azul}Obtener${reset}${Blanco}:${reset}"
      echo -e "1.- Se te preguntará por la ruta exacta, si pones mal la ruta"
      echo -e "se te volverá a preguntar hasta que la introduzcas bien."
      echo -e "2.- A continuación, se mostrarán TODOS los ficheros de esa carpeta"
      echo -e "(NO recursivamente) y tendrás que elegir uno de los anteriores para"
      echo -e "seguir. En caso, de que no haya ficheros en la ruta, se te volverá a"
      echo -e "preguntar la ruta. También si pones un fichero que no se encuentra en"
      echo -e "la lista mencionada anteriormente, no podrás seguir. Se tiene que escoger"
      echo -e "uno de los anteriores obligatoriamente."
      echo -e "3.- Se mostrará una lista de todos los hashes que soporta este script del fichero"
      echo -e "y se te copiará en el portafolios."
      exit 1
   elif [ "${1}" == "-sh" ] || [ "${1}" == "--soporte-hash" ];then
      echo -e "\n${S_Rojo}SIGNED HASHES SOPORTADOS${reset}${Blanco}:${reset}"
      echo -e "\t-md5 ${CNegro}->${reset} 32 carácteres${punto}"
      echo -e "\t-sha1 ${CNegro}->${reset} 40 carácteres${punto}"
      echo -e "\t-sha224 ${CNegro}->${reset} 56 carácteres${punto}"
      echo -e "\t-sha256 ${CNegro}->${reset} 64 carácteres${punto}"
      echo -e "\t-sha384 ${CNegro}->${reset} 96 carácteres${punto}"
      echo -e "\t-sha512 ${CNegro}->${reset} 128 carácteres${punto}"
      exit 1
   elif [ "${para}" -eq 0 ];then
      unset para
      return
   else 
      errorLog 8
      exit
   fi
}

function PedirRutaSum(){
   echo -e "\n${Amarillo}Pon la ruta exacta donde se encuentra el fichero para el sum${punto}"
   read -rp " ·> " ruta_sum
   RutaExiste "${ruta_sum}" "ruta_sum"
}

function RutaExiste(){
  local ruta=$1
  variable=$2
  while [ "${v}" -eq 0 ];do
    if [[ -d "${ruta}" ]];then
        return
    else
        errorLog 6 "${ruta}"
        read -rp " ·> " ruta
        declare -g "${variable}"="${ruta}"
    fi
  done
}

function MostrarArchivo(){
   mapfile -t archivos < <(find "${ruta_sum}" -maxdepth 1 -type f -exec basename {} \;)
   
      if [ "${#archivos[@]}" -ne 0 ];then
         echo -e "\n${Rojo}${#archivos[@]}${reset} ${Purpura}archivo/s con ${reset}${Purpura}que es/son${reset}${Blanco}:${reset}\n${Azul}${archivos[*]}${reset}\n"
         return
      else
         errorLog 7 "${ruta_sum}"
         PedirRutaSum
         MostrarArchivo
      fi
}

function seleccionarArchivo(){
   echo -e "${Amarillo}Selecciona un archivo de los anteriores para obtener el sum${punto}"
   read -rp " ·> " fichero_sum
    
   while [ "${v}" -eq 0 ];do
         for i in "${archivos[@]}";do
            if [ "$i" == "${fichero_sum}" ];then
               return
            fi
        done
        errorLog 5 "${fichero_sum}" "${ruta_sum}"
        read -rp " ·> " fichero_sum
   done
}

function PedirRutaSumOficial(){
   echo -e "${Amarillo}Pon la sum exacta del fichero oficial para el sum${punto}"
   read -rp " ·> " oficial_sum

   while [ "${v}" -eq 0 ];do
      case "$1" in
      "md5")
            if ! echo "${oficial_sum}" | grep -E "[0-9a-f]{32}" >/dev/null;then
               errorLog 3 "${oficial_sum}" "MD5"
               read -rp " ·> " oficial_sum
            else 
               break
            fi
            
      ;;
      "sha1")
            if ! echo "${oficial_sum}" | grep -E "[0-9a-f]{40}" >/dev/null;then
               errorLog 3 "${oficial_sum}" "SHA1"
               read -rp " ·> " oficial_sum
            else 
               break
            fi
      ;;
      "sha224")
            if ! echo "${oficial_sum}" | grep -E "[0-9a-f]{56}" >/dev/null;then
               errorLog 3 "${oficial_sum}" "SHA224"
               read -rp " ·> " oficial_sum
            else 
               break
            fi
      ;;
      "sha256")
            if ! echo "${oficial_sum}" | grep -E "[0-9a-f]{64}" >/dev/null;then
               errorLog 3 "${oficial_sum}" "SHA256"
               read -rp " ·> " oficial_sum
            else 
               break
            fi
      ;;
      "sha384")
            if ! echo "${oficial_sum}" | grep -E "[0-9a-f]{96}" >/dev/null;then
               errorLog 3 "${oficial_sum}" "sha384"
               read -rp " ·> " oficial_sum
            else 
               break
            fi
      ;;
      "sha512")
            if ! echo "${oficial_sum}" | grep -E "[0-9a-f]{128}" >/dev/null;then
               errorLog 3 "${oficial_sum}" "SHA512"
               read -rp " ·> " oficial_sum
            else 
               break
            fi
      ;;
      esac
   done
}

function comprobar_Sum(){
   if [ "${oficial_sum}" == "${sum}" ];then
      echo -e "\n${Azul}Los hashes coinciden perfectamente, no hay ningún riesgo${punto}"
      sleep 10s
      clear
   else
      errorLog 4
      return
   fi
}
#*****************************************************************************************************************
#	                					      CREACIÓN DE VARIABLES GLOBALES
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
v=0 # Variable para los bucles del script.


#*****************************************************************************************************************
#	                					            EL SCRIPT EN SÍ
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ayuda "$1"

echo -e "\n${CVerde}Script Realizado por: 9alexx3 | variant"

while [ "${v}" -eq 0 ];do
   echo -e "\n${CRojo}1${reset}${CNegro}) ${reset}${Verde}Comparar${punto}"
   echo -e "${CRojo}2${reset}${CNegro}) ${reset}${Verde}Obtener${punto}"
   echo -e "${CRojo}3${reset}${CNegro}) ${reset}${Verde}Salir${punto}"
   read -rp " ·> " elegir
   case "${elegir}" in
   1)
      while [ "${v}" -eq 0 ];do
         echo -e "\n${CRojo}1${reset}${CNegro}) ${reset}${CVerde}MD5${punto}"
         echo -e "${CRojo}2${reset}${CNegro}) ${reset}${CVerde}SHA1${punto}"
         echo -e "${CRojo}3${reset}${CNegro}) ${reset}${CVerde}SHA224${punto}"
         echo -e "${CRojo}4${reset}${CNegro}) ${reset}${CVerde}SHA256${punto}"
         echo -e "${CRojo}5${reset}${CNegro}) ${reset}${CVerde}SHA384${punto}"
         echo -e "${CRojo}6${reset}${CNegro}) ${reset}${CVerde}SHA512${punto}"
         echo -e "${CRojo}7${reset}${CNegro}) ${reset}${CVerde}Salir${punto}"
         read -rp " ·> " comparacion
         case "${comparacion}" in
         1)
            clear
            echo -e "${NAzul}Se ha escogido el hash ${reset}${CPurpura}'${Rojo}MD5${reset}${CPurpura}'${punto}"
            PedirRutaSum
            MostrarArchivo
            seleccionarArchivo
            PedirRutaSumOficial "md5"
            sum=$(md5sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
            comprobar_Sum
            unset sum ruta_sum fichero_sum archivos oficial_sum
         ;;
         2)
            clear
            echo -e "${NAzul}Se ha escogido el hash ${reset}${CPurpura}'${Rojo}SHA1${reset}${CPurpura}'${punto}"
            PedirRutaSum
            MostrarArchivo
            seleccionarArchivo
            PedirRutaSumOficial "sha1"
            sum=$(sha1sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
            comprobar_Sum
            unset sum ruta_sum fichero_sum archivos oficial_sum
         ;;
         3)
            clear
            echo -e "${NAzul}Se ha escogido el hash ${reset}${CPurpura}'${Rojo}SHA224${reset}${CPurpura}'${punto}"
            PedirRutaSum
            MostrarArchivo
            seleccionarArchivo
            PedirRutaSumOficial "sha224"
            sum=$(sha224sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
            comprobar_Sum
            unset sum ruta_sum fichero_sum archivos oficial_sum
         ;;
         4)
            clear
            echo -e "${NAzul}Se ha escogido el hash ${reset}${CPurpura}'${Rojo}SHA256${reset}${CPurpura}'${punto}"
            PedirRutaSum
            MostrarArchivo
            seleccionarArchivo
            PedirRutaSumOficial "sha256"
            sum=$(sha256sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
            comprobar_Sum
            unset sum ruta_sum fichero_sum archivos oficial_sum
         ;;
         5)
            clear
            echo -e "${NAzul}Se ha escogido el hash ${reset}${CPurpura}'${Rojo}SHA384${reset}${CPurpura}'${punto}"
            PedirRutaSum
            MostrarArchivo
            seleccionarArchivo
            PedirRutaSumOficial "sha384"
            sum=$(sha384sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
            comprobar_Sum
            unset sum ruta_sum fichero_sum archivos oficial_sum
         ;;
         6)
            clear
            echo -e "${NAzul}Se ha escogido el hash ${reset}${CPurpura}'${Rojo}SHA512${reset}${CPurpura}'${punto}"
            PedirRutaSum
            MostrarArchivo
            seleccionarArchivo
            PedirRutaSumOficial "sha512"
            sum=$(sha512sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
            comprobar_Sum
            unset sum ruta_sum fichero_sum archivos oficial_sum
         ;;
         7)
            echo -e "\n${NAmarillo}Saliendo del script...${reset}"
            unset comparacion
            break
         ;;
         *) errorLog 1 7
         ;;
         esac
      done
   ;;
   2)
      PedirRutaSum
      MostrarArchivo
      seleccionarArchivo
      echo -e "\n${Cian}Los hashes del fichero ${reset}${CPurpura}'${reset}${Verde}${fichero_sum}${reset}${CPurpura}'${reset}${Cian} son:${reset}"
      hash_md5=$(md5sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
      hash_sha1=$(sha1sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
      hash_sha224=$(sha224sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
      hash_sha256=$(sha256sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
      hash_sha384=$(sha384sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
      hash_sha512=$(sha512sum "${ruta_sum}/${fichero_sum}" | cut -d " " -f1)
      echo -e "${Blanco}MD5: ${reset}${Azul}${hash_md5}${reset}"
      echo -e "${Blanco}SHA1: ${reset}${Azul}${hash_sha1}${reset}"
      echo -e "${Blanco}SHA224: ${reset}${Azul}${hash_sha224}${reset}"
      echo -e "${Blanco}SHA256: ${reset}${Azul}${hash_sha256}${reset}"
      echo -e "${Blanco}SHA384: ${reset}${Azul}${hash_sha384}${reset}"
      echo -e "${Blanco}SHA512: ${reset}${Azul}${hash_sha512}${reset}"
      mapfile por < <(
      echo "MD5: ${hash_md5}"
      echo "SHA1: ${hash_sha1}"
      echo "SHA224: ${hash_sha224}"
      echo "SHA256: ${hash_sha256}"
      echo "SHA384: ${hash_sha384}"
      echo "SHA512: ${hash_sha512}")
      echo "${por[@]}" | xclip -select clipboard
      echo -e "\n${Cian}Se te ha copiado al portapapales todos los hashes${punto}\n"
      sleep 10s
      unset hash_md5 hash_sha1 hash_sha224 hash_sha256 hash_sha384 hash_sha512 archivos ruta_sum fichero_sum por
   ;;
   3) echo -e "${NAmarillo}Saliendo del script...${reset}"
      break
   ;;
   *) errorLog 1 3
   ;;
   esac
done

