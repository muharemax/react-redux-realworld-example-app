pipeline {
    agent any
    environment {
        DockerHubRepo = 'chorba/antcolony'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git credentialsId: 'GITHUB_CREDENTIALS', url: 'https://github.com/muharemax/react-redux-realworld-example-app.git'
            }
        }
        
        stage('Docker build') {
            steps {
                bat "docker build -t react-app ."
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CREDENTIALS', passwordVariable: 'docker_hub_pwd', usernameVariable: 'docker_hub_username')]) {
                    bat "docker tag react-app ${DockerHubRepo}:react-app.latest"
                    bat "docker tag react-app ${DockerHubRepo}:react-app.v${BUILD_NUMBER}"
                    bat "docker push ${DockerHubRepo}:react-app.latest"
                    bat "docker push ${DockerHubRepo}:react-app.v${BUILD_NUMBER}"
                }
            }
        }
        
        stage('Remove Unused docker image') {
            steps{
                bat "docker rmi ${DockerHubRepo}:react-app.latest"
                bat "docker rmi ${DockerHubRepo}:react-app.v${BUILD_NUMBER}"
            }
        }
        
        stage('Deploy to k8s cluster') {
            steps{
                bat "cd Kubernetes"
                bat "kubectl apply -f Kubernetes/deployment.yml"
                bat "kubectl apply -f Kubernetes/service.yml"
                bat "kubectl apply -f Kubernetes/ingress.yml"
            }
        }
    }
}