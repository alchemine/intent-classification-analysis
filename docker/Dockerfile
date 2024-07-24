FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-devel
# Install fundamental packages
RUN apt-get update && \
    apt-get install -y git wget unzip vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*