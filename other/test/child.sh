#!/usr/bin/env bash

install(){
echo "This is  child shell"

export child_Val="child shell"

echo $father_Val

echo "child shell over"
exit 1
}



