pipeline {

	agent any

	options {
		buildDiscarder(logRotator(numToKeepStr: '5'))
	}

    environment {

      

       
	   DOCKER_REGISTRY = "172.27.59.80:8082/docker-pranav/deccan_pranav"
       DATE = new Date().format('yy.M')
       TAG = "${DATE}.${BUILD_NUMBER}"
    }

	tools {

		maven "Maven"

		jdk "JDK11"

	}


	stages {

		stage('Begin') {
			steps{
			node('Pranav_node') {
        bat 'echo " for node My test here"'
        
       }
	   }
		}

		


		stage('Initialize') {
			steps {
				bat "echo 'Initializing'"
			}
		}

		stage('Clean') {
			steps {
				echo "Cleaning"
				bat "mvn clean"
			}
		}

		stage('Install') {
			steps {
				echo "Install"
				bat "mvn install"
			}
		}

		stage('Sonarqube Analysis') {
			steps {

				withSonarQubeEnv('SonarScannerPranav') {
					bat 'mvn sonar:sonar'
				}

				timeout(time: 10, unit: 'MINUTES') {
					waitForQualityGate abortPipeline: true
					echo 'inside sonar environment'
				}

			}

		}

		stage('Deploy to Artifact') {
			steps {
				script {
					def server = Artifactory.server 'Pranav-Jfrog'
					def uploadSpec = """{
					"files": [{
						"pattern": "target/*.jar",
						"target": "CICD/"
					}]
				}
				"""
				server.upload(uploadSpec)
			}

		}

		post {
			always {
				jiraSendBuildInfo()
			}

		}

	}

    stage('Building Docker Image') {
			steps {



                 bat "podman build -t ${DOCKER_REGISTRY}:${TAG} -t ${DOCKER_REGISTRY}:latest ."
		  				

			}

		}

        stage('Push Image To Registry') {
			steps {
				bat "podman push ${DOCKER_REGISTRY}:${TAG}"
				bat "podman push ${DOCKER_REGISTRY}:latest"
			}
		}



}

}
