#!/bin/bash
    clear
#####################################################################################################
# Seccion 1: Variables
#####################################################################################################
    
    source  ../envvars/bitbucket_sh-files.sh

    # Varables Proyecto
        # Variables Archivo Temporal
        tmpFiles="$WorkSpaceMPipeline/$sourceShells/$tmp"
        #tmpReport="$tmpFiles/$changeNumber"  
        #echo "tmpFiles: $tmpFiles"
        tmpReport="$tmpFiles/$changeNumber"
        #echo "tmpReport: $tmpReport"
    
#####################################################################################################
# Seccion 2: Ayuda
#####################################################################################################

    #Ayuda de Shell tagCreate
     if [[ -z "$artifact" ]]; # Si no se envia carpeta de repositorio de la aplicacion
        then
        echo  '---------------------------------------------------------------------'
        echo  ' >>> Requiere parametros. recomendamos usar la ayuda  >>>>           '
        echo  ' >>> [ ./tagDelete.sh -h ] >>>>                                      '
        echo  '---------------------------------------------------------------------'
        rm -rf "$WorkSpaceMPipeline*"
        exit 1
     else

    #Ayuda de Shell
     if [ "$artifact" == "-h" ] ; then 

        cat ./help.sh

        echo ' ------------------------------------------------------------------------------------------------------------------------------------------'
        echo ' Ejemplo Ejecución'
        echo ' ------------------------------------------------------------------------------------------------------------------------------------------'
        echo '  1   cd /C/Users/s2176466/Desktop/Repositorios/common/BITBUCKET/sh-files/' 
        echo '  2   ./tagDelete.sh "tagDelete" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "NA" "NA" feature "NA" userbitbucket "@bitbucket.agile.bns/projects/sccoldsoc/repos/common.git" "*****" "getNewNextTag" "BITBUCKET/sh-files" "develop"'

        exit 1
        
    else

#####################################################################################################
# Seccion 3 : Funciones
#####################################################################################################
    
    #Funcion Change Number Git Log
        functionDeleteTag(){
            
            #Delete Tag
             git tag -d "$getNewNextTag"
              #echo "git tag -d $getNewNextTag"
            
            # Push tag to remote repository on feature or hotfix branch
             git push $uriUser:$passwordGit$urlBitbucket --delete $getNewNextTag
              #echo "git push $uriUser:$passwordGit$urlBitbucket --delete $getNewNextTag"
            
        }

#####################################################################################################
# Seccion 4 : Logs
#####################################################################################################
    
    #Validate Variables por Componente
       echo "artifact:[$artifact] | WorkSpaceTrigger:[$WorkSpaceTrigger] | WorkSpaceMPipeline:[$WorkSpaceMPipeline] | changeNumber:[$changeNumber] | patternPointStable:[$patternPointStable] | excludeFiles:[$excludeFiles] | branchType:[$branchType] | patternFiles:[$patternFiles] | sourceShells:[$sourceShells] | branchName:[$branchName] | tmpdiffFiles:[$tmpdiffFiles] | tmpReportFiles:[$tmpReportFiles] | getInitTag:[$getInitTag] | getRama:[$getRama]"

    ##Manejo de Errores
     if [[ -z "$WorkSpaceTrigger" ]]; # Si no se envia carpeta de repositorio de la aplicacion
        then
            echo  '---------------------------------------------------------------------'
            echo  '>>> Falla al Obtener la carpeta de repositorio de la aplicacion FINALIZADO! con ERROR >>>>'
            echo  '--------------------------------------------------------------------'
            rm -rf "$WorkSpaceMPipeline*"
            exit 1
        else
            #Cmabiar directorio de repositorio de aplicacion
             cd "$WorkSpaceTrigger"
            
            #####################################################################################################
            # Seccion 5 : Ejecutar Funcion Opcion 1
            #####################################################################################################

            functionDeleteTag "$getNewNextTag" "$uriUser" "$passwordGit" "$urlBitbucket" "$branchName"

                echo  '---------------------------------------------------------------------'
                echo  ">>> Tag deleted: [$getNewNextTag] <<<"
                echo  '---------------------------------------------------------------------'
        fi
    fi
fi
