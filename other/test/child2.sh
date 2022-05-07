#!/usr/bin/env bash

install(){
echo "This is  child2 shell"

export child2_Val="child2 shell"

echo $father_Val

echo "child2 shell over"
}

install

