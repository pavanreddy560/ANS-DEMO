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
		
		/*stage('Compile and Test'){
		  steps{
		  	//sh 'mvn clean test'
		  }
		}*/
		
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
		            sh 'mvn sonar:sonar'
		        }
		    }
	    }   
	    
	    stage('Publish to JFrog'){
 		    steps{
 			    sh 'jf rt u --url http://192.168.56.102:8082/artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN} target/spring-boot-thymeleaf-2.0.0.war Spring-Boot-Thymeleaf'
 		    }	
 	    }
		
		stage('Tomcat deploy'){
		    steps{
		        ansiblePlaybook credentialsId: 'Tomcat-deploy', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml'    
		    }
		}
		
	}
}
