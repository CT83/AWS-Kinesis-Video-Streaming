FROM debian:buster

# Download the SDK & compile it
RUN apt-get update -y && apt-get install git -y
RUN git clone --recursive https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp.git

RUN mkdir -p amazon-kinesis-video-streams-producer-c/build && cd amazon-kinesis-video-streams-producer-c/build && cmake ..

 sudo apt-get install byacc flex adoptopenjdk-8-hotspot

 default-jdk

 wget

 git clone https://github.com/awslabs/amazon-kinesis-video-streams-producer-c.git


 apt-get update -y

apt-get install git build-essential cmake g++ wget curl -y

apt-get install libssl-dev libcurl4-openssl-dev liblog4cplus-1.1-9 liblog4cplus-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools -y

git clone https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp.git && cd amazon-kinesis-video-streams-producer-sdk-cpp && git checkout 824de900c2d4b42a403319ace5de9d68ec88b171

cd kinesis-video-native-build

./min-install-script

AWS_ACCESS_KEY_ID=X AWS_SECRET_ACCESS_KEY=XXXX ./kinesis_video_gstreamer_sample_app Stream1 /dev/video0