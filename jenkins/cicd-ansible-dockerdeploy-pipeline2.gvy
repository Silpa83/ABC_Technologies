pipeline {
     agent any
    
     options {
        skipDefaultCheckout()
     }
    tools
    {
        maven 'Apache Maven 3.8.7'
    }

    stages {
        stage('Setup Git Identity') {
            steps {
                sh 'git config --global user.name "SilpaNandipati"'
                sh 'git config --global user.email SilpaNandipati@github.com'
            }
        }

        stage('Code Compile') {
            steps {
                echo "Performing code compilation..."
                git 'https://github.com/Silpa83/ABC_Technologies.git'
                sh 'mvn compile'
            }
        }

        stage('Package') 
        {
            steps
            {
                echo "Generating the WAR file..."
                sh 'mvn package'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'target/*.war', followSymlinks: false
                }
            }
        }
		stage('docker login & ansible playbook for docker build and push') {
	       steps {
	           withDockerRegistry(credentialsId: 'DOCKER_HUB_LOGIN', url: 'https://index.docker.io/v1/') {
               sh script: 'ansible-playbook -i localhost, deploy/ansible_dockerbuild_play2.yml'
                }
	        }
		}
				
	stage('Deploy Docker Container')
       {
        steps 
        {
         script
         {
            sh '''
                docker stop abc-container || true
                docker rm -f abc-container || true
                docker run --dns 8.8.8.8 --dns 1.1.1.1 -d -p 9090:8080 --name abc-container silpanandipati/abc_technologies:${BUILD_NUMBER}
            '''
          }
         }
       }

    }
}
