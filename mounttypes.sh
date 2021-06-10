#! /bin/bash
cat /etc/mtab | awk '{print $1,$3}'
