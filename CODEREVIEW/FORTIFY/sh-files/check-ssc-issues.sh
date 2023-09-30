#!/bin/bash

## Variables de Entrada
    VarTokenFortify="${1}"
    VarKeyFortify="${2}"
    FileOutSscApiJson="${3}"
    FileOutPrettyJson="${4}"
    FileOutGrepJson="${5}"
    FortifyClient="${6}"
    ServerFortify="${7}"
    VersionFortify="${8}"
    ServerReportFortify="${9}"
    projectName="${10}"
    VarTokenCIFortify="${11}"

if [[ -z "$VarTokenFortify" ]]; # Si no se envia carpeta de repositorio de la aplicacion
        then
            echo  '---------------------------------------------------------------------'
            echo  '>>> Falla al variables  TokenFortify, VarKeyFortify, KeyFortify >>>>'
            echo  '--------------------------------------------------------------------'
            exit 
else
    #echo "--------------------------------"
    #echo "[1]:VarTokenFortify:[$VarTokenFortify] | [2]:VarKeyFortify:[$VarKeyFortify] | [3]:FileOutSscApiJson:[$FileOutSscApiJson] | [4]:FileOutPrettyJson:[$FileOutPrettyJson] | [5]:FileOutGrepJson:[$FileOutGrepJson] | [6]:FortifyClient:[$FortifyClient] | [7]:ServerFortify:[$ServerFortify] | [8]:VersionFortify:[$VersionFortify] | [9]:ServerReportFortify:[$ServerReportFortify] | [10]:projectName:[$projectName] | [11]:VarTokenCIFortify:[$VarTokenCIFortify]  "

    # nombre deñ Proyecto
    sscProjectName="$projectName"
    echo "--------------------------------"
    echo "sscProjectName: $sscProjectName"
    echo "--------------------------------"

    # obtener Id del proyecto en foritify
        #echo "$FortifyClient -url $ServerFortify -authtoken $VarTokenCIFortify listApplicationVersions | grep -E "$sscProjectName" | grep -E "$VersionFortify" | awk '{ print $1 }'"
        #echo "--------------------------------"
        sscProjectId=$($FortifyClient -url $ServerFortify -authtoken $VarTokenCIFortify listApplicationVersions | grep -E "$sscProjectName" | grep -E "$VersionFortify" | awk '{ print $1 }')
        
        # Imprimir ID Resultado
        echo "ci sscProjectId: $sscProjectId"
        echo "--------------------------------"

    # Contruccion de URL de fortify
        urlReportSSC="$ServerReportFortify/$sscProjectId/issues/"

    # Descargar Result en formato Json
        curl --connect-timeout 60 -k -X GET "$urlReportSSC" \
        -H "Accept: application/json" \
        -H "Authorization: FortifyToken $VarTokenFortify" > $FileOutSscApiJson

    # Formatar Json con python
        python3 -m json.tool $FileOutSscApiJson > $FileOutPrettyJson

    # Filtrar los friority
        grep "friority" $FileOutPrettyJson > $FileOutGrepJson

    # Filtrar por tipo
        lowFriority=$(grep -o -i "Low" $FileOutGrepJson | wc -l)
        mediumFriority=$(grep -o -i "Medium" $FileOutGrepJson | wc -l)
        highFriority=$(grep -o -i "High" $FileOutGrepJson | wc -l)
        criticalFriority=$(grep -o -i "Critical" $FileOutGrepJson | wc -l)
        totalFriority=$(($lowFriority + $mediumFriority + $highFriority + $criticalFriority))

    # imprimir resultados 
        echo "-------------------------------------------------------------------------------------"
        echo " URL Reporte SCC: $urlReportSSC"
        echo "-------------------------------------------------------------------------------------"
        echo " Priorty            | Result                                      "
        echo "-------------------------------------------------------------------------------------"
        echo " Low                | [$lowFriority]                           "
        echo " Medium             | [$mediumFriority]                        "
        echo " High               | [$highFriority]                          "
        echo " Critical           | [$criticalFriority]                      "
        echo "-------------------------------------------------------------------------------------"
    
    # Validación de Issues y Categorias de fortify
    if [[ $totalFriority -gt $total_sca_issues ]]; then
        
        echo " Total              | $totalFriority : Error: Total Friorities issues reached."
        echo "-------------------------------------------------------------------------------------"
        exit 1	
    else
        echo " Total              | $totalFriority : successfully: Total friorty issues passed successfully!"
        echo "-------------------------------------------------------------------------------------"
    fi
fi