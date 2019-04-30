#!/bin/bash

# At first run need to add:
# --git_repos="https://github.com/tensorflow/models.git"
# After that if we want to change the model parameter, it's in
# perfzero/workspace/site-packages/models/official/resnet/keras/keras_imagenet_benchmark.py

nvidia-docker run -it --rm -v $(pwd):/workspace -v $ROOT_DATA_DIR:$ROOT_DATA_DIR \
  perfzero/tensorflow python3 /workspace/perfzero/lib/benchmark.py \
  --gcloud_key_file_url="" \
  --python_path=models \
  --data_downloads="https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz" \
  --benchmark_methods=official.resnet.keras.keras_imagenet_benchmark.Resnet50KerasBenchmarkSynth.benchmark_graph_1_gpu_no_dist_strat \
  --root_data_dir=$ROOT_DATA_DIR

