pipeline {
    agent { label 'Dev' }

    environment {
        TOMCAT_WEBAPPS = "/opt/tomcat11/webapps"
    }

    stages {
        stage('SCM Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/Karthikeyareddy81/basic-webapp.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sshagent(['agent1']) {
                    sh """
                        scp -o StrictHostKeyChecking=no target/basic-webapp.war ubuntu@13.114.204.16:${TOMCAT_WEBAPPS}/
                        ssh ubuntu@13.114.204.16 "sudo systemctl restart tomcat11"
                    """
                }
            }
        }
    }
}
