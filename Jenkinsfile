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
        stage('SonarQube Code Analysis') {
                    steps {
                        dir("${WORKSPACE}"){
                        // Run SonarQube analysis for Python
                        script {
                            def scannerHome = tool name: 'Sonar-tool', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                            withSonarQubeEnv('Sonar-system') {
                                sh "${scannerHome}/bin/sonar-scanner \
                                    -D sonar.projectVersion=1.0-SNAPSHOT \
                                    -D sonar.projectKey=sonar-project \
                                    -D sonar.sourceEncoding=UTF-8 \
                                    -D sonar.language=php \
                                    -D sonar.host.url=http://localhost:9000"
                                }
                            }
                        }
                    }
        }

//        stage('Code Analysis') {
//                    environment {
//                        scannerHome = tool 'Sonar'
//                    }
//                    steps {
//                        script {
//                            withSonarQubeEnv('Sonar') {
//                                sh "${scannerHome}/bin/sonar-scanner \
//                                    -Dsonar.projectKey=sonar-project \
//                                    -Dsonar.projectName=sonar-project \
//                                    -Dsonar.projectVersion=1.0 \
//                                    -Dsonar.sources=."
//                            }
//                        }
//                    }
//        }


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
