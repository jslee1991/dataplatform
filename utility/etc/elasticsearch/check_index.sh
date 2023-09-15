#!/bin/sh

input="/root/js/check_index/$1.txt"
ELS="https://34.22.77.58:9200"

echo "$input" > result.log
echo "`date`" >> result.log


generate_post_data()
{
cat << EOF
{
	"query": 
	{ "exists": 
		{ "field" : "$line"
		}
	}
}
EOF
}


while read -r line; 
do



result=$(curl --header 'Content-Type: application/json' \
	--data "$(generate_post_data)" \
	-XGET "$ELS/*/_search" \
	-u admin:admin --insecure|grep type|wc -l)



echo $result >> result.sh



if [ $result -eq 0 ];
then
	echo "$line is NO" >> result.log

elif [ $result -eq 1 ];
then
	echo "$line is OK" >> result.log

fi

done < $input

cat result.log | mail -s "$1 확인결과" $2

