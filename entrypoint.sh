#!/bin/bash

# Source ROS distro environment and local catkin_ws
source "/opt/ros/$ROS_DISTRO/setup.bash"
if [ -f "$CATKIN_WS/devel/setup.bash" ]; then
    source "$CATKIN_WS/devel/setup.bash"
fi
if [ -f "$CATKIN_WS/install/setup.bash" ]; then
    source "$CATKIN_WS/install/setup.bash"
fi

HOME_DIR=/home/docker

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/python3.8
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.8

# if something goes wrong with activating the environment we might have to do:
# echo $LD_LIBRARY_PATH

# DIR_CONTEXT_ACTION_FRAMEWORK=$HOME_DIR/catkin_ws/src/context_action_framework
DIR_VISION_PIPELINE=$HOME_DIR/vision-pipeline
DIR_ACTION_PREDICTOR=$HOME_DIR/action_predictor

# install context_action_framework
# if [ -d "$DIR_CONTEXT_ACTION_FRAMEWORK" ]; then
#     # install python package
#     # if ! pip3 list | grep -F context_action_framework &> /dev/null; then
#     #     echo "installing context_action_framework..."
#     #     cd $DIR && python3 -m pip install -e .
#     # fi

#     # install ros package, which also installs python package
#     if ! rospack list-names | grep -F context_action_framework &> /dev/null; then
#         echo "installing context_action_framework catkin package..."
#         cd $HOME_DIR/catkin_ws && catkin build && catkin config --install
#         source "/opt/ros/$ROS_DISTRO/setup.bash" && source "$CATKIN_WS/devel/setup.bash" && source "$CATKIN_WS/install/setup.bash"
#         # reload rospack
#         cd $HOME_DIR/catkin_ws && rospack profile
#     fi
# fi

# install yolact_pkg only for vision pipeline
if [ -d "$DIR_VISION_PIPELINE" ]; then
    if ! pip3 list | grep -F yolact &> /dev/null; then
        echo "installing yolact..."
        cd $HOME_DIR/vision-pipeline/yolact_pkg && python3 -m pip install -e .
    fi
fi

# now cd to the right directory
if [ -d "$DIR_VISION_PIPELINE" ]; then
    export PATH=$PATH:$DIR_VISION_PIPELINE
    cd $DIR_VISION_PIPELINE
fi

if [ -d "$DIR_ACTION_PREDICTOR" ]; then
    export PATH=$PATH:$DIR_ACTION_PREDICTOR
    cd $DIR_ACTION_PREDICTOR
fi

# if build folder doesn't exist, run catkin build
if [ ! -d "$HOME_DIR/catkin_ws/build" ]; then
    cd $HOME_DIR/catkin_ws && catkin build

    # source the new local catkin_ws
    if [ -f "$CATKIN_WS/devel/setup.bash" ]; then
        source "$CATKIN_WS/devel/setup.bash"
    fi
    if [ -f "$CATKIN_WS/install/setup.bash" ]; then
        source "$CATKIN_WS/install/setup.bash"
    fi
fi


exec "$@"