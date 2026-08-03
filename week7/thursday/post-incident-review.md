# Post-Incident Review – Week 5 Monday Incident

## Incident Summary

During a production demonstration, a manual production deployment was triggered, causing an unexpected service disruption. The issue was identified quickly and the previous working version was restored.

---

## Timeline

- 09:00 – Amina opened the deployment terminal.
- 09:02 – Production deployment command was executed.
- 09:03 – Deployment started.
- 09:04 – Service behaviour changed.
- 09:05 – Nia noticed the issue during the investor walkthrough.
- 09:06 – Tendo investigated the deployment.
- 09:08 – Previous version was restored.
- 09:10 – Service confirmed healthy.

---

## Root Cause (Five Whys)

**Why did the incident happen?**

A production deployment was triggered manually.

**Why?**

The deployment relied on a manually supplied environment variable.

**Why?**

The deployment process allowed manual environment selection.

**Why?**

The pipeline did not automatically determine the deployment environment.

**Root Cause**

The deployment process depended on manual input instead of an automated pipeline.

---

## Prevention

- Use the `set-environment` job in `deploy.yml` to determine the environment automatically.
- Remove manual `ENV` parameters from deployment commands.
- Require production deployments to go through the pipeline.

---

## Action Items

| Owner | Action | Target Week |
|-------|--------|-------------|
| Amina | Stop using manual production deployment commands. | Week 8 |
| Tendo | Improve deployment validation and rollback checks. | Week 8 |
| Nia | Review deployment process before production releases. | Week 8 |
