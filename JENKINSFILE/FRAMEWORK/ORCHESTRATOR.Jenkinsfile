pipeline {
    agent { label 'principal' }
    environment {
            WorkSpaceMPipeline = "$WORKSPACE"
            VarsAPP = "$WorkSpaceMPipeline/JENKINSFILE/envvars/SCCOLSFG.cfg"
            VarsJenkinsfile = "$WorkSpaceMPipeline/JENKINSFILE/envvars/jenkins.cfg"
    } 
    stages {
        stage ('Variables - Master'){
         steps {
          script {
            // Worspace
                load "$VarsAPP"
                load "$VarsJenkinsfile"
                load "$VarsTrigger"
                    env.BranchName = TEMP_GIT_BRANCH.substring(TEMP_GIT_BRANCH.indexOf('/')+1)
                load "$VarsBitbucket"
                     env.VarsFolderClone = "${VarsPathShfiles}/${folderCompress}"  // 
                load "$VarsTeams"
                load "$VarsJfrog"
                load "$VarsJira"
                    env.JIRA_URL = "${ServerJira}${projectName}"
                    env.pathFile = "${PathJira}/${VarTmp}"
                    echo " PathJira : ${PathJira}"
                load "$VarsSonar"
                    env.SONAR_URL = "${ServerSonar}${projectName}${appName}"
                load "$VarsFortify"
                load "$VarsBlackDuck"                    
            // Variables por Ambiente
                    def TempAgentLabel
                    def TempVarsEnvironment
                    def TempVarsUserBitbucket
                    def TemVarsPrivileges
                    def TemVarsComPrivileges
                    def TemTeamsWebhook
                    def TempEnv
                    def TemPatternPointStable
                // Variables DEV
                    if ( env.WorkSpaceMPipeline.contains("${envFolderDev}") ){          
                        TempAgentLabel = "${appName}_${envDevPath}"
                        TempVarsEnvironment = "${envDevPath}"
                        TempVarsUserBitbucket = "${findUserBitbucketIronHide}"
                        TempEnv = "${envDev}"
                        TemPatternPointStable = "${patternPointPrev}${patternGeneric}"
                        TemTeamsWebhook = sh (script: 'grep ${projectName} ${ProdTeamsWebhook} ', returnStdout: true).trim()
                    } 
                // Variables UAT
                    else if ( env.WorkSpaceMPipeline.contains("${envFolderUat}") ) {  
                        TempAgentLabel = "${appName}_${envUatPath}"
                        TempVarsEnvironment = "${envUatPath}"
                        TempVarsUserBitbucket = "${findUserBitbucketBumblebee}"
                        TempEnv = "${envUat}"
                        TemPatternPointStable = "${patternPointPrev}${patternGeneric}"
                    } 
                // Variables PROD
                    else if ( env.WorkSpaceMPipeline.contains("${envPrdPath}") ) {
                        TempAgentLabel = "${appName}_${envPrdPath}"
                        TempEnv = "${envPrd}"
                        TemPatternPointStable = "${patternPointProd}${patternGeneric}"
                    } 
                // Variables DEVOPS
                    else if ( env.WorkSpaceMPipeline.contains("${envFolderDvS}") ) {  
                        TempAgentLabel = "${appName}_${envDvSPath}"
                        TempVarsEnvironment = "${envDvSPath}"
                        TemPatternPointStable = "${patternPointPrev}${patternGeneric}"
                        if ( "${branchName}" == "develop" )  {
                            TempEnv = "${envDev}"
                            } else { TempEnv = "${envDsV}" }
                        TempVarsUserBitbucket = "${findUserBitbucketIronHide}"
                        TemTeamsWebhook = sh (script: 'grep ${projectName} ${DevTeamsWebhook} ', returnStdout: true).trim() 
                    }
                env.patternPointStable = "${TemPatternPointStable}"                
                env.TempEnvBitbucket = "${TempEnv}"
                env.AgentLabel = "${TempAgentLabel}"
                env.VarEnviron = "${TempVarsEnvironment}"
                env.FindUserBitbucket = "${TempVarsUserBitbucket}"
                env.TeamsWebhook  = TemTeamsWebhook.substring(TemTeamsWebhook.indexOf(' '))
            // Credenciales de Bitbucket
                withCredentials([usernamePassword(credentialsId: "${FindUserBitbucket}", passwordVariable: 'tmppasswordGit', usernameVariable: 'tmpUserBitbucket')]){ // Obtener usuario y password de Bitbucket
                    script {
                        env.UserBitbucket = "${tmpUserBitbucket}"                                           // Get User bitbucket
                        env.ComUriUser = env.TEMP_GIT_URL.substring(0,env.TEMP_GIT_URL.indexOf('/')+2)      // Extract URL Bitbucket After @
                        env.uriUser = "${ComUriUser}${UserBitbucket}"                                       // echo "env.ComUriUser=${env.ComUriUser}"
                        //echo "ComUriUser: ${ComUriUser}"
                        env.ComUrlBitbucket = env.TEMP_GIT_URL.substring(env.TEMP_GIT_URL.indexOf('/')+2)   // Extract URL Bitbucket Before 
                        env.urlBitbucket = "@${ComUrlBitbucket}"                                            // Concat @Complemet URL Bitbucket
                        //echo "urlBitbucket: ${urlBitbucket}"
                        env.folderExecShells = "${WorkSpaceMPipeline}/${sourceShells}"                      // Shell de Folder
                        env.execShell = "${WorkSpaceMPipeline}/${sourceShells}/${shellOrchestator}"         // Assing Variable execute Shell Orchestator
                        env.execShellCompressArtifact = "${WorkSpaceMPipeline}/${sourceShells}/${shellCopyArtifact}" // Assing Variable execute Shell Compress Artifact
                        env.execShellCompressFolder = "${WorkSpaceMPipeline}/${sourceShells}/${shellCopyFolder}" // Assing Variable execute Shell Compress Folder ShellDeploy
                        //echo "execShellCompressFolder: ${execShellCompressFolder}"
                        sh 'chmod +x ${sourceShells}/*.sh'               // Assing Permisos de Ejecución Shells
                        sh 'chmod +x ${sourceShellsFortify}/*.sh'        // Assing Permisos de Ejecución Shells
                    }
                }
                env.FolderDeploy = "${changeNumber}-$BUILD_NUMBER"                          // CHG98432-130
            // Variables Proyectos
            // Notificacion de Inicio en Teams
                if ( "${disableTeams}" == "1")  {
                    env.Color = "${ColorGreen}"
                    env.PipelineStatus = "${PipelineStart}"
                    env.msTeamsTmpMessageCard = "${WorkSpaceMPipeline}/${TemporaryMessageCard}"
                    env.msTeamsMessageCard = "${WorkSpaceMPipeline}/${MessageCard}"
                    env.msTeamsShell = "${WorkSpaceMPipeline}/${SendMessageCard}"
                    env.team = "${VarEnviron}"
                    sh ('chmod +x $msTeamsShell && envsubst < $msTeamsMessageCard > $msTeamsTmpMessageCard && $msTeamsShell $msTeamsTmpMessageCard $TeamsWebhook')
                }
          }
         }
        }
        stage ('Variables - Compile Agent Slaves'){
            agent { label "${AgentLabel}" }
            options { skipDefaultCheckout(true) }
            stages { stage ('Identity Environtment'){
                    parallel {
                        stage('Environtment - DEVOPS'){
                            when { expression { "${BranchName}" =~ 'trunk' } }
                            steps { script { env.remoteDirPath = "$WORKSPACE" } }
                        } 
                        stage('Environtment - DEV'){
                            when { expression { "${BranchName}" == 'develop' } }
                            steps {  script {  env.remoteDirPath = "$WORKSPACE" } }
                        }
                        stage('Environtment - UAT'){
                            when { expression { "${BranchName}" == 'release' } }
                            steps { script { env.remoteDirPath = "$WORKSPACE" } }
                        }
                        stage('Environtment - PRD'){
                            when { expression { "${BranchName}" =~ /^(hotfix|master)$/ } }
                            steps { script { env.remoteDirPath = "$WORKSPACE" } }
                        }
                    }
                }  
            }
        }
        stage ('Bitbucket - Create Tag'){
         steps {
          withCredentials([usernamePassword(credentialsId: "${FindUserBitbucket}", passwordVariable: 'tmppasswordGit', usernameVariable: 'tmpUserBitbucket')]){
           script {
            if ( "${disableBitbucketTag}" == "1")  {
                // Shell Orquesthator Crear tag
                    sh (' cd ${folderExecShells} && ./${shellOrchestator} ${temptagCreate} ${WorkSpaceTrigger} NA ${WorkSpaceMPipeline} NA ${changeNumber} ${patternPointStable} NA ${branchType} ${patternFiles} ${uriUser} ${urlBitbucket} ${tmppasswordGit} ${getNewNextTag} ${sourceShells} ${BranchName} NA NA ${getInitTag} ${getRama} ${tmpLogs} ${domainUser} ${PathJira} ${TempEnvBitbucket}')
                // Traer Variables al Workspace
                    env.vpdInitTag = sh (script: 'cat "${VarsShfiles}/${getInitTag}" ', returnStdout: true).trim() 
                    env.getNewNextTag = sh (script: 'cat "${VarsShfiles}/${getNewNextTag}" ', returnStdout: true).trim()
             }
           }
          } 
         }
        }
        stage ("Jira - Create - update"){
            when { expression { "${env.disableJira}" == '1' } }
            options { skipDefaultCheckout(true) }
            steps {
                script {
                    try {
                        withEnv(['JIRA_SITE=Jira']){
                            def notification = load "${ExecTaskJira}"
                            notification.jiraNotification()
                        }
                    } catch (err){  echo "Warning: The build info was not written in the project ${projectName} on Jira Software due to earlier failure(s)." }
                }
            }
        }
        stage ("Code Review"){
            when { expression { "${disableCodeReview}" == '1' } }
            options { skipDefaultCheckout(true) }
            stages {
                stage ('Identity Code'){           
                    parallel {
                        stage('SonarQube'){
                            when { expression { "${disableSonar}" == '1' } }
                            steps {  
                                script {       
                                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                                        script {
                                            env.VersionSonarQube = "build-${projectName}-${appName}"
                                            def scannerHome = tool 'sonarqube';
                                            withSonarQubeEnv("sonarqube") {
                                                sh ("""${tool("sonarqube")}/bin/sonar-scanner \
                                                -Dsonar.projectKey=${VersionSonarQube} \
                                                -Dsonar.projectName=${VersionSonarQube} \
                                                -Dsonar.projectBaseDir=${workSpaceTrigger} \
                                                -Dsonar.sources=. -Dsonar.sourceEncoding=${sourceEncoding} -Dsonar.java.binaries=. \
                                                -Dsonar.branch.name=${BranchName} -Dsonar.projectVersion=${BUILD_NUMBER} """)  
                                            }
                                        }
                                    }
                                } 
                            }
                        }
                        stage('Black Duck'){
                            when { expression { "${disableBlackDuck}" == '1' } }
                            steps { 
                                script { 
                                    withCredentials([ string(credentialsId: "${CredentialsBlackDuck}", variable: 'BlackDuckToken')	]) 
                                        {	
                                            env.VersionBlackDuck = "build-${projectName}-${appName}"
                                            sh (' java -jar ${JarBlackDuck} --blackduck.url=${ServerBlackDuck} --detect.blackduck.signature.scanner.paths="${WorkSpaceMPipeline}" --blackduck.trust.cert=true --blackduck.api.token="${BlackDuckToken}" --detect.project.name=${projectName} --detect.project.version.name=${VersionBlackDuck} ')
                                        } 
                                } 
                            }
                        }
                        stage('Fortify'){
                            options { timeout(time: 60, unit: "MINUTES") }
                            when { expression { "${disableFortify}" == '1' } }
                            steps { 
                                script{ 
                                    // Credentials Fortify
                                    withCredentials([
                                            string(credentialsId: "${CredentialsTokenCIFortify}", variable: 'VarTokenCIFortify'),
                                            string(credentialsId: "${CredentialsTokenFortify}", variable: 'VarTokenFortify'),
                                            string(credentialsId: "${CredentialsKeyFortify}", variable: 'VarKeyFortify')
                                        ]) 
                                    {
                                        env.VersionFortify = "${buildAnalyzer}${projectName}-${appName}"
                                        env.FileFPR = "${WorkSpaceTrigger}/${VersionFortify}${extFileAnalyzer}"

                                        // Inicial el analisis
                                            sh ('${SourceAnalyzer} -b ${VersionFortify} ${WorkSpaceTrigger} -verbose')
                                        // Genera el resultado del reporte en fpr
                                            sh ('${SourceAnalyzer} -b ${VersionFortify} -scan -f ${FileFPR} -verbose')
                                        // Finaliza con limpieza de fortify
                                            sh ('${SourceAnalyzer} -b ${VersionFortify} -clean ${WorkSpaceTrigger} -verbose')
                                        // Subir reporte
                                            sh ('${FortifyClient} -url ${ServerFortify} -authtoken $VarTokenCIFortify uploadFPR -file ${FileFPR}  -project ${projectName} -version "${VersionFortify}"')
                                        // Verified Exist Vulnerability
                                            sh ('${ExecCheckSSCIssues} $VarTokenFortify $VarKeyFortify ${FileOutSscApiJson} ${FileOutPrettyJson} ${FileOutGrepJson} ${FortifyClient} ${ServerFortify} ${VersionFortify} ${ServerReportFortify} ${projectName} $VarTokenCIFortify ') 
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        stage ("Bitbucket - Diff"){
         steps {
          withCredentials([usernamePassword(credentialsId: "${FindUserBitbucket}", passwordVariable: 'tmppasswordGit', usernameVariable: 'tmpUserBitbucket')]){
            script {
             if ( "${disableBitbucketDiff}" == "1")  {
                // Shell Orquesthator diff files
                    sh ('cd ${folderExecShells} && ./${shellOrchestator} ${tempdiffFiles} ${WorkSpaceTrigger} NA ${WorkSpaceMPipeline} NA ${changeNumber} ${patternPointStable} ${excludeFiles} ${branchType} ${patternFiles} ${uriUser} ${urlBitbucket} ${tmppasswordGit} ${getNewNextTag} ${sourceShells} ${BranchName} ${tmpdiffFiles} ${tmpReportFiles} ${vpdInitTag} ${getRama} ${tmpLogs} ${domainUser} ${PathJira} ${TempEnvBitbucket} && cp -r $folderExecShells/$tmp/$tmpdiffFiles $VarsFolderTemp/') 
                }
             }
          }
         }
        }
        stage ("Compress - Artifact"){
            when { expression { "${env.disableCompress}" == '1' } }
            options { skipDefaultCheckout(true) }
            steps {
                script {
                    // Construccion de Variables
                        env.VarsFileCompress="${getNewNextTag}.${typeCompres}" // Concatener Numero de Cambio y Extension
                        env.VarsShellCompress="${folderShellsArtifact}.${typeCompres}" // Concatener Shelldeploy y Extension
                        env.VarsFolderCompress="${WorkSpaceMPipeline}/${envFolderOth}/${projectName}" //  Shell Compress Artifacts
                    // Shell Compress Artifact
                        sh ('"${execShellCompressArtifact}" "${WorkSpaceTrigger}" "${WorkSpaceMPipeline}" "${tmpdiffFiles}" "${getNewNextTag}" "${typeCompres}" "${sourceShells}" "${patternFiles}" ${tmp} ')
                    // Shell Compress ShellDeploy                      
                        sh ('"${execShellCompressFolder}" "${VarsFolderCompress}" "${WorkSpaceMPipeline}" "${folderShellsArtifact}" ${typeCompres} ') 
                }
            }
        }
        stage ("Jfrog"){
            when { expression { "${disableJfrog}" == '1' } }
            options { skipDefaultCheckout(true) }
            steps {
                script { 
                    // Construccion de Variables
                        env.FileArtifact = "${JfrogArtifact}/${VarEnviron}"
                        env.JfrogRepositoryArtifact = "${JfrogRepository}/${JfrogRepositoryComplement}/${FileArtifact}"
                        env.JfrogfileArtifact = "${WorkSpaceMPipeline}/${VarsFileCompress}"
                    // Upload Artifactory
                     rtUpload (  serverId: JfrogServerID,
                                spec: '''{ "files": [ {  "pattern": "${JfrogfileArtifact}", "target": "${JfrogRepositoryArtifact}/", "recursive": "false" } ] }'''
                            )
                }
            }
        }
        stage ("Copy - Artifact"){
            when { expression { "${env.disableCopy}" == '1' } }
            options { skipDefaultCheckout(true) }
            steps {
                script { // Upload SSH Server
                    sshPublisher(publishers: [
                        sshPublisherDesc(configName: "${AgentLabel}", verbose: true, transfers: [
                            sshTransfer( sourceFiles: "${VarsFileCompress}, ${VarsShellCompress}", remoteDirectory: "${remoteDirPath}" )
                        ])])
                }
            }
        }
        stage ('Deploy - Sterling'){
            agent { label "${AgentLabel}" }
            options { skipDefaultCheckout(true) }
            stages {
                stage ('Deploy - Buld Variables'){
                 steps {
                  script {
                        echo "step pipeline CD"
                  }
                 }
                }
            }
            post {
                failure {
                    script {
                        if ( "${cleanFolderRemoteDir}" == "1")  {               // Limpieza Ambiente Remoto
                            deleteDir()
                                dir("${FolderArtifact}") { deleteDir() }  // Limpieza WorkSpace Remoto
                        } else { echo "Eliminar Carpetas desactivado" }     // Desactivado
                    }
                }
                success {
                    script {
                        if ( "${cleanFolderRemoteDir}" == "1")  {               // Limpieza Ambiente Remoto
                            deleteDir()
                                dir("${FolderArtifact}") { deleteDir() }  // Limpieza WorkSpace Remoto
                        } else { echo "Eliminar Carpetas desactivado" }     // Desactivado
                    }   
                }
                aborted {
                    script {
                        if ( "${cleanFolderRemoteDir}" == "1")  {               // Limpieza Ambiente Remoto
                            deleteDir()
                                dir("${FolderArtifact}") { deleteDir() }  // Limpieza WorkSpace Remoto
                        } else { echo "Eliminar Carpetas desactivado" }     // Desactivado
                    }   
                }
            }
        }
    }
    post {
        failure {
            withCredentials([usernamePassword(credentialsId: "${FindUserBitbucket}", passwordVariable: 'tmppasswordGit', usernameVariable: 'tmpUserBitbucket')]){
                script {
                    // Bitbucket Delete Tag
                        sh (' cd ${folderExecShells} && ./${shellOrchestator} "${temptagDelete}" "${WorkSpaceTrigger}" NA "${WorkSpaceMPipeline}" NA "${changeNumber}" ${patternPointStable} NA ${branchType} ${patternFiles} ${uriUser} ${urlBitbucket} "${tmppasswordGit}" "${getNewNextTag}" "${sourceShells}" "${BranchName}" "${tmpdiffFiles}" "${tmpReportFiles}" "${getInitTag}" "${getRama}" "${tmpLogs}" "${domainUser}" "${PathJira}" "{TempEnvBitbucket}"')
                    // Notificacion fallido en Teams
                     if ( "${disableTeams}" == "1")  {
                        env.Color = "${ColorRed}"
                        env.PipelineStatus = "${PipelineFailed}"
                        env.msTeamsTmpMessageCard = "${WorkSpaceMPipeline}/${temporaryMessageCard}"
                        env.msTeamsMessageCard = "${WorkSpaceMPipeline}/${MessageCard}"
                        env.msTeamsShell = "${WorkSpaceMPipeline}/${sendMessageCard}"
                        env.team = "${VarEnviron}"
                        sh ('envsubst < $msTeamsMessageCard > $msTeamsTmpMessageCard')
                        sh ('$msTeamsShell $msTeamsTmpMessageCard $TeamsWebhook')
                     }
                    // Limpieza Ambiente
                     if ( "${cleanEnvironment}" == "1")  {
                            deleteDir()
                            dir("${WorkSpaceMPipeline}") { deleteDir() }    // Limpieza WorkSpace Pipeline
                            dir("${WorkSpaceTrigger}") { deleteDir() }      // Limpieza WorkSpace Trigger
                        } else { echo "Eliminar Carpetas desactivado" }     // Desactivado
                }
            }
        }
        success {
            script {
                // Notificacion exitoso en Teams
                 if ( "${disableTeams}" == "1")  {
                    env.Color = "${ColorGreen}"
                    env.PipelineStatus = "${PipelineStatus}"
                    env.msTeamsTmpMessageCard = "${WorkSpaceMPipeline}/${temporaryMessageCard}" // Template Temporal Message Card
                    env.msTeamsMessageCard = "${WorkSpaceMPipeline}/${MessageCard}"             // Template Message Card
                    env.msTeamsShell = "${WorkSpaceMPipeline}/${sendMessageCard}"               // Shell Message Card
                    env.team = "${VarEnviron}"                                                  // Ambiente DEV|UAT|PRD
                    sh ('envsubst < $msTeamsMessageCard > $msTeamsTmpMessageCard')              // Create Message Card Temporal
                    sh ('$msTeamsShell $msTeamsTmpMessageCard $TeamsWebhook')                // Put Message Teams
                 }
                // Limpieza Ambiente
                 if ( "${cleanEnvironment}" == "1")  {               
                        deleteDir()
                        dir("${WorkSpaceMPipeline}") { deleteDir() }    // Limpieza WorkSpace Pipeline
                        dir("${WorkSpaceTrigger}") { deleteDir() }      // Limpieza WorkSpace Trigger
                    } else { echo "Eliminar Carpetas desactivado" }     // Desactivado
            }   
        }
        aborted {
            withCredentials([usernamePassword(credentialsId: "${FindUserBitbucket}", passwordVariable: 'tmppasswordGit', usernameVariable: 'tmpUserBitbucket')]){
                script {
                    // Bitbucket Delete Tag
                        sh (' cd ${folderExecShells} && ./${shellOrchestator} "${temptagDelete}" "${WorkSpaceTrigger}" NA "${WorkSpaceMPipeline}" NA "${changeNumber}" ${patternPointStable} NA ${branchType} ${patternFiles} ${uriUser} ${urlBitbucket} "${tmppasswordGit}" "${getNewNextTag}" "${sourceShells}" "${BranchName}" "${tmpdiffFiles}" "${tmpReportFiles}" "${getInitTag}" "${getRama}" "${tmpLogs}" "${domainUser}" "${PathJira}" "{TempEnvBitbucket}"') // Execute Shell Orquesthator Eliminar Tag
                    // Notificacion de abortado en Teams
                     if ( "${disableTeams}" == "1")  {
                        env.Color = "${ColorRed}"
                        env.PipelineStatus = "${PipelineAborted}"
                        env.msTeamsTmpMessageCard = "${WorkSpaceMPipeline}/${temporaryMessageCard}" // Template Temporal Message Card
                        env.msTeamsMessageCard = "${WorkSpaceMPipeline}/${MessageCard}"             // Template Message Card
                        env.msTeamsShell = "${WorkSpaceMPipeline}/${sendMessageCard}"               // Shell Message Card
                        env.team = "${VarEnviron}"                                                  // Ambiente DEV|UAT|PRD
                        sh ('envsubst < $msTeamsMessageCard > $msTeamsTmpMessageCard')              // Create Message Card Temporal
                        sh ('$msTeamsShell $msTeamsTmpMessageCard $TeamsWebhook')                // Put Message Teams
                     }
                    // Limpieza Ambiente
                     if ( "${cleanEnvironment}" == "1")  {               
                            deleteDir()
                            dir("${WorkSpaceMPipeline}") { deleteDir() }    // Limpieza WorkSpace Pipeline
                            dir("${WorkSpaceTrigger}") { deleteDir() }      // Limpieza WorkSpace Trigger
                        } else { echo "Eliminar Carpetas desactivado" }     // Desactivado
                }   
            }
        }
    }
}