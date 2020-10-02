## AWS-Kinesis-Video-Streaming

# How to stream video using AWS Kinesis Video Streaming with Python on Linux?

This article talks about how you can stream video using AWS Kinesis Video from one machine to AWS. We will use AWS Kinesis Producer library for this and then view the livestream on AWS. 

>  Note The Producer is not available for Python we are going to have to be hacky about it. - More in the Appendix

## Prerequisites

This article assumes that you already know

* Basics of AWS, Python and Linux
* AWS Kinesis

## Background

Let's first get some of the basics out of the way.

* AWS Kinesis - essentially a tunnel which lets you send things 
* AWS Kinesis Producer - the thingy that creates stuff to send through the tunnel
* AWS Kinesis Consumer - the thingy that accepts/consumers stuff from the tunnel

This means to get video streaming to work we have to first setup our Producer make sure it is sending things to Kinesis, that's what we will be doing here.

## Steps

### 1. Create a Video Stream Using the AWS CLI

1. Install [AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/) 

2. Run the following `Create-Stream` command in the AWS CLI:

   ```shell
   aws kinesisvideo create-stream --stream-name "Stream1" --data-retention-in-hours "2"
   ```

3. Note down the **StreamARN** from the response.

   ```json
   {
       "StreamARN": "arn:aws:kinesisvideo:us-east-1:334749483857:stream/Stream1/1601273866498"
   }
   ```

### 2. Send Video to the Kinesis Stream



## Troubleshooting



## References

* https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/gs-createstream.html