FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel

ENV TZ=Asia/Seoul
ENV COCOAPI=/workspace/cocoapi

WORKDIR /workspace

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install git ffmpeg libsm6 libxext6  -y

RUN mkdir /workspace/deep-high-resolution-net.pytorch
COPY . /workspace/deep-high-resolution-net.pytorch

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR ./deep-high-resolution-net.pytorch/lib
RUN make

RUN git clone https://github.com/cocodataset/cocoapi.git $COCOAPI
WORKDIR $COCOAPI/PythonAPI
RUN make install
RUN python setup.py install --user

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

WORKDIR /workspace/deep-high-resolution-net.pytorch
RUN mkdir output log models data data/coco data/mpii

CMD ["bash", "start.sh"]