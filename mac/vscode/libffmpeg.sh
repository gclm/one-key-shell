#!/bin/bash 

cd ~
cd "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
i=0
vscode_version=()
for j in `./code -v` 
    do
    vscode_version[$i]=$j
    i=`expr $i + 1`
    done
# echo ${vscode_version[@]}

arch=${vscode_version[2]}

echo "Visual Studio Code on macOS 版本信息 : ${vscode_version[0]} $arch "

i=0
electron_version=()
for j in `curl https://raw.githubusercontent.com/Microsoft/vscode/${vscode_version[0]}/.yarnrc | sed 's/\"//g' `
    do
    electron_version[$i]=$j
    i=`expr $i + 1`
    done
echo ${electron_version[@]}  

version=${electron_version[3]}
arch=${vscode_version[2]}

# 假数据
# version="3.1.6"
# arch="x64"
echo "electron 版本为：$version"
# 任务名称: electron-v3.1.6-darwin-x64.zip
# cd ~/Users/gclm/Downloads
home=$HOME
cd $home/Downloads

wget https://github.com/electron/electron/releases/download/v$version/electron-v$version-darwin-$arch.zip
unzip  electron-v$version-darwin-$arch.zip -d electron-v$version-darwin-$arch

cd electron-v$version-darwin-$arch
cp -R Electron.app/Contents/Frameworks/Electron\ Framework.framework/Libraries/libffmpeg.dylib /Applications/Visual\ Studio\ Code.app/Contents/Frameworks/Electron\ Framework.framework/Libraries

rm -rf $home/Downloads/electron-v$version-darwin-$arch*

echo "libffmpeg更换完成，请重启 VS Code！！！"