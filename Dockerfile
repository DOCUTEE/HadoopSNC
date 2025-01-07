# Base Image
FROM ubuntu:22.04

LABEL maintainer="DOCUTEE <work.docutee@outlook.com>"

# Set root password
RUN echo "root:root" | chpasswd

# Update and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openjdk-8-jdk wget ssh openssh-server vim && \
    apt-get clean

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV HADOOP_HOME=/home/hadoopminhquang/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin

# Configure SSH
RUN ssh-keygen -A && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd

# Create user hadoopminhquang
RUN adduser --disabled-password --gecos "" hadoopminhquang && \
    echo "hadoopminhquang:hadoopminhquang" | chpasswd && \
    usermod -aG sudo hadoopminhquang && \
    echo "hadoopminhquang ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Hadoop
USER hadoopminhquang
WORKDIR /home/hadoopminhquang
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz && \
    tar -xzf hadoop-3.4.1.tar.gz && \
    mv hadoop-3.4.1 hadoop && \
    rm hadoop-3.4.1.tar.gz

# Set JAVA_HOME in hadoop-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> /home/hadoopminhquang/hadoop/etc/hadoop/hadoop-env.sh

# Configure bashrc
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> /home/hadoopminhquang/.bashrc && \
    echo "export HADOOP_HOME=/home/hadoopminhquang/hadoop" >> /home/hadoopminhquang/.bashrc && \
    echo "export PATH=\$PATH:\$HADOOP_HOME/bin" >> /home/hadoopminhquang/.bashrc && \
    echo "export PATH=\$PATH:\$HADOOP_HOME/sbin" >> /home/hadoopminhquang/.bashrc && \
    echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> /home/hadoopminhquang/.bashrc && \
    echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> /home/hadoopminhquang/.bashrc && \
    echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >> /home/hadoopminhquang/.bashrc && \
    echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >> /home/hadoopminhquang/.bashrc && \
    echo "export HADOOP_YARN_HOME=\$HADOOP_HOME" >> /home/hadoopminhquang/.bashrc && \
    echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> /home/hadoopminhquang/.bashrc && \
    echo "export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib/native\"" >> /home/hadoopminhquang/.bashrc
    

# Copy Hadoop configuration files
COPY config/core-site.xml /home/hadoopminhquang/hadoop/etc/hadoop/core-site.xml
COPY config/hdfs-site.xml /home/hadoopminhquang/hadoop/etc/hadoop/hdfs-site.xml
COPY config/mapred-site.xml /home/hadoopminhquang/hadoop/etc/hadoop/mapred-site.xml
COPY config/yarn-site.xml /home/hadoopminhquang/hadoop/etc/hadoop/yarn-site.xml

# Format HDFS
RUN hdfs namenode -format

# Configure SSH keys
RUN mkdir -p /home/hadoopminhquang/.ssh && \
    ssh-keygen -t rsa -f /home/hadoopminhquang/.ssh/id_rsa -P "" && \
    cat /home/hadoopminhquang/.ssh/id_rsa.pub >> /home/hadoopminhquang/.ssh/authorized_keys && \
    chmod 600 /home/hadoopminhquang/.ssh/authorized_keys && \
    chown -R hadoopminhquang:hadoopminhquang /home/hadoopminhquang/.ssh

# Start SSH and Hadoop services at runtime
USER root
ENTRYPOINT service ssh start && su - hadoopminhquang -c "source ~/.bashrc && ${HADOOP_HOME}/sbin/start-dfs.sh && ${HADOOP_HOME}/sbin/start-yarn.sh && bash"
