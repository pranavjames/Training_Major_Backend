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
				sh "PATH = ${M2_HOME}/bin:${PATH}"
				sh "M2_HOME = /opt/maven"
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
					def server = Artifactory.server 'Jfrog'
					def uploadSpec = """{
					"files": [{
						"pattern": "target/*.jar",
						"target": "Jenkins_Integration/"
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
