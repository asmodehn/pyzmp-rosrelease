#!/bin/bash
set -e

# first we ensure we change to the directory where this script is.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


# These variables need to be setup before calling this script:
# ROS_DISTRO [indigo | jade | kinetic]
# ROS_FLOW [devel | install]

source /opt/ros/$ROS_DISTRO/setup.bash
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=./install
if [ "$ROS_FLOW" == "devel" ]; then
    make -j1
    source devel/setup.bash
    make -j1 tests
    make -j1 run_tests
    catkin_test_results .
elif [ "$ROS_FLOW" == "install" ]; then
    make -j1 install
    source install/setup.bash
    python -m pytest --pyargs pyzmp
fi
