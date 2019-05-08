#!/bin/bash
set -x

DATA_DIR=$HOME/Workspace/data
run_tmpl() {
  nvidia-docker run -it --rm \
    -v $(pwd):/workspace \
    -v $DATA_DIR:$DATA_DIR \
    -v /tmp:/tmp \
    perfzero/tensorflow "$@"
}
run() {
  # Docker file is in ./perfzero/docker/Dockerfile_ubuntu_1804_tf_v2. To build a
  # v2 docker image, inside a virtualenv do:
  # $ python3 ./perfzero/lib/setup.py \
  #       --dockerfile_path=docker/Dockerfile_ubuntu_1804_tf_v2 \
  #       --tensorflow_pip_spec=tf-nightly-gpu
  #
  # At first run need to add the following to init the models repo:
  #   --git_repos="https://github.com/tensorflow/models.git"
  # or
  #   --git_repos="https://github.com/aaroey/models.git;keras_tftrt" \
  #
  # After that, if we don't want to update the models repo each time we can
  # remove it from the run. Also if we want to change the model parameter
  # locally, it's in
  # ./perfzero/workspace/site-packages/models/official/resnet/keras/keras_imagenet_benchmark.py
  #
  # For v1 test use:
  # --benchmark_methods=official.resnet.keras.keras_imagenet_benchmark.Resnet50KerasBenchmarkSynth.benchmark_graph_1_gpu_no_dist_strat \
  run_tmpl python3 /workspace/perfzero/lib/benchmark.py \
    --gcloud_key_file_url="" \
    --python_path=models \
    --data_downloads="https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz" \
    --benchmark_methods=official.resnet.keras.keras_imagenet_benchmark.Resnet50KerasBenchmarkSynth.benchmark_1_gpu_no_dist_strat \
    --root_data_dir=$DATA_DIR
}

run
