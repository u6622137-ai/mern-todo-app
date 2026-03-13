pipeline {
    agent any

    environment {
        // Replace 'dockerhub-credentials' with the actual ID of your Jenkins credential
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "${DOCKERHUB_CREDENTIALS_USR}/finead-todo-app:latest"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Install dependencies for backend
                    dir('TODO/todo_backend') {
                        sh 'npm install'
                    }
                    // Install dependencies and build frontend
                    dir('TODO/todo_frontend') {
                        sh 'npm install'
                        sh 'npm run build'
                    }
                    
                    // Move the frontend build artifact to backend/static as required by README
                    dir('TODO') {
                        sh 'mkdir -p todo_backend/static'
                        sh 'rm -rf todo_backend/static/build' // Ensure clean slate if rerunning
                        sh 'mv todo_frontend/build todo_backend/static'
                    }
                }
            }
        }
        stage('Containerise') {
            steps {
                script {
                    // Build a Docker image from the root of the repository
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    // Login to Docker Hub using stored credentials and push the image
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }
}
