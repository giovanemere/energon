-------------------------------------------------------------------------------------------------------------------------------------------
-  Variables assignments        - Description                                     - Examples
-------------------------------------------------------------------------------------------------------------------------------------------
  1. artefact="$1"              - Complemento de Shell Orquestador                - changeNumber | diffFiles | tagCreate | tagDelete |
  2. WorkSpaceTrigger="$2"   - Ruta Job Trigger                                - "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes"
  3. validateType="$3"          - Variable decision para changeNumber             - true | false
  4. WorkSpaceMPipeline="$4" - Ruta Job Orquestador                            - "/c/Users/s2176466/Desktop/Repositorios/common" 
  5. tmpCommit="$5"             - Archivo Variable Temporal Commit                - tmpCommit   
  6. getChangeNumber="$6"       - Archivo Variable Temporal Change Number         - changeNumber
  7. patternPointStable="$7"    - Filtro Git diff                                 - "^VP*"
  8. excludeFiles="$8"          - Filtro para Incluir o excluir Archivos          - excluir = true o incluiir = false
  9. branchType="$9"            - Rama la cual realiza acciones de git            - $TEMP_GIT_BRANCH = feature | hotfix
 10. patternFiles="${10}"       - patron Archivos para filtrar en el diff         - ".txt"
 11. uriUser="${11}"            - Usuario de Conexion a Repositorios Bitbucket    - "user bitbucket"
 12. urlBitbucket="${12}"            - URL repositorio de Aplicacion                   - "ruta repositorio"
 13. passwordGit="${13}"        - User Password Bitbucket                         - "user password bitbucket"
 14. getNewNextTag="${14}"      - Archivo Variable Temporal siguiente Tag         - NewNextTag 
 15. sourceShells               - Folder Bitbucket REposiotio Common              - BITBUCKET/sh-files

