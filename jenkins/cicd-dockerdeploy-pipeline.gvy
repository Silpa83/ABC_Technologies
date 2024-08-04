pipeline 
{
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

        stage('Unit Test') {
            steps {
                echo "Performing unit testing..."
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
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
       stage('List Files')
       {
        steps
        {
            script
            {
                 dir('Industry_Grade_Project1/ABC_Technologies')
                 {
                    sh 'ls -l'
                 }
            }
        }
       }

       stage('Build Docker Image') {
    steps {
        script {
            docker.build("silpanandipati/abc_technologies:${BUILD_NUMBER}")
        }
    }
}

stage('Push Docker Image') {
    steps {
        script {
            docker.withRegistry('https://index.docker.io/v1/','DOCKER-HUB-LOGIN') {
                sh "docker push silpanandipati/abc_technologies:${BUILD_NUMBER}"
            }
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
