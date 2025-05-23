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

# Installing with xformers requires access to the CUDA runtime, which is difficult to configure at the moment.
# See https://github.com/moby/buildkit/issues/1436
# Current solution is to enter the container post build and manually install packages

# Install RVT
# RUN pip install -e .

# # Install dependencies
# # RUN pip install -e rvt/libs/YARR && \
# #     pip install -e rvt/libs/peract_colab && \
# #     pip install -e rvt/libs/point-renderer
