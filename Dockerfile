FROM debian:buster

# Install Requirements
RUN apt-get update -y && apt-get install git build-essential cmake g++ wget curl -y
RUN apt-get install libssl-dev libcurl4-openssl-dev liblog4cplus-1.1-9 liblog4cplus-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools -y

# Build Producer
RUN git clone https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp.git
WORKDIR /amazon-kinesis-video-streams-producer-sdk-cpp
RUN git checkout 824de900c2d4b42a403319ace5de9d68ec88b171
WORKDIR /amazon-kinesis-video-streams-producer-sdk-cpp/kinesis-video-native-build
RUN ./min-install-script

CMD ["/amazon-kinesis-video-streams-producer-sdk-cpp/kinesis-video-native-build/kinesis_video_gstreamer_sample_app", "Producer-Stream","/dev/video0"]