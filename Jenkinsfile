pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "${DOCKERHUB_CREDENTIALS_USR}/finead-todo-app:latest"
    }

    stages {

        stage('Build') {
            steps {
                script {
                    docker.image('node:18-alpine').inside {

                        // Backend dependencies
                        dir('TODO/todo_backend') {
                            sh 'npm install'
                        }

                        // Frontend build
                        dir('TODO/todo_frontend') {
                            sh 'npm install'
                            sh 'npm run build'
                        }

                        // Move frontend build to backend/static
                        dir('TODO') {
                            sh 'mkdir -p todo_backend/static'
                            sh 'rm -rf todo_backend/static/build'
                            sh 'mv todo_frontend/build todo_backend/static'
                        }

                    }
                }
            }
        }

        stage('Containerise') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }
}