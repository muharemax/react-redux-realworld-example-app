pipeline {
    agent any
    environment {
        imageName = 'chorba/antcolony'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git credentialsId: 'GITHUB_CREDENTIALS', url: 'https://github.com/muharemax/react-redux-realworld-example-app.git'
            }
        }
        
        stage('Docker build') {
            steps {
                bat "docker build -t ${imageName} ."
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CREDENTIALS', passwordVariable: 'docker_hub_pwd', usernameVariable: 'docker_hub_username')]) {
                    bat "docker login -u ${env.docker_hub_username} -p ${env.docker_hub_pwd}"
                    bat "docker tag ${imageName} ${imageName}:${BUILD_NUMBER}"
                    bat "docker push ${imageName}:latest"
                    bat "docker push ${imageName}:${BUILD_NUMBER}"
                }
            }
        }
        
        stage('Remove Unused docker image') {
            steps{
                bat "docker rmi ${imageName}:${BUILD_NUMBER}"
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