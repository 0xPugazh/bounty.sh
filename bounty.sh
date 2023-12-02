#!/bin/bash

cat <<"EOF"
    ____                    __               __  
   / __ )____  __  ______  / /___  __  _____/ /_ 
  / __  / __ \/ / / / __ \/ __/ / / / / ___/ __ \
 / /_/ / /_/ / /_/ / / / / /_/ /_/ / (__  ) / / /
/_____/\____/\__,_/_/ /_/\__/\__, (_)____/_/ /_/ 
                            /____/             

   Bug Bounty automation script - $$$ by @0xPugazh
EOF

domain=$1
mkdir /root/bounty.sh/output/bounty.sh/output/$1
mkdir /root/bounty.sh/output/bounty.sh/output/$1/xray

subfinder -d $1 -silent -all | anew /root/bounty.sh/output/$1/subs.txt
assetfinder -subs-only $1 | anew /root/bounty.sh/output/$1/subs.txt
amass enum -passive -d $1 | anew /root/bounty.sh/output/$1/subs.txt
findomain --target $1 --quiet | anew /root/bounty.sh/output/$1/subs.txt
cat /root/bounty.sh/output/$1/subs.txt | naabu -top-ports full -silent | anew /root/bounty.sh/output/$1/open-ports.txt
cat /root/bounty.sh/output/$1/open-ports.txt | httpx -silent | anew /root/bounty.sh/output/$1/alive.txt                                                                                                                                                                                                                                              
for i in $(cat /root/bounty.sh/output/$1/alive.txt); do xray_linux_amd64 ws --basic-crawler $i --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho /root/bounty.sh/output/$1/xray/$(date +"%T").html ; done
cat /root/bounty.sh/output/$1/alive.txt | nuclei -t /root/nuclei-templates -severity critical -etags ssl | anew /root/bounty.sh/output/$1/nuclei_critical.txt
cat /root/bounty.sh/output/$1/alive.txt | nuclei -t /root/nuclei-templates -severity high -etags ssl | anew /root/bounty.sh/output/$1/nuclei_high.txt
cat /root/bounty.sh/output/$1/alive.txt | nuclei -t /root/nuclei-templates -severity medium -etags ssl | anew /root/bounty.sh/output/$1/nuclei_medium.txt
cat /root/bounty.sh/output/$1/alive.txt | nuclei -t /root/nuclei-templates -severity low -etags ssl | anew /root/bounty.sh/output/$1/nuclei_low.txt

## Inspired from https://medium.com/@0xelkot/how-i-get-10-sqli-and-30-xss-via-automation-tool-cebbd9104479
