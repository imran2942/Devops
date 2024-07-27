def img
pipeline {
    environment {
        registry = "imran2942/devops-pro" //To push an image to Docker Hub, you must first name your local image using your Docker Hub username and the repository name
         //that you created through Docker Hub on the web.
        registryCredential = 'dockerhub'
        githubCredential = 'github'
        dockerImage = ''
    }
    agent any
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
