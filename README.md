## AWS-Kinesis-Video-Streaming

# How to stream video using AWS Kinesis Video Streaming  with Docker on Linux ?

This article talks about how you can stream video using AWS Kinesis Video from one machine to AWS. We will use AWS Kinesis Producer library for this and then view the livestream on AWS.

## 📚 Prerequisites

This article assumes that you already know

* Basics of AWS, AWS Kinesis, Python and Linux
* Cursory understanding  of Docker and Docker Compose

Let's first get some of the basics out of the way.

* AWS Kinesis - essentially a tunnel which lets you send things 
* Kinesis Producer - the thingy that creates stuff to send through the tunnel

This means to get video streaming to work we have to first setup our Producer make sure it is sending things to Kinesis, that's what we will be doing here. 

**Note** - Here, the video source mounted at `/dev/video0` will be streamed to AWS, this can be updated in the `docker-compose.yml` file. Before starting with the next steps make sure `/dev/video0` is the desired video source and that it's working correctly. 

## 👷🏽‍♂️ Steps

### 1. Create a Video Stream Using the AWS CLI

1. Install & setup the [AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/) 

2. Run the following `Create-Stream` command in the AWS CLI:

   ```shell
   aws kinesisvideo create-stream --stream-name "Producer-Stream" --data-retention-in-hours "1"
   ```


### 2. Send Video to the Kinesis Stream

1. Clone my [Github Repo](https://github.com/CT83/AWS-Kinesis-Video-Streaming) `git clone https://github.com/CT83/AWS-Kinesis-Video-Streaming.git `
2. Create .env with client id, & secret for your IAM user Refer the `.example.env` - [Read More](https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/gs-account.html)
3. `docker-compose up --build`

### 3. View the Video Stream

1. Login to AWS Console
2. Navigate to **Kinesis Video Streams**, **Video Streams** and **Producer-Stream**
3. Check different regions if you can't see anything in your current one. Mine in `us-west-2`.

![image-20201002135750753](D:\Code\Python\CT83-PC\AWS-Kinesis-Video-Streaming\images\image-20201002135750753.png)



## 🐛 Appendix

Now, let's get a little bit of a background on what this repository is actually doing, and it is not doing much. 

### Dockerfile

First, let's take a look at the `Dockerfile`, it's simply starting from a base debian image, installing build tools and Gstreamer and building the C++ producer. In the last step we are simply running this producer when the container starts.

```dockerfile
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
```

#### References

* https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp

#### docker-compose.yml

The docker-compose file simply sets a container name, mounts the `/dev/video0` inside the container and sends the environment variables to the container

```yaml
version: "3.3"

services:
  producer:
    container_name: aws-kvs-producer
    build: .
    devices:
      - /dev/video0:/dev/video0
    env_file:
      - .env
```

## References

* https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/gs-createstream.html