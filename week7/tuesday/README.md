# Week 7 - Tuesday
## Blue/Green Deployment Simulation

This lab focused on building and testing a simple Blue/Green deployment process for the KijaniKiosk API.

The goal was to simulate how a new application version can be deployed safely without affecting the currently running version.

## What I implemented

- A five-phase deployment script (`deploy-app.sh`)
- Blue/Green deployment using separate environments
- Artifact download and validation
- Health checks after deployment
- Idempotent deployments (running the same deployment twice doesn't repeat unnecessary work)
- Basic failure handling for deployment errors

## Project Structure

```
week7/
└── tuesday/
    ├── ansible/
    ├── scripts/
    └── screenshots/
```

## Deployment Phases

1. Fetch the application artifact
2. Validate the downloaded artifact
3. Deploy the new version
4. Restart the target service (only when required)
5. Verify the deployment using the application's health endpoint

## Verification

The deployment was tested by confirming:

- Blue environment continues serving **v1.3.0**
- Green environment successfully runs **v1.4.0**
- Running the deployment twice skips unnecessary work (idempotency)
- Failure scenarios are handled correctly and reported clearly

## Screenshots

The `screenshots/` folder contains evidence of:

- Successful deployment
- Idempotency test
- Phase 1 failure
- Phase 5 failure
- Verification of both Blue and Green environments

## What I learned

This lab helped me understand how production deployments are automated using deployment scripts and service managers like `systemd`.

I also gained hands-on experience with:

- Bash scripting
- Blue/Green deployment
- Artifact management
- Health checks
- Idempotent deployments
- Basic Ansible playbook structure
