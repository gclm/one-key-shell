# Archey for OS X

`Fork`自[athlonreg](https://github.com/athlonreg/archey-osx)的一个`macOS`脚本，效果如图

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/gclm/shell/master/mac/archey-osx/bin/archey-en)"
```
![screen-en.png](https://cdn.jsdelivr.net/gh/gclm/images@master/2020/02/04/1580813119937QKPYNN.jpg)

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/gclm/shell/master/mac/archey-osx/bin/archey)" 
```

![screen-zh_CN.png](https://cdn.jsdelivr.net/gh/gclm/images@master/2020/02/04/1580813123426vhGTDG.jpg)

## Installation/安装
```
$ cd && wget https://github.com/gclm/shell/releases/download/v1.0/archey-osx.tar.gz
$ tar zxvf archey-osx.tar.gz
$ sudo mv archey-osx/ /usr/local/ 
$ sudo ln -s /usr/local/archey-osx/bin/archey /usr/local/bin/archey #中文版
$ sudo ln -s /usr/local/archey-osx/bin/archey-en /usr/local/bin/archey-en #英文版
```

> 设置打开终端自启动

```
$ echo archey >> ~/.bashrc #中文版
$ echo archey-en >> ~/.bashrc #英文版
$ echo "[[ -s ~/.bashrc ]] && source ~/.bashrc" >> ~/.bash_profile 
$ source ~/.bashrc && source ~/.bash_profile 
```

> 如果你是`oh-my-zsh`用户

```
$ echo archey >> ~/.zshrc #中文版
$ echo archey-en >> ~/.zshrc #英文版
$ source ~/.zshrc 
```

## Update/更新
```
$ cd /usr/local/archey-osx/ && git pull && cd 
```

## License
This tool is protected by the [GNU General Public License v2](http://www.gnu.org/licenses/gpl-2.0.html).


