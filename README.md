# CICDQualityGateCRTTests

The CRT job Copado CI/CD runs after a deployment. One suite, `tests/create_lead.robot`: log in to the
deployed (destination) org, create a Lead with generated values, check it saved.

**Login (`resources/login.robot`, `Login To Target Org`):** when Copado CI/CD runs the job (a test
attached to a user story, or a quality gate after a promotion) it passes `${loginUrl}`, a one-click
login link to the destination environment; the suite goes straight in with it. Run on its own in CRT,
no `${loginUrl}` arrives and the suite logs in with JWT from the job's `client_id` / `username` /
`private_key` variables (set them in CRT, never in this repo). `${route}` comes from the Copado Test
record's configuration so the log says which route triggered the run.
