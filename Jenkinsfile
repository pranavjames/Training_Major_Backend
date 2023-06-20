pipeline {

	agent {
		label 'Linux_Node1'
	      }

	options {
		buildDiscarder(logRotator(numToKeepStr: '5'))
	}

	tools {

		maven "Maven"

		jdk "JDK17"

	}

	stages {

		stage('Begin') {
			steps {
				sh 'echo "Helo"'
			}
		}

		stage('Initialize') {
			steps {
				sh "echo 'Initializing'"
			}
		}

		stage('Clean') {
			steps {
				echo "Cleaning"
				sh "mvn clean"
			}
		}

		stage('Install') {
			steps {
				echo "Install"
				sh "mvn install"
			}
		}

		stage('Sonarqube Analysis') {
			steps {

				withSonarQubeEnv('Sonarqube_Server') {
					sh 'mvn sonar:sonar'
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
					def server = Artifactory.server 'Jfrog'
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
}

}
