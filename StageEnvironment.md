# Convert an eBlocker to the Stage environment

Prerequisites:

* You need root and SSH access on the eBlocker
* eBlocker must be configured in the automatic network mode (because `/etc/network/interfaces` is overwritten with the default configuration)

Build a stage bootstrap package with Maven, e.g. for Raspbian Buster

    git clone https://github.com/eblocker/eblocker-bootstrap.git
    cd eblocker-bootstrap
    mvn -Praspbian-buster-stage clean package

Other profile options are:

* `-Parmbian-buster-stage` for a Banana Pi M2+ board
* `-Pamd64-buster-stage` for the eBlocker VM

On the eBlocker, uninstall the bootstrap package:

    apt-get remove eblocker-bootstrap

Copy the stage bootstrap package from `eblocker-bootstrap/target` to the eBlocker and install it:

    dpkg -i eblocker-bootstrap_..._all.deb

Create the configuration file `/opt/eblocker-icap/conf/configuration.properties` with the following content:

    registration.truststore.resource = classpath:stage-ca/eblocker-truststore.jks
    baseurl.apt = https://apt.stage.eblocker.com
    baseurl.api = https://api.stage.eblocker.com
    baseurl.my  = https://my.stage.eblocker.com

Stop the Icapserver, remove the registration and reboot:

    systemctl stop icapserver
    rm /opt/eblocker-icap/registration/registration.properties
    reboot
