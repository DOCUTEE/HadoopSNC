![Docker Logo](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8oc9rEzkFAbyQxF6TYgfCoCwmKjsFH9O8QA&s) 
![Hadoop Logo](https://hadoop.apache.org/images/hadoop-logo.jpg)
---
"Hadoop Single-Node Cluster on Docker Setup"
Author: DOCUTEE 
---

# Introduction

This guide explains how to set up a Hadoop single-node cluster using Docker. The process involves pulling the Docker image, configuring the Hadoop environment, and running the cluster within a container.

## Prerequisites

Before you begin, ensure that you have the following installed:

- Docker
- Basic understanding of Hadoop and Docker

## Step 1: Pull the Hadoop Docker Image

Start by pulling a Hadoop Docker image. You can use `docutee/hadoop_single`:

```bash
docker pull docutee/hadoop_single
```

## Step 2: Run the Container

Run the Docker container with the following command:

```bash
docker run -it --hostname hadoop-master docutee/hadoop_single
```

## Conclusion

You have successfully set up a Hadoop single-node cluster on Docker. You can now use this setup for learning and testing Hadoop functionalities.

# References

1. [Hadoop Official Documentation](https://hadoop.apache.org/docs/stable/)

2. [Docker Documentation](https://docs.docker.com/)

3. Kiwenlau. *Hadoop Cluster on Docker*. GitHub repository, [https://github.com/kiwenlau/hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker).

4. *Docker Workshop Guide*. Available at: [https://www.example.com/docker-workshop-guide](https://www.example.com/docker-workshop-guide).

5. *Hadoop Single Node Cluster Guide*. Available at: [https://www.example.com/hadoop-single-node-guide](https://www.example.com/hadoop-single-node-guide).


