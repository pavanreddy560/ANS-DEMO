pipeline{
	agent any
	environment{
	    ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
	    DOCKER_ACCESS_TOKEN = credentials('docker-access-token')
	}
	tools {
            maven 'Maven'
    	}
	
	stages{
	    stage('Fetch code from GitHub'){
	  	agent {
	   	   label 'agent-1'
		}
		steps{
		   git url: "https://github.com/BharadwajAyinapurapu/Spring-Boot-Thymeleaf.git"
		}
	    }
		
	    stage('Compile and Test'){
	  	agent {
	      	   label 'agent-1'
	      	}
	  	steps{
		   sh 'mvn clean test'
	  	}
	    }
		
	    stage('Package'){
		agent {
		   label 'agent-1'
		}
    	  	steps{
    		   sh 'mvn install'
    	     	}
    	  	post{
        	    success{
           		archiveArtifacts 'target/*.war'
           		sh 'java -version'
           		sh 'mvn -version'
           		stash 'source'
    		    }
               }
	    }
		
	    stage('Code Quality Check'){
		agent{
		   label 'agent-1'
		}
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
	       agent {
		      label 'agent-1'
	       }
 	       steps{
 		   sh 'jf rt ping --url http://20.244.50.64:8082/artifactory/'
 		   sh 'jf rt u --url http://20.244.50.64:8082/artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN} target/spring-boot-thymeleaf-2.0.0.war Spring-Boot-Thymeleaf/'
 		}	
 	    }
 	    
 	    stage('Docker Stage'){
 	        agent {
		      label 'agent-1'
		    }
 	        steps{
 	            //unstash 'source'
 	            sh ' docker build -t bharadwajayinapurapu/spring-boot-thymeleaf:V.$BUILD_NUMBER .'
 	            sh ' echo $DOCKER_ACCESS_TOKEN_PSW | docker login --username $DOCKER_ACCESS_TOKEN_USR --password-stdin'
 	            sh ' docker push bharadwajayinapurapu/spring-boot-thymeleaf:V.$BUILD_NUMBER'
		    sh ' docker tag bharadwajayinapurapu/spring-boot-thymeleaf:V.$BUILD_NUMBER bharadwajayinapurapu/spring-boot-thymeleaf:latest'
 	            sh ' docker push bharadwajayinapurapu/spring-boot-thymeleaf:latest'
 	        }
 	        
 	    }
		
	    stage('K8S deploy'){
	        agent{
		   label 'agent-2'
	    	}
	        steps{
		    unstash 'source'
		    script{
		        kubernetesDeploy(
			     configs: 'YAML.yml',
			     kubeconfigId: 'K8S' 
			)
		    }
	        }
	    }
		
	    stage('Tomcat deploy'){
		agent {
		   label 'agent-1'
		}
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
