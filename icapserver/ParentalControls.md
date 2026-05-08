# Parental Controls

<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
</script>

## Devices

By default a device has a unique system user. This is the owner of the
device if it is not assigned to a user in the parental controls
settings.

A device can be assigned to a user (owner).

Optionally, another user can log in via the dashboard and be the operating user.

The operating user is shown in the dashboard title bar next to the device name.

## Users

A user has a dashboard layout (for 1, 2, 3 columns).

### User roles

* Child
* Parent
* Other

Children have a very minimal dashboard. They have a birthday.

What is the difference between Parent and Other?

All users can have a PIN.

Parents (and Others) can lock a device out of the internet.

## User profiles

Each user has an associated profile. (Some profiles are shared, but
they are used only for default users.)

A user profile defines restrictions, e.g. max daily usage, blocked
domains, etc.

Multiple filter lists can be configured as accessible or inaccessible.

## Filter meta-data

For each filter list – built-in or custom – there is a filter
meta-data object that references lists stored on disk.

The meta-data objects are associated with users in two ways:

1. In the parental controls settings there are the tabs _Web site
   black/whitelists_. These lists are referenced in the
   `UserProfileModule` via the `(in)accessibleSitesPackages`
   attributes.
1. In the dashboard there are the _Block/Allow domains_ cards. The
   lists edited there are referenced in the `UserModule` via the
   `customBlack/WhitelistId` attributes.

## Database classes

<pre class="mermaid">
classDiagram
    UiCard <|-- ParentalControlCard
    UserModule --> UserProfileModule: associatedProfileId
    UserModule --> UiCard: dashboardColumnView
    ParentalControlCard --> UserModule: referencingUserId
    Device --> UserModule
    UserProfileModule --> ParentalControlFilterMetaData: (in)accessibleSitesPackages
    UserModule --> ParentalControlFilterMetaData: customBlack/WhitelistId

    class UserModule {
        +int id
        +userRole
    }
    class Device {
        +String id
        +defaultSystemUserId
        +parentalControlUserId
        +parentalControlOperatingUserId
    }
    class ParentalControlFilterMetaData {
        +int id
    }
    class UserProfileModule {
        +int id
    }
</pre>
