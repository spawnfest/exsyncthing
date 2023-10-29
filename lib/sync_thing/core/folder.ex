defmodule SyncThing.Core.Folder do
  use GenServer

  def start_link(folder_id) do
    GenServer.start_link(__MODULE__, folder_id, name: via_tuple(folder_id))
  end

  def inbound_index(msg) do
    GenServer.cast(__MODULE__, {:index, msg})
  end

  def inbound_index_update(msg) do
    GenServer.cast(__MODULE__, {:index_update, msg})
  end

  def data_request(request) do
    GenServer.call(__MODULE__, {:request, request})
  end

  def data_response(response) do
    GenServer.cast(__MODULE__, {:response, response})
  end

  def download_progress(progress) do
    GenServer.cast(__MODULE__, {:progress, progress})
  end

  defstruct [:id, :label, :path, devices: []]

  @impl true
  def init(folder_id) do
    {:ok, %__MODULE__{id: folder_id}}
  end

  @impl true
  def handle_cast(cast, state)

  def handle_cast({:add_config, msg}, state) do
    msg.folders
    {:noreply, state}
  end

  def handle_cast({:index, _data}, state) do
    # full listing of files/folders in a shared folder
    # check against current state and request/send changes if needed
    {:noreply, state}
  end

  def handle_cast({:index_update, _data}, state) do
    # partial listing of files/folders
    {:noreply, state}
  end

  def handle_cast({:response, _data}, state) do
    # receive data from a peer
    {:noreply, state}
  end

  def handle_cast({:progress, _data}, state) do
    # receive progress from a peer
    {:noreply, state}
  end

  @impl true
  def handle_call(request, from, state)

  def handle_call({:request, _request}, _from, state) do
    # provide data to a peer
    {:reply, "here it is", state}
  end

  defp via_tuple(folder_id) do
    {:via, Registry, {SyncThing.Core.FolderRegistry, folder_id}}
  end
end
