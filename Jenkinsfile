pipeline{
	agent any
	
	stages{
		stage('Fetch code from GitHub'){
		  steps{
		  	git url: "https://github.com/BharadwajAyinapurapu/Thymeleaf-Project-Spring-Boot.git"
		  }
		}
		
		stage('Compile and Test'){
		  steps{
		  	sh 'mvn clean test'
		  }
		  post{
                	always{
                    		junit '**/target/surefire-reports/TEST-*.xml'
                	}
            	  }
		}
		
		stage('Package'){
            	  steps{
                	sh 'mvn install'
            	  }
                 post{
                	success{
                       	archiveArtifacts 'target/*.jar'
                	}
            	  }
        	}
		
		//stage('Tomcat deploy'){
		//  steps{
		//  	sh 'mv 
		//  }
		//}
		
	}
}
