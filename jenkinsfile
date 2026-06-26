pipeline {
    agent any
    triggers { 
      githubPush() 
    }
    environment {
        DOCKER_IMAGE_NAME = 'sysmon'
        GITHUB_REPO_URL = 'https://github.com/Regentflame11/sysmon-cicd-pipeline.git'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git branch: 'main', url: "${GITHUB_REPO_URL}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_NAME}", '.')
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script{
                    docker.withRegistry('', 'DockerHubCred') {
                        sh "docker tag ${DOCKER_IMAGE_NAME} regentflame11/${DOCKER_IMAGE_NAME}:latest"
                        sh "docker push regentflame11/${DOCKER_IMAGE_NAME}:latest"
                    }
                 }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    ansiblePlaybook(
                        playbook: 'deploy.yml',
                        inventory: 'inventory'
                     )
                }
            }
        }
    }
}
