# Ansible Intro

Ansible是什么:
- 一个运维管理工具
- 可以同时操作多台机器
- 可以预先设置好脚本，进行多台机器部署安装

## Ansible Installation

```sh
pip install ansible
```

## Ansible 访问远程机器

```sh 
ansible -m ping all -i hosts
```

ping所有的远程机器

## Ansible playbook 的基本概念 

- inventory: ansible需要管理的机器
- vars: 变量
- task： ansible执行的部署安装任务，可以是多个步骤的集合
- module: ansible用于操作不同任务对应的模块

## Ansible module的使用

```sh
ansible -i hosts -m shell -a 'uname -a' host0.example.org
```

```-m``` 指定需要的模块 ```-a``` 表示参数

## Ansible playbook

```sh
ansible-playbook -i hosts -l host1.example.org apache.yml
```

## Ansible Playbook tags

## Ansible variable

## Ansible templates

## Ansible files

## Ansible notify

## Ansible best practice

## Ansible ansible-galaxy