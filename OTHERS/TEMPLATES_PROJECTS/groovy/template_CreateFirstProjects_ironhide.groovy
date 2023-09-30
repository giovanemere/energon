// Defintion Variables
def FREE_STYLE = "FREE_STYLE"
def PIPELINE = "PIPELINE"
def TYPE_JOB = "TRIGGER"
def TYPE_JOB_PIPELINE = "ORCHESTRATOR"
def PROJECT = "${PATH_PROJECT}"
def SCRIPTPATH_COMMON = "${SCRIPTPATH}/${PATH_PROJECT}/${TYPE_JOB_PIPELINE}.Jenkinsfile"

if(PROJECT == ''){
    def list = ['FOLDER_SCCOLCOMUNES']
    
    for (common in list) {
        
        // Create Folder Aplicación
         String CreatebasePath = "${common}/${appName}"
          folder(CreatebasePath) {
          displayName "${appName}"
          description "DSL generated folder ${appName}."

        }
        
        // Create Folder Free Style Comunes
         String CreatebasePathFree = "${common}/${appName}/${FREE_STYLE}"
          folder(CreatebasePathFree) {
          displayName "${FREE_STYLE}"
          description "DSL generated folder ${appName} type ${FREE_STYLE}"

        }
        
        // Create Folder Pipeline Comunes
         String CreatebasePathPipe = "${common}/${appName}/${PIPELINE}"
          folder(CreatebasePathPipe) {
          displayName "${PIPELINE}"
          description "DSL generated folder ${appName} type ${PIPELINE}."

        }
    }

}
else {
        def list = ['FOLDER_OPSDEV','FOLDER_DEV']
        for (item in list) {
            
            // define variables temp
             def NAME_JOB_TRIGGER = "${item}/${PATH_PROJECT}/${appName}/${FREE_STYLE}/${TYPE_JOB}_${appName}"
             def NAME_JOB_PIPELINE = "${item}/${PATH_PROJECT}/${appName}/${PIPELINE}/${TYPE_JOB_PIPELINE}_${appName}"
            
            // Create Folder Project
             String CreatebasePath = "${item}/${PATH_PROJECT}"
              folder(CreatebasePath) {
               displayName "${PATH_PROJECT}"
               description "DSL generated folder ${item}/${PATH_PROJECT}"
            
              }
            
            // Create Folder Application
             String CreatebasePathApp = "${item}/${PATH_PROJECT}/${appName}"
              folder(CreatebasePathApp) {
               displayName "${appName}"
               description "DSL generated folder ${item}/${PATH_PROJECT}."

              }
            
            // Create Folder and Job Free Style for Application
             String CreatebasePathFree = "${item}/${PATH_PROJECT}/${appName}/${FREE_STYLE}"
              folder(CreatebasePathFree) {
                displayName "${FREE_STYLE}"
                description "DSL generated folder ${item}, ${PATH_PROJECT}, ${appName} type ${FREE_STYLE}."
                freeStyleJob("${NAME_JOB_TRIGGER}") {
                    description("DSL generated poject ${PATH_PROJECT}, ${appName} Job.")
                    keepDependencies(false)
                    triggers {
                        bitbucketPush()
                    }
                    scm {
                        git {
                            remote {
                                url("${URL_REPO}")
                                credentials("${ACCOUNT_BITBUCKET}")
                            }                            
                            if("${item}" == "FOLDER_OPSDEV"){
                                branch("trunk")
                            }                            
                            if("${item}" == "FOLDER_DEV"){
                                branch("develop")
                            }                            
                            if("${item}" == "FOLDER_UAT"){
                                branch("release")
                            }                            
                            if("${item}" == "FOLDER_PDN"){
                                branch("master")
                            }
                        }
                    }
                    disabled(false)
                    concurrentBuild(false)
                    steps {
                        shell("""mkdir -p "\$WORKSPACE/temp"
vartemp="\$WORKSPACE/temp/envtrigger.groovy"
lastReleaseCommitId="\$(git log -n 1 | grep "commit" | awk '{print \$2}' | grep -v "commit" )"
echo "lastReleaseCommitId: \$lastReleaseCommitId"

changeNumber=\$(git log  --format=%B -n 1 "\$lastReleaseCommitId" | grep -Eo 'C[0-9]{1,20}|CHG[0-9]{1,20}' | awk 'NR==1 {print; exit}')
TmpRama=\$(git branch -r | grep \$changeNumber)
getRama=\$(echo \${TmpRama#*/})
branchType=\$(echo \${getRama%/*})

touch \$vartemp
>\$vartemp

echo "env.changeNumber=\\"\$changeNumber\\"" >>\$vartemp
echo "env.branchType=\\"\$branchType\\"" >>\$vartemp
echo "env.getRama=\\"\$getRama\\"" >>\$vartemp
echo "env.TEMP_GIT_URL=\\"\$GIT_URL\\"" >>\$vartemp
echo "env.TEMP_GIT_BRANCH=\\"\$GIT_BRANCH\\"" >>\$vartemp

cat -b \$vartemp""")
                    }
                            // Adds build steps to run at the end of the build.
                            steps {
                                // Triggers new parametrized builds.
                                downstreamParameterized {
                                    // Adds a trigger for parametrized builds.
                                    trigger("${NAME_JOB_PIPELINE}") {
                                        // Adds parameter values for the projects to trigger.
                                        parameters {
                                            // Adds a parameter.
                                            predefinedProp('WorkSpaceTrigger', '$WORKSPACE')
                                        }
                                    }
                                }
                            }
                    
              }
            }
            
            // Create Folder and Job Pipeline Orchestator
             String CreatebasePathPipe = "${item}/${PATH_PROJECT}/${appName}/${PIPELINE}"
              folder(CreatebasePathPipe) {
               displayName "${PIPELINE}"
               description "DSL generated folder ${item}, ${PATH_PROJECT}, ${appName} type ${PIPELINE}."
                pipelineJob("${NAME_JOB_PIPELINE}") {
                    description("DSL generated poject ${PATH_PROJECT}, ${appName} Job.")
                    keepDependencies(false)
                    parameters {
                        textParam("NameRepository", "", "Nombre del reopositorio para concatenar framework")
                        textParam("WorkSpaceTrigger", "", "Ruta de Pipeline Free Style")
                    }
                    definition {
                        cpsScm {
                            scm {
                                git {
                                    remote {
                                        url("${URL_REPO_COMMON}")
                                        credentials("${ACCOUNT_BITBUCKET}")
                                    }
                                    branch("${BRANCH_COMMON}")
                                }
                            }
                            scriptPath("${SCRIPTPATH_COMMON}")
                        }
                    }
                    disabled(false)
                }
              }

        }
        
}