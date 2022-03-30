# DESIGN
1.  AWS LAMBDA :  Application code runs here.
1.  AWS S3 : Application packaged artifacts are stored here .
1.  AWS API GATEWAY : Single point of entry to API on lambda .
1.  AWS CLOUDWATCH : Logs for both lambda and apigateway

# DESIGN CONSIDERATION
1.  Zero maintenance overhead.
1.  Use default autoscaling provided by lambda.
1.  Infra compromise/attacks avoid by using serverless architecture so that SSH is not even possible.
1.  Blue/Green deployments: zero-downtime release enables traffic to shift to the new live environment (green) while still keeping the old production environment (blue) warm in case a rollback is necessary. 
1.  API Gateway allows you to define what percentage of traffic is shifted to a particular environment
1.  CloudWatch metrics can be captured on API Gateway & Lambda .


# API USED
https://github.com/GoogleCloudPlatform/nodejs-getting-started/tree/30d625750f542a03e9c239ac851560ac0def3080/1-hello-world
# CHANGES DONE TO API SHARED
Added aws lambda specific file: ```lifebit-test/hello-world/lambda.js```   

# STEPS TO PROVISION INFRASTRUCTURE AND DEPLOY APPLICATION

1.  Install [Node.js](https://nodejs.org/en/).
1.  Install [git](https://git-scm.com/).
1.  Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
1.  Install [Terraform](https://www.terraform.io/downloads).


1.  Install dependencies:

        cd hello-world
        npm install

1.  Configure AWS Account:

        aws configure
        AWS Access Key ID [None]: XXXXXXXXXXXXXXX
        AWS Secret Access Key [None]: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        Default region name [None]: us-east-1
        Default output format [None]: json

1.  Initialize terraform and validate syntax:

        cd terraform
        terraform init
        terraform validate

1.  Infrastructure provisioning and application package & deployment done with below single command. Review plan either separately or just review with apply:

        terraform apply
        Plan: 14 to add, 0 to change, 0 to destroy.
        Enter yes

1.  Once terraform execution finishes, it will output the endpoint of the deployed app:

        Outputs:
        base_url = "https://XXXXXXX.execute-api.us-east-1.amazonaws.com/v1"

1. Access application :

        curl https://XXXXXXX.execute-api.us-east-1.amazonaws.com/v1       
        Hello, world!

1. DESTROY deployed aws resources by:

        terraform destroy
        Plan: 0 to add, 0 to change, 14 to destroy.
        Enter yes
        Destroy complete! Resources: 14 destroyed.


# APPLICATION LOGS
1. Logs are stored in cloudwatch.
1. Separate logs for lambda (app) and apigateway.



# SIMULATE LOAD(Use base_url from terraform output):

        for i in `seq 1 20`; do curl https://XXXXXXX.execute-api.us-east-1.amazonaws.com/v1; done
```
Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world! 
```
