데이터 수집 쿠버네티스 패키지

1. KAFKA operator
k apply -f kafka/operator


2. KAFKA CRDS
k apply -f kafka/crds


3. KAFKA cluster

3-1. KAFKA cluster yaml파일에서 config 설정(replica, shard 등.)

3-2. k appy -f kafka/cluster


4. LOGSTASH

4-1 logstash configmap설정(pipeline, conf에서 replica 및 O.S에 쏠 데이터 가공)

4-2 k apply -f logstash


5. OPENSEARCH MASTER

5-1 opensearch env 설정 (plugin옵션 및 replica)

5-2 k apply -f opensearch_master


6. OPENSEARCH DATA

6-1 opensearch env 설정 (plugin옵션 및 replica)

6-2 k apply -f opensearch_data


7. OPENSEARCH DASHBOARD

7-1 opensearch dashboard env 설정

7-2 k apply -f opensearch_dashboard


(컨테이너 규칙으로, 순서가 크게 상관있지는 않음)
