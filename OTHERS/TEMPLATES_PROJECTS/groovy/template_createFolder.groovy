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
        String CreatebasePath = "${common}/${PATH_APP}"
        folder(CreatebasePath) {
        displayName "${PATH_APP}"
        description "DSL generated folder ${PATH_APP}."
        }
        // Create Folder Free Style Comunes
        String CreatebasePathFree = "${common}/${PATH_APP}/${FREE_STYLE}"
        folder(CreatebasePathFree) {
        displayName "${FREE_STYLE}"
        description "DSL generated folder ${PATH_APP} type ${FREE_STYLE}"
        }
        // Create Folder Pipeline Comunes
        String CreatebasePathPipe = "${common}/${PATH_APP}/${PIPELINE}"
        folder(CreatebasePathPipe) {
        displayName "${PIPELINE}"
        description "DSL generated folder ${PATH_APP} type ${PIPELINE}."
        }
    }
}
else {
        def list = ['FOLDER_DEV','FOLDER_UAT','FOLDER_PDN']
        for (item in list) {
            
            // define variables temp
            def NAME_JOB_TRIGGER = "${item}/${PATH_PROJECT}/${PATH_APP}/${FREE_STYLE}/${TYPE_JOB}_${PATH_APP}"
            def NAME_JOB_PIPELINE = "${item}/${PATH_PROJECT}/${PATH_APP}/${PIPELINE}/${TYPE_JOB_PIPELINE}_${PATH_APP}"
            // Create Folder Project
            String CreatebasePath = "${item}/${PATH_PROJECT}"
            folder(CreatebasePath) {
            displayName "${PATH_PROJECT}"
            description "DSL generated folder ${item}/${PATH_PROJECT}"
            }

            // Create Folder Application
            String CreatebasePathApp = "${item}/${PATH_PROJECT}/${PATH_APP}"
            folder(CreatebasePathApp) {
            displayName "${PATH_APP}"
            description "DSL generated folder ${item}/${PATH_PROJECT}."
            }

            // Create Folder Free Style Application
            String CreatebasePathFree = "${item}/${PATH_PROJECT}/${PATH_APP}/${FREE_STYLE}"
            folder(CreatebasePathFree) {
            displayName "${FREE_STYLE}"
            description "DSL generated folder ${item}, ${PATH_PROJECT}, ${PATH_APP} type ${FREE_STYLE}."
                displayName "${FREE_STYLE}"
                description "DSL generated folder ${item}, ${PATH_PROJECT}, ${PATH_APP} type ${FREE_STYLE}."
                freeStyleJob("${NAME_JOB_TRIGGER}") {
                    description("DSL generated poject ${PATH_PROJECT}, ${PATH_APP} Job.")
                    triggers {
                        bitbucketPush()
                    }
                    scm {
                        git {
                            remote {
                                url("${URL_REPO}")
                                credentials("${ACCOUNT_BITBUCKET}")
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
                        publishers {
                            postBuildScripts {
                                steps {
                                    triggerBuilder {
                                        configs {
                                            blockableBuildTriggerConfig {
                                                // A comma separated list of projects to build
                                                projects("${NAME_JOB_PIPELINE}")
                                                block {
                                                     buildStepFailureThreshold('never')
                                                     unstableThreshold('never')
                                                     failureThreshold('never')
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Create Folder Free Style Pipeline
            String CreatebasePathPipe = "${item}/${PATH_PROJECT}/${PATH_APP}/${PIPELINE}"
            folder(CreatebasePathPipe) {
            displayName "${PIPELINE}"
            description "DSL generated folder ${item}, ${PATH_PROJECT}, ${PATH_APP} type ${PIPELINE}."
                pipelineJob("${NAME_JOB_PIPELINE}") {
                    description("DSL generated poject ${PATH_PROJECT}, ${PATH_APP} Job.")
                    keepDependencies(false)
                    definition {
                        cpsScm {
                            scm {
                                git {
                                    remote {
                                        url("${URL_REPO_COMMON}")
                                        credentials("${ACCOUNT_BITBUCKET}")
                                    }
                                    branch("master")
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