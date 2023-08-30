#!/bin/bash

export K6_PROMETHEUS_RW_SERVER_URL=http://192.168.0.50:30560/api/v1/write

k6 run -o experimental-prometheus-rw test.js --tag testid=test1 --summary-trend-stats="avg,med,p(95),p(99)"

