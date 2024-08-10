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
        stage('Code Analysis') {
                    environment {
                        scannerHome = tool 'Sonar'
                    }
                    steps {
                        script {
                            withSonarQubeEnv('Sonar') {
                                sh "${scannerHome}/bin/sonar-scanner \
                                    -Dsonar.projectKey=sonar-project \
                                    -Dsonar.projectName=sonar-project \
                                    -Dsonar.projectVersion=1.0 \
                                    -Dsonar.sources=."
                            }
                        }
                    }
        }

//        stage('SonarQube Analysis') {
//            steps {
//               withSonarQubeEnv('Sonarsystem') {
//                      sh 'sonar-scanner'
//                     }
//                }
//            }
//        }
//                stage('SonarQube Analysis') {
//                    steps {
                        // Use the SonarQube environment defined in Jenkins
//                        withSonarQubeEnv(SONARQUBE_ENV) {
                            // Run the sonar-scanner inside the Docker container
//                            bat '''
//                            docker exec <container_name> sonar-scanner.bat \
//                            -Dsonar.projectKey=your_project_key \
//                            -Dsonar.sources=src \
//                            -Dsonar.host.url=http://localhost:9000 \
//                            -Dsonar.login=$SONARQUBE_AUTH_TOKEN
//                            '''
//                        }
//                    }
//                }

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
