pipeline{
	agent any
	environment{
	    ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
	    DOCKER_ACCESS_TOKEN = credentials('docker-access-token')
	}
	
	stages{
		stage('Fetch code from GitHub'){
		  steps{
		  	git url: "https://github.com/BharadwajAyinapurapu/Spring-Boot-Thymeleaf.git"
		  }
		}
		
		stage('Compile and Test'){
		  steps{
		  	sh 'mvn clean test'
		  }
		}
		
		stage('Package'){
    	  steps{
    		sh 'mvn install'
    	  }
    	  post{
        	success{
           		archiveArtifacts 'target/*.war'
           		sh 'java -version'
           		sh 'mvn -version'
    		}
          }
		}
		
		stage('Code Quality Check'){
		    steps{
	    	    withSonarQubeEnv(installationName: 'sonarqube-7.1'){
	    	        
		            sh 'mvn sonar:sonar \
		            -Dsonar.projectKey=Spring-Boot-Thymeleaf \
                    	    -Dsonar.host.url=http://20.244.33.251:9000 \
                            -Dsonar.login=fd33ee7091591b0f916c86700f2a700ea9cbfe21'

		        }
		    }
	    }   
	    
	    stage('Publish to JFrog'){
 		    steps{
 		        sh 'jf rt ping --url http://20.244.50.64:8082/artifactory/'
 			    sh 'jf rt u --url http://20.244.50.64:8082/artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN} target/spring-boot-thymeleaf-2.0.0.war Spring-Boot-Thymeleaf/'
 		    }	
 	    }
 	    
 	    stage('Docker Stage'){
 	        steps{
 	            sh ' docker build -t bharadwajayinapurapu/spring-boot-thymeleaf:V.$BUILD_NUMBER .'
 	            sh ' echo $DOCKER_ACCESS_TOKEN_PSW | docker login --username $DOCKER_ACCESS_TOKEN_USR --password-stdin'
 	            sh ' docker push bharadwajayinapurapu/spring-boot-thymeleaf:V.$BUILD_NUMBER'
 	        }
 	    }
		
		stage('Tomcat deploy'){
		    steps{
		        ansiblePlaybook becomeUser: 'bd', credentialsId: 'SSH-Private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml'
		    }
		}
		
	}
	
	post{
	    always{
	        sh 'docker logout'
	    }
	}
}
