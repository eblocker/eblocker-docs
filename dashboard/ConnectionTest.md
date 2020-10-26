# Debugging dashboard connection tests

This document describes how eBlocker's dashboard connection tests work and how you can debug them using the tools `dig` and `curl`.

All connection tests are based on HTTP(S) requests that are made in the browser. The client code is implemented in [`ConnectionTestService.js`](https://github.com/eblocker/eblocker/blob/develop/eblocker-ui/src/dashboard/app/service/connectionTest/ConnectionTestService.js).

Note: if you debug any connection test you must remember to clear the DNS and browser cache after changing eBlocker's settings.

Be careful not to have `eblocker.org` on any blocking list.

## Device is monitored

This is the `routingTest` which can be checked with

	curl -i http://controlbar.eblocker.org/api/check/route

The expected result is `204 No Content`. The domain `controlbar.eblocker.org` is resolved to a public IP address, but this address is directly bound to eBlocker's `eth0` interface (see `ip addr list`). The path `/api/check/route` is mapped to the [`ConnectionCheckControllerImpl`](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/http/controller/impl/ConnectionCheckControllerImpl.java) class which sets the response code to 204 and sets the header field

	Access-Control-Allow-Origin: *

## DNS Firewall

This is the `dnsFirewallTest`. The domain `dnscheck.eblocker.org` is expected to be resolved locally to eBlocker's IP address (see Settings / DNS Firewall / Local Network), if the DNS firewall is enabled.

The test can be checked with

	curl -i http://dnscheck.eblocker.org/api/check/route

The expected result is `204 No Content`, if the DNS firewall is enabled.

If the DNS firewall is not enabled, the request will go to the webserver (since `*.eblocker.org` resolves to the webserver's IP). It will return a redirect to `https://eblocker.org/api/check/route`.

## Web filtering (HTTP)

This is the `httpRoutingTest` which can be checked with

	curl -i https://setup.eblocker.org/_check_/routing

The expected result is `204 No Content`. This is hardwired in the [`RedirectFromSetupPageProcessor`](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/transaction/processor/RedirectFromSetupPageProcessor.java) class.

## Web filtering (HTTPS)

See above, but use protocol `https` instead of `http`.

## Domain Blocker (ads)

This is the `adsDomainBlockerTest` which can be checked with

	curl -i http://ads.domainblockercheck.eblocker.org/_check_/domain-blocker

The expected result is `200 OK`. The response must contain the header field

	Access-Control-Allow-Origin: *

for the test to pass which is set in the [`AccessDeniedRequestHandler`](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/http/service/AccessDeniedRequestHandler.java) class. Otherwise the browser will not allow the cross-origin request.

The domain is resolved to eBlocker's blocking IP `169.254.93.109`. It is blocked in the file [`eBlocker-ads-blacklist.txt`](https://github.com/eblocker/eblocker-lists/blob/develop/src/main/resources/eBlocker-ads-blacklist.txt).

## Domain Blocker (trackers)

See above, but use domain `tracker.domainblockercheck.eblocker.org` instead of `ads.domainblockercheck.eblocker.org`.

The domain is blocked in the file [`eBlocker-tracker-blacklist.txt`](https://github.com/eblocker/eblocker-lists/blob/develop/src/main/resources/eBlocker-tracker-blacklist.txt).

## Pattern Blocker

This is the `patternBlockerTest` which can be checked with

	curl -i http://setup.eblocker.org/_check_/pattern-blocker

The expected result is `204 No Content`. This is configured in the [special blocking rule](https://github.com/eblocker/eblocker-lists/blob/develop/lists_src/eblocker-filter.txt_src):

	NO_CONTENT	HIGHEST	setup.eblocker.org	ENDSWITH	/_check_/pattern-blocker	-	-	-

If the above rule would not work, the server at `setup.eblocker.org` should return `404 Not Found`.
