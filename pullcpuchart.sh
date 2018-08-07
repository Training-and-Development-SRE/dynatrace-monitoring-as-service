#!/bin/bash
# Will call the dtcli to query cpu data for all frontend process groups 
bash ../dynatrace-cli/dtclidocker.sh dqlr pgi.cpu.usage[avg%hour],cpi.cpu.usage[p95%hour] Frontend.*