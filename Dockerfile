# syntax=docker/dockerfile:1-labs

FROM maniskill/base

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

WORKDIR /build

# Install torch with CUDA
RUN pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1+cu113 --index-url https://download.pytorch.org/whl/cu113

# Install PyTorch3D
# TODO: Remove
RUN curl -LO https://github.com/NVIDIA/cub/archive/1.10.0.tar.gz && \
    tar xzf 1.10.0.tar.gz && \
    export CUB_HOME=$(pwd)/cub-1.10.0 && \
    pip install 'git+https://github.com/facebookresearch/pytorch3d.git@stable'

# Clone RVT and submodules
RUN git clone --recurse-submodules https://github.com/codyswang/RVT.git

WORKDIR /build/RVT

# Install RVT
RUN pip install ninja
RUN --device=nvidia.com/gpu=all pip install -e .[xformers]

# Install dependencies
RUN --device=nvidia.com/gpu=all pip install -e rvt/libs/YARR && \
    pip install -e rvt/libs/peract_colab && \
    pip install -e rvt/libs/point-renderer

RUN pip install triton==2.2.0 yacs