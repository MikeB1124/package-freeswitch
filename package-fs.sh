#!/bin/bash

PACKAGE_NAME="freeswitch"
VERSION="1.0.0"
ARCH="amd64"
MAINTAINER="Michael Balian <balianmichael@gmail.com>"
DEB_NAME="${PACKAGE_NAME}-${VERSION}_${ARCH}.deb"

#Create package structure
mkdir -p ${PACKAGE_NAME}/DEBIAN
mkdir -p ${PACKAGE_NAME}/usr/local
mkdir -p ${PACKAGE_NAME}/var/lib/freeswitch/recordings
mkdir -p ${PACKAGE_NAME}/var/lib/freeswitch/storage
mkdir -p ${PACKAGE_NAME}/var/lib/freeswitch/images
mkdir -p ${PACKAGE_NAME}/usr/local/share/freeswitch
mkdir -p ${PACKAGE_NAME}/etc/freeswitch
mkdir -p ${PACKAGE_NAME}/var/log/freeswitch

#Copy files
cp -r /usr/local/* ${PACKAGE_NAME}/usr/local/
# cp -r /var/lib/freeswitch/storage/* ${PACKAGE_NAME}/var/lib/freeswitch/storage/
cp -r /var/lib/freeswitch/images/* ${PACKAGE_NAME}/var/lib/freeswitch/images/
cp -r /usr/local/share/freeswitch/* ${PACKAGE_NAME}/usr/local/share/freeswitch/
cp -r /etc/freeswitch/* ${PACKAGE_NAME}/etc/freeswitch/

#Create control file
cat > ${PACKAGE_NAME}/DEBIAN/control <<EOL
Package: $PACKAGE_NAME
Version: $VERSION
Section: net
Priority: optional
Architecture: $ARCH
Maintainer: $MAINTAINER
Depends: build-essential, wget, git, autoconf, automake, libtool, pkg-config, libcurl4-openssl-dev, libjansson-dev, libxml2-dev, libsqlite3-dev, libssl-dev, libspandsp-dev, libsndfile1-dev, libopus-dev, libpq-dev, zlib1g-dev, libevent-dev, libsrtp2-dev, libunbound-dev, libsdl1.2-dev, gawk, uuid-dev, libncurses5-dev, libtool-bin, libpcre3-dev, libspeex-dev, libspeexdsp-dev, libldns-dev, libedit-dev, php, php-dev, php-pear, python3, python3-pip, libpcap-dev, yasm, nasm, libavformat-dev, libswscale-dev, liblua5.1-dev, vim, net-tools, tcpdump, sngrep, libsystemd-dev
Description: FreeSWITCH media gateway with sources
EOL

cat > ${PACKAGE_NAME}/DEBIAN/postinst <<'EOL'
#!/bin/bash

cat > /etc/systemd/system/freeswitch.service <<'SERVICE_EOL'
[Unit]
Description=FreeSWITCH Service
After=network.target

[Service]
Type=forking
Environment=DAEMON_OPTS="-ncwait -nonat"
ExecStartPre=/bin/chown -R root:root /var/log/freeswitch /etc/freeswitch /usr/local/share/freeswitch /usr/local/bin/freeswitch /run/freeswitch /var/run/freeswitch
ExecStart=/usr/local/bin/freeswitch -u root -g root $DAEMON_OPTS
ExecStop=/usr/local/bin/freeswitch -stop
ExecReload=/usr/local/bin/freeswitch -nc reload
PIDFile=/var/run/freeswitch/freeswitch.pid
Restart=on-failure
User=root
Group=root
LimitCORE=infinity
LimitNOFILE=100000
LimitNPROC=60000
UMask=007

[Install]
WantedBy=multi-user.target
SERVICE_EOL

systemctl enable freeswitch
systemctl start freeswitch
EOL

#Set permissions
chmod -R 755 ${PACKAGE_NAME}/DEBIAN

#Build the package
dpkg-deb --build ${PACKAGE_NAME}

echo "Package ${PACKAGE_NAME} created successfully!"