# Design Decisions

To ensure secure and performant self-hosted runners, the following design decisions have been made:

1. Runners are ephemeral, i.e. they get discarded after running a single job. In particular, no file sharing occurs between runs to prevent leakage of secrets and code injection possibilities.
2. The runners are executed on GKE to leverage the cluster autoscaling capabilities of Kubernetes. The official [GitHub Actions Runner Controller](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller) mechanism is used.
3. There is always a specified number of idle runners available that is ready to instantly pick up new jobs.
4. The runners are deployed in multiple GCP regions to mitigate regional outages like compute capacity shortages. See documentation on [high availability and automatic failover](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/deploying-runner-scale-sets-with-actions-runner-controller#high-availability-and-automatic-failover).
5. Monitoring dashboards showing the performance of the runners are made available to all consumers of the runners.
6. Setup actions like `actions/setup-node` and `google-github-actions/setup-gcloud` can execute without having to download files. To facilitate this, the runners are equipped with a [tool cache](https://docs.github.com/en/enterprise-server@3.12/admin/monitoring-managing-and-updating-your-instance/updating-the-virtual-machine-and-physical-resources/upgrading-github-enterprise-server) filled with relevant tools. The tool cache is implemented in a way that allows fast runner startup times, that preseves disk space on the Kubernetes nodes (avoid file duplication) and that avoids leaking files from one job to the next.

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
