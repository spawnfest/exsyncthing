defmodule SyncThing.Core.FolderSupervisor do
  use DynamicSupervisor

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def start_child(config) do
    child_spec = {SyncThing.Core.Folder, config}

    {:ok, _cluster} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one, max_chilren: 10)
  end
end
