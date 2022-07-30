pipeline{
	agent any
	environment{
	    ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
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
                    	    -Dsonar.host.url=http://localhost:9000 \
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
		
		stage('Tomcat deploy'){
		    steps{
		        ansiblePlaybook becomeUser: 'bd', credentialsId: 'SSH-Private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml'
		    }
		}
		
	}
}
