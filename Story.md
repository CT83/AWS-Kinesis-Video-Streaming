# The story of how I (kinda') fixed AWS Kinesis Producers, helped a student and saved humanity hundreds of  man hours! 

After investing about 20 hours, I finally managed to get AWS Kinesis Video Streaming Producers to work on my Raspberry Pi, despite of the confusing instructions, Github repos which were widely different from the official docs & too many alternative ways to run things - this is the story of how I did that. 

## 👦🏽 How did it start?

It all started with an innocent looking WhatsApp message, from a student who was trying to get AWS Kinesis Video Streams to work for a college project. He said he saw my commits to the AWS Kinesis repo and messaged me asking for help to get it up and running. 

I arrogantly thought, "Ah, newbies can't even follow the docs properly."  Back then, little did I know how deep this rabbit hole went, what followed were 3 entire days of research, googling and total mind-funkery, all just to get a simple "send data to cloud script" working.

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/yoahq8la92h99cr9xqrv.png)

## 🖤 You stare into the abyss...

What we wanted to achieve was pretty simple, we just wanted a way to stream video frames to AWS Kinesis from `/dev/video0` on Linux. Instinctively I looked up the AWS docs and here is where the trouble started

The Problems.

### GStreamer?!

Turns out there are mainly 2 ways to get the AWS Kinesis Producer libraries to working. One is using the compiled C++ code from a Github repo and other is by compiling a GStreamer plugin, but that's not all. The GStreamer command changes slightly depending on what platform you are on, this means there are in all 2 x 3 (Mac/Win/Linux) ways to get this up and running that you are greeted with right when you first load up their hello-world example. One could patiently try to read through all of this but the docs even lack a *Prerequisites Section*, this makes getting started even more difficult. 

Suggested Fixes - *Adding a Prerequisites Section will easily fix this.*

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/ob1f7977c64wr3e5jie7.png)

### Docker to the rescue?...No

The next way to get the Kinesis Video Producer up and running is by using Docker, one would imagine that this would be lesser of the two evils and it would work similarly across all platforms but you would still be wrong. The docs briefly mention that there is some kind of Docker way to run the Producer but towards the end they leave you off with  - **Start streaming from the camera using the `gst-launch-1.0` command that is appropriate for your device.**

The commands GStreamer commands they wanted me to run here kept on complaining that the GStreamer Plugin to support Kinesis-stuff was not installed.

This essentially meant even Amazon's own Docker Images are not working.

Suggested Fixes - *Installing things using Docker is a separate way to get the producer up, it should have come with **complete** instructions on what we are supposed to do, one should not have to run back and forth between several pages.*

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/8uozq6iten40pb5cwztb.png)

### Inequality among platforms

Now, on Windows and Mac you cannot get the web camera streaming working with Docker, but on Linux you can. There is no table which tells you which way allows you to do what, what are the advantages and what are the disadvantages of that way and so on. This makes it all really a hit-and-miss approach while deciding what to do. 

Suggested Fixes -  *All the 2 different ways (Docker and GStreamer) and ways for different platforms are all sprinkled in with each other a better way would be to create a separate and complete tutorial for each platform, and then add a comparison sheet to summarize everything nicely.*

This was just the start, these were all of the glaring issues I could see right off the bat when I took a look at AWS's documentation, Azure on the other hand in one of their Azure IOT tutorials runs us through each scenario completely from start to finish. They also have several videos to show us how to get things up.

## 🌪 Smoke & Mirrors

Back to the problem we were trying to solve - "how to get a AWS Kinesis Producer running on Linux"

Initially I just assumed that the docs were difficult to understand but correct, I just needed to follow them precisely. But, boy! was I wrong. I soon came to the realization that the docs were flat out lying. Yes, let me explain.

### The Lying Docs  #1

In [Using the C++ Producer SDK on Raspberry Pi](https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/producersdk-cpp-rpi.html)  the docs tell you to run **install-script**, but I have look around and if one were to follow the docs to the point, and I have you won't be able to find any such file. The closest thing you can find to something like this in a previous version of the GitHub repo in one of the [older commits](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp/blob/824de900c2d4b42a403319ace5de9d68ec88b171/kinesis-video-native-build/install-script). 

Yes. You see the problem? Not only that, this is not where this ends. 

The only reason I was able to find this out was because the docs referred to using `git clone --recursive`, I was skeptical what that meant but, I thought it was because the repo, once used to have embedded repos. Now the docs still say it does but in reality it does not.

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/fwcpapi0d989ocz5phbu.png)

### The Lying Docs  #2

In [Step 3: Run and Verify the Code](https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/producersdk-cpp-test.html) the docs talk about cd-ing into `amazon-kinesis-video-streams-producer-c` but, that is impossible because one of the commits removed this embedded github repository ([Read More](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp/commit/1865e4e8ea55fbc8d090650480ddf6af004511ef))

The only way to get this to work is by checking out the older code from one of the [previous commits](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp/tree/824de900c2d4b42a403319ace5de9d68ec88b171) - *This is what I do [here](https://dev.to/rohansawant/how-to-stream-video-using-aws-kinesis-video-streaming-with-docker-on-linux-14e9)* 

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/i0y6m1han8mvgvis8i9j.png)

I will cease to ramble more on about this but the temporary solution for this is to checkout the repo at one of the earlier stages that fixes all of the out-of-sync issues of the docs with the repos. 

*Suggested Fixes - Checkout commit [824de900c2d4b42a403319ace5de9d68ec88b171](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp/tree/824de900c2d4b42a403319ace5de9d68ec88b171)*

## 🔥  My Solution

I knew something had to be done about this. I could not let everyone waste just as much time as I had wasted, so I wrote a very short technical blog about this.  [How to stream video using AWS Kinesis Video Streaming - Docker on Linux?](https://dev.to/rohansawant/how-to-stream-video-using-aws-kinesis-video-streaming-with-docker-on-linux-14e9)  - It gives you just enough information to get this to work, and nothing else. 

But, hopefully some one some day will find great value in it.

Finally, how did I get the streaming to work, how can you? 

### docker-compose up --build

I wrote this blog summarizing my approach - [How to stream video using AWS Kinesis Video Streaming - Docker on Linux?](https://dev.to/rohansawant/how-to-stream-video-using-aws-kinesis-video-streaming-with-docker-on-linux-14e9)

That's all you need to do. 😎

This will send the video stream from `/dev/video0` straight to your AWS Kinesis Video Stream

Now, the approach I propose in the blog may not be the best one, it might not be the most efficient one, but that's not the goal of it. The official docs can go in more details on how to speed things up, but the initial setup I believe should be way easier than it is right now.

## 👩🏽‍🚀  Conclusion

What did we learn here? And why was I extremely mad when I first encountered this issue? 

### AWS Kinesis is actually great

Personally, I think this enormous level of complexity to get things up and running with AWS Kinesis makes the entire pipeline look very difficult to use and because I have used AWS Kinesis before I know for a fact that this is not the case, AWS Kinesis is pretty cool and paired up with SageMaker it is capable of doing really impressive things. (expensive, yes but impressive things)

### The Space-Time Continuum

I am also confident that Rohan from 2 years ago would have certainly given up on trying to get this working, and because all the ways to get an AWS Kinesis Producer up and running are considerably difficult Amazon is actually losing out on a large chunk of new users which would have otherwise used the service but now fail to do so. 

It is also really surprising to note that the ways I tried to get the Producer up and running are also the ways most web developers would try to get things running and all of those failed, I had to literally go back in time to get the Producer working. When customers have to bend the space-time continuum to get your service working it is rarely a good thing.

### Currently no way to get it up

The issue disproportionately ended up affecting all of the new users who were trying to use AWS Kinesis, virtually without being very very smart, and without using Github commit history I cannot think of a way someone would be able to get the Producer running, this means there will be very few people are able to get it up.

So, yeah this was it. That was how I was able to get AWS Streaming to work. 

### AMZ, Slide in to the DMs

Amazon, you are watching and want me to build docker images to add support for RTSP streaming too don't be shy. My DMs are open for you. If I was too hard on you that's only because you made me waste a week's worth of time on you, nothing against you, man. You are okay. 🤝🏽