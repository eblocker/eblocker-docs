# Filter lists

<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
</script>

Filter lists are either built-in and distributed via the
`eblocker-lists` package or they are added by the user. User-defined
lists can either be downloaded from a URL or manually edited.

Based on the type of the filter list there are different mechanisms
for storing the lists on disk:

## Domain filters

For each domain filter list two files are created for fast filtering:

* A file with extension `.bloom` that stores a Bloom filter. This is a
  very fast method to find out if a domain is _not_ on the list. But
  there can be false positives.
* A file with extension `.filter` that stores all domains in
  buckets. Each domain is assigned to a bucket using a hash
  function. The implementation
  [SingleFileFilter](/apidocs/eblocker-icapserver/org/eblocker/server/common/blacklist/SingleFileFilter.html)
  does not have false positives.

## Pattern filters

Pattern filters require access to the full URL, so enabling the HTTPS
feature is mandatory.

The filter lists are mainly in the EasyList format.

See also: [PatternBlocker](PatternBlocker.html)

## Meta-data

The following entities are stored in Redis:

* [ExternalDefinition](/apidocs/eblocker-icapserver/org/eblocker/server/common/blocker/ExternalDefinition.html)
  stores meta-data for filter lists on disk. Lists were either
  downloaded from the given URL or manually edited. The field
  `referenceId` contains a reference to either a
  `ParentalControlFilterMetaData` object (for domain filters) or a
  `FilterStoreConfiguration` object.
* [ParentalControlFilterMetaData](/apidocs/eblocker-icapserver/org/eblocker/server/common/data/parentalcontrol/ParentalControlFilterMetaData.html)
  stores meta-data for domain filters.
* [FilterStoreConfiguration](/apidocs/eblocker-icapserver/org/eblocker/server/icap/filter/FilterStoreConfiguration.html)
  stores meta-data for pattern filters.

<pre class="mermaid">
classDiagram
    ExternalDefinition --> FilterStoreConfiguration: referenceId
    ExternalDefinition --> ParentalControlFilterMetaData: referenceId (type DOMAIN)

    class FilterStoreConfiguration {
        +int id
        +String[] resources
        +FilterLearningMode learningMode
    }
    class ExternalDefinition {
        +int id
        +String file
        +String url
    }
    class ParentalControlFilterMetaData {
        +int id
        +List~String~ filenames
    }
</pre>
