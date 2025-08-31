pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME = 'rubeshdevops/my-website-app'
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/devopsbyrubesh/website.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Logging into Docker Hub..."
                    // Fixed: Using single quotes to avoid Groovy interpolation security warning
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    
                    echo "Pushing Docker image..."
                    sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying to Kubernetes..."
                    
                    // Update deployment.yml with new image
                    sh "sed -i 's|image: .*|image: ${IMAGE_NAME}:${BUILD_NUMBER}|' deployment.yml"
                    
                    // Option 1: Using kubeconfig credentials (recommended)
                    withCredentials([kubeconfigFile(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh 'kubectl apply -f deployment.yml'
                    }
                    
                    // Option 2: If you don't have kubeconfig, use this instead:
                    // withCredentials([string(credentialsId: 'k8s-token', variable: 'K8S_TOKEN')]) {
                    //     sh '''
                    //         kubectl config set-credentials jenkins --token=$K8S_TOKEN
                    //         kubectl config set-cluster k8s-cluster --server=https://your-k8s-api-server --insecure-skip-tls-verify=true
                    //         kubectl config set-context jenkins-context --cluster=k8s-cluster --user=jenkins
                    //         kubectl config use-context jenkins-context
                    //         kubectl apply -f deployment.yml
                    //     '''
                    // }
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline finished.'
            sh 'docker logout'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs above.'
        }
    }
}
