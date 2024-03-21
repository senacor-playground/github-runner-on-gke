# Manual Steps

## Step 1: GitHub App

- Create and install a Github App [following these steps](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api).
- Record the secrets in a YAML document `runner.yaml`:
  ```yaml
  github_app_id: 123456
  github_app_installation_id: 12345678
  github_app_private_key: |
    -----BEGIN RSA PRIVATE KEY-----
    ...
    -----END RSA PRIVATE KEY-----
  ```
- Run `cat runner.yaml | yq e -o=json | pbcopy` to convert it into JSON.
- Create a Google Secret Manager secret called `github-runnner-app` and store the JSON in it.
