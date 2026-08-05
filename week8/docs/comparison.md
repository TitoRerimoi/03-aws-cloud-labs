# Comparing Blue/Green Deployment and Container-Based Deployment

## Prepared for Nia

Modern software delivery aims to minimise downtime while making deployments safer, faster and easier to recover when problems occur. During this project, two deployment approaches were implemented and evaluated. The first used a blue/green deployment strategy to reduce the risk associated with releasing a new version of an application. The second used containerisation to package the application into a portable image that can run consistently across different environments. Although both approaches improve software delivery, they solve different operational challenges and complement each other.

Blue/green deployment reduces deployment risk by maintaining two identical production environments. One environment serves live traffic while the second hosts the new application version. Once the new version has been validated, production traffic is redirected to it. If a fault is detected after the release, traffic is quickly redirected back to the previous environment. This approach significantly reduces downtime and provides a safe rollback mechanism.

Container-based deployment addresses a different challenge by packaging the application together with all required runtime dependencies. The resulting image behaves consistently regardless of where it is deployed, reducing environment-specific issues. Versioned images also improve traceability because each deployment can be linked directly to a specific application version and source code revision.

| Concern | How the blue/green approach addresses it | How the container approach addresses it |
|----------|------------------------------------------|------------------------------------------|
| Deployment mechanism | Two identical environments are maintained and production traffic is switched only after the new version has been verified. | The application is packaged into a versioned container image that runs consistently across development, testing and production environments. |
| Rollback mechanism | Service is restored by redirecting production traffic back to the previously healthy environment. | Service is restored by deploying a previously published container image version from the registry. |
| Failure recovery | Recovery depends on switching traffic back to the healthy environment after a failed deployment. | Failed application instances can be recreated automatically when managed by an orchestration platform. |
| Scaling | Additional capacity requires preparing additional environments or servers. | Multiple identical container instances can be started quickly to handle increased workload. |

The practical results from this project demonstrate the strengths of combining automation with containerisation. During testing, the automated monitoring process detected a simulated deployment failure and completed the rollback in approximately **21 seconds**, comfortably below the required recovery target of 90 seconds. This reduced the need for manual intervention and improved service availability.

The production container image was also optimised for deployment by removing unnecessary build tools and running the application as a dedicated non-root user. Compared with a development-oriented image, the production image reduced unnecessary runtime components while improving security and portability. Smaller production images generally require less storage space and can be distributed more efficiently because less data must be transferred before the application starts.

Containerisation alone does not solve every operational challenge. Containers provide consistency and portability, but they do not automatically manage multiple application instances, distribute traffic, replace failed workloads or coordinate large-scale deployments. These responsibilities require an orchestration platform.

The next stage of the project introduces Kubernetes orchestration, which builds upon containerisation by continuously monitoring application health, restarting failed application instances, managing scaling and maintaining the desired application state. Together, blue/green deployment, containerisation and orchestration provide a reliable foundation for delivering resilient production systems.
