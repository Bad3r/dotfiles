# Tool: CUDA
# Desc: NVIDIA CUDA Compiler configuration

if [ ! -f "/opt/cuda/bin/nvcc" ]; then
    return
fi

export CUDACXX=/opt/cuda/bin/nvcc