#!/bin/bash

mkdir exec  pid  work
mv  xx.jar work
cd exec
wget https://dev.tencent.com/u/gclm/p/shell/git/raw/master/java/deploay.sh
chmod +x deploay.sh
sh deploay.sh xx.jar start