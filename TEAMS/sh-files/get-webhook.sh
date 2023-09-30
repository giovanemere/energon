#!/bin/bash

################################################################
# Description:
# This script filters a text file with a list of webhooks
# using Bitbucket project name. It returns the webhook needed
# depends on its project name.
################################################################
echo "Reused Script: get-webhook.sh"
################################################################
# Author: Marco Antonio Ortega Piedrahita
# email: marco.ortega@scotiabankcolpatria.com
################################################################
# REQUIREMENTS
################################################################
# projectName = Bitbucket project name (SCCOL*).
################################################################
# Arguments:
# $1: Text file with a list of webhooks 
# $2: Text file where is written the webhook taken.
#

## Variables de Entrada
    dbWebhooks=$1
    devTeamWebhook=$2

if [[ -z "$dbWebhooks" ]]; # Si no se envia carpeta de repositorio de la aplicacion
        then
            echo  '---------------------------------------------------------------------'
            echo  '>>> Falla al variables  TokenFortify, VarKeyFortify, KeyFortify >>>>'
            echo  '--------------------------------------------------------------------'
            exit 
else

    echo "[1]:dbWebhooks:[$dbWebhooks] | [2]:devTeamWebhook:[$VarKeyFortify] "
    echo  '---------------------------------------------------------------------'

    cat $dbWebhooks | grep "$projectName" | awk '{print $2}' > $devTeamWebhook

    if [ -s $devTeamWebhook ]
    then
        printf "\n"
        echo "DEV Webhook:"
        cat $devTeamWebhook
    else
        printf "\n"
        printf "Error: The webhook to $projectName project does not exist.\n"
        printf "Please, contact the admin to configure the webhook of $projectName on MS Teams channel.\n"
        #exit 1
    fi
fi