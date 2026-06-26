# sysmon-cicd-pipeline

A beginner DevOps project that automates the build, packaging, and deployment of a System Health Monitor script using a full CI/CD pipeline.

---

## What This Project Does

This project shows how code moves from your laptop all the way to a running container on a server, without you having to do anything manually after the first push.

The application itself is a Bash script called `sysmon.sh`. When it runs inside a Docker container, it prints a simple health report of the system:

- Current date and time
- Hostname and uptime
- CPU usage percentage
- Memory usage (used / total)
- Disk space (used / total)

The pipeline handles everything else. You push code to GitHub, Jenkins picks it up, builds a Docker image, uploads it to Docker Hub, and then Ansible pulls and runs it on the server.

---

## Project Structure

```
sysmon-cicd-pipeline/
├── sysmon.sh       - The main script that prints system health info
├── Dockerfile      - Defines how to package the script into a Docker image
├── jenkinsfile     - The Jenkins pipeline (build, push, deploy steps)
├── deploy.yml      - Ansible playbook that pulls and runs the container
├── inventory       - Tells Ansible which server to deploy to (localhost)
└── README.md       - This file
```

---

## How the Pipeline Works

1. You push code to the `main` branch on GitHub
2. Jenkins detects the push via a webhook and starts the pipeline
3. Jenkins clones the repo and builds a Docker image using the Dockerfile
4. Jenkins logs in to Docker Hub and pushes the image as `regentflame11/sysmon:latest`
5. Jenkins triggers Ansible, which pulls the latest image, stops the old container if one is running, and starts a fresh one

---

## Prerequisites

Before running this pipeline, make sure you have the following set up:

- A Linux server with Docker installed
- Jenkins installed with these plugins: Git, Docker Pipeline, Ansible, GitHub
- Ansible installed on the Jenkins server
- A Docker Hub account with credentials saved in Jenkins as `DockerHubCred`
- A GitHub account with a webhook pointing to your Jenkins server

---

## Setup Instructions

**1. Clone the repository**
```bash
git clone https://github.com/Regentflame11/sysmon-cicd-pipeline.git
cd sysmon-cicd-pipeline
```

**2. Add Docker Hub credentials to Jenkins**

Go to Jenkins, then Manage Jenkins, then Credentials. Add a Username/Password entry and set the ID to `DockerHubCred`. Use your Docker Hub username and password.

**3. Create a Jenkins pipeline job**

Create a new Pipeline job in Jenkins. Under Pipeline settings, choose "Pipeline script from SCM", set SCM to Git, paste the repo URL, and set the Script Path to `jenkinsfile`.

**4. Configure a GitHub webhook**

In your GitHub repo, go to Settings, then Webhooks, then Add webhook. Set the Payload URL to `http://your-jenkins-server/github-webhook/`, content type to `application/json`, and trigger it on push events only.

**5. Push and go**

From this point, any push to the `main` branch will trigger the full pipeline automatically.

---

## Running Locally Without Jenkins

If you just want to test the script and Docker image on your own machine:

```bash
# Build the image
docker build -t sysmon .

# Run it
docker run -it --rm sysmon
```

You should see output like:

```
===============================================
           SYSTEM HEALTH DASHBOARD
===============================================
Current Time: Thu Jun 26 10:00:00 IST 2026
Hostname:     your-hostname
Uptime:       up 2 hours, 15 minutes
-----------------------------------------------
CPU Usage:    12.5%
Memory:       3200MB / 15648MB (20.45%)
Disk Space:   30G / 365G (9%)
===============================================
```

---

## Author

Surya Pranav Reddy Vummadi
- GitHub: https://github.com/Regentflame11
- Docker Hub: https://hub.docker.com/u/regentflame11
