#! /bin/bash
df -Th | grep "^/dev/sda2" | awk '{print $2}'
