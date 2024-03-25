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

# Background Info

# Tool cache

GitHub's public runners have a tool cache at `/opt/hostedtoolcache`. Popular `setup-*` actions like `setup-node` use it to execute faster by skipping the download and using the cached version.

The contents of the tool cache on public runners looks like this:

```
/opt/hostedtoolcache
├── CodeQL
│   └── 2.16.4
├── Java_Temurin-Hotspot_jdk
│   ├── 11.0.22-7
│   ├── 17.0.10-7
│   ├── 21.0.2-13
│   └── 8.0.402-6
├── PyPy
│   ├── 3.10.13
│   ├── 3.7.13
│   ├── 3.8.16
│   └── 3.9.18
├── Python
│   ├── 3.10.13
│   ├── 3.11.8
│   ├── 3.12.2
│   ├── 3.7.17
│   ├── 3.8.18
│   └── 3.9.18
├── Ruby
│   └── 3.1.4
├── go
│   ├── 1.20.14
│   ├── 1.21.8
│   └── 1.22.1
└── node
    ├── 16.20.2
    ├── 18.19.1
    └── 20.11.1
```
