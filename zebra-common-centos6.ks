install
text
url --url http://mirror.us.leaseweb.net/centos/6/os/x86_64/
lang en_US.UTF-8
keyboard us
network --onboot yes --bootproto dhcp --noipv6 --hostname zebra-common.blue-newt.com
rootpw vagrant
timezone --utc America/Detroit
repo --name=epel --baseurl=http://dl.fedoraproject.org/pub/epel/6/x86_64/
repo --name=pg93 --baseurl=http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/
repo --name=springdale --baseurl=http://puias.princeton.edu/data/puias/6/x86_64/os/
authconfig --enableshadow --passalgo=sha512
selinux --permissive
firewall --disabled
zerombr
clearpart --all --initlabel
part /boot --fstype=ext4 --size=512
part pv.01 --size=1 --grow
volgroup vg_root --pesize=4096 pv.01
logvol swap --fstype swap --name=lv_swap --vgname=vg_root --size=1024
logvol / --fstype=ext4 --name=lv_root --vgname=vg_root --size=1024 --grow
bootloader --location=mbr --append="crashkernel=auto rhgb quiet"
user --name=vagrant --groups=wheel --password=vagrant
poweroff --eject


%packages --nobase
@core
epel-release
pgdg-centos93
python27
python27-devel
python27-setuptools
boost155-devel
acl
atlas-devel
autoconf
automake
bash-completion
binutils
bison
blas-devel
byacc
cmake28
colordiff
cscope
ctags
curl
diffstat
doxygen
dstat
elfutils
flex
freetype-devel
gcc
gcc-c++
gcc-gfortran
gettext
git
hiredis-devel
htop
iftop
indent
iotop
kernel
kernel-devel
kernel-headers
lapack-devel
libevent-devel
libgfortran
libpng-devel
libtool
libxml2 
libxml2-devel 
libxslt
libxslt-devel
lshw
lsof
ltrace
lzop
make
man
mosh
msgpack-devel
nano
ncurses
ncurses-devel
nginx
nload
ntp
openssh-clients
openssh-server
patch
pbzip2
pg_top93
pkgconfig
postgresql93
postgresql93-contrib
postgresql93-devel
postgresql93-docs
pv
python-keyczar
python-psycopg2
qt-devel
redhat-rpm-config
rpm-build
s3cmd
strace
sudo
sysstat
tcpdump
telnet
tmux
tree
vim
wget
xfsdump
xfsprogs
xterm
yum-utils
zeromq3-devel
%end

%post 
chkconfig iptables off
chkconfig ip6tables off

mkdir -m 0700 -p /home/vagrant/.ssh
/usr/bin/curl -k -L -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 400 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant

echo "UseDNS no" >> /etc/ssh/sshd_config
chkconfig sshd on

cat << _EOF > /etc/sudoers.d/vagrant
Defaults env_keep += "SSH_AUTH_SOCK"
Defaults !requiretty
vagrant ALL=(ALL) NOPASSWD: ALL
_EOF
chmod 0400 /etc/sudoers.d/vagrant

cat << EOF1 > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=dhcp
EOF1

rm -f /etc/udev/rules.d/70-persistent-net.rules
yum clean all
rm -rf /tmp/*
rm -f /var/log/wtmp /var/log/btmp
history -c
%end
