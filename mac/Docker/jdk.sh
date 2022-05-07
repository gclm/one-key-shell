#!/usr/bin/env bash

cd /Users/gclm/jre1.8.0_231

rm -rf COPYRIGHT LICENSE README release *.txt Welcome.html
#删除其他无用文件
rm -rf     lib/plugin.jar \
           lib/ext/jfxrt.jar \
           bin/javaws \
           lib/javaws.jar \
           lib/desktop \
           plugin \
           lib/deploy* \
           lib/*javafx* \
           lib/*jfx* \
           lib/amd64/libdecora_sse.so \
           lib/amd64/libprism_*.so \
           lib/amd64/libfxplugins.so \
           lib/amd64/libglass.so \
           lib/amd64/libgstreamer-lite.so \
           lib/amd64/libjavafx*.so \
           lib/amd64/libjfx*.so

tar zcvf jre-8u231-linux-x64.tar.gz  *