# ExSyncThing

Pure Elixir implementation for SyncThing.

Components:
- Syncthing Client
- Web Client for individual file up/download
- Local Discovery Server
- [todo] Global Discovery Server (not implemented until main client is working safely)
- [todo] Relay Server

## SpawnFest Notes
- Got majorly stuck in the weeds with SSL issues, until this is fixed I can't test against the reference implementation.
- Had to change my approach to handling the relationship between Devices, ClusterConfigs, Folders, and SSL connections mid way through. 
I don't think the current setup is working either.
- SyncThing protocol documentation is a little vague on the exact matchup of clients/configs/folders. After this attempt I need to step back and re-consider the whole data flow.


## TODO
Core:
Test TLS against reference
On start, send Announce message
On received Announce, update record of local/remote devices, check status
On connect, send `Hello` before auth
On connect, send ClusterConfig
On file change, send Index

Web Client:
All off it.
Web UI to view files/folders/config
Up/Download files and trigger sync


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exsyncthing` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exsyncthing, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/exsyncthing>.

