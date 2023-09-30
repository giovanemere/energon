def editStatus() {
        
       def transitionInput = [transition: [id: "${varStatus}"]]
       jiraTransitionIssue idOrKey: "${catGetIssue}", input: transitionInput

}

return this