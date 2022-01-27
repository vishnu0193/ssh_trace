#!/bin/bash
echo "Tracing the ssh logins"
echo "Capturing the failed ssh  attempts "
rm -rf /tmp/auth.txt

if grep -q "Disconnected from" /var/log/auth.log
then
    tail -100  /var/log/auth.log | grep 'sshd'| grep 'Disconnected from' |uniq |awk '{print $10}'|uniq -c | sort -nr >> /tmp/auth.txt
    while read count node; do
    echo "$count ssh log-in failed attempts were made by $node"
    done < /tmp/auth.txt
else
    exit
fi