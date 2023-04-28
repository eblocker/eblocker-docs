# ICAP Server Sub-Systems

Many service classes are organized into sub-systems in the ICAP
server. These sub-system services are initialized in a specific order defined
by:

1. The order number of the sub-system (see enum [SubSystem](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/common/data/systemstatus/SubSystem.java))
1. The priority of the service

The priority can be specified as an attribute of the
[@SubSystemService](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/common/startup/SubSystemService.java)
annotation. Services with a smaller priority are initialized earlier.

The @SubSystemService annotation only makes sense for singleton classes.

The
[EblockerServerApp](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/app/EblockerServerApp.java)
automatically calls all initialization methods of sub-system services
in the defined order and installs shutdown-hooks for their shutdown
methods.

Service initialization methods are annotated with @SubSystemInit, shutdown methods with @SubSystemShutdown.

## Runtime Check During Startup 

The
[SubSystemUsageInterceptor](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/common/startup/SubSystemUsageInterceptor.java)
ensures that service methods can only be called after all sub-systems
with a lower order number have been initialized.

However, it is not checked whether a service has itself been initialized
before any of its methods are called. Some services check this
themselves, for example
[SslService](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/common/ssl/SslService.java).

See also: [AOP in Guice](https://github.com/google/guice/wiki/AOP)

## Startup Example

As an example, below is the current order of initializations of
sub-systems and service classes (with priorities in brackets):

    HTTP_SERVER
        [-1000]
            common.network.NetworkInterfaceWrapper
        [0]
            http.server.EblockerHttpsServer

    DATABASE_CLIENT
        [0]
            common.data.JedisDataSource

    EVENT_LISTENER
        [-1]
            http.service.AccessDeniedService
        [0]
            http.service.DeviceService
            common.network.unix.EblockerDnsServer
            http.service.ParentalControlEnforcerService
            http.service.ParentalControlService
            http.service.ParentalControlUsageService
            http.service.ProductInfoService
            common.network.TrafficAccounter
            http.service.UserService
        [10]
            common.blacklist.DomainBlockingService

    BACKGROUND_TASKS
        [-1]
            http.service.AppModuleService
            common.update.AutomaticUpdater
            common.data.statistic.BlockedDomainsStatisticService
            common.network.DhcpBindListener
            http.service.MessageCenterService
            common.network.NetworkInterfaceWatchdog
            http.service.ParentalControlAccessRestrictionsService
            common.network.TorController
            common.network.TorExitNodeCountries
        [0]
            app.BackgroundServices
            common.openvpn.server.OpenVpnAddressListener
            common.squid.SquidWarningService

    ICAP_SERVER
        [0]
            icap.server.EblockerIcapServer
            icap.filter.FilterManager

    NETWORK_STATE_MACHINE
        [25]
            common.network.unix.IpSets
        [50]
            common.malware.MalwareFilterService
        [100]
            common.network.NetworkStateMachine

    HTTPS_SERVER
        [0]
            http.server.SSLContextHandler
            common.squid.SquidConfigController
        [100]
            common.ssl.SslService
        [200]
            common.openvpn.OpenVpnService

    SERVICES
        [0]
            http.service.AnonymousService
            http.service.AutoTrustAppService
            common.blocker.BlockerService
            icap.filter.bpjm.BpjmFilterService
            http.service.DashboardCardService
            common.blacklist.DomainBlockingNetworkService
            common.service.FilterStatisticsService
            http.service.OpenVpnServerService
            http.service.ParentalControlSearchEngineConfigService
            http.service.RegistrationServiceAvailabilityCheck
