#!/usr/bin/env bash



echo "This is father shell"

export father_Val="fath shell";

#./child.sh
. ./child.sh
install
. ./child2.sh
#exec ./child.sh

echo $child_Val
echo $child2_Val

echo "father shell over"