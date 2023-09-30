#!/bin/bash
    clear

    #####################################################################################################
    # Seccion 1: Variables
    #####################################################################################################
    
     # Load Variables Shell
      source  ../envvars/bitbucket_sh-files.sh

     # Validate Variables del Orquestador
        #echo "artifact:[$artifact] | sourceFolderTrigger:[$sourceFolderTrigger] | validateType:[$validateType] | WorkSpaceMPipeline:[$WorkSpaceMPipeline] | tmpCommit:[$tmpCommit] | changeNumber:[$changeNumber] | patternPointStable:[$patternPointStable] | excludeFiles:[$excludeFiles] | branchType:[$branchType] | patternFiles:[$patternFiles] | uriUser:[$uriUser] | urlBitbucket:[$urlBitbucket] | passwordGit:[$passwordGit] | getNewNextTag:[$getNewNextTag] | sourceShells:[$sourceShells] | branchName:[$branchName] | tmpdiffFiles:[$tmpdiffFiles] | tmpReportFiles:[$tmpReportFiles] | getInitTag:[$getInitTag] | getRama:[$getRama] | tmpLogs:[$tmpLogs] | domainUser:[$domainUser] | PathJira:[$PathJira] "

     # Variables Archivo Temporal
        tmpFiles="$WorkSpaceMPipeline/$sourceShells/$tmp"
        tmpFiles="$tmpFiles"
        #echo "tmpFiles: $tmpFiles"

     # Varables Proyecto

        tmpLogsIni="$tmpFiles/$tmpLogs"
        #echo "tmpLogsIni: $tmpLogsIni"
        > "$tmpLogsIni"
        #echo "pruebas echo "
        #cat -b "$tmpLogsIni"
        #echo '---------------------------------------------------------------------'

        tmpInitTag="$PathJira/$getInitTag"
        #echo "tmpInitTag: $tmpInitTag"
        #cat -b $tmpInitTag

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

        # Validate Archivo
            #echo "grep \"$patternFiles\" \"$tmpInitTag\" > \"$tmpLogsIni\""
            grep "$patternFiles" "$tmpInitTag" > "$tmpLogsIni"
            #echo "prueba 2"
            cat -b "$tmpLogsIni"

        #Procesar
        while read -r line;
        do
        # Extraer
        cleanVar=$(echo $line | sed -e 's/^.//' -e 's/.$//')
        echo "cleanVar: $cleanVar"

        # Obtener Variables
            TempUriBitbucket=${cleanVar##*http://}
            ServerBitbucket=${TempUriBitbucket%/projects/*}
            tmpUriUser="http://${uriUser}"
            reducir=${cleanVar##*$ServerBitbucket/projects/}
            keyName=${reducir%/repos/*}
            tempProjectName=${reducir%/commits/*}
            projectName=${tempProjectName##*repos/} #Aplicacion : projectName
            tempReducir=${reducir##*commits/} 
            lastReleaseCommitId=$(echo "$tempReducir" | grep -Eo '".*?"(*SKIP)(*FAIL)|(\w+)')
            tmpReport="$tmpFiles/$projectName.txt"

            echo "TempUriBitbucket: $TempUriBitbucket"
            echo "ServerBitbucket: $ServerBitbucket"
            echo "    UserBitbucket         : $UserBitbucket"
            echo "    reducir               : $reducir"
            #echo "    keyName               : $keyName"
            #echo "    tempProjectName       : $tempProjectName"
            #echo "    projectName           : $projectName"
            #echo "    lastReleaseCommitId   : $lastReleaseCommitId"

        # URL Bitbucket
            urlBitbucket="$tmpUriUser:$passwordGit@$ServerBitbucket/scm/$keyName/$projectName.git" #Construir URL
            echo "urlBitbucket: $urlBitbucket"
            urlBitbucketPull="$tmpUriUser@$ServerBitbucket/scm/$keyName/$projectName.git" #Construir URL
            echo "urlBitbucketPull: $urlBitbucketPull"

        # Construir Folder
            pathClone="$WorkSpaceMPipeline/$sourceShells/clones"
            pathCloneRepo="$pathClone/$projectName/"
            rm -rf "$pathCloneRepo"
            mkdir -p "$pathCloneRepo"

        # Clone N Repos
            echo '---------------------------------------------------------------------'
            git -C "$pathClone" clone "$urlBitbucket"
            echo "git -C $pathClone clone $urlBitbucket"
        
        # Ingresar Carpeta Clone    
            cd "$pathCloneRepo/"

        # Ejeuctar Comandos
            git -C "$pathCloneRepo" init
            git -C "$pathCloneRepo" config --global user.name "$UserBitbucket"
            git -C "$pathCloneRepo" config --global user.email "$UserBitbucket@$domainUser"
            git -C "$pathCloneRepo" config --global core.autocrlf false
            git -C "$pathCloneRepo" config --global push.default current

        # Variables Repo por Commit

            #echo "git -C \"$pathCloneRepo\" log --format=%B -n 1 \"$lastReleaseCommitId\" | grep -Eo 'C[0-9]{1,20}|CHG[0-9]{1,20}' | awk 'NR==1 {print; exit}'"
            changeNumber=$(git -C "$pathCloneRepo" log --format=%B -n 1 "$lastReleaseCommitId" | grep -Eo 'C[0-9]{1,20}|CHG[0-9]{1,20}' | awk 'NR==1 {print; exit}')
            TmpRama=$(git -C "$pathCloneRepo" branch -r | grep "$changeNumber" | grep feature )
            if [[ -z "$TmpRama" ]]; then
                
                TmpRama=$(git -C "$pathCloneRepo" branch -r | grep "$changeNumber" | grep hotfix     )
                echo " es nula se asigna rama $TmpRama"
            fi

            getRama=$(echo ${TmpRama#*/})
            branchType=$(echo ${getRama%/*})
            getRamaStag="staging/$changeNumber"                     #Obtener Rama

            echo "    pathClone             : $pathClone"
            echo "    pathCloneRepo         : $pathCloneRepo"
            echo "    changeNumber          : $changeNumber"
            echo "    TmpRama               : $TmpRama"
            echo "    getRama               : $getRama"
            echo "    branchType            : $branchType"
            echo "    lastReleaseCommitId   : $lastReleaseCommitId"
            echo "    getRamaStag           : $getRamaStag"

        # Validar Rama Staging
        ValidateRamaStag=$(git -C "$pathCloneRepo" branch -r | grep "$changeNumber" | grep "staging/$changeNumber" | wc -l)

        if [[ "$ValidateRamaStag" == 1 ]]; then

            git -C "$pathCloneRepo" push "$urlBitbucket" --delete "$getRamaStag"

            echo '---------------------------------------------------------------------'
            echo "     Salir de la Shell"
            echo '---------------------------------------------------------------------'
            exit 1
            
            else

                cd "$pathCloneRepo"

                git -C "$pathCloneRepo" pull --tags
                nameTad=$(git -C "$pathCloneRepo" tag -l | grep "$changeNumber")
                git -C "$pathCloneRepo" push "$urlBitbucket" origin :$nameTad
                git -C "$pathCloneRepo" push "$urlBitbucket" origin :staging/"$changeNumber"         
                    
            # Subir Cambios
                echo '---------------------------------------------------------------------'
                echo " Git Log Grafico "
                echo '---------------------------------------------------------------------'
                git -C "$pathCloneRepo" log --pretty=format:"%h %s" --decorate --oneline --graph

            # Preparar Pull Request
            #    git -C "$pathCloneRepo" request-pull "$getRamaStag" "$urlBitbucketPull" "$getRama"
            #    echo '---------------------------------------------------------------------'
        fi
     done < "$tmpLogsIni"
    fi