# Pattern Blocker

Requests that eBlocker receives via ICAP are processed by the pattern
blocker. It has access to the full URLs.

Pattern filters are defined in the [EasyList format](https://help.eyeo.com/en/adblockplus/how-to-write-filters).

Each filter rule is
[parsed](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/easylist/EasyListLineParser.java)
and a
[UrlFilter](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/url/UrlFilter.java)
is created from it.

## Filter Manager

Filter lists are organized in
[categories](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/Category.java),
e.g. ads, trackers, malware. The built-in filter lists are defined in
[patternfilters.json](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/resources/patternfilters.json). Each
object in this file is a
[FilterStoreConfiguration](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/FilterStoreConfiguration.java)
that is saved in Redis.

The
[FilterManager](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/FilterManager.java)
creates `FilterStore` objects from the configurations and caches them
in encrypted JSON files at `/opt/eblocker-icap/conf/filter/`.

## Filter Store

The
[FilterStore](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/FilterStore.java)
maps domains to the rules that have matched on their URLs. Since there
are tens of thousands of rules, it is not feasible on a Raspberry Pi
to check every rule for every request.

## Learning Filters

A
[LearningFilter](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/learning/LearningFilter.java)
learns the mapping from a domain to the rules its URLs have matched
on.

There are two main learning filters:

* [SynchronousLearningFilter](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/learning/SynchronousLearningFilter.java) learns the mapping during filtering.
* [AsynchronousLearningFilter](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/learning/AsynchronousLearningFilter.java)
  learns the mapping after filtering, i.e. the first result of the
  filter is NO_DECISION.

For performance reasons the `AsynchronousLearningFilter` should be used for large filter lists.

## Filter List

Filters for a specific domain (or the wildcard domain `*.*`) are
stored in a filter store as a
[FilterList](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/FilterList.java). The
filters are sorted by
[priority](https://github.com/eblocker/eblocker/blob/develop/eblocker-icapserver/src/main/java/org/eblocker/server/icap/filter/FilterPriority.java)
in the list.
