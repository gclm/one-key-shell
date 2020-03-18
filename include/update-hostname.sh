#!/usr/bin/env bash

install(){

hostnamectl set-hostname centos
hostnamectl --pretty
hostnamectl --static
hostnamectl --transient
echo "修改终端名为：centos"

}

install