#!/bin/bash
    clear

#cd /c/Users/s2176466/Desktop/Repositorios/Arreglo/sterling/Arreglo/CHG98754-33/shellDeploy/Shells/
#./recorrer-artifact.sh "shellDeploy" "CHG98754-33" "CHG98754-ds-1" "tmpdiffFiles.tmp" "/c/Users/s2176466/Desktop/Repositorios/Arreglo/sterling/Arreglo" "ADAPTERS,OBSCUREDATA,XSLT,CERTIFICATES,BUSINESS_PROCESS,TEMPLATES,SCHEDULES,SSH_PROFILES,PARTNERS,GROUPS,ACCOUNTS_PERMISSION,CODE_LISTS,ROUTING_CHANNELS" "Tmp" "/c/Users/s2176466/Desktop/Repositorios/Arreglo/sterling/Arreglo/CHG98754-33/CHG98754-ds-1" "/c/Users/s2176466/Desktop/Repositorios/Arreglo/sterling/Arreglo/CHG98754-33/shellDeploy/Tmp"
############################################################################

folderShellsArtifact="$1"   # shellDeploy      
FolderDeploy="$2"           # CHG98754-33
getNewNextTag="$3"          # CHG98754-ds-1
tmpdiffFiles="$4"           # tmpdiffFiles.tmp
remoteDirPath="$5"          # /c/Users/s2176466/Desktop/Repositorios/Arreglo/sterling/Arreglo
ListArtifact="$6"           # "ADAPTERS,OBSCUREDATA,XSLT,CERTIFICATES,BUSINESS_PROCESS,TEMPLATES,SCHEDULES,SSH_PROFILES,PARTNERS,GROUPS,ACCOUNTS_PERMISSION,CODE_LISTS,ROUTING_CHANNELS"
VarTmp=$7                   # Tmp
VarsFolderRemoteTemp=$8     # /c/Users/s2176466/Desktop/Repositorios/Arreglo/sterling/Arreglo/CHG98754-33/CHG98754-ds-1
VarsFolderTemp=$9           #/c/Users/s2176466/Desktop/Repositorios/Arreglo/sterling/Arreglo/CHG98754-33/shellDeploy/Tmp

#Imprime Resultado de Diff de Bitbucket
echo "-----------------------------------------"
echo "Listado de Componentes a Validar"
echo "-----------------------------------------"
cat -b $VarsFolderTemp/$tmpdiffFiles
echo "."

echo "-----------------------------------------"
echo " Validacion de Componentes"
echo "-----------------------------------------"

#Definición de listado de Compoenetes
stringList="$ListArtifact"

for item in ${stringList//,/ }
do
    #Buscar y contar numero por componenete 1 o 0
    grep "$item" "$VarsFolderTemp/$tmpdiffFiles" | wc -l > "$VarsFolderTemp/$item"

    #Alamcena resultado de cada componente
    result=$(cat $VarsFolderTemp/$item)
    
    #Imprime la validación por componentes
    echo "[ $result ] : $item >> "
done
echo "-----------------------------------------"