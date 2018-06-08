% registries.conf(5) Container Registries Configuration File
% Tom Sweeney
% June 2018

# NAME
registries.conf - Syntax of Container Registries configuration file

# DESCRIPTION
The REGISTRIES configuration file is a system-wide configuration file
that specifies the registries to use for various container backends.
It adheres to TOML format and does not support recursive lists of
registries.

# FORMAT
The [TOML format][toml] is used as the encoding of the configuration file.
The only valid categories are: 'registries.search', 'registries.insecure',
and 'registries.block'.

No bare options are used. The format of TOML can be simplified to:

    [table]
    option = value

    [table.subtable1]
    option = value

    [table.subtable2]
    option = value

### REGISTRIES SEARCH OPTIONS TABLE

The `registries.search` table supports the following option:

**registries**=[]
  A comma separated list of registries to search through when pulling
an image.  The registries are searched in order until a match is found
or the search is exhausted.  For example:
```
 registries = ['docker.io', 'registry.fedoraproject.org', 'registry.access.redhat.com']
```

The `registries.insecure` table supports the following option:

**registries**=[]
  A comma separated list of insecure registries to search through when pulling
an image.  An insecure registry is one that does not have a valid SSL certificate
or only uses the HTTP protocol.  These registries should only be used for testing
purposes.  The registries are searched in order until a match is found or the
search is exhausted.  For example:
```
 registries = ['testregistry.mydomain.com', 'insecureregistry.mydomain.com']
```

The `registries.block` table supports the following option:

**registries**=[]
  A comma separated list of registries to block access to when pulling
an image.  For example:
```
 registries = ['registry.mycompetitor.com', 'registry.unsafe.com']
```

# HISTORY
June 2018, Originally compiled by Tom Sweeney <tsweeneey@redhat.com>
