def getCommits() {

  // Obtener archivo por variables
        def filePathDescription = "${pathFileDescription}"
        def filePathChangeNumber = "${pathChangeNumber}"
        //echo filePath.toString()

  // Query JQL issue
        def searchResults = jiraJqlSearch jql: "project = ${projectName} AND summary ~ \"${summary}\" AND status = \"${estaCertificado}\" AND environment ~ \"${environment}\" AND \"OP #\"~ \"${catGetIssue}\""

  // Guardar Resultado de Issue Jira
        def textCommits = searchResults.data.issues.fields.environment
        def textChangeNumber = searchResults.data.issues.fields.summary
        def textkey = searchResults.data.issues.fields.key
        def textlastViewed = searchResults.data.issues.fields.lastViewed
        def textDescription= searchResults.data.issues.fields.description

  // Imprimir Variables en Groovy 
        //echo textCommits.toString()
        //echo textChangeNumber.toString()
        //echo textkey.toString()
        //echo textlastViewed.toString()
        //echo textDescription.toString()

  // Almacenar resultado en archivo de Salida
        File fileDescription = new File(filePathDescription)
        fileDescription.append(textCommits)
        //println fileDescription.text

  // Almacenar resultado en archivo de Salida
        File fileChangeNumber = new File(filePathChangeNumber)
        fileChangeNumber.append(textChangeNumber)
        //println fileChangeNumber.text

}

return this