#!/bin/sh
page=1
while [ $page -le $2 ]
   do
       node zhihu_topic_Q.js $1 $page
       page=`expr $page + 1`
   done
