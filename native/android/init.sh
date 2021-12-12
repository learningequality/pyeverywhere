#!/bin/bash

START_DIR=$PWD
DIR=${ANDROID_ROOT}
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Dir is $DIR"
echo "Script Dir is $SCRIPT_DIR"
if [ ! -d $DIR ]
then
    mkdir -p "$DIR"
fi

. $SCRIPT_DIR/setup.sh

cd "$DIR"

echo Platform is $PLATFORM

export ANDROID_HOME=$DIR/android-sdk-$PLATFORM
export SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

FORMAT=tgz
if [[ "$PLATFORM" == "macosx" ]]; then
    FORMAT=zip
fi

if [ ! -d $ANDROID_HOME ] 
then
    echo "Downloading Android SDK build tools"
    mkdir $ANDROID_HOME
    cd $ANDROID_HOME
    wget https://dl.google.com/android/repository/commandlinetools-$PLATFORM-7583922_latest.zip
    unzip commandlinetools-$PLATFORM-7583922_latest.zip
    rm commandlinetools-$PLATFORM-7583922_latest.zip
    cd cmdline-tools/bin
    yes y | ./sdkmanager "platform-tools" --sdk_root=$SDK_ROOT
    yes y | ./sdkmanager "platforms;android-$ANDROIDAPI" --sdk_root=$SDK_ROOT
    yes y | ./sdkmanager "system-images;android-$ANDROIDAPI;default;x86_64" --sdk_root=$SDK_ROOT
    yes y | ./sdkmanager "build-tools;$ANDROIDBUILDTOOLSVER" --sdk_root=$SDK_ROOT
    echo "Accepting all licenses"
    yes | ./sdkmanager --licenses --sdk_root=$SDK_ROOT
    cd ../../..
fi

if [ ! -d android-ndk-$ANDROIDNDKVER ]
then
    echo Downloading Android NDK to $PWD
    curl -o android-ndk.zip --location https://dl.google.com/android/repository/android-ndk-$ANDROIDNDKVER-$NDKPLATFORM-x86_64.zip
    unzip android-ndk.zip
fi 

echo "NDK version is $ANDROIDNDKVER"

echo Downloading https://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz

if [ ! -d apache-ant-$ANT_VERSION ]
then
    curl --location https://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz | tar -x -z -C .
fi
