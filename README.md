A small tool to pass a TOML file that contains system-wide registries for 
container runtimes. By default, the tooling will look at the TOML file in
`/etc/containers/registries.conf`.  This will be used by the atomic CLI and
other container runtimes to inject the proper registries.


To compile:

```
# sudo make install
```

See docs/ for explicit instructions on how to run.
