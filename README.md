A small tool to pass a YAML file that contains system-wide registries for 
container runtimes. By default, the tooling will look at the YAML file in
`/etc/containers/registries.conf`.  This will be used by the atomic CLI and
other container runtimes to inject the proper registries.


To compile:

```
# autoreconf --verbose --install --force
# ./configure
# sudo make install
```

See docs/ for explicit instructions on how to run.
