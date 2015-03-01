#!/bin/bash
#  Description:
#    Import latest backup data (.gz) into mysql database.
#  Author:
#    serveryang@qq.com

declare mysql_username="root"
declare mysql_password="1trip.com"

sichuan_weixin="/home/rails/uploads/SiChuan/dbs"
sichuan_weixin_db_name="SiChuanWeiXin"

lijiang_weixin="/home/rails/uploads/LiJiang/dbs"
lijiang_weixin_db_name="LiJiangWeiXin"

yunnan_weixin="/home/rails/uploads/YunNanWeixin/dbs"
yunnan_weixin_db_name="YunNanWeixin_production"

# params:
#   $1: gz files' foloder path.
get_latest_sql_gz_file(){
  echo $1/"`cd $1 && ls -tp |grep .gz$ |head -1`"
}

# params:
#   $1: gz file path
unzip_latest_sql_gz_file(){
  `gunzip $1`
}

# params:
#   $1: gz files' folder path.
get_lateset_sql_file(){
  echo $1/"`cd $1 && ls -tp |grep .sql$ |head -1`"
}

# params:
#   $1: database name.
#   $2: sql file path.
import_sql_to_database(){
  `mysql -u$mysql_username -p$mysql_password $1 < $2`
  echo "[$(date +"%Y-%m-%d-%H %M:%S")] Finished import $2 to $1." >> import_sql.log
}

# SiChuan Weixin
gz_file_path=$(get_latest_sql_gz_file $sichuan_weixin)
unzip_latest_sql_gz_file $gz_file_path
sql_file_path=$(get_lateset_sql_file $sichuan_weixin)
import_sql_to_database $sichuan_weixin_db_name $sql_file_path

# LiJiang Weixin
gz_file_path=$(get_latest_sql_gz_file $lijiang_weixin)
unzip_latest_sql_gz_file $gz_file_path
sql_file_path=$(get_lateset_sql_file $lijiang_weixin)
import_sql_to_database $lijiang_weixin_db_name $sql_file_path

# YunNan Weixin
gz_file_path=$(get_latest_sql_gz_file $yunnan_weixin)
unzip_latest_sql_gz_file $gz_file_path
sql_file_path=$(get_lateset_sql_file $yunnan_weixin)
import_sql_to_database $yunnan_weixin_db_name $sql_file_path
