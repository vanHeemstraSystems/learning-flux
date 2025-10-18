# 300 - Learning Our Subject


# Learning Flux

**Learning Our Subject**

Welcome to the Flux learning guide! This documentation will take you from Flux basics to advanced GitOps practices for managing Kubernetes deployments.

## Table of Contents

### [100 - Introduction to Flux and GitOps](./100/README.md)

Learn the fundamentals of Flux and the GitOps methodology.

- What is Flux?
- What is GitOps?
- Why use Flux for Kubernetes?
- Flux vs other GitOps tools
- Prerequisites and requirements
- The Flux architecture overview

### [200 - Installation and Setup](./200/README.md)

Get Flux up and running on your Kubernetes cluster.

- Installing the Flux CLI
- Bootstrapping Flux on a cluster
- Repository structure best practices
- Initial configuration
- Connecting to Git repositories
- Basic troubleshooting

### [300 - Core Concepts and Components](./300/README.md)

Understand the building blocks of Flux.

- Source Controller (Git, Helm, Bucket repositories)
- Kustomize Controller
- Helm Controller
- Notification Controller
- Image Reflector Controller
- Image Automation Controller
- How controllers work together

### [400 - GitOps Workflows](./400/README.md)

Learn practical workflows for managing applications with Flux.

- Managing applications with Kustomize
- Managing applications with Helm
- Multi-environment deployments (dev, staging, production)
- Handling secrets and sensitive data
- Application dependencies
- Rollback strategies

### [500 - Advanced Topics](./500/README.md)

Dive into advanced Flux capabilities and patterns.

- Image automation and updates
- Multi-tenancy and RBAC
- Monitoring and observability
- Progressive delivery with Flagger
- Security best practices
- Disaster recovery
- Performance optimization

### [600 - Practical Examples and Troubleshooting](./600/README.md)

Apply your knowledge with real-world examples.

- Sample applications and manifests
- Common use cases and patterns
- Troubleshooting guide
- Debugging techniques
- Common errors and solutions
- Best practices checklist

## Learning Path

We recommend following the sections in order, especially if you’re new to Flux:

1. Start with **100** to understand the concepts
1. Move to **200** to get hands-on with installation
1. Study **300** to learn how Flux works internally
1. Practice with **400** to build real workflows
1. Explore **500** when you’re ready for advanced features
1. Reference **600** as needed for examples and troubleshooting

## Additional Resources

- [Official Flux Documentation](https://fluxcd.io/docs/)
- [Flux GitHub Repository](https://github.com/fluxcd/flux2)
- [CNCF Flux Project Page](https://www.cncf.io/projects/flux/)

-----

Let’s begin! Head to [100 - Introduction to Flux and GitOps](./100/README.md) to start your learning journey.
