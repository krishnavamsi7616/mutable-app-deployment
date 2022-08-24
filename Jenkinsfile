pipeline {
    agent any
    options {
           ansiColor('xterm')
    }
    parameters {

        choice(name: 'ENV', choices: ['', 'prod', 'dev'], description: '')
        choice(name: 'COMPONENT', choices: ['shipping'], description: '')
    }

    stages {
    stage('Terraform'){
    steps {
    sh '''
         terraform init
         terraform apply -auto-approve -var COMPONENT=${COMPONENT} -var ENV=${ENV} -parallelism=1
         '''
    }
    }
    }

    post {
    always {
        cleanWs()
    }
    }


}