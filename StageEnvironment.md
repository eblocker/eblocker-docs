# Convert an eBlocker to the Stage environment

Prerequisite: You need root and SSH access on the eBlocker.

Build a stage bootstrap package, e.g. for Raspbian Buster

	cd eblocker-bootstrap
	mvn -Praspbian-buster-stage clean package

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
