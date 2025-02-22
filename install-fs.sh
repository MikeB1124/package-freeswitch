# Install dependencies
apt-get update && apt-get install -y \
    build-essential \
    wget \
    git \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libcurl4-openssl-dev \
    libjansson-dev \
    libxml2-dev \
    libsqlite3-dev \
    libssl-dev \
    libspandsp-dev \
    libsndfile1-dev \
    libopus-dev \
    libpq-dev \
    zlib1g-dev \
    libevent-dev \
    libsrtp2-dev \
    libunbound-dev \
    libsdl1.2-dev \
    gawk \
    uuid-dev \
    libncurses5-dev \
    libtool \
    libtool-bin \
    libpcre3-dev \
    libspeex-dev \
    libspeexdsp-dev \
    libldns-dev \
    libedit-dev \
    php \
    php-dev \
    php-pear \
    python3 \
    python3-pip \
    libpcap-dev \
    yasm \
    nasm \
    libavformat-dev \
    libswscale-dev \
    liblua5.1-dev \
    libopus-dev \
    libpq-dev \
    libsndfile-dev \
    librabbitmq-dev \
    vim \
    net-tools \
    tcpdump \
    sngrep \
    libsystemd-dev \
    && apt-get clean


git clone https://github.com/freeswitch/sofia-sip /tmp/sofiasip \
    && cd /tmp/sofiasip \
    && ./bootstrap.sh -j \
    && ./configure \
    && make && make install \
    && rm -rf /tmp/sofiasip \
    && cd /tmp

git clone https://github.com/freeswitch/spandsp /tmp/spandsp \
    && cd /tmp/spandsp \
    && git reset --hard 67d2455efe02e7ff0d897f3fd5636fed4d54549e \
    && ./bootstrap.sh -j \
    && ./configure \
    && make && make install \
    && rm -rf /tmp/spandsp \
    && cd /tmp

echo "/usr/local/lib" > "/etc/ld.so.conf.d/local.conf" && ldconfig


git clone https://github.com/MikeB1124/freeswitch.git /tmp/freeswitch \
    && cd /tmp/freeswitch \
    && ./bootstrap.sh -j \
    && ./configure \
        --prefix="/usr/local" \
        --localstatedir="/var" \
        --sysconfdir="/etc" \
        --with-logfiledir="/var/log/freeswitch" \
        --enable-systemd \
    && make && make install \
    && make sounds-install \
    && make moh-install