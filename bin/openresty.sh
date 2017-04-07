#!/bin/bash

# openresty 脚本

openresty_path=`which openresty`

if [ $openresty_path = "" ]; then
    echo "can not find openresty!"
    exit 1
fi

script="$0"

# determine elasticsearch home
app=`dirname "$script"`/..

# absolute path
app=`cd "$app"; pwd`

nginx_path=$app/nginx

test() {
    openresty -t -c $nginx_path/conf/nginx.conf
}

start() {
    openresty -p $nginx_path -c conf/nginx.conf
}

stop() {
    openresty -s stop
}

reload() {
    openresty -s reload -p $nginx_path -c conf/nginx.conf
}

restart() {
    openresty -s restart -p $nginx_path -c conf/nginx.conf
}

start

