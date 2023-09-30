def editOP() {

    //Look at IssueInput class for more information.
    def testIssue = [fields: [ // id or key must present for project.
                               project: [key: "${projectName}"],
                               customfield_10606: "${catGetIssue}"]]

    response = jiraEditIssue idOrKey: "${catGetIssue}", issue: testIssue

    echo response.successful.toString()
    echo response.data.toString()

}

return this