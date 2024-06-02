#!/bin/bash

# 仅在脚本首次运行时设置快捷键
if [[ -z $(alias | grep "j") ]]; then
    echo "正在设置快捷键 j 关联到本脚本"
    echo "alias j='bash $(pwd)/$(basename $0)'" >> ~/.bashrc
    source ~/.bashrc
fi

# 检查是否存在 J 快捷键，没有则添加
if [[ -z $(alias | grep "J") ]]; then
    echo "正在设置快捷键 J 关联到本脚本"
    echo "alias J='bash $(pwd)/$(basename $0)'" >> ~/.bashrc
    source ~/.bashrc
fi

# 以下是脚本的其他内容
clear

# 检测系统类型
if [ -f /etc/os-release ]; then
. /etc/os-release
    OS=$ID
elif command -v lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
else
    OS=$(uname -s)
fi

while true; do
    # 检测系统信息
    echo -e "\033[1;33m 检测到的系统信息：\033[0m"
    if [ "$OS" == "ubuntu" ]; then
        echo "系统版本：$(lsb_release -sd)"
    elif [ "$OS" == "centos" ]; then
        echo "系统版本：$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2)"
    elif [ "$OS" == "debian" ]; then
        echo "系统版本：$(cat /etc/os-release | grep VERSION_CODENAME | cut -d '=' -f 2)"
    fi
    echo "内核版本：$(uname -r)"
    echo "CPU 架构：$(uname -m)"
    echo "CPU 型号：$(lscpu | grep "Model name" | cut -d ':' -f 2 | xargs)"
    echo "CPU 核心数：$(lscpu | grep "CPU(s):" | cut -d ':' -f 2 | xargs)"
    echo "物理内存：$(free -h | grep Mem | awk '{print $2}')"
    echo "公网 IPv4 地址：$(curl -s ifconfig.me)"

    # 二级菜单
    echo -e "\n\033[1;36m 二级菜单：\033[0m"
    echo "1. 系统更新命令"
    if [ "$OS" == "ubuntu" ] || [ "$OS" == "debian" ]; then
        echo "2. 安装常用软件包（Ubuntu/Debian 版）"
    elif [ "$OS" == "centos" ]; then
        echo "2. 安装常用软件包（CentOS 版）"
    fi
    echo "3. 修改主机名"
    echo "00. 退出脚本"

    read -p "请输入选项：" choice

    clear

    case $choice in
        1)
            if [ "$OS" == "ubuntu" ] || [ "$OS" == "debian" ]; then
                echo -e "\n\033[1;33m 执行 Ubuntu/Debian 系统更新命令：\033[0m"
                if [ "$OS" == "ubuntu" ]; then
                    sudo apt update && sudo apt upgrade -y
                elif [ "$OS" == "debian" ]; then
                    sudo apt-get update && sudo apt-get upgrade -y
                fi
                echo -e "\033[1;32m Ubuntu/Debian 系统更新完成\033[0m"
            elif [ "$OS" == "centos" ]; then
                echo -e "\n\033[1;33m 执行 CentOS 系统更新命令：\033[0m"
                sudo yum update -y
                echo -e "\033[1;32m CentOS 系统更新完成\033[0m"
            fi
            ;;
        2)
            if [ "$OS" == "ubuntu" ] || [ "$OS" == "debian" ]; then
                echo -e "\n\033[1;33m 安装常用软件包（Ubuntu/Debian 版）：\033[0m"
                sudo apt install -y curl wget vim git
                echo -e "\033[1;32m 安装完成\033[0m"
            elif [ "$OS" == "centos" ]; then
                echo -e "\n\033[1;33m 安装常用软件包（CentOS 版）：\033[0m"
                sudo yum install -y curl wget vim git
                echo -e "\033[1;32m CentOS 系统更新完成\033[0m"
            fi
            ;;
        3)
            echo -e "\n\033[1;33m 修改主机名：\033[0m"
            read -p "请输入新的主机名：" new_hostname
            sudo hostnamectl set-hostname $new_hostname
            sudo systemctl restart network
            echo -e "\033[1;32m 主机名修改完成并重启 network 服务\033[0m"
            ;;
        00)
            clear
            echo -e "\033[1;31m 退出脚本\033[0m"
            break
            ;;
        *)
            echo -e "\033[1;31m 无效选项，请重新输入\033[0m"
            ;;
    esac
done