#!/bin/bash
    clear

    #####################################################################################################
    # Seccion 1: Variables
    #####################################################################################################
    
     # Load Variables Shell
      source  ../envvars/bitbucket_sh-files.sh

     # Variables Archivo Temporal
        tmpFiles="$WorkSpaceMPipeline/$sourceShells/$tmp"
        tmpFiles="$tmpFiles"
        #echo "tmpFiles: $tmpFiles"

     # Varables Proyecto

        tmpLogsIni="$tmpLogs"
        #echo "tmpLogsIni: $tmpLogsIni"
        > "$tmpLogsIni"
        #echo "pruebas echo "
        #cat -b "$tmpLogsIni"

        tmpInitTag="$getInitTag"
        #echo "tmpInitTag: $tmpInitTag"
        #cat -b $tmpInitTag

        https="://"
        conhttps="https$https"
        #echo "patternFiles: $patternFiles"

    #####################################################################################################
    # Seccion 2: Ayuda
    #####################################################################################################

    #Ayuda de Shell diffFiles
    if [[ -z "$artifact" ]]; then
        echo  '---------------------------------------------------------------------'
        echo  ' >>> Requiere parametros. recomendamos usar la ayuda  >>>>           '
        echo  ' >>> [ ./cycleRepos.sh -h ] >>>>                                     '
        echo  '---------------------------------------------------------------------'
        exit 1
    else

        # Validate Archivo de Repos
            #echo "grep \"$patternFiles\" \"$tmpInitTag\" > \"$tmpLogsIni\""
            grep "$patternFiles" "$tmpInitTag" > "$tmpLogsIni"
            cat -b "$tmpLogsIni"
        
            #Validación de archivo con Datos
            if [ -s "$tmpLogsIni" ]; then
                echo "El $tmpLogsIni tiene datos"
            else
                echo "El $tmpLogsIni no tiene datos"
                exit 1
            fi

        #Procesar
        while read -r line;
        do
            # Limpieza Variables
                TmpRama=""
                getRama=""
                branchType=""
                valRamaStag=""
                cleanVar=$(echo $line | sed -e 's/^.//' -e 's/.$//')

            # Obtener Variables
                TempLastCommitStaging=${cleanVar%/*}
                Temp1Chg=${changeNumber%\"}
                Temp2Chg=${Temp1Chg##\"}
                changeNumber=${Temp2Chg}
                TempUriBitbucket=${cleanVar##*$https}
                ServerBitbucket=${TempUriBitbucket%/projects/*}
                tmpUriUser="$conhttps${uriUser}"
                reducir=${cleanVar##*$ServerBitbucket/projects/}
                keyName=${reducir%/repos/*}
                tempProjectName=${reducir%/commits/*}
                projectName=${tempProjectName##*repos/} #Aplicacion : projectName
                tempReducir=${reducir##*commits/} 
                lastReleaseCommitId=$(echo "$tempReducir" | grep -Eo '".*?"(*SKIP)(*FAIL)|(\w+)')
                tmpReport="$tmpFiles/$projectName.txt"
                urlBitbucket="$tmpUriUser:$passwordGit@$ServerBitbucket/$folderSCM/$keyName/$projectName.git" #Construir URL
                urlBitbucketPull="$tmpUriUser@$ServerBitbucket/$folderSCM/$keyName/$projectName.git" #Construir URL

                echo  '---------------------------------------------------------------------'
                #echo "    TempLastCommitStaging  : $TempLastCommitStaging"
                echo "    # Cambio              : $changeNumber"            #CHG###
                echo "    TempUriBitbucket      : $TempUriBitbucket"
                #echo "    ServerBitbucket       : $ServerBitbucket"
                #echo "    UserBitbucket         : $UserBitbucket"
                echo "    reducir               : $reducir"
                echo "    Proyecto              : $keyName"                 #SSCOL
                #echo "    tempProjectName       : $tempProjectName"
                echo "    Repositorio           : $projectName"             #Repositorio
                echo "    Ultimo Commit         : $lastReleaseCommitId"
                echo "    urlBitbucket          : $urlBitbucket"    
                echo "    urlBitbucketPull      : $urlBitbucketPull"
                echo  '---------------------------------------------------------------------'
                echo  " URL : $projectName                                           "
            
            # Construir Folder
                pathCompress="$WorkSpaceMPipeline/$sourceShells/$folderCompress/$changeNumber"
                pathReadme="$WorkSpaceMPipeline/$sourceShells/$folderClone/$changeNumber"
                pathClone="$pathReadme/$keyName"
                pathCloneRepo="$pathClone/$projectName/"
                rm -rf "$pathCloneRepo"
                mkdir -p "$pathCloneRepo"

            # Clone N Repos
                echo '---------------------------------------------------------------------'
                git -C "$pathClone" clone "$urlBitbucket"
            
            # Ingresar Carpeta Clone    
                cd "$pathCloneRepo"

            # Ejeuctar Comandos
                git -C "$pathCloneRepo" init
                git -C "$pathCloneRepo" config --global user.name "$UserBitbucket"
                git -C "$pathCloneRepo" config --global user.email "$UserBitbucket@$domainUser"
                git -C "$pathCloneRepo" config --global core.autocrlf false
                git -C "$pathCloneRepo" config --global push.default current

            # Variables Repo por CommiT
                #echo "git -C \"$pathCloneRepo\" branch -r | grep $tmpStaging/$changeNumber | wc -l"
                valBranchStaging=$(git -C "$pathCloneRepo" branch -r | grep $tmpStaging/$changeNumber | wc -l)
                echo "valBranchStaging      : $valBranchStaging"
                    if [[ "$valBranchStaging" -eq 1 ]]; then

                        tmpRamaStaging=$(git -C "$pathCloneRepo" branch -r | grep $tmpStaging/$changeNumber )
                        getRamaStaging=$(echo ${tmpRamaStaging#*/})
                        branchTypeStaginf=$(echo ${getRama%/*})
                        
                        #                                                      CHGXXX                   feature
                        TmpRama=$(git -C "$pathCloneRepo" branch -r | grep $changeNumber | grep -E "$tmpFeature|$tmpHotfix" )                
                        getRama=$(echo ${TmpRama#*/})
                        branchType=$(echo ${getRama%/*})
                        valRamaStag=1

                        echo '---------------------------------------------------------------------'
                        echo "    Rama Pre-Produccion   : $getRamaStaging"
                        #echo "   TmpRama               : $TmpRama"
                        #echo "   getRama               : $getRama"
                        #echo "   branchType            : $branchType"
                        #echo "   valRamaStag           : $valRamaStag"

                    else
                        # Validar numero de ramas hotfix por changenumber
                        valBranchHotfix=$(git -C "$pathCloneRepo" branch -r | grep "$tmpHotfix/$changeNumber" | wc -l)
                        echo "valBranchHotfix       : $valBranchHotfix"
                        if [[ "$valBranchHotfix" -eq 1 ]]; then

                            #                                                CHGXXX                  feature
                            TmpRama=$(git -C "$TmpRama" branch -r | grep "$tmpHotfix/$changeNumber" )
                            getRama=$(echo ${TmpRama#*/})
                            branchType=$(echo ${getRama%/*})                    
                            valRamaStag=0

                            echo  '---------------------------------------------------------------------'
                            #echo "   TmpRama               : $TmpRama"
                            echo "   rama hotfix            : $getRama"
                            #echo "   branchType            : $branchType"
                            #echo "   valRamaStag           : $valRamaStag"
                        else

                            # Validar numero de ramas feature por changenumber
                            valBranchFeature=$(git -C "$pathCloneRepo" branch -r | grep $tmpFeature/$changeNumber | wc -l)                        
                            echo "valBranchFeature      : $valBranchFeature"

                                #                                                      CHGXXX                   feature
                                TmpRama=$(git -C "$pathCloneRepo" branch -r | grep $tmpFeature/$changeNumber )
                                getRama=$(echo ${TmpRama#*/})
                                branchType=$(echo ${getRama%/*})
                                valRamaStag=0

                                echo  '---------------------------------------------------------------------'
                                #echo "   TmpRama               : $TmpRama"
                                echo "   rama feature           : $getRama"
                                #echo "   branchType            : $branchType"
                                #echo "   valRamaStag           : $valRamaStag"
                        fi
                    fi
                #

                # valida si no aplica las ramas feature | hotfix | staging    
                if [[ -z "$getRama" ]]; then
                    echo  '---------------------------------------------------------------------'
                    echo  ' >>> Falla en Obtener Ramas Vacia >>>>           '
                    echo  '---------------------------------------------------------------------'
                    exit 1
                fi

                echo '---------------------------------------------------------------------'
                #echo "    pathClone             : $pathClone"               #BITBUCKET/sh-files/clones
                echo "    Repositorio Local     : $pathCloneRepo"           #BITBUCKET/sh-files/clones/vdigital_cf/
                echo "    Rama Origin Dev       : $TmpRama"                 #Rama feature | hotfix
                echo "    Rama Dev              : $getRama"                 #staging|feature|hotfix/CHG###
                #echo "    Rama Dev              : $branchType"              #staging|feature|hotfix
                echo "    1-> Existe Staging    : $valRamaStag"             # 1 | 0 
                echo '---------------------------------------------------------------------'
                        
                # Validar rama staging 
                    if [[ "$valRamaStag" = 0 ]]; then

                        getRamaStaging="$tmpStaging/$changeNumber"                     #Obtener Rama
                        echo "    Rama Pre-Produccion   : $getRamaStaging"

                        echo '---------------------------------------------------------------------'
                        echo " Crear rama $getRamaStaging "
                            
                            #echo "git -C \"$pathCloneRepo\" checkout -b \"$getRamaStaging\" \"$tmpMaster\""
                                git -C "$pathCloneRepo" checkout -b "$getRamaStaging" "$tmpMaster"
                                #   >>> git checkout -B staging/CHG12345                

                        echo '---------------------------------------------------------------------'
                        echo " Subir Cambios "
                        echo '---------------------------------------------------------------------'
                            
                            #echo "git -C \"$pathCloneRepo\" push \"$urlBitbucket\""
                                git -C "$pathCloneRepo" push "$urlBitbucket"

                            echo '---------------------------------------------------------------------'

                    fi

                # Ir Rama Feature y validar diferencias
                        #echo "git -C \"$pathCloneRepo\" checkout \"$getRama\""
                        git -C "$pathCloneRepo" checkout "$getRamaStaging"
                        #update rama
                        git -C "$pathCloneRepo" checkout "$getRama"

                # Diif Files
                    echo '---------------------------------------------------------------------'
                    echo " diff $getRamaStaging and $getRama "
                    echo '---------------------------------------------------------------------'
                        
                        #echo "git -C \"$pathCloneRepo\" diff \"$getRama\" \"$getRamaStaging\" --no-commit-id --name-only > \"$tmpReport\""
                        git -C "$pathCloneRepo" diff "$getRamaStaging" "$getRama" --no-commit-id --name-only > "$tmpReport"
                        echo '---------------------------------------------------------------------'
                        echo " Archivos a processar:  $tmpReport"
                        echo '---------------------------------------------------------------------'
                        cat -b "$tmpReport"
                        echo '---------------------------------------------------------------------'

                    #Validación de archivo con Datos
                        if [ -s "$tmpReport" ]; then
                                echo "El $projectName.txt tiene datos"
                        else
                                echo "El $projectName.txt no tiene datos"
                                exit 1
                        fi

                    #echo "git -C \"$pathCloneRepo\" checkout \"$getRama\""
                        git -C "$pathCloneRepo" checkout "$getRamaStaging"
                    

                    # Merge Feature a Staging
                        echo '---------------------------------------------------------------------'
                        echo " Merge $getRama and $tmpMaster "
                        echo '---------------------------------------------------------------------'
                    
                        #git -C "$pathCloneRepo" push "$urlBitbucket" "$getRama:$getRamaStag"
                        #echo "git -C \"$pathCloneRepo\" merge --no-ff \"$getRama\""
                        echo "    urlBitbucket          : $urlBitbucket"    
                        git -C "$pathCloneRepo" merge --no-ff "$getRama"
                        ##  >>> git merge --no-ff feature/CHG12345

                    # Actualizar clone
                        echo '---------------------------------------------------------------------'
                        echo " Actualizar Cambios Staging "
                        echo '---------------------------------------------------------------------'
                        echo "git -C \"$pathCloneRepo\" fetch --prune --prune --tags"
                        git -C "$pathCloneRepo" fetch --prune --prune --tags
                    
                    # Subir Cambios
                        echo "git -C \"$pathCloneRepo\"  push \"$urlBitbucket\" $getRamaStaging"
                        git -C "$pathCloneRepo" push "$urlBitbucket" $getRamaStaging
                        #echo "git -C $WorkSpaceTrigger push $uriUser:$passwordGit$urlBitbucket $newNextTag $getRama"

                    # Obtener Commit
                        lastStagingCommitId="$(git log -n 1 | grep "commit" | awk '{print $2}' | grep -v "commit" )"
                        urlLastCommitStaging=$TempLastCommitStaging/$lastStagingCommitId
                        echo '---------------------------------------------------------------------'
                        echo "urlLastCommitStaging: $urlLastCommitStaging"    
                        echo '---------------------------------------------------------------------'

                    # Copiar Archivos para comprimir
                        echo '---------------------------------------------------------------------'
                        echo " Procesar archivos a comprimir "
                        echo '---------------------------------------------------------------------'
                            
                            echo "mkdir -p $pathCompress/$keyName/$projectName"
                            mkdir -p "$pathCompress/$keyName/$projectName"

                            #Copiar Archivos de Bistbucket a Carpeta del Pipeline
                            cp --parents $(cat "$tmpReport") "$pathCompress/$keyName/$projectName"
                            ls -ltr "$pathCompress/$keyName/$projectName"

                        # Almacenar Variables para proximos stage
                            echo '---------------------------------------------------------------------'
                            echo " Creación Readme "
                            echo '---------------------------------------------------------------------'
                            #echo "$changeNumber+$newNextTag+$pathCloneRepo+$projectName+$tmpReport"
                            echo "      # Cambio  :   SSCOL    : Repositorio: Commit Staging                                     "
                            echo "$changeNumber: [ $keyName:$projectName:$urlLastCommitStaging ]" >> "$pathCompress/$readme"
                            cat -b "$pathCompress/$readme"

                        # Almacenar Variables para proximos stage
                            echo '---------------------------------------------------------------------'
                            echo " Variables para proceso de Compresion "
                            echo '---------------------------------------------------------------------'
                            #echo "$changeNumber+$newNextTag+$pathCloneRepo+$projectName+$tmpReport"
                            echo "$pathCompress" > "$tmpFiles/$fileEntrada"
                            cat -b "$tmpFiles/$fileEntrada"
                            
                    # Git Log Grafico
                        echo '---------------------------------------------------------------------'
                        echo " Git Log Grafico "
                        echo '---------------------------------------------------------------------'
                        #echo "git -C \"$pathCloneRepo\" log --pretty=format:\"%h %s\" --decorate --oneline --graph"
                        git -C "$pathCloneRepo" log --pretty=format:"%h %s" --decorate --oneline --graph

                    ###############################################################################################
                    # Tag Rama Feature
                    ##############################################################################################3

                        #update rama
                            git -C "$pathCloneRepo" checkout "$getRamaStaging"

                        # Generar Tag

                            newNextTag="ST_$changeNumber"

                            echo '---------------------------------------------------------------------'
                            echo " crear Tag : $newNextTag  "
                            echo '---------------------------------------------------------------------'

                            #echo "git -C \"$pathCloneRepo\"  tag $newNextTag -m \"$textTagPRD $changeNumber\""
                            git -C "$pathCloneRepo" tag $newNextTag -m "$textTagPRD $changeNumber"
                            #echo "git -C $WorkSpaceTrigger tag $newNextTag -m "$changeNumber"" >$tmpLogsIni

                            # Subir Cambios
                            #echo "git -C \"$pathCloneRepo\"  push \"$urlBitbucket\" $newNextTag $getRamaStaging"
                            git -C "$pathCloneRepo" push "$urlBitbucket" $newNextTag $getRamaStaging
                            #echo "git -C $WorkSpaceTrigger push $uriUser:$passwordGit$urlBitbucket $newNextTag $getRama"

        done < "$tmpLogsIni"

                #File Folder Compress
                echo '---------------------------------------------------------------------'
                echo " Contenido carpeta principal "
                echo '---------------------------------------------------------------------'
                echo "$pathCompress"
                ls -ltr "$pathCompress"

                echo '---------------------------------------------------------------------'
                echo " Contenido subfolder repositorios "
                echo '---------------------------------------------------------------------'
                ls -ltr "$pathCompress/$keyName/"
    fi