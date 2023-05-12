#! /bin/sh

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#Check # of args
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi


id=4
hostname=$(hostname -f)
cpu_number=$(lscpu | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(lscpu |egrep "^Architecture"| awk '{print $2}'| xargs)
cpu_model=$(lscpu |egrep "^Model\ name\:"| awk '{$1=$2=""; print $0}'| xargs)
cpu_mhz=$(lscpu|egrep "^CPU\ MHz\:"| awk '{print $3}'| xargs)
l2_cache=$(lscpu |egrep "^L2\ cache\:"| awk '{print substr($3, 1, length($3)-1)}'|xargs)   #in kB
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')  #in kB
timestamp=$(vmstat -t | awk '{print $18,$19}'| tail -1| xargs) #Current time in UTC time zone

insert_stmt="INSERT INTO host_info (id, hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem) VALUES ('$id', '$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$timestamp', '$total_mem' )"

export PGPASSWORD=$psql_password 
#Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
