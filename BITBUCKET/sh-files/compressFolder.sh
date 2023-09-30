#!/bin/bash
    clear

#####################################################################################################
# Seccion 1: Variables
#####################################################################################################

    # Variables assignments
        VarsFolderCompress="$1"          # "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes"
        WorkSpaceMPipeline="$2"          # "/c/Users/s2176466/Desktop/Repositorios/common" 
        folderShellsArtifact="$3"        # shellDeploy
        typeCompres="$4"                 # zip            
    
    # Varables Proyecto
        pathArtifactZip="$folderShellsArtifact.$typeCompres"
        #echo "pathArtifactZip: $pathArtifactZip"

        folderCompress="$VarsFolderCompress/$folderShellsArtifact"
        #echo "folderCompress: $folderCompress"

    #####################################################################################################
    # Seccion 2: Ayuda
    #####################################################################################################

     #Ayuda de Shell diffFiles
      if [ -z "$VarsFolderCompress" ]; then # Si no se envia carpeta de repositorio de la aplicacion
        echo  '---------------------------------------------------------------------'
        echo  ' >>> Requiere parametros. recomendamos usar la ayuda  >>>>           '
        echo  ' >>> [ ./compressArtifact.sh -h ] >>>>                               '
        echo  '---------------------------------------------------------------------'
        
        exit 1

      else

        #Ayuda de Shell
         if [ "$WorkSpaceMPipeline" = "-h" ]; then

            echo '-------------------------------------------------------------------------------------------------------------------------------------------'
            echo ' Ejemplo Ejecución'
            echo ' ------------------------------------------------------------------------------------------------------------------------------------------'
            echo '  1   cd /c/Users/s2176466/Desktop/Repositorios/analytics_rep_col/Campaign' 
 
            exit 0
            
         else
        
    #####################################################################################################
    # Seccion 3 : Funciones
    #####################################################################################################
                
         #Funcion expcluir Archivos
          functioncompresszip(){
             
            #Ejecución con Zip
            echo "-----------------------------------------------------------------------------------"
            echo ">>> Files Compress Zip: Total [ $folderShellsArtifact ] <<<"
            echo "-----------------------------------------------------------------------------------"

            #Ejecuci[on de Compress de carpeta del artefacto final tipo zip
            /bin/zip -r "$pathArtifactZip" "$folderCompress"
            
          }

         #Funcion Change Number Files
          functioncompresstar(){
            
            #Ejecución con Tar
            echo "-----------------------------------------------------------------------------------"
            echo ">>> Files Compress Tar: Total [ $folderShellsArtifact ] <<<"
            echo "-----------------------------------------------------------------------------------"

            #Ejecuci[on de Compress de carpeta del artefacto final tipo tar
            #echo "/bin/tar -zcvf $pathArtifactZip $folderCompress"
            /bin/tar -C $VarsFolderCompress -cvf "$pathArtifactZip" "$folderShellsArtifact"
            
          }

        ###############################################################################
        # Seccion 4 : Logs
        ###############################################################################

             #Validate Variables por Componente
             #echo "VarsFolderCompress:[$VarsFolderCompress] | WorkSpaceMPipeline:[$WorkSpaceMPipeline] | folderShellsArtifact:[$folderShellsArtifact] | typeCompres:[$typeCompres] "

             #Cambiar directorio de repositorio de aplicacion
              cd "$VarsFolderCompress"

                #Revisar tipos de compresion de archivos
                if [ "$typeCompres" = "zip" ]; then # Paso para incluir extension de archivos
                        
                    ###################################################################
                    # Seccion 5 : Ejecutar Funcion Opcion 1
                    ###################################################################

                        functioncompresszip "$VarsFolderCompress" "$WorkSpaceMPipeline" "$folderCompress"
                        
                        echo  '-----------------------------------------------------------'
                        echo  '>>> Obtener Artefacto Comprimido <<<'
                        echo '------------------------------------------------------------'
                        
                        #Listar Archivos
                            mv "$pathArtifactZip" "$WorkSpaceMPipeline/"
                            ls -ltr "$WorkSpaceMPipeline/$pathArtifactZip"
                        echo  '-----------------------------------------------------------'

                else #Paso para excluir extension de archivos
                        
                    ###################################################################
                    # Seccion 6 : Ejecutar Funcion Opcion 2
                    ###################################################################

                        functioncompresstar "$VarsFolderCompress" "$WorkSpaceMPipeline" "$folderCompress"
                    
                        echo  '-----------------------------------------------------------'
                        echo  '>>> Obtener Artefacto Comprimido <<<'
                        echo '------------------------------------------------------------'
                    
                        #Listar Archivos
                            mv "$pathArtifactZip" "$WorkSpaceMPipeline/"
                            ls -ltr "$WorkSpaceMPipeline/$pathArtifactZip"
                        echo  '-----------------------------------------------------------'
                fi
        fi
      fi