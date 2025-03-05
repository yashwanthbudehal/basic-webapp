pipeline {
    agent { label 'Dev' }

    environment {
        DOCKER_IMAGE = "karthikeyareddy716/basic-webapp:${BUILD_NUMBER}"
        TOMCAT_WEBAPPS = "/opt/tomcat9/webapps"
        DOCKER_USERNAME = credentials('docker-hub-cred')  // Store in Jenkins credentials
        DOCKER_PASSWORD = credentials('docker-hub-cred')
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
                script {
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_IMAGE} ."
        
                    echo "Logging into Docker registry..."
                    sh "echo '${DOCKER_PASSWORD}' | docker login -u '${DOCKER_USERNAME}' --password-stdin"
        
                    echo "Pushing Docker image to registry..."
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }           
    }
}
