#!/bin/env bash

timestamp=$(date +%Y%m%d%H%M%S)

sql_dump_file=redmine_${timestamp}.sql
#sudo -u postgres pg_dump --file=$sql_dump_file redmine
# file is created with current user through usage of redirection
sudo -u postgres pg_dump redmine > $sql_dump_file

echo "$sql_dump_file created" >&2
