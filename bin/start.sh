#!/bin/bash

openresty_path=`which openresty`

if [ $openresty_path = "" ]; then
    echo "can not find openresty!"
    exit 1
fi

script="$0"

# determine elasticsearch home
app=`dirname "$script"`/..

# make ELASTICSEARCH_HOME absolute
app=`cd "$app"; pwd`

nginx_path=$app/nginx/

# check conf
openresty -p $nginx_path -c conf/nginx.conf -t

#openresty -p $nginx_path -c conf/nginx.conf
