# AWS Snakemake Pipeline

## Current Status
### Currently this repo is just CloudFormation templates, scripts and some documentation. Future effort would wrap an AWS Amplify App around the deployment and execution of pipelines.
#


## Installation
### This architecture and AWS deployment is guided by a recent blog found [here](https://aws.amazon.com/blogs/architecture/genomics-workflows-part-2-simplify-snakemake-launches/) that elevates Snakemake as a player in Genomics workflows.
<br>

### **The deployment to AWS requires an AWS account that has the AdministratorAccess managed policy**
<br>


### This deployment flow, described in detail below, will create resources in AWS, use a CodeBuild project to put the biolabs/snakemake container into ECR and install latest version of Tibanna. After this is complete, you will have the **example** snakemake configuration in an S3 bucket that can be modified for your use case. A Lambda function is configured that will kick off the pipeline.
<br>

#### AWS CloudFormation Deployment
1. Open the CloudFormation Service in the AWS console.
2. Create a stack with new resources
3. Select **Upload a template file** and use the **Choose File** button to select the AWS-WGS-Snakemake.json file in this repo
4. Hit Next
5. On this screen name the stack **wgs-stack** and leave the network defaults as they are unless this CIDR block conflicts with an existing one, in which case you will need to specify new blocks
6. Hit Next twice and check the box for **I acknowledge that AWS CloudFormation might create IAM resources with custom names.**
7. Then hit submit to start the stack deployment. Some images below should help as you step through this part

   ![alt text](../SS/CloudFormation_1.png)

   <br>

   ![alt text](../SS/CloudFormation_2.png)

    <br>

   ![alt text](../SS/CloudFormation_3.png) 

<br>

#### AWS CodeBuild Execution
1. The Cloudformation template creates a AWS CodeBuild project and executes it as a last step. This can take 5-10 minutes to complete. You should verify it is complete before going to the next step.
2. Log into the AWS Console and go to the CodeBuild projects
3. Select **Build Projects** on the left side navigation
4. Verify the wgs-**create**-pipeline-codebuild project shows success for all phases
   
   ![alt text](../SS/CodeBuild_0a.png)

    <br>

   

   ![alt text](../SS/CodeBuild_2.png)

<br>

#### Update Environment for check_task_awsem_wgs-pipeline-xxxxxxx Lambda
1. Before running you will need to update the check_task_awsem_wgs-pipeline-xxxxxxx function to have TIBANNA_DEFAULT_STEP_FUNCTION_NAME that matches your step function name
2. TIBANNA_DEFAULT_STEP_FUNCTION_NAME is set by default to tibanna_unicorn. You should change this to your Tibanna step function which will be something like tibanna_unicorn_wgs-pipeline-xxxxxxx
3. See image below
![alt text](../SS/LambdaCheckTask_01.png)

    <br>


#### Time to look around
- The engine for this deployment will be powered by a snakemake container and a Tibanna step function that calls Lambdas to allocate the appropriate EC2 instances based on snakefile parameters for memory and cpu. 

- The Tibanna Step function and Lambdas can be seen by going to the respective services in the console and looking around. You should see something like the images below.

   ![alt text](../SS/Statemachine_0.png)

<br>

   ![alt text](../SS/TibannaLambda_0.png)

- The engine will fire up when an Elastic Container Service (ECS) task gets executed. In the above blog this happens when new snakemake files are **PUT** into the S3 bucket. The S3 bucket will notify a Lambda function that executes the ECS task. Currently the S3 bucket doesn't have the trigger to call a Lambda but a Lambda exist that can be called directly. Look around the console in ECS and at the Lambda functions and you should see the following.

  ![alt text](../SS/ECS_0.png)

<br>

   ![alt text](../SS/ECS_1.png)

<br>

   ![alt text](../SS/LambdaExecutor_0.png)

<br>

#### Load the data 

### The fuel for the engine is the data you put into the S3 bucket called **wgs-pipeline-bucket-xxxxxxxx***. Again, some example data already exist to run a very basic pipeline
<br>

1. Verify there is a **data** folder in the S3 bucket. This should look like below image. Make sure the folder structure is right!

<br>

![alt text](../SS/S3_0.png)

#### Fire up the engine
### If things have gone well up to this point, you should be able to start a pipeline from the **WGSStateExecutor** Lambda.
<br>

1. Navigate to the lambda console, and click on the **WGSStateExecutor** Lambda.
2. Take a look at the **Configuration** tab and the environment variables defined.
3. IMPORTANT! You may have to change the **TASK** variable for the right revision. It might have to be move it up 1 like from wgs-pipeline-task:1 to wgs-pipeline-task:2
4. You can find the right revision in the ECS console.
5. Once this revision is correct, create a Lambda Test configuration and then run the Lambda. Some images below to help with this part.

<br>

 ![alt text](../SS/LambdaExecutor_1.png)

   <br>

   ![alt text](../SS/LambdaExecutor_2.png)

   <br>


#### Follow the trial of the pipeline
1. Start in Cloudwatch logs looking at the /ecs/wgs-pipeline-snakemake log

    ![alt text](../SS/CW_0.png)

<br>

2. If you get an ECS task started correctly, then you can start looking at the Tibanna Step function

    ![alt text](../SS/TibannaStepFunction_0.png)

<br>
3. You will also see Tibanna start creating EC2 instances in the EC2 console for each step in the snakemake pipeline
   
   ![alt text](../SS/EC2_0.png)

<br>

4. Eventually the mapped_reads folder in S3 will have 2 file created when a successful run completes

 ![alt text](../SS/S3_1.png)

<br>

#### More Sections to come . . .
#


## Removal

1. Log into the AWS Console and go to the CodeBuild projects
2. Select **Build Projects** on the left side navigation
3. Start the wgs-**remove**-pipeline-codebuild project and watch for success of all phases
   
   ![alt text](../SS/CodeBuild_0.png)

   <br>

   ![alt text](../SS/CodeBuild_1.png)

   <br>

   ![alt text](../SS/CodeBuild_2.png)

   <br>

4. Next, you will need to save off your data in the S3 bucket called **wgs-pipeline-bucket-xxxxxxxx** and then empty and delete the bucket
5. Finally, after the CodeBuild project has completed and you have deleted the S3 bucket, go to the CloudFormation service in the AWS console and delete the stack you created initially

    ![alt text](../SS/CloudFormation_0.png)

** Issues


