# 08 Configure Websites

**Updated:** 2024-02-02

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

Value | Example | Usage
------ | ------- | -----
`$domain` | example.test | blah blah blah
`$template_index` | 0 or 1 | Index of `.conf` template file.
`$reverse_domain` | test.example | blah blah blah
`$underscore_domain` | test_example | blah blah blah
`$ssl_filename` | example.test_YYYY-MM-DD | SSL filenames & their references in `.conf` files.


