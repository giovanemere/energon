#!/bin/bash
    clear
#####################################################################################################
# Seccion 1: Variables
#####################################################################################################

    source  ../envvars/bitbucket_sh-files.sh
        
    # Varables Proyecto
       # Variables Archivo Temporal
         tmpFiles="$WorkSpaceMPipeline/$sourceShells/$tmp"
         #tmpFiles="$tmpFiles"
      
       #echo "tmpFiles: $tmpFiles"
        tmpReport="$tmpFiles/$changeNumber"
        #echo "tmpReport: $tmpReport"
      
       #echo "tmpTagIni: $tmpTagIni"
        tmpRama="$tmpFiles/$getRama"
        #echo "tmpRama: $tmpRama"

#####################################################################################################
# Seccion 2: Ayuda
#####################################################################################################

 #Ayuda de Shell changeNumber
    if [[ -z "$artifact" ]]; # Si no se envia carpeta de repositorio de la aplicacion
        then
        echo  '---------------------------------------------------------------------'
        echo  ' >>> Requiere parametros. recomendamos usar la ayuda  >>>>           '
        echo  ' >>> [ ./changeNumber.sh -h ] >>>>                                   '
        echo  '---------------------------------------------------------------------'
        rm -rf "$WorkSpaceMPipeline*"
        exit 1
    else

    #Ayuda de Shell changeNumber
    if [ "$artifact" == "-h" ] ; then 

        cat ./help.sh

        echo '-------------------------------------------------------------------------------------------------------------------------------------------'
        echo ' Ejemplo Ejecución'
        echo '-------------------------------------------------------------------------------------------------------------------------------------------'
        echo ' 1 cd /C/Users/s2176466/Desktop/Repositorios/common/BITBUCKET/sh-files/' 
        echo ' 2 ./changeNumber.sh "NA" "/mnt/d/Projects/Repositorios/DevOps/sfg_proc_00056" true "/mnt/d/Projects/Repositorios/giovanemere/devops-common" tmpCommit changeNumber "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo ' 3 ./changeNumber.sh "NA" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" false "/c/Users/s2176466/Desktop/Repositorios/common" tmpCommit changeNumber "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'

        exit 0
        
    else

#####################################################################################################
# Seccion 3 : Funciones
#####################################################################################################

    #Funcion Get Change Number Git Log
        functionGetChangeNumber(){
            
            #Obtener ultimo Commit
             
             git -C "$WorkSpaceTrigger" log -n 1 | grep commit | grep -v "*" | awk '{print $2}' >"$tmpFiles"/"$tmpCommit"
             #echo "git -C $WorkSpaceTrigger log -n 1 | grep commit | grep -v \"*\" | awk '{print $2}' >$tmpFiles/$tmpCommit"
            
            #Leer archivo
             lastReleaseCommitId=$(cat "$tmpFiles"/"$tmpCommit")

            #Obtener el numero de Cambio
             changeNumber=$(git -C "$WorkSpaceTrigger" log  --format=%B -n 1 "$lastReleaseCommitId" | grep -Eo 'C[0-9]{1,20}|CHG[0-9]{1,20}' | awk 'NR==1 {print; exit}') 

             #echo "git -C $WorkSpaceTrigger log  --format=%B -n 1 $lastReleaseCommitId | grep -Eo 'C[0-9]{1,20}|CHG[0-9]{1,20}' | awk 'NR==1 {print; exit}' "

             #echo "changeNumber: $changeNumber"

             #Clean Folder Temp
             #rm -rf "$tmpFiles"/*.tmp

            #Obtener Numero de Cambio con Ultimo Commit
             echo "$changeNumber" >$tmpReport
            
        }

    #Funcion Get Change Number Directory Files
        functionGetFileChangeNumber(){
            
            #Obtener ultimo Commit
             lastReleaseCommitId=$(git -C "$WorkSpaceTrigger" log -n 1 | grep "commit" | awk '{print $2}' | grep -v "commit")
             #echo "git -C $WorkSpaceTrigger log -n 1 | grep \"commit\" | awk '{print $2}' | grep -v \"commit\")"
             #echo "lastReleaseCommitId: $lastReleaseCommitId"
             #printf "\n"

             #git -C $SOURCE_REPOSITORY log -m -1 --name-only --diff-filter=dc --pretty="format:" $lastReleaseCommitId > $tmpCommit
              git -C "$WorkSpaceTrigger" show --stat --oneline "$lastReleaseCommitId" | grep -E ".sql|.txt|.xml" | awk '{$1=$1};1' | grep -Eo '^[^ ]+' | grep -Ev '^[0-9]{1,20}' > "$tmpFiles"/"$listDiffFiles"
              #echo "git -C $WorkSpaceTrigger show --stat --oneline $lastReleaseCommitId | grep -E \".sql|.txt|.xml\" | awk '{$1=$1};1' | grep -Eo '^[^ ]+' | grep -Ev '^[0-9]{1,20}' > $tmpFiles/$listDiffFiles"

             echo "Files in latest release branch merge:"
              cat "$tmpFiles"/"$listDiffFiles"
              printf "\n"

             changeNumberResult=$(grep -Eo '[0-9]{1,20}.sql|[0-9]{1,20}.txt|[0-9]{1,20}.xml' "$tmpFiles"/"$listDiffFiles" | sed '/^[[:space:]]*$/d' | awk 'NR==1 {print; exit}' | grep -Eo '[0-9]{1,20}')
              #echo "changeNumber: $changeNumberResult"
              echo "$changeNumberResult" > $changeNumber
              printf "\n"
            
        }

#####################################################################################################
# Seccion 4 : Logs
#####################################################################################################
    
    #Validate Variables por Componente
     #echo "artifact:[$artifact] | WorkSpaceTrigger:[$WorkSpaceTrigger] | WorkSpaceMPipeline:[$WorkSpaceMPipeline] | changeNumber:[$changeNumber] | patternPointStable:[$patternPointStable] | excludeFiles:[$excludeFiles] | branchType:[$branchType] | patternFiles:[$patternFiles] | sourceShells:[$sourceShells] | branchName:[$branchName] | tmpdiffFiles:[$tmpdiffFiles] | tmpReportFiles:[$tmpReportFiles] | getInitTag:[$getInitTag] | getRama:[$getRama]"

    #Manejo de Logs y Errores
    if [[ -z "$WorkSpaceTrigger" ]]; # Si no se envia carpeta de repositorio de la aplicacion
        then
            echo  '---------------------------------------------------------------------'
            echo  '>>> Falla al Obtener la carpeta de repositorio de la aplicacion FINALIZADO! con ERROR >>>>'
            echo  '--------------------------------------------------------------------'
            exit 1
        else
            if [[ "$validateType" = true ]]; then
                
                #Cambiar directorio de repositorio de aplicacion
                 cd "$WorkSpaceTrigger"

#####################################################################################################
# Seccion 5 : Ejecutar Funcion Opcion 1
#####################################################################################################
                    
                    functionGetChangeNumber "$WorkSpaceTrigger" "$WorkSpaceMPipeline" "$tmpCommit" "$changeNumber" "$uriUser" "$urlBitbucket" "$passwordGit" "$rama" "$getInitTag" "$getRama"

                    # Si no puede abrir el .log entonces arroja error            
                     if [ $(echo $?) -eq 2 ]; 
                     then
                        exit 1
                     else
                        if [ -f "$tmpReport" ]; then

                            echo  '---------------------------------------------------------------------'
                            echo  '>>> Prerequisitos Uso de Folder >>>>'
                            echo  '--------------------------------------------------------------------'
                            echo  "lastReleaseCommitId: $lastReleaseCommitId"
                            printf "\n"
                            echo  '--------------------------------------------------------------------'

                            #Assign Rama
                             rama="$branchType/$changeNumber"
                             #echo "rama: $rama"

                            # Almacenar Variable NextTagName en carpetas vars
                             echo "$rama" >$tmpRama

                            #Cambiar de Rama
                             git -C $WorkSpaceTrigger/ checkout $getRama
                             #echo "git -C $WorkSpaceTrigger/ checkout $rama"

                            echo  '---------------------------------------------------------------------'
                            echo  '>>> Obtener Numero Cambio FINALIZADO! <<<'
                            echo  '---------------------------------------------------------------------'
                                
                                # Ver numero de Cambio
                                #ls -ltr $tmpReport
                                #echo "---------------------------------------------"
                                
                                cat -b "$tmpReport"

                            # Ver Lista componentes del Commit
                            #printf "\n"
                            #echo  '--------------------------------------------------------------------'
                            #echo  '>>> Lista componentes del Commit >>>>'
                            #echo  '--------------------------------------------------------------------'
                            #
                            # git -C $WorkSpaceTrigger log -m -1 --name-only --diff-filter=dc --pretty="format:" $lastReleaseCommitId
                            # #echo "git -C $WorkSpaceTrigger log -m -1 --name-only --diff-filter=dc --pretty=\"format:\" $lastReleaseCommitId"

                            echo  '---------------------------------------------------------------------'
                            echo  '>>> Obtener Numero Cambio FINALIZADO! <<<'
                            echo  '---------------------------------------------------------------------'
                        else
                            echo  '>>> Numero de Cambio Vacio >>>>'
                            echo  '--------------------------------------------------------------------'
                            rm -rf "$WorkSpaceMPipeline*"
                            exit 1
                        fi	
                     fi
                else
                    
#####################################################################################################
# Seccion 6 : Ejecutar Funcion Opcion 2
#####################################################################################################

                    functionGetFileChangeNumber "$WorkSpaceTrigger" "$WorkSpaceMPipeline" "$tmpCommit" "$changeNumber" "$rama" "$getInitTag" "$getRama"

                    # Si no puede abrir el .log entonces arroja error
                     if [ $(echo $?) -eq 2 ]; 
                     then
                        exit 1
                     else
                        if [ -f "$tmpReport" ]; then
                            
                            #ls -ltr $tmpReport
                            #echo "---------------------------------------------"

                            cat -b "$tmpReport"

                            echo  '---------------------------------------------------------------------'
                            echo  '>>> Obtener Numero Cambio FINALIZADO! <<<'
                            echo  '---------------------------------------------------------------------'
                        else
                            echo  '>>> Numero de Cambio Vacio >>>>'
                            echo  '--------------------------------------------------------------------'
                            rm -rf "$WorkSpaceMPipeline*"
                            exit 1
                        fi
                     fi
            fi
        fi
    fi
fi