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
                bat "docker build -t frontend-app ."
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CREDENTIALS', passwordVariable: 'docker_hub_pwd', usernameVariable: 'docker_hub_username')]) {
                    bat "docker login -u ${env.docker_hub_username} -p ${env.docker_hub_pwd}"
                    bat "docker tag frontend-app ${DockerHubRepo}:frontend-app.latest"
                    bat "docker tag frontend-app ${DockerHubRepo}:frontend-app.v${BUILD_NUMBER}"
                    bat "docker push ${DockerHubRepo}:frontend-app.latest"
                    bat "docker push ${DockerHubRepo}:frontend-app.v${BUILD_NUMBER}"
                }
            }
        }
        
        stage('Remove Unused docker images') {
            steps{
                bat "docker rmi ${DockerHubRepo}:frontend-app.latest"
                bat "docker rmi ${DockerHubRepo}:frontend-app.v${BUILD_NUMBER}"
            }
        }
        
        stage('Deploy to k8s cluster') {
            steps{
                bat "cd Kubernetes"
                bat "kubectl apply -f Kubernetes/frontend-deploy.yml"
            }
        }
    }
}