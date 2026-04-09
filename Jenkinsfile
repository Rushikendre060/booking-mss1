pipeline {
    agent { label 'Team-A_jenkinsslave' }

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
                echo 'Code Compilation Completed Successfully!'
            }
        }

        stage('Code QA Execution') {
            steps {
                echo 'Running JUnit Test Cases...'
                sh 'mvn test'
                echo 'JUnit Test Cases Completed Successfully!'
            }
        }

        stage('Code Package') {
            steps {
                echo 'Creating WAR Artifact...'
                sh 'mvn package'
                echo 'WAR Artifact Created Successfully!'
            }
        }

        stage('Print Java Version') {
            steps {
                echo 'Java Version...'
                sh 'java --version'
                echo 'Current Java version!'
            }
        }

    }   // ✅ closes stages

}   // ✅ closes pipeline