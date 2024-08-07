def img
pipeline {
    environment {
        registry = "imran2942/devops-pro" //To push an image to Docker Hub, you must first name your local image using your Docker Hub username and the repository name
         //that you created through Docker Hub on the web.
        registryCredential = 'dockerhub'
        githubCredential = 'github'
        dockerImage = ''
        SONARQUBE_URL = 'http://localhost:9000' // SonarQube server URL
        SONARQUBE_AUTH_TOKEN = credentials('sonarquebe') // Jenkins credential ID for SonarQube token

    }
    agent any
    tools {
                // Assuming SonarQube Scanner is installed via Jenkins tool configuration
                sonarScanner 'SonarQube Scanner'
                }

    triggers {
        githubPush()
        }
    stages {

        stage('checkout') {
                steps {
                git branch: 'master',
                credentialsId: githubCredential,
                url: 'https://github.com/imran2942/Devops'
                }
        }
        stage('SonarQube Analysis') {
                        steps {
                            withSonarQubeEnv('SonarQube') {
                                sh 'sonar-scanner \
                                    -Dsonar.projectKey=your_project_key \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=$SONARQUBE_URL \
                                    -Dsonar.login=$SONARQUBE_AUTH_TOKEN'
                                }
                        }
        }

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
                    docker.withRegistry( 'https://registry.hub.docker.com ', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

      }
    }



    pipeline {
        agent any



        environment {
            SONARQUBE_URL = 'http://your-sonarqube-url' // SonarQube server URL
            SONARQUBE_AUTH_TOKEN = credentials('sonarqube-auth-token') // Jenkins credential ID for SonarQube token
        }

        stages {
            stage('Checkout') {
                steps {
                    checkout scm
                }
            }

            stage('Build') {
                steps {
                    // Your build steps here
                    sh './build.sh'
                }
            }


        }
    }

