FROM osrf/ros:noetic-desktop
ARG WS=/opt/ros/mocap_ws
ENV FCU_URL udp://:14551@192.168.4.1:14556
ENV GCS_URL udp://:14555@14550
ENV WORLD_FRAME vicon/world
ENV FCU_FRAME vicon/TD2/TD2
ENV VICON_IP 192.168.10.6:801

# Expose ports for Windows/MacOS since we can't use host network driver
# MAVROS
EXPOSE 14550 14551 14555 14556 
# VICON
EXPOSE 801
# ROSBridge
EXPOSE 9090
# ROS ports not exposed since this will only run mavros and vicon

# Select mirror instead of archive for faster image building
RUN sed -i -e 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//mirror:\/\/mirrors\.ubuntu\.com\/mirrors\.txt/' /etc/apt/sources.list

# Setup git
RUN apt update && apt install -y git

# Setup rvizweb and vicon_bridge
WORKDIR $WS
ARG rvizweb_branch=master
RUN git clone https://github.com/dheera/rosboard.git src/rosboard
RUN git clone https://github.com/ethz-asl/vicon_bridge.git src/vicon_bridge

# Copy our custom launch files
COPY mocap_launch ${WS}/src/mocap_launch

# Install mavros
RUN apt install -y ros-noetic-mavros ros-noetic-mavros-extras
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh && chmod +x install_geographiclib_datasets.sh && ./install_geographiclib_datasets.sh

# Install Rosbridge-server for visualizations
RUN apt install -y ros-noetic-rosbridge-suite

# Build workspace
RUN . /opt/ros/noetic/setup.sh && catkin_make

# Clear apt cache.
RUN apt clean

ENTRYPOINT ["/bin/bash", "-c", "source /opt/ros/noetic/setup.bash && source /opt/ros/mocap_ws/devel/setup.bash && /bin/bash"]