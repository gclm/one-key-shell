#!/usr/bin/env bash

version=9.0.34

tomcat(){
    tomcat_uninstall
    echo "安装tomcat 之前必须安装 JDK"
    cd /usr/local/src

    echo "正在下载 tomcat 安装包，请稍等..."
    wget -N --no-check-certificate https://gclm.coding.net/p/java/d/java/git/raw/master/apache-tomcat-${version}.tar.gz

    echo " 开始安装 tomcat "
    tar -zxvf apache-tomcat-${version}.tar.gz
    mv apache-tomcat-${version}  /usr/local/tomcat
    rm -rf /usr/local/src/apache-tomcat-*

    clear
    echo "安装完成"
    cd /usr/local/tomcat
}

tomcat_uninstall(){
    echo "开始卸载原有 maven 组件"
    rm -rf /usr/local/src/apache-tomcat-*
	  rm -rf /usr/local/tomcat
}

main(){
  clear
  echo -e "
  ———————————— 开发环境(Java) ————————————
   1.${Font_color_suffix} 安装 Tomcat7
   2.${Font_color_suffix} 安装 Tomcat8
   3.${Font_color_suffix} 安装 Tomcat9
   0.${Font_color_suffix} 退出脚本
  ——————————————————————————————————————" && echo
  read -p " 请输入选项 :" num
  case "$num" in
    0)
    exit 1
    ;;
    1)
      version=7.0.100
      tomcat
    ;;
    2)
      version=8.5.53
      tomcat
    ;;
    3)
      version=9.0.34
      tomcat
    ;;
    *)
    clear
    echo -e "${Error}:请输入正确选项："
    sleep 3s
    main
    ;;
  esac
}

main