ps -ef|grep k6|grep -v grep|awk '{print $2}'|xargs kill -9
