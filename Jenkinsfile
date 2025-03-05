pipeline {
    agent { label 'Dev' }

    environment {
        DOCKER_IMAGE = "karthikeyareddy716/basic-webapp:${BUILD_NUMBER}"
        TOMCAT_WEBAPPS = "/opt/tomcat9/webapps"
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
                        scp -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no target/basic-webapp.war ubuntu@13.114.204.16:/opt/tomcat9/webapps/
                        ssh ubuntu@13.114.204.16 "sudo systemctl restart tomcat9"
                    """
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE} .
                    docker push ${DOCKER_IMAGE}
                """
            }
        }
    }
}
