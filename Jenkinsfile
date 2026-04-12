pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
    }

    tools {
        maven 'Maven_3.9.6'
    }

    stages {

        stage('Code Compilation') {
            steps {
                echo 'Starting Code Compilation...'
                sh 'mvn clean compile'
            }
        }

        stage('Code QA Execution') {
            steps {
                echo 'Running JUnit Test Cases...'
                sh 'mvn test'
            }
        }

        stage('Code Package') {
            steps {
                echo 'Creating JAR Artifact...'
                sh 'mvn clean package'
            }
        }

        stage('Build & Tag Docker Image') {
            steps {
                echo 'Building Docker Image...'
                sh '''
                    docker build -t rishokendre/booking-mss1:latest \
                                 -t booking-mss1:latest .
                '''
            }
        }

        stage('Docker Image Scanning') {
            steps {
                echo 'Scanning Docker Image with Trivy...'
                sh '''
                    if ! trivy image rishokendre/booking-mss1:latest ; then
                        echo "Trivy Scan Failed - Proceeding with Caution"
                    fi
                '''
                echo 'Docker Image Scanning Completed!'
            }
        }

        stage('Push Docker Image to Amazon ECR') {
            steps {
                script {
                    withDockerRegistry(
                        [credentialsId: 'ecr:ap-south-1:ecr-upload-credentials',
                         url: "https://797748030688.dkr.ecr.ap-south-1.amazonaws.com"]
                    ) {
                        echo 'Tagging and Pushing Docker Image to ECR...'
                        sh '''
                            docker images
                            docker tag booking-mss1:latest 797748030688.dkr.ecr.ap-south-1.amazonaws.com/booking-mss1:latest
                            docker push 797748030688.dkr.ecr.ap-south-1.amazonaws.com/booking-mss1:latest
                        '''
                        echo 'Docker Image Pushed to Amazon ECR Successfully!'
                    }
                }
            }
        }

        stage('Cleanup Docker Images') {
            steps {
                echo 'Cleaning up Docker...'
                sh 'docker system prune -af'
            }
        }
    }
}