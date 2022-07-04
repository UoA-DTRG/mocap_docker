#  Mocap Docker
This package sets up ROS noetic, mavros, and Vicon_bridge in a docker container to make it portable across multiple different OSes. You will need at least the following hardware requirements to run this package

 - 64-bit CPU with Hardware Virtualization support. Any recent processor should support this.
 - 4GB or more RAM (8+GB recommended)
 - ~15-20gb storage for building the docker container (SSD recommended!)
 - Windows 10 (build 19041 or later), macOS 10.15 or later
 - Both Ethernet and Wi-Fi to connect to Mocap and Drone simultaneously

 NOTE: Only Vicon support is available at this point in time.

 ## Installing
 Since we're using docker containers to run ROS under other OSes, the first step is to install docker. \
 The simplest way to do this is to install docker desktop from [here](https://www.docker.com/products/docker-desktop/)

 Once you have docker installed, run docker desktop and open up a new terminal/command prompt.
 Confirm docker works by running

 ```
 docker --version
 ```

 If you have done everything correctly so far, you should see something along the lines of

 ```
 Docker version 20.10.17, build 100c701
 ```

 Next, clone this repository
 ```
 git clone git@github.com:UoA-DTRG/mocap_docker.git
 ```

 Build the docker container
 ```
 cd mocap_docker
 docker build -t mocap_docker .
 ```

 Go and grab a coffee because this will take a little while.

 ## Running
 Once you have finished building the container, you will have an image thats' ready to run. Get the list of available images using
 
 ```
 docker images
 ```

 From the list of images, select the latest one that you just built
 ```
 REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
 mocap_docker   latest    24a87a32e208   8 minutes ago   2.58GB
 ```

 Run the image using
 ```
 docker run --rm -it -p 14550-14556:14550-14556 -p 801:801 -p 9090:9090 -e FCU_FRAME="vicon/{*UAV_OBJECT_NAME*}/{*UAV_OBJECT_NAME*}" mocap_docker:latest
 ```
 Change ```{*UAV_OBJECT_NAME*}``` to the name of the UAV object in Vicon. This should drop you into a terminal

 ```
 root@a8e3b43688fd:/opt/ros/mocap_ws#
 ```

 Lastly, run the included launch file
 ```
 source devel/setup.bash
 roslaunch mocap_launch all.launch
 ```

 You should now be able to connect with QGroundControl and verify position mode operation.
