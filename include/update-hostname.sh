#!/usr/bin/env bash

install(){

hostnamectl set-hostname centos7
hostnamectl --pretty
hostnamectl --static
hostnamectl --transient
echo "${Info}:修改终端名为：centos7"

}

install