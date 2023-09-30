#!/bin/bash
    clear

#####################################################################################################
# Seccion 1: Variables
#####################################################################################################
        
    # Load Variables Shell
        source  ../envvars/bitbucket_sh-files.sh

    # Variables Archivo Temporal
        tmpFiles="$WorkSpaceMPipeline/$sourceShells/$tmp"
        #tmpFiles="$tmpFiles"

    # Varables Proyecto    
        #echo "tmpFiles: $tmpFiles"
        tmpReport="$tmpFiles/$getNewNextTag"
        #echo "tmpReport: $tmpReport"
        tmpTagIni="$tmpFiles/$getInitTag"
        #echo "tmpTagIni: $tmpTagIni"
        tmpLogsIni="$tmpFiles/$tmpLogs"
        #echo "tmpLogsIni: $tmpLogsIni"

#####################################################################################################
# Seccion 2: Ayuda
#####################################################################################################

#Ayuda de Shell tagCreate
if [[ -z "$artifact" ]]; then
    
    #Filtro
        echo  '---------------------------------------------------------------------'
        echo  ' >>> Requiere parametros. recomendamos usar la ayuda  >>>>           '
        echo  ' >>> [ ./tagCreate.sh -h ] >>>>                                      '
        echo  '---------------------------------------------------------------------'
        
        exit 1

else

    #Ayuda de Shell
        if [ "$artifact" == "-h" ] ; then 

            cat ./help.sh

            echo ' ------------------------------------------------------------------------------------------------------------------------------------------'
            echo ' Ejemplo Ejecución'
            echo ' ------------------------------------------------------------------------------------------------------------------------------------------'
            echo '  1   cd /C/Users/s2176466/Desktop/Repositorios/common/BITBUCKET/sh-files/' 
            echo '  2   ./tagCreate.sh "NA" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "NA" feature "NA" "userbitbucket" "@bitbucket.agile.bns/projects/sccoldsoc/repos/common.git" "*****" "NewNextTag" "BITBUCKET/sh-files"'

            exit 0
            
        else
    #####################################################################################################
    # Seccion 3 : Funciones
    #####################################################################################################
    
    # Funcion Change Number Git Log
        functionCreateTag(){

            #Generar Tag
                git -C $WorkSpaceTrigger tag $newNextTag -m "$changeNumber" >>$tmpLogsIni
                #echo "git -C $WorkSpaceTrigger tag $newNextTag -m "$changeNumber"" >$tmpLogsIni

            #URL Bitbucket Externo
                git -C $WorkSpaceTrigger push $uriUser:$passwordGit$urlBitbucket $newNextTag $getRama >>$tmpLogsIni
                #echo "git -C $WorkSpaceTrigger push $uriUser:$passwordGit$urlBitbucket $newNextTag $getRama"    >>$tmpLogsIni
        }

    #####################################################################################################
    # Seccion 4 : Prerequisitios
    #####################################################################################################

    # Validate Variables por Componente
    #echo "crear tag: artifact:[$artifact] | WorkSpaceTrigger:[$WorkSpaceTrigger] | validateType:[$validateType] | WorkSpaceMPipeline:[$WorkSpaceMPipeline] | tmpCommit:[$tmpCommit] | changeNumber:[$changeNumber] | patternPointStable:[$patternPointStable] | excludeFiles:[$excludeFiles] | branchType:[$branchType] | patternFiles:[$patternFiles] | uriUser:[$uriUser] | urlBitbucket:[$urlBitbucket] | passwordGit:[$passwordGit] | getNewNextTag:[$getNewNextTag] | sourceShells:[$sourceShells] | branchName:[$branchName] | tmpdiffFiles:[$tmpdiffFiles] | tmpReportFiles:[$tmpReportFiles] | getInitTag:[$getInitTag] | getRama:[$getRama] | tmpLogs:[$tmpLogs] | domainUser:[$domainUser] | PathJira:[$PathJira] | TempEnvBitbucket:[$TempEnvBitbucket]"

    #Manejo de Errores
        if [[ -z "$WorkSpaceTrigger" ]]; then
        
            echo  '---------------------------------------------------------------------'
            echo  '>>> Falla al Obtener la carpeta de repositorio de la aplicacion FINALIZADO! con ERROR >>>>'
            echo  '--------------------------------------------------------------------'
            rm -rf "$WorkSpaceMPipeline"
            exit 1
        
        else
        
            # Definición de Correo y usuario para bitbucket
                git config --global user.email "$uriUser@$domainUser"
                git config --global user.name "$uriUser"
            
            # Cambiar directorio de repositorio de aplicacion
                cd "$WorkSpaceTrigger/"

            #Cambiar de Rama
                git -C "$WorkSpaceTrigger/" checkout $getRama
                #echo "git -C $WorkSpaceTrigger/ checkout $rama"

            # Valida tag Vacio
            if [[ -z "$changeNumber" ]]; then
                echo "No hay numero de cambio"
                exit 1

                else

                ############################################################################################
                # Obtener Variables por Ambiente
                ############################################################################################
            
                # echo "tempEnv = $tempEnv"
                    filtertag="$TempEnvBitbucket$envCom$patternGeneric"
                    echo "filtertag = $filtertag"

                ############################################################################################
                # Obtener Variables por Ambiente
                ############################################################################################

                    #Obtener Ultimo tag
                    lastTag=$(git -C "$WorkSpaceTrigger/" tag --sort=-v:refname | grep "$changeNumber" | grep "$filtertag" | head -1)
                    #echo "git -C $WorkSpaceTrigger/ tag --sort=-v:refname | grep $changeNumber | grep "$filtertag" | head -1"
                    echo ">> N lastTag    : << $lastTag >>"

                    #Contiene Tag?
                    TmpStable=$(echo "$lastTag" | grep  "$envCom" | wc -l)
                    echo ">> TmpStable    : << $TmpStable >>"

                    # No contine tag            
                    if [ "$TmpStable" == 0 ]; then                     
                        primero="Si"
                        temppatternPointStable=0
                        lastTag=0
                        
                        # Vlaidate brach Emergency or Normal
                        echo "branchType = $branchType"
                        if [ "$branchType" == "$tmpFeature" ]; then

                                echo "tmpFeature: $tmpFeature"
                                # Obtener el Ultimo Punto estable VPD
                                    #echo "tmpFeature: git -C $WorkSpaceTrigger tag --merged \"$getRama\" --sort=-taggerdate | grep \"$filterChgNormal\" | awk 'NR==1 {print; exit}' "
                                    firstTag=$(git -C "$WorkSpaceTrigger/" tag --merged "$getRama" --sort=-taggerdate | grep "$filterChgNormal" | awk 'NR==1 {print; exit}' )
                                    echo "firstTag = $firstTag"

                            else
                                if [ "$branchType" == "$tmpHotfix" ]; then

                                    echo "tmpHotfix: $tmpHotfix"
                                    # Obtener el Ultimo Punto estable VP
                                    #echo "tmpHotfix: git -C \"$WorkSpaceTrigger\" tag --merged \"$getRama\" --sort=-taggerdate | grep \"$filterChgEmergency\" | awk 'NR==1 {print; exit}' )"
                                    ##git tag --merged hotfix/CHG654512 --sort=-taggerdate | grep VP[0-9] | awk 'NR==1 {print; exit}'
                                    firstTag=$(git -C "$WorkSpaceTrigger/" tag --merged "$getRama" --sort=-taggerdate | grep "$filterChgEmergency" | awk 'NR==1 {print; exit}' )
                                    echo "firstTag = $firstTag"
                            fi
                        fi
                        
                        if [[ -z "$firstTag" ]]; then
                            echo "No hay Tag Inicial"
                            exit 1
                        fi
                    
                    # Si contiene Tag CHG-XX-#
                    else 
                        
                        primero="No"
                        firstTag=$lastTag
                        echo ">> N lastTag        : << $lastTag >>"

                        # Obtener el numero del tag
                         TmpStable=$(echo "$lastTag" | cut -d "$envCom" -f2)
                         echo "TmpStable = $TmpStable"
                        
                        if [[ "$TmpStable" =~ "$TempEnvBitbucket" ]]; then
                            
                            #seperar numero de [-d-1]
                            temppatternPointStable=$( echo "$lastTag" | cut -d "$envCom" -f3)
                         else
                            
                            #seperar numero de [-1]
                            temppatternPointStable=$( echo "$lastTag" | cut -d "$envCom" -f2)
                        fi
                    fi
                    echo "temppatternPointStable : $temppatternPointStable"

                    # Almacenar Variable NextTagName en carpetas vars
                     echo "$firstTag" >$tmpTagIni
                     echo "firstTag : $tmpTagIni"
                     cat -b $tmpTagIni

                    ############################################################################################
                    # Obtener Siguiente Tag por Ramas
                    ############################################################################################
                    
                        # Sumar siguiente Tag
                            tempNextTag=$(expr $temppatternPointStable + 1)
                             echo ">> - Tag Siguiente  : << $temppatternPointStable + 1 = $tempNextTag >>"

                    ############################################################################################    
                    # Crear Numero Cambio y siguiente tag    
                    ############################################################################################

                        # Crear Siguiente Tag
                            newNextTag="$changeNumber$envCom$TempEnvBitbucket$envCom$tempNextTag"
                    
                        # Logs
                            echo ">> -----------------|---------------------------|---------------------|----------------------| --------------------|"
                            echo ">> -  Primera Vez   |       Change Number       | Last Tag Inicial    |    Siguiente Tag     |        Rama         |"
                            echo ">> -   << $primero >>     |      << $changeNumber >>      | << $lastTag | $firstTag >> | << $newNextTag >>  |    << $branchName >>"
                            echo ">> -----------------|---------------------------|---------------------|-------------------------------| --------------------|"
                            echo ">> - Next Tag    : $newNextTag >>"
                        
                        # Almacenar Variable NextTagName en carpetas vars                
                         echo "$newNextTag" >$tmpReport
                         echo "newNextTag : $tmpReport"
                    
                    #####################################################################################################
                    # Seccion 5 : Ejecutar Funciones
                    #####################################################################################################
                    # Valida tag Vacio
                    if [[ "$lastTag" == 0 ]]; then

                     # Generar Configuraciones Previas
                        echo " Paso > Generar Primera vez el Tag"
                        echo "----------------------------------------------------------------------------------------------------"

                     # Llamar Funcion

                        functionCreateTag "$WorkSpaceTrigger" "$WorkSpaceMPipeline" "$tmpCommit" "$changeNumber" "$getRama" "$newNextTag" "$getNewNextTag" "$tmpFiles" "$uriUser" "$urlBitbucket" "$passwordGit" "$tempNextTag" "$tempNextTag" "$complementDsV" "$complement" "$complementDev" "$complementPrd" "$newNextTag" "$tmpTagIni" "$tmpReport" "$temppatternPointStable"

                            echo  '---------------------------------------------------------------------'
                            echo  '>>> Obtener Siguente Numero Cambio FINALIZADO! <<<'
                            echo  '---------------------------------------------------------------------'
                    
                     # Si existe tag 
                     else 
                        
                        echo '---------------------------------------------------------------------'
                        echo "Paso > Generar siguiente Numero de Tag"
                        echo '---------------------------------------------------------------------'

                        functionCreateTag "$WorkSpaceTrigger" "$WorkSpaceMPipeline" "$tmpCommit" "$changeNumber" "$getRama" "$newNextTag" "$getNewNextTag" "$tmpFiles" "$uriUser" "$urlBitbucket" "$passwordGit" "$tempNextTag" "$tempNextTag" "$complementDsV" "$complement" "$complementDev" "$complementPrd" "$newNextTag" "$tmpTagIni" "$tmpReport" "$temppatternPointStable"

                            echo  '---------------------------------------------------------------------'
                            echo  '>>> Obtener Siguente Numero Cambio FINALIZADO! <<<'
                            echo  '---------------------------------------------------------------------'
                    fi
            fi
     fi
  fi
fi