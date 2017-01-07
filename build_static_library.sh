#!/bin/sh

#要build的target名
target_Name=${PROJECT_NAME}
if [[ $1 ]]
then
target_Name=$1
fi

UNIVERSAL_OUTPUT_FOLDER="${SRCROOT}/${PROJECT_NAME}_Products"

# 创建输出目录，并删除之前的文件
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}"
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"

# 分别编译真机和模拟器版本
xcodebuild -target "${target_Name}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
xcodebuild -target "${target_Name}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

#复制头文件到目标文件夹
HEADER_FOLDER="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/include/${target_Name}"
if [[ -d "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/usr/local/include" ]]
then
    HEADER_FOLDER="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/usr/local/include"
fi
cp -R "${HEADER_FOLDER}" "${UNIVERSAL_OUTPUT_FOLDER}"

#合成模拟器和真机.a包
lipo -create "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${target_Name}.a" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${target_Name}.a" -output "${UNIVERSAL_OUTPUT_FOLDER}/lib${target_Name}.a"

# 判断build文件夹是否存在，存在则删除
if [ -d "${SRCROOT}/build" ]
then
rm -rf "${SRCROOT}/build"
fi

#打开目标文件夹
open "${UNIVERSAL_OUTPUT_FOLDER}"