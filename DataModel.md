# Data Model

Data is stored in a Redis key-value store.

Classes that access Redis are:

* [JedisDataSource](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/JedisDataSource.html)
* [JedisDomainRecordingDataSource](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/JedisDomainRecordingDataSource.html)
* [JedisFilterStatisticsDataSource](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/statistic/JedisFilterStatisticsDataSource.html)
* [JedisEventDataSource](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/events/JedisEventDataSource.html)
* [JedisDnsDataSource](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/dns/JedisDnsDataSource.html)


Some [scripts](https://github.com/eblocker/eblocker/tree/develop/eblocker-icapserver/src/main/package/scripts) also use `redis-cli`.

## Schema Migrations

Although a Redis database does not have an explicit schema, by storing certain types (strings, hashes, lists) in certain keys, we create an implicit schema.

During the lifetime of a database application there will usually be changes in the schema.

We need initial data (e.g. a default user) in the database. Therefore, the first schema migration is from an empty to the initial database.

A software release is optionally tagged with a schema version. The
version number increases monotonically. An empty database does not
have a schema, i.e. it has version 0. The current version is stored as
an integer in the key `version`.

For each schema update there is a migration script or program that
updates the data. Migrations run sequentially, e.g. when an empty
database needs to be migrated to version 3, the following migrations
are performed:

1. Create default user, etc.
2. Some schema updates...
3. More schema updates...

There is no migration that updates the schema directly to the latest version.

There are only migrations to higher schema numbers.

The migrations are maintained in package
[org.eblocker.server.common.data.migrations](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/migrations/package-summary.html).

## Stored Data

Short description about what data are stored in Redis and what it is used for.

Note: In some cases, the key contains additional data in angle
brackets. This indicates additional data is contained in the key,
e.g. the key of a device contains its MAC address. Also seen are
integers, dates/times, IPs.

| Key | Type | Purpose |
|-----|------|---------|
| `appmodule:<int>` | Boolean | If App Module is enabled or not |
| `AppModuleDetails:<int>` | JSON: [AppWhitelistModule](/apidocs/eblocker-icapserver/org/eblocker/server/http/ssl/AppWhitelistModule.html) | contains info needed to whitelist all connections a specific app makes (SSL) |
| `autoEnableNewDevices` | Boolean | Whether to enable new devices automatically |
| `autoupdate_active` | Boolean | If automatic updates are activated or not |
| `autoupdate` | JSON: [AutomaticUpdaterConfiguration](/apidocs/eblocker-icapserver/org/eblocker/server/common/update/AutomaticUpdaterConfiguration.html) | When to execute the automatic update |
| `CaOptions` | JSON: [CaOptions](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/CaOptions.html) | Details about eBlocker's own SSL certificate |
| `clean_shutdown` | Boolean | If the last shutdown was clean |
| `CloakedUserAgentConfig` | JSON: [CloakedUserAgentConfig](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/CloakedUserAgentConfig.html) | Pretend a device is of different type/operating system |
| `compression_mode` | JSON: [CompressionMode](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/CompressionMode.html) | Compression is only enabled for VPN clients by default |
| `consolePassword` | String | Hashed password |
| `content_filter_enabled` | Boolean | Whether the content and video ads filter is enabled |
| `device:<MAC-address>` | Hash: [Device](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/Device.html) | Information about the devices in the network (actual Hash in Redis) |
| `deviceScanningInterval` | Long | Device Scanning Interval (seconds) |
| `dhcpLeaseTime` | Integer | See [NetworkConfiguration](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/NetworkConfiguration.html) |
| `dhcpRange` | Hash | See [NetworkConfiguration](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/NetworkConfiguration.html) |
| `dhcp_ip_fixed_by_default` | Boolean | See [NetworkConfiguration](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/NetworkConfiguration.html) |
| `DnsCheckDone` | JSON: [DnsCheckDone](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/dns/DnsCheckDone.html) | Exists if the "enable DNS by default" check has been run |
| `DnsServerConfig` | JSON: [DnsServerConfig](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/dns/DnsServerConfig.html) | Configuration of the DNS server running on the eBlocker (if enabled) |
| `dns_stats:<YYYYMMDDHHMM>:<IP>:blocked_queries:<ListID>` | Integer | Count the number of blocked DNS queries in a given minute from a given device (IP) due to a given blocking list (ListID) |
| `dns_stats:<YYYYMMDDHHMM>:<IP>:queries` | Integer | Count the number of DNS queries in a given minute from a given device (IP) |
| `dns_stats:<resolverconfig>` | List | Last 25000 resolver events. A resolver event is a comma separated list of values: timestamp, name server IP or "cache", status (valid/invalid/error/timeout), optional duration in seconds |(
| `dnt_header_enabled` | Boolean | If the eBlocker should add the Do-Not-Track Header |
| `do_not_show_reminder` | Boolean | If the eBlocker should not display the license expiration reminder |
| `DynDnsConfig` | JSON: [DynDnsConfig](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/DynDnsConfig.html) | Configuration for eBlocker Mobile's DynDNS service |
| `EblockerDnsServerState` | JSON: [EblockerDnsServerState](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/dns/EblockerDnsServerState.html) | State of the DNS server running on the eBlocker (e.g. running) |
| `ExternalDefinition:<int>` | JSON: [ExternalDefinition](/apidocs/eblocker-icapserver/org/eblocker/server/common/blocker/ExternalDefinition.html) | External filter lists |
| `event_last_seen` | JSON: [Event](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/events/Event.html) | The last event seen (Adminconsole / System / Events) |
| `events` | List of JSON: [Event](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/events/Event.html) | All events (Adminconsole / System / Events) |
| `FailedConnectionsEntity` | JSON: [FailedConnectionsEntity](/apidocs/eblocker-icapserver/org/eblocker/server/common/squid/FailedConnectionsEntity.html) | Failed Squid TLS connections |
| `FilterStoreConfiguration:<int>` | JSON: [FilterStoreConfiguration](/apidocs/eblocker-icapserver/org/eblocker/server/icap/filter/FilterStoreConfiguration.html) | Configurations for filter lists |
| `frontend_language` | Hash | Language currently used in the frontend |
| `gateway` | String | IP of the gateway |
| `google_CPC_responder_enabled` | Boolean | If the eBlocker should respond to Google Captive Portal Check requests |
| `http_referer_remove_enabled` | Boolean | If the eBlocker should remove referrer from the headers of requests |
| `lastUpdate` | String (LocalDateTime) | Time of the last update, needed for automatic updates |
| `lists-version` | String (YYYYMMDDhhmm) | Version of lists package |
| `MessageContainer:<int>` | JSON: [MessageContainer](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/messagecenter/MessageContainer.html) | Messages to be shown to the user (in dashboard and controlbar) |
| `network_is_expert_mode` | Boolean | True if the network mode is _Expert_ |
| `networkState` | String| Network state, `LOCAL_DHCP`, `EXTERNAL_DHCP` or `PLUG_AND_PLAY` (default) |
| `OpenVpnClientState:<int>` | JSON: [OpenVpnClientState](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/openvpn/OpenVpnClientState.html) | State of an OpenVPN client connection |
| `OpenVpnExternalAddressType` | String: [ExternalAddressType](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/openvpn/ExternalAddressType.html) | eBlocker Mobile: Fixed IP, Dyn-DNS, eBlocker-Dyn-DNS |
| `OpenVpnFirstRun` | Boolean | If true, eBlocker Mobile creates a CA certificate |
| `OpenVpnHost` | String | eBlocker Mobile, external IP/host |
| `OpenVpnMappedPort` | Integer | eBlocker Mobile port at the router |
| `OpenVpnPortForwardingMode` | String: [PortForwardingMode](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/openvpn/PortForwardingMode.html) | eBlocker Mobile port forwarding: auto or manual |
| `OpenVpnProfile:<int>` | JSON: [OpenVpnProfile](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/openvpn/VpnProfile.html) | Client OpenVPN configurations |
| `OpenVpnServerEnabled` | Boolean | Whether eBlocker Mobile is enabled |
| `ParentalControlCard:<int>` | JSON: [ParentalControlCard](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/dashboard/ParentalControlCard.html) | Parental controls dashboard card configuration |
| `ParentalControlFilterMetaData:<int>` | JSON: [ParentalControlFilterMetaData](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/parentalcontrol/ParentalControlFilterMetaData.html) | Holds info on Parental Control Filter that are not to be shown, e.g. filenames |
| `pattern_stats:<YYYYMMDDHHMM>:<IP>:blocked_queries:<ListID>` | Integer | Count the number of blocked requests in a given minute from a given device (IP) due to a given blocking list (ListID) |
| `pattern_stats:<YYYYMMDDHHMM>:<IP>:queries` | Integer | Count the number of requests in a given minute from a given device (IP) |
| `privacy_extensions_enabled` | Boolean | Whether IPv6 privacy extensions are enabled |
| `ProductInfo:0` | JSON: [ProductInfo](https://github.com/eblocker/eblocker-registration-api/blob/develop/src/main/java/org/eblocker/registration/ProductInfo.html) | Contains info about what the customer has licensed (BAS/PRO/FAM/etc.) |
| `recorded_domains:<DeviceID>:<timestamp>` | JSON: [RecordedDomainBin](/apidocs/eblocker-icapserver/org/eblocker/server/common/recorder/RecordedDomainBin.html) | Contains one hour of recorded domains |
| `RecordedTransaction:<int>` | JSON: [RecordedTransaction](/apidocs/eblocker-icapserver/org/eblocker/server/common/recorder/RecordedTransaction.html) | A transacion recorded by: Blocker / Analysis Tool |
| `resolved_dns_gateway` | String (IP) | Is set to the router's IP address if common router names (e.g. `fritz.box`) have been resolved |
| `router_advertisements_enabled` | Boolean | Whether eBlocker should send IPv6 router advertisements |
| `showSplashScreen` | Boolean | Whether the release notes should be shown when the settings are opened |
| `ssl_enabled` | Boolean | If SSL is enabled |
| `ssl_record_errors` | Boolean | Whether eBlocker should read TLS errors logged by Squid |
| `stats_total:dns:blocked_queries:<ListID>` | Integer | Total number DNS queries blocked by a specific list |
| `stats_total:dns:queries` | Integer | Total number of domain requests |
| `stats_total:pattern:blocked_queries:<ListID>` | Integer | Total number of requests blocked by a specific list or category (ADS, ...) |
| `stats_total:pattern:queries` | Integer | Total number of pattern requests |
| `stats_total_reset` | Integer | Filter statistics: When the counter was last reset |
| `timezone` | String | Timezone used in settings |
| `torCurrentExitNodes` | JSON: list of strings | Countries from which to choose Tor exit nodes |
| `TrafficAccount:<int>` | JSON: [TrafficAccount](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/TrafficAccount.html) | Counts packets from a specific device for parental controls |
| `UiCard:<int>` | JSON: [UiCard](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/dashboard/UiCard.html) | Dashboard card configuration |
| `UsageChangeEvents:<int>` | JSON: [UsageChangeEvents](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/UsageChangeEvent.html) | Parental Control, keep track of time used by a device |
| `UserModule:<int>` | JSON: [UserModule](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/UserModule.html) | Appearance for different users (Dashboard Cards) |
| `UserProfileModule:<int>` | JSON: [UserProfileModule](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/UserProfileModule.html) | Profiles for Parental Control (e.g. child, parent,...) |
| `version` | Integer | Version of the database schema |
| `VersionInfo` | JSON: [VersionInfo](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/VersionInfo.html) | Information about the OS running on the eBlocker |
| `webrtc_block_enabled` | Boolean | If eBlocker should block webRTC |
