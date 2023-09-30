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
        tmpReport="$tmpFiles/$tmpdiffFiles"
        #echo "tmpReport: $tmpReport"
    
    #####################################################################################################
    # Seccion 2: Ayuda
    #####################################################################################################

 #Ayuda de Shell diffFiles
if [[ -z "$artifact" ]]; # Si no se envia carpeta de repositorio de la aplicacion
    then
    echo  '---------------------------------------------------------------------'
    echo  ' >>> Requiere parametros. recomendamos usar la ayuda  >>>>           '
    echo  ' >>> [ ./diffFiles.sh -h ] >>>>                                      '
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
        echo '  2   ./diffFiles.sh "diffFiles" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "false" "feature" "xml" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo '  3   ./diffFiles.sh "diffFiles" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "false" "feature" "txt" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo '  4   ./diffFiles.sh "diffFiles" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "true" "feature" "*.xml" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo '  5   ./diffFiles.sh "diffFiles" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "true" "feature" "*.txt" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'

        exit 0
        
  else

    #####################################################################################################
    # Seccion 3 : Funciones
    #####################################################################################################
            
    #Funcion expcluir Archivos
        functiondiffFilesExclude(){

            echo '---------------------------------------------------------------------'
            echo '>>> Función Exclude'
            echo '---------------------------------------------------------------------'
                
            #Obtener diferencia de tag Anterior y tag Nuevo
            git -C "$WorkSpaceTrigger" diff "$getNewNextTag" "$vpdInitTag" --no-commit-id --name-only | grep -Ev "$patternFiles" > "$tmpReport"
            #echo "git -C $WorkSpaceTrigger diff $getNewNextTag $penultimateTag --no-commit-id --name-only | grep -Ev $patternFiles > $tmpReport"
            echo "diff entre $vpdInitTag and $getNewNextTag"
        
            #git -C $SourceRepo diff $Previous_tag $NextTagName --no-commit-id --name-only | grep xml | xargs cp --parents -t $artifacType
            #ls -ltr $artifacType]

        }

    #Funcion Change Number Files
        functiondiffFilesInclude(){

            echo '---------------------------------------------------------------------'
            echo '>>> Función Include'
            echo '---------------------------------------------------------------------'
            
            #Obtener diferencia de tag Anterior y tag Nuevo
            git -C "$WorkSpaceTrigger" diff "$getNewNextTag" "$vpdInitTag" --no-commit-id --name-only | grep "$patternFiles" > "$tmpReport"
            #echo "git -C $WorkSpaceTrigger diff $getNewNextTag $penultimateTag --no-commit-id --name-only | grep -Ev $patternFiles > $tmpReport"
            echo "diff entre $vpdInitTag and $getNewNextTag"
        
            #git -C $SourceRepo diff $Previous_tag $NextTagName --no-commit-id --name-only | grep xml | xargs cp --parents -t $artifacType
            #ls -ltr $artifacType]
        }
    
    #####################################################################################################
    # Seccion 4 : Logs
    #####################################################################################################

    #Validate Variables del Orquestador
     #echo "artifact:[$artifact] | WorkSpaceTrigger:[$WorkSpaceTrigger] | validateType:[$validateType] | WorkSpaceMPipeline:[$WorkSpaceMPipeline] | tmpCommit:[$tmpCommit] | changeNumber:[$changeNumber] | patternPointStable:[$patternPointStable] | excludeFiles:[$excludeFiles] | branchType:[$branchType] | patternFiles:[$patternFiles] | uriUser:[$uriUser] | urlBitbucket:[$urlBitbucket] | passwordGit:[$passwordGit] | getNewNextTag:[$getNewNextTag] | sourceShells:[$sourceShells] | branchName:[$branchName] | tmpReportFiles:[$tmpReportFiles] | getInitTag:[$getInitTag] | getRama:[$getRama]"

   ##Manejo de Errores
   if [ -z "$WorkSpaceTrigger" ]; then # Si no se envia carpeta de repositorio de la aplicacion
        echo  '---------------------------------------------------------------------'
        echo  '>>> Falla al Obtener la carpeta de repositorio de la aplicacion FINALIZADO! con ERROR >>>>'
        echo  '--------------------------------------------------------------------'
        exit 1
    else       
            
      #Cambiar directorio de repositorio de aplicacion
      cd "$WorkSpaceTrigger"

      #####################################################################################################
      # Seccion 5 : Ejecutar Funcion Opcion 1
      #####################################################################################################

      #Variable vacia falla el pipeline
      if [ $vpdInitTag == 1 ] || [[ "$excludeFile" = true ]]; then #VPD.0.0.0

            functiondiffFilesExclude "$changeNumber" "$WorkSpaceTrigger" "$branchType" "$patternPointStable" "$patternFiles" "$tmpReportFiles" "$rama" "$getNewNextTag" "$vpdInitTag" "$tmpReportFiles"

                    echo '---------------------------------------------------------------------'
                    echo ">>> Folder: [ls -ltr $tmpReport]"
                    echo '>>> Listado de Archivos <<<'
                    echo '---------------------------------------------------------------------------------------------------------------------'

                    #Validar Archivos
                    cat -b "$tmpReport"

                    echo '---------------------------------------------------------------------'
                    echo  '>>> Obtener Numero Cambio FINALIZADO! <<<'
                    echo  '---------------------------------------------------------------------'

       else #Paso para excluir extension de archivos
            
        #####################################################################################################
        # Seccion 6 : Ejecutar Funcion Opcion 2
        #####################################################################################################

            functiondiffFilesInclude "$changeNumber" "$WorkSpaceTrigger" "$branchType" "$patternPointStable" "$patternFiles" "$tmpReportFiles" "$rama" "$getNewNextTag" "$vpdInitTag" "$tmpReportFiles"
                
                #Validar Archivos
                    echo '---------------------------------------------------------------------'
                    echo ">>> Folder: [ls -ltr $tmpReport]"
                    echo '>>> Listado de Archivos <<<'
                    echo '---------------------------------------------------------------------------------------------------------------------'

                    #Validar Archivos
                    cat -b "$tmpReport"

                    echo '---------------------------------------------------------------------'
                    echo  '>>> Obtener Numero Cambio FINALIZADO! <<<'
                    echo  '---------------------------------------------------------------------'
     fi
   fi
 fi
fi
