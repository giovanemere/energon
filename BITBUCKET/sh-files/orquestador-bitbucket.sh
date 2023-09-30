#!/bin/bash
    clear
#####################################################################################################
# Seccion 1: Variables
#####################################################################################################
    
    source  ../envvars/bitbucket_sh-files.sh
    
#####################################################################################################
# Seccion 2: Ayuda
#####################################################################################################
    #Ayuda de Shell Orquestador
     if [[ -z $artifact ]]; # Si no se envia carpeta de repositorio de la aplicacion
        then
        echo  '---------------------------------------------------------------------'
        echo  ' >>> Requiere parametros. recomendamos usar la ayuda  >>>>           '
        echo  ' >>> [ ./orquestador-bitbucket.sh -h ] >>>>                          '
        echo  '---------------------------------------------------------------------'
        exit 1
    else

    #Ayuda de Shell
     if [ $artifact == "-h" ] ; then 

        cat ./help.sh

        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' Example Execute Orquesthator                                                                                                              '
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' # Ir a la carpeta de los shells de reoposiotio componenetes comunes                                                                       '
        echo ' # cd /C/Users/s2176466/Desktop/Repositorios/common/BITBUCKET/sh-files/                                                                    '
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' Incluir al inicio en todos los comandos ./orquestador-bitbucket.sh                                                                        '
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' changeNumber                                                                                                                              '
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' 1) "changeNumber" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" true "/c/Users/s2176466/Desktop/Repositorios/common" "tmpCommit" "changeNumber" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo ' 2) "changeNumber" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" false "/c/Users/s2176466/Desktop/Repositorios/common" "tmpCommit" "changeNumber" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' diffFiles                                                                                                                                 '
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' 1) "diffFiles" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "false" "feature" "xml" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo ' 2) "diffFiles" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "false" "feature" "txt" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo ' 3) "diffFiles" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "true" "feature" "*.xml" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo ' 4) "diffFiles" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" changeNumber "^VP*" "true" "feature" "*.txt" "NA" "NA" "NA" "NA" "BITBUCKET/sh-files"'
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' tagCreate                                                                                                                                 '
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' 1) "tagCreate" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "changeNumber" "^VP*" "NA" "feature" "NA" "DevSecOps_PRD_SVC_Ac" "@bitbucket.agile.bns/projects/sccoldsoc/repos/common.git" "*****" "NewNextTag" "BITBUCKET/sh-files"'
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' tagDelete                                                                                                                                 '
        echo ' -----------------------------------------------------------------------------------------------------------------------'
        echo ' 2) "tagDelete" "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes" "NA" "/c/Users/s2176466/Desktop/Repositorios/common" "NA" "changeNumber" "NA" "NA" "feature" "NA" "DevSecOps_PRD_SVC_Ac" "@bitbucket.agile.bns/projects/sccoldsoc/repos/common.git" "*****" "NewNextTag" "BITBUCKET/sh-files"'
        echo ' -----------------------------------------------------------------------------------------------------------------------'

        exit 0
        
    else

#####################################################################################################
# Seccion 3 : Funciones
#####################################################################################################
    
        #Validate Variables del Orquestador
        #echo "orquestador: artifact:[$artifact] | WorkSpaceTrigger:[$WorkSpaceTrigger] | validateType:[$validateType] | WorkSpaceMPipeline:[$WorkSpaceMPipeline] | tmpCommit:[$tmpCommit] | changeNumber:[$changeNumber] | patternPointStable:[$patternPointStable] | excludeFiles:[$excludeFiles] | branchType:[$branchType] | patternFiles:[$patternFiles] | uriUser:[$uriUser] | urlBitbucket:[$urlBitbucket] | passwordGit:[$passwordGit] | getNewNextTag:[$getNewNextTag] | sourceShells:[$sourceShells] | branchName:[$branchName] | tmpdiffFiles:[$tmpdiffFiles] | tmpReportFiles:[$tmpReportFiles] | getInitTag:[$getInitTag] | getRama:[$getRama] | tmpLogs:[$tmpLogs] | domainUser:[$domainUser] | PathJira:[$PathJira] | TempEnvBitbucket:[$TempEnvBitbucket] "
        
        #Cambiar de Ruta de Shells
        cd "$WorkSpaceMPipeline/$sourceShells/"

        #Inicia Proceso de Bitbucket
        echo
        echo '*********************************************************************************'
        echo 'Orquestador Bitbucket'
        echo '*********************************************************************************'
        echo

        scriptOrquestadorBitbucket="$WorkSpaceMPipeline/$sourceShells/$artifact.sh $artifact $WorkSpaceTrigger $validateType $WorkSpaceMPipeline $tmpCommit $changeNumber $patternPointStable $excludeFiles $branchType $patternFiles $uriUser $urlBitbucket $passwordGit $getNewNextTag $sourceShells $branchName $tmpdiffFiles $tmpReportFiles $getInitTag $getRama $tmpLogs $domainUser $PathJira $TempEnvBitbucket "
        $scriptOrquestadorBitbucket

    fi
fi

#Logs
## Variables diff
# echo "scriptOrquestadorBitbucket: $scriptOrquestadorBitbucket"

