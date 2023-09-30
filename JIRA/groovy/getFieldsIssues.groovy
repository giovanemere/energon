def getFields() {

        // Obtener archivo por variables
        def tempFileKey = "${pathGetIssue}"
        echo tempFileKey.toString()
        
        def searchResults = jiraJqlSearch jql: "project = ${projectName} AND summary ~ \"${summary}\" AND status = \"${estaCertificado}\" AND environment ~ \"${environment}\" AND \"OP #\" is null"
        def issues = searchResults.data.issues
        def key = issues[0].key

        echo key.toString()

        // Almacenar resultado en archivo de Salida
        File filefileKey = new File(tempFileKey)
        filefileKey.append(key)
        echo tempFileKey.toString()

}

return this