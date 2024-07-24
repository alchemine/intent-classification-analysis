FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-devel

# Set korean
ENV LANG=ko_KR.UTF-8
ENV LC_ALL=ko_KR.UTF-8

# Install fundamental packages
RUN apt-get update && \
    apt-get install -y git wget unzip vim curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*