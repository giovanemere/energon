#!/bin/bash

################################################################
# Description:
# This script sends a message card to a webhook.
################################################################
echo "Reused Script: send-message-card.sh"
################################################################
# Author: Marco Antonio Ortega Piedrahita
# email: marco.ortega@scotiabankcolpatria.com
################################################################
# REQUIREMENTS
################################################################
# This script does not need any environment varible configured.
################################################################
# Arguments:
# $1: Message card json file
# $2: Webhook
#

## Variables de Entrada
  messageCard=$1
  webhook=$2

if [[ -z "$dbWebhooks" ]]; # Si no se envia carpeta de repositorio de la aplicacion
        then
            echo  '---------------------------------------------------------------------'
            echo  '>>> Falla al variables  TokenFortify, VarKeyFortify, KeyFortify >>>>'
            echo  '--------------------------------------------------------------------'
            exit 
else

  echo "[1]:dbWebhooks:[$dbWebhooks] | [2]:devTeamWebhook:[$VarKeyFortify] "
  echo  '---------------------------------------------------------------------'

  curl -H 'Content-Type: application/json' \
    -X POST \
    -d @$messageCard \
    $webhook

  echo  '---------------------------------------------------------------------'
  echo "curl -H 'Content-Type: application/json' "
  echo " -X POST "
  echo " -d @$messageCard "
  echo "$webhook"

fi