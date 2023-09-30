#!/bin/bash
    clear

#####################################################################################################
# Seccion 1: Variables
#####################################################################################################

    # Variables assignments
        WorkSpaceTrigger="$1"            # "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes"
        WorkSpaceMPipeline="$2"          # "/c/Users/s2176466/Desktop/Repositorios/common" 
        tmpdiffFiles="$3"                # tmpCommit   
        changeNumber="$4"                # changeNumber
        typeCompres="$5"                 # zip
        sourceShells="$6"                # "BITBUCKET/sh-files"
        patternFiles="$7"                # XML
        tmp="$8"                         # tmp
            
    # Variables Fijas
        tmpFiles="$WorkSpaceMPipeline/$sourceShells/$tmp"
        #echo "tmpFiles: $tmpFiles"
    
    # Varables Proyecto
        tmpReport="$tmpFiles/$tmpdiffFiles"
        #echo "tmpReport: $tmpReport"
        pathArtifact="$tmpFiles/$changeNumber"
        #echo "$pathArtifact"
        pathArtifactZip="$WorkSpaceMPipeline/$changeNumber.$typeCompres"
        #echo "$pathArtifactZip"

    #####################################################################################################
    # Seccion 2: Ayuda
    #####################################################################################################

    #Ayuda de Shell diffFiles
    if [ -z "$WorkSpaceTrigger" ]; then # Si no se envia carpeta de repositorio de la aplicacion
        echo  '---------------------------------------------------------------------'
        echo  ' >>> Requiere parametros. recomendamos usar la ayuda  >>>>           '
        echo  ' >>> [ ./compressArtifact.sh -h ] >>>>                               '
        echo  '---------------------------------------------------------------------'
        
        rm -rf "$WorkSpaceMPipeline*"
        exit 1

    else

        #Ayuda de Shell
        if [ "$WorkSpaceTrigger" = "-h" ]; then

            echo '-------------------------------------------------------------------------------------------------------------------------------------------'
            echo ' Ejemplo Ejecución'
            echo ' ------------------------------------------------------------------------------------------------------------------------------------------'
            echo '  1   cd /c/Users/s2176466/Desktop/Repositorios/analytics_rep_col/Campaign' 
            echo '  2.  find "/c/Users/s2176466/Desktop/Repositorios/analytics_rep_col/Campaign" -type f -name "*XML"> "/c/Users/s2176466/Desktop/Repositorios/common/BITBUCKET/sh-files/tmp/tmpdiffFiles.tmp"'
            echo '  3.  cat "/c/Users/s2176466/Desktop/Repositorios/common/BITBUCKET/sh-files/tmp/tmpdiffFiles.tmp"'
            echo '  4.  cd /C/Users/s2176466/Desktop/Repositorios/common/BITBUCKET/sh-files/' 
            echo '  5.  ./compressArtifact.sh "/c/Users/s2176466/Desktop/Repositorios/analytics_rep_col/Campaign" "/c/Users/s2176466/Desktop/Repositorios/common" "tmpdiffFiles.tmp" "CHG156456" "zip" "BITBUCKET/sh-files" '
            echo '  6.  ./compressArtifact.sh "/c/Users/s2176466/Desktop/Repositorios/analytics_rep_col/Campaign" "/c/Users/s2176466/Desktop/Repositorios/common" "tmpdiffFiles.tmp" "CHG156456" "tar" "BITBUCKET/sh-files" '
            
            exit 0
            
        else
        
         #####################################################################################################
         # Seccion 3 : Funciones
         #####################################################################################################
                
         #Funcion expcluir Archivos
         functioncompresszip(){
             
            #Ejecución con Zip
            echo "-----------------------------------------------------------------------------------"
            echo ">>> Files Compress Zip: Total [ $validate ] <<<"
            echo "-----------------------------------------------------------------------------------"

            #Ejecuci[on de Compress de carpeta del artefacto final tipo zip
            echo "/bin/zip -r $pathArtifactZip $changeNumber"
            /bin/zip -r "$pathArtifactZip" "$changeNumber"
            #/c/Servicio/7-ZipPortable/App/7-Zip64/7z.exe a -w $pathArtifactZip $pathArtifact
            
         }

         #Funcion Change Number Files
         functioncompresstar(){
            
            #Ejecución con Tar
            echo "-----------------------------------------------------------------------------------"
            echo ">>> Files Compress Tar: Total [ $validate ] <<<"
            echo "-----------------------------------------------------------------------------------"

            #Ejecuci[on de Compress de carpeta del artefacto final tipo tar
            echo "/bin/tar cvf $pathArtifactZip $changeNumber"
            /bin/tar cvf "$pathArtifactZip" "$changeNumber"
            #/c/Servicio/7-ZipPortable/App/7-Zip64/7z.exe a -w $pathArtifactZip $pathArtifact
            
         }

            #####################################################################################################
            # Seccion 4 : Logs
            #####################################################################################################

            #Validate Variables por Componente
             echo "WorkSpaceTrigger:[$WorkSpaceTrigger] | WorkSpaceMPipeline:[$WorkSpaceMPipeline] | tmpdiffFiles:[$tmpdiffFiles] | changeNumber:[$changeNumber] | typeCompres:[$typeCompres] | sourceShells:[$sourceShells] | patternFiles:[$patternFiles]"

            ##Manejo de Errores
            if [ -z "$WorkSpaceTrigger" ]; then # Si no se envia carpeta de repositorio de la aplicacion
                echo  '---------------------------------------------------------------------'
                echo  '>>> Falla al Obtener la carpeta de repositorio de la aplicacion FINALIZADO! con ERROR >>>>'
                echo  '--------------------------------------------------------------------'
                exit 1
            else

                #Cambiar directorio de repositorio de aplicacion
                cd "$WorkSpaceTrigger"
                
                #listar los archivos
                validate="$( ls | wc -l )"
                    #echo "artefactos a procesar: [ $validate ]"

                #Revisar tipos de compresion de archivos
                if [ "$typeCompres" = "zip" ]; then # Paso para incluir extension de archivos
                        
                    #####################################################################################################
                    # Seccion 5 : Ejecutar Funcion Opcion 1
                    #####################################################################################################

                    functioncompresszip "$WorkSpaceTrigger" "$WorkSpaceMPipeline" "$changeNumber" "$tmpReport" "$pathArtifact"
                        
                        echo  '---------------------------------------------------------------------'
                        echo  '>>> Obtener Artefacto Comprimido <<<'
                        echo '--------------------------------------------------------------------'
                        
                        #Borrar Carpeta de Arttefactos
                            #rm -rf "$WorkSpaceTrigger"

                        #Listar Archivos
                            ls -ltr "$WorkSpaceTrigger"
                        echo  '---------------------------------------------------------------------'

                else #Paso para excluir extension de archivos
                        
                    #####################################################################################################
                    # Seccion 6 : Ejecutar Funcion Opcion 2
                    #####################################################################################################

                        functioncompresstar "$WorkSpaceTrigger" "$WorkSpaceMPipeline" "$changeNumber" "$tmpReport" "$pathArtifact"
                    
                        echo  '---------------------------------------------------------------------'
                        echo  '>>> Obtener Artefacto Comprimido <<<'
                        echo '---------------------------------------------------------------------'
                    
                            #Borrar Carpeta de Arttefactos
                            #rm -rf "$WorkSpaceTrigger"

                            #Listar Archivos
                            ls -ltr "$WorkSpaceTrigger"
                        echo  '---------------------------------------------------------------------'
                fi
            fi
        fi
    fi