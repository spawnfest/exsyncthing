defmodule SyncThing.LocalDiscovery.Message.Announce do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :bytes
  field :addresses, 2, repeated: true, type: :string
  field :instance_id, 3, type: :int64, json_name: "instanceId"
end