# DevOps Intern Final Assessment

**Name:**Muhammad Haseeb Sajid  
**Date:** 11 August 2026  
**Project:** DevOps Intern Final Assessment

## Project Overview

This project demonstrates a small DevOps workflow using open-source and commonly used DevOps tools.

The project covers:

- Git & GitHub
- Linux shell scripting
- Docker
- GitHub Actions CI/CD
- HashiCorp Nomad
- Grafana Loki
- Promtail

Each step produces a practical output that is used or documented in the following steps.

---

# Project Structure

```text
devop-intern/
├── .github/
│   └── workflows/
│       └── ci.yml
├── monitoring/
│   ├── loki_setup.txt
│   └── promtail-config.yml
├── nomad/
│   └── hello.nomad
├── scripts/
│   └── sysinfo.sh
├── screenshots/
│   ├── step-1-github.png
│   ├── step-1-hello-readme.png
│   ├── step-2-linux-script.png
│   ├── step-3-docker.png
│   └── step-4-github-actions.png
├── Dockerfile
├── README.md
└── hello.py
Step 1 — Git & GitHub Setup

A public GitHub repository was created for the assessment.

The initial project includes:

README.md
hello.py

The Python program prints:

Hello, DevOps!
Test
python hello.py

Expected output:

Hello, DevOps!
Git Verification
git status

The repository was initialized and synchronized with the GitHub main branch.

Screenshot

Step 2 — Linux & Scripting Basics

A shell script was created at:

scripts/sysinfo.sh

The script displays:

Current user using whoami
Current date using date
Disk usage using df -h
Make the script executable
chmod +x scripts/sysinfo.sh
Run the script
./scripts/sysinfo.sh

The script was tested successfully in the Linux/WSL environment.

Screenshot

Step 3 — Docker Basics

A Dockerfile was created to containerize hello.py.

Dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY hello.py .

CMD ["python", "hello.py"]
Build the Docker image
docker build -t devops-hello .
Run the container
docker run --rm devops-hello

Expected output:

Hello, DevOps!

The image was built and the container was tested successfully.

Screenshot

Step 4 — CI/CD with GitHub Actions

A GitHub Actions workflow was created at:

.github/workflows/ci.yml

The workflow runs automatically whenever code is pushed to the repository.

The CI job executes:

python hello.py

This verifies that the sample application can run successfully in the GitHub Actions environment.

CI Workflow
name: DevOps CI

on:
  push:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Run application
        run: python hello.py
CI Status

The GitHub Actions workflow completed successfully.

Screenshot

Step 5 — Job Deployment with Nomad

A Nomad job specification was created at:

nomad/hello.nomad

The job uses:

type = "service"
Docker driver
devops-hello:latest
Minimal CPU and memory resources
Validate the Nomad job
nomad job validate ./nomad/hello.nomad

The job specification validated successfully.

Run the Nomad job
nomad job run ./nomad/hello.nomad
Check job status
nomad status hello-devops
Docker Image Verification

The Docker image was independently verified with:

docker run --rm devops-hello:latest

Output:

Hello, DevOps!

The Nomad Docker driver was detected as healthy on the Nomad client.

During the local Nomad deployment test, the allocation encountered a Docker image visibility/pull issue. Nomad attempted to pull devops-hello:latest instead of using the locally available image in the same way as the interactive Docker CLI environment.

The issue was investigated using Nomad allocation status and node information.

Step 6 — Monitoring with Grafana Loki

Grafana Loki was configured locally using Docker.

Promtail was used as the log collector and forwarder. It watches Docker container JSON log files and forwards them to Loki.

Start Loki

The Loki image was pulled using:

docker pull grafana/loki:latest

Loki was started using:

docker run -d --name loki -p 3100:3100 grafana/loki:latest
Check Loki readiness
curl.exe "http://localhost:3100/ready"

After Loki finished starting, the response was:

ready

This confirmed that Loki was running successfully.

Create Monitoring Network

A Docker network was created for the monitoring components:

docker network create monitoring

The Loki container was connected to the network:

docker network connect monitoring loki
Promtail Configuration

Promtail was configured using:

monitoring/promtail-config.yml

The configuration watches Docker container log files:

/var/lib/docker/containers/*/*-json.log

Promtail forwards these logs to Loki.

Start Promtail

Promtail was started with:

docker run -d --name promtail `
  --network monitoring `
  -v /var/lib/docker/containers:/var/lib/docker/containers:ro `
  -v "${PWD}/monitoring/promtail-config.yml:/etc/promtail/config.yml:ro" `
  grafana/promtail:latest `
  --config.file=/etc/promtail/config.yml
Verify Promtail
docker ps -a --filter "name=promtail"

Promtail was running successfully.

Its logs were checked using:

docker logs promtail --tail 30

The Promtail logs confirmed that Docker container log files were discovered and watched.

Query Logs from Loki

Loki's HTTP API was used to query the forwarded Docker logs:

curl.exe "http://localhost:3100/loki/api/v1/query_range?query=%7Bjob%3D%22docker%22%7D&limit=100"

The API returned JSON log data.

This confirmed that Docker container logs were being collected by Promtail and made available through Loki.

Detailed monitoring setup notes are also available in:

monitoring/loki_setup.txt
Extra Credit

The optional MLflow and VirtualBox extensions were not required for the core assessment and were not included.

Final Deliverables
Requirement	Output
Git & GitHub	Public GitHub repository
Linux scripting	scripts/sysinfo.sh
Docker	Dockerfile
CI/CD	.github/workflows/ci.yml
Nomad	nomad/hello.nomad
Monitoring	monitoring/loki_setup.txt
Promtail	monitoring/promtail-config.yml
Documentation	README.md
Screenshots	screenshots/
Tools Used
Git / GitHub — Source control and repository hosting
Linux / WSL — Shell scripting and Linux environment
Python — Sample application
Docker — Application containerization
GitHub Actions — CI automation
HashiCorp Nomad — Job scheduling and deployment
Grafana Loki — Log aggregation
Grafana Promtail — Docker log collection and forwarding
DevOps Workflow
Source Code
    ↓
Git & GitHub
    ↓
Linux Script
    ↓
Docker Container
    ↓
GitHub Actions CI
    ↓
Nomad Deployment
    ↓
Docker Logs
    ↓
Promtail
    ↓
Grafana Loki
Conclusion

This project demonstrates a basic end-to-end DevOps workflow covering source control, Linux scripting, containerization, CI/CD, job deployment, logging, monitoring, and technical documentation.

The project was implemented and tested using a local Windows/WSL development environment with Docker Desktop.