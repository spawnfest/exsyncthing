defmodule SyncThing.Core.Connection do
  use GenServer, restart: :temporary

  # alias SyncThing.BEP.Message

  require Logger

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  defstruct([:socket, buffer: <<>>])

  @impl true
  def init(socket) do
    Logger.debug("Client connected")

    case :ssl.handshake(
           socket,
           [
             # handshake: :hello
           ],
           30_000
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
    dbg({socket, data})
    {:noreply, state}
  end

  def handle_info({:error, message}, state) do
    dbg(message)
    {:noreply, state}
  end
end
