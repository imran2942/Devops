def img
pipeline {
    environment {
        registry = "imran2942/devops-pro"
        registryCredential = 'dockerhub'
        githubCredential = 'github'
        dockerImage = ''
        SONARQUBE_URL = 'http://localhost:9000' // SonarQube server URL
        SONARQUBE_AUTH_TOKEN = credentials('sonarquebe') // Jenkins credential ID for SonarQube token
    }
    agent any

    triggers {
        githubPush()
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    credentialsId: githubCredential,
                    url: 'https://github.com/imran2942/Devops'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool name: 'SonarQube Scanner' // Adjust 'SonarScanner' to match your tool installation name in Jenkins
                    withSonarQubeEnv('Sonar1') { // Replace 'SonarQube' with your SonarQube installation name
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=devops-sonar \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=$SONARQUBE_URL \
                            -Dsonar.login=$SONARQUBE_AUTH_TOKEN"
                    }
                }
            }
        }

//        stage('SonarQube Analysis') {
//            def scannerHome = tool 'SonarScanner';
//            withSonarQubeEnv() {
//              sh "${scannerHome}/bin/sonar-scanner"
//            }
//          }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
                    img = registry + ":${env.BUILD_ID}"
                    println ("${img}")
                    dockerImage = docker.build("${img}")
                }
            }
        }

        stage('Push To DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }

    }
}
