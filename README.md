# Veime
Terraform

I wrote the terraform code using modules, this is the structure of the files:

├── modules
│   ├── cluster
│   │   └── main.tf
│   ├── deployment
│   │   └── main.tf
│   └── network
│       └── main.tf
├── providers.tf
├── outputs.tf
├── variables.tf
└── main.tf
└── .github
    └── workflows
        └── regtech-ci-cd.yml



How tu run
Each environment will be deployed in its own workspace: dev, prod and stage and has its won var values files (tfvars/prod.tfvars, tfvars/dev.tfvars, tfvars/stage.tfvars). To apply the terraform code you need to be in the root folder with backend configured and the aws credentials configured in the aws cli and run:



key decisions made during the challenge

EKS Cluster: Chose EKS for its managed Kubernetes offering, simplifying cluster operations and maintenance.
Node Group: Implemented a node group to provide scalability and flexibility for different workloads.
Encryption: Enabled encryption for EKS secrets at rest and used TLS for data in transit to protect sensitive data.
CloudWatch: Chose CloudWatch for its seamless integration with AWS services and cost-effectiveness.
CI/CD: Used GitHub Actions to automate the build and deployment process, ensuring consistent and reliable deployments.
Namespaces: Created separate namespaces for development and staging environments to isolate workloads and manage deployments effectively.








