defmodule SyncThing.Core.Acceptor do
  use Task, restart: :transient

  require Logger

  def start_link(_opts) do
    Task.start_link(__MODULE__, :run, [22000])
  end

  def run(port) do
    case :ssl.listen(
           port,
           [
             :binary,
             certs_keys: [
               %{
                 certfile: "priv/cert/selfsigned.pem",
                 keyfile: "priv/cert/selfsigned_key.pem"
               }
             ],
             # cacerts: :public_key.cacerts_get(),
             # certs_keys: [
             #   %{
             #     keyfile: "key.pem",
             #     certfile: "cert.pem"
             #   }
             # ],
             active: true,
             # handshake: :hello,
             reuseaddr: true
           ]
         ) do
      {:ok, listen_socket} ->
        Logger.debug(":ssl.listen")
        accept_loop(listen_socket)

      {:error, reason} ->
        raise "Failed to listen on port #{inspect(port)}: reason #{inspect(reason)}"
    end
  end

  defp accept_loop(listen_socket) do
    case :ssl.transport_accept(listen_socket, :infinity) do
      {:ok, socket} ->
        Logger.debug(":ssl.transport_accept")
        {:ok, _} = SyncThing.Core.ConnectionSupervisor.start_child(socket)
        accept_loop(listen_socket)

      {:error, reason} ->
        raise "Failed to accept connection: #{inspect(reason)}"
    end
  end
end
