pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE_NAME = "rubeshdevops/my-website-app" // IMPORTANT: Replace with your info
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/devopsbyrubesh/website.git' // IMPORTANT: Replace with your forked repo URL
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Logging into Docker Hub..."
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"

                    echo "Pushing Docker image..."
                    sh "docker push ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying to Kubernetes..."
                    // We need to update the image tag in the deployment file
                    sh "sed -i 's|image: .*|image: ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}|' deployment.yml"
                    // Apply the configuration
                    sh 'kubectl apply -f deployment.yml'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
            sh 'docker logout' // Clean up login session
        }
    }
}