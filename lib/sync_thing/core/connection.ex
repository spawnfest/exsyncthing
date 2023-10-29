defmodule SyncThing.Core.Connection do
  use GenServer, restart: :temporary

  alias SyncThing.BEP.Message
  alias SyncThing.Core.Folder

  require Logger

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  defstruct([:socket, :remote_device_id, cluster_received: false, buffer: <<>>])

  @impl true
  def init(socket) do
    Logger.debug("Client connected")

    case :ssl.handshake(
           socket,
           [
             # handshake: :hello
           ],
           :infinity
         ) do
      {:ok, socket} ->
        Logger.debug("no pause")
        :ssl.send(socket, "yay!")
        socket

      {:ok, socket, ext} ->
        Logger.debug("hello pause, ext: #{ext}")
        {:ok, socket} = :ssl.handshake_continue(socket, 30_000)
        socket
    end

    {:ok, %__MODULE__{socket: socket}}
  end

  @impl true
  def handle_info({:ssl, socket, data}, state) do
    state = update_in(state.buffer, &(&1 <> data))
    :ok = :inet.setopts(socket, active: :once)
    parse_all_data(state)
  end

  def handle_info({:error, message}, state) do
    Logger.error("error: #{inspect(message)}")
    {:noreply, state}
  end

  @magic <<0x2EA7D90B::32>>

  defp parse_all_data(
         %__MODULE__{
           buffer: <<@magic::binary, hello_length::16, hello::binary-size(hello_length)>>
         } = state
       ) do
    hello = Message.Hello.decode(hello)
    state = %{state | remote_device_id: hello.device_id}
    # TODO - auth the connection, drop if invalid
    {:noreply, state}
  end

  defp parse_all_data(
         %__MODULE__{
           buffer:
             <<header_length::16, header::binary-size(header_length), msg_length::32,
               msg::binary-size(msg_length)>>
         } = state
       ) do
    header = Message.Header.decode(header)

    message =
      if header.compression == 2 do
        raise "needs LZ4 implementation to decompress"
      else
        msg
      end

    case {state.cluster_received, header.type} do
      {false, 0} ->
        _msg = Message.ClusterConfig.decode(message)
        # Cluster.add_config(msg)
        %{state | cluster_received: true}

      {_, 0} ->
        raise "error: ClusterConfig already set"

      {true, _} ->
        raise "error: ClusterConfig must be first message"

      {_, 1} ->
        index = Message.Index.decode(message)

        [{pid, _} | _] = Registry.lookup(FolderRegistry, index.id)

        Folder.cast(pid, {:index, index})

      {_, 2} ->
        index = Message.IndexUpdate.decode(message)
        [{pid, _} | _] = Registry.lookup(FolderRegistry, index.id)
        Folder.cast(pid, {:index_update, index})

      {_, 3} ->
        request = Message.Request.decode(message)
        [{pid, _} | _] = Registry.lookup(FolderRegistry, request.folder)
        Folder.data_request(request)

      {_, 4} ->
        response = Message.Response.decode(message)

      # Folder.data_response(response)

      {_, 5} ->
        progress = Message.DownloadProgress.decode(message)

      # Folder.download_progress(progress)

      {_, 6} ->
        Message.Ping.decode(message)

      # pushback disconnect timer 90s

      {_, 7} ->
        Message.Close.decode(message)
        # close this connection
    end

    {:noreply, state}
  end
end
