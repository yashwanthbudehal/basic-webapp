pipeline {
    agent { label 'Dev' }

    environment {
    REGISTRY = "karthikeyareddy716"
    IMAGE_NAME = "basic-webapp"
    IMAGE_TAG = "${BUILD_NUMBER}"
    DOCKER_IMAGE = "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
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
                script {
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_IMAGE} ."
        
                    echo "Logging into Docker registry..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    }
        
                    echo "Pushing Docker image to registry..."
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }
}
