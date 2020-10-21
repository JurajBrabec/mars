@echo off
set client=ida-nbmast1.res.hpe.com
echo BPPLLIST
mkdir bppllist>nul 2>&1
bppllist -allpolicies >bppllist\allpolicies.txt
echo NBSTL
mkdir nbstl>nul 2>&1
nbstl -l>nbstl\l.txt
echo BPDBJOBS
mkdir bpdbjobs>nul 2>&1
bpdbjobs -summary -l>bpdbjobs\summaryl.txt
bpdbjobs -report -most_columns>bpdbjobs\reportmost_columns.txt
echo BPPLCLIENTS
mkdir bpplclients>nul 2>&1
bpplclients -allunique -l>bpplclients\alluniquel.txt
echo NBDEVQUERY
mkdir nbdevquery>nul 2>&1
nbdevquery -listdv -stype PureDisk -l>nbdevquery\listdvstypepurediskl.txt
echo BPRETLEVEL
mkdir bpretlevel>nul 2>&1
bpretlevel -L>bpretlevel\L.txt
echo BPIMMEDIA
mkdir bpimmedia>nul 2>&1
bpimmedia -l -client %client% >bpimmedia\l.txt
echo BPFLIST
mkdir bpflist>nul 2>&1
bpflist -l -client %client% >bpflist\l.txt
