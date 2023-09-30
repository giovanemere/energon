def jiraNotification() {
    
    try{
                        
    def searchResults = jiraJqlSearch jql: "project = ${projectName} AND summary ~ feature-${changeNumber}"
    def issues = searchResults.data.issues
    def key = issues[0].key
    
    echo searchResults.data.issues.summary.toString()

    // Look at IssueInput class for more information.
    def testIssue = [fields: [ project: [key: "${projectMame}"],
                                summary: "feature-${changeNumber}",
                                description: "Edited task feature-${changeNumber} automatically from Jenkins Build Numer: ${BUILD_NUMBER} ${BUILD_URL}/display/redirect",
                                issuetype: [name: 'Task']]]

    response = jiraEditIssue idOrKey: "${key}", issue: testIssue
    
    echo response.successful.toString()
    echo response.data.toString()

    echo "ISSUE EDITED"

    } catch(error){

        def issue = [fields:[project:[key:"${projectName}"],
        summary: "feature-${changeNumber}",
        description: "Feature merged to release: feature-${changeNumber} Build Numer: ${BUILD_NUMBER} ${BUILD_URL}/display/redirect",
        issuetype:[name: 'Task']]]

        def newIssue = jiraNewIssue issue: issue, site: 'Jira'
            echo newIssue.data.key
            echo "summary: ${issue.fields.summary}"

        echo "ISSUE CREATED"
    }
}

return this