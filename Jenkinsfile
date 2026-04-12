pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
    }

    tools {
        maven 'Maven_3.9.6'
    }

    environment {
        IMAGE_NAME = "booking-mss1"
        DOCKERHUB_REPO = "rishokendre/booking-mss1"
        ECR_REPO = "797748030688.dkr.ecr.ap-south-1.amazonaws.com/booking-mss1"
    }

    stages {

        stage('Code Compilation') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Code QA Execution') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Code Package') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Verify Artifact') {
            steps {
                sh 'ls -l target/'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $DOCKERHUB_REPO:latest \
                                 -t $IMAGE_NAME:latest .
                '''
            }
        }

        stage('Prepare Trivy DB') {
            steps {
                sh 'trivy image --download-db-only'
            }
        }

        stage('Docker Image Scanning') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    sh '''
                        trivy image --severity HIGH,CRITICAL \
                        --no-progress \
                        $DOCKERHUB_REPO:latest || true
                    '''
                }
            }
        }

        stage('Push Docker Image to Amazon ECR') {
            steps {
                script {
                    withDockerRegistry(
                        [credentialsId: 'ecr:ap-south-1:ecr-upload-credentials',
                         url: "https://797748030688.dkr.ecr.ap-south-1.amazonaws.com"]
                    ) {
                        sh '''
                            docker tag $IMAGE_NAME:latest $ECR_REPO:latest
                            docker push $ECR_REPO:latest
                        '''
                    }
                }
            }
        }

        stage('Cleanup Docker Images') {
            steps {
                sh 'docker system prune -af'
            }
        }
    }
}