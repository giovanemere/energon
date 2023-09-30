#!/bin/bash
    clear

#Al llamar este shell 
#sh /Sterling/import/Shells/orquestador-deploy.sh "/Sterling/import" "Artifact_115" "ADAPTERS" "Migra2019"
# Jenkinsfile
# //                  1                 2            3           4
#sh './$OrqShell "$WORKSPACE"   "$VarsFolderRemoteNextTag" "ADAPTERS" "$PwdImport"'
#                 $FolderArtifact                   "Artefact"             

#Varables d"e" Orquestador"/Sterling/import" "
FolderArtifact="$1"
VarsFolderRemoteNextTag="$2"
Artifact="$3"
PwdImport="$4"
ShellImport="$5"

#Ajustar permisos de carpeta Artifacts
#chmod -R 740 $VarsFolderRemoteNextTag

echo "FolderArtifact: [$FolderArtifact] | VarsFolderRemoteNextTag: [$VarsFolderRemoteNextTag] | Artifact: [$Artifact] | PwdImport: [$PwdImport]  | ShellImport: [$ShellImport] "

echo "cd $FolderArtifact"
#Inicia Proceso de Despliegue
echo '\n*********************************************************************************'
echo 'Orquestador Despliegue STERLING'
echo '\n*********************************************************************************'

scriptImport="$FolderArtifact/$ShellImport $VarsFolderRemoteNextTag $Artifact $PwdImport"
$scriptImport
