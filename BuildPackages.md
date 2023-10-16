# Build eBlocker packages

The commands below build all software packages that run on the eBlocker.

The build environment is Debian Buster.

## Preparations

Install pre-requisites:

    sudo apt-get install git gcc build-essential debhelper fakeroot openjdk-11-jdk-headless maven bundler

Create user `icapd`:

    sudo adduser --quiet --system --no-create-home --home /opt/eblocker-icap --shell /usr/sbin/nologin --group icapd

## Build bootstrap package

The bootstrap package can only be installed on the architecture it was built for.

In this example the target architecture is `amd64`, so the profile `amd64-buster` is used:

    git clone https://github.com/eblocker/eblocker-bootstrap.git
    cd eblocker-bootstrap
    mvn -Pamd64-buster clean package
    cd ..

Other profiles are:

* `armbian-buster` for the Banana Pi M2+
* `raspbian-buster` for the Raspberry Pi.

## Build architecture dependent packages

The following packages are architecture dependent, so they must be
built on the same architecture as the target, e.g. `amd64` or `armhf`.

### Build network tools

    sudo apt-get install libnet1-dev libpcap-dev libhiredis-dev
    
    git clone https://github.com/eblocker/eblocker-network-tools.git
    cd eblocker-network-tools
    make package
    cd ..
    
### Build Squid

    sudo apt-get install libldap2-dev libpam0g-dev libdb-dev cdbs libsasl2-dev libcppunit-dev libkrb5-dev comerr-dev libcap2-dev libecap3-dev libexpat1-dev libxml2-dev libltdl-dev libnetfilter-conntrack-dev nettle-dev libgnutls28-dev libssl-dev
    
    git clone https://github.com/eblocker/squid.git
    cd squid
    fakeroot debian/rules binary
    cd ..

### Build LED driver

    git clone https://github.com/eblocker/eblocker-led
    cd eblocker-led
    make package
    cd ..

### Build DNS server

    sudo apt-get install ruby-hitimes ruby-nio4r
    
    git clone https://github.com/eblocker/eblocker-dns
    cd eblocker-dns
    make package
    cd ..

## Build Java components

The Java components are architecture independent.

The RestExpres project needs the `JAVA_HOME` variable:

    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

### Build libraries

    git clone https://github.com/eblocker/eblocker-top.git
    git clone https://github.com/eblocker/eblocker-crypto.git
    git clone https://github.com/eblocker/eblocker-registration-api.git
    git clone https://github.com/eblocker/netty-icap.git
    git clone https://github.com/eblocker/RestExpress.git
    cd eblocker-top              && mvn install && cd ..
    cd eblocker-crypto           && mvn install && cd ..
    cd eblocker-registration-api && mvn install && cd ..
    cd netty-icap                && mvn install && cd ..
    cd RestExpress               && mvn install && cd ..

### Build ICAP server, certificate validator and UI

    git clone https://github.com/eblocker/eblocker
    export OPENSSL_CONF=/etc/ssl/
    cd eblocker
    mvn clean package
    cd ..

### Build lists package

    git clone https://github.com/eblocker/eblocker-lists.git
    cd eblocker-lists
    mvn -Pupdate-lists clean package
    cd ..
