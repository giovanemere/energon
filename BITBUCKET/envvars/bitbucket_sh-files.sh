# Variables assignments
    artifact="${1}"             # changeNumber | diffFiles | tagCreate | tagDelete |
    sourceFolderTrigger="${2}"  # "/c/Users/s2176466/Desktop/Repositorios/sfg_comunes"
    validateType="${3}"         # true | false
    WorkSpaceMPipeline="${4}"   # "/c/Users/s2176466/Desktop/Repositorios/common" 
    tmpCommit="${5}"            # tmpCommit   
    changeNumber=$6             # changeNumber
    patternPointStable="${7}"   # "^VP*"
    excludeFiles="${8}"         # true o false
    branchType="${9}"           # $TEMP_GIT_BRANCH = feature | hotfix
    patternFiles="${10}"        # ".txt"
    uriUser="${11}"             # "https//bitbucket"
    urlBitbucket="${12}"        # "ruta repositorio"
    passwordGit="${13}"         # "user password bitbucket"
    getNewNextTag="${14}"       # "NewNextTag"
    sourceShells="${15}"        # "BITBUCKET/sh-files"
    branchName="${16}"          # develop | release | master | hotfix
    tmpdiffFiles="${17}"        # tmpdiffFiles.tmp
    tmpReportFiles="${18}"      # tmpReportFiles.tmp
    getInitTag="${19}"          # "InitTag"
    getRama="${20}"             # "tmpRama"
    tmpLogs="${21}"             # "tmpLogs.tmp"
    domainUser="${22}"          # "scotiabankcolpatria.com"
    PathJira="${23}"            # ${WorkSpaceMPipeline}/JIRA
    TempEnvBitbucket="${24}"    # d|u|ds|p


# Variables Fijas
    envCom="-"

# Variables Ramas
    tmpTrunk="trunk"
    tmpDevelop="develop"
    tmpRelease="release"
    tmpMaster="master"
    tmpHotfix="hotfix"
    tmpFeature="feature"
    tmpStaging="staging"

# Filter and Pattern
    patternFilter="*"
    patternChangeNumber="C[0-9]{1,20}|CHG[0-9]{1,20}"
    tmp="tmp"

# Textos predefinidos
    textTagPRD="pre-prd"

# Folder Temporal
    folderSCM="scm"
    folderClone="clones"
    folderCompress="compress"

# Cycle Compress
    fileEntrada="cycleCompress.tmp"
    tempEntrada="TempEntrada.tmp"
    tempArtifact="TempFileArtifact.tmp"
    temporal="temporal"
    typeCompres="tar"
    readme="Readme.txt"
    filterCompress="*.txt"