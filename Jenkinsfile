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

                    sh '''
                    docker run --rm -v $(pwd):/app -w /app node:18-alpine sh -c "
                        cd TODO/todo_backend && npm install
                    "
                    '''

                    sh '''
                    docker run --rm -v $(pwd):/app -w /app node:18-alpine sh -c "
                        cd TODO/todo_frontend && npm install && npm run build
                    "
                    '''

                    sh '''
                    cd TODO
                    mkdir -p todo_backend/static
                    rm -rf todo_backend/static/build
                    mv todo_frontend/build todo_backend/static
                    '''
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