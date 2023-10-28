defmodule SyncThing.LocalDiscovery.Announcer do
  use GenServer

  alias SyncThing.LocalDiscovery.Message

  @magic <<0x2EA7D90B::32>>

  require Logger

  def start_link(_opts) do
    port = 21027
    device_id = "AMS355T-IOTRP5D-36DWTD2-NUIDC32-JDPXGGG-2HFKT7F-HHTCYON-OPVNLA2"
    GenServer.start_link(__MODULE__, {port, device_id})
  end

  defstruct [:socket, :device_id, addresses: [], peer_addresses: []]

  @impl true
  def init({port, device_id}) do
    case :gen_udp.open(port, [:binary, active: false, broadcast: true, ip: {0, 0, 0, 0}]) do
      {:ok, socket} ->
        Logger.debug("Port opened: #{inspect(port)}")
        state = %__MODULE__{socket: socket, device_id: device_id}

        message =
          %Message.Announce{
            id: device_id,
            addresses: ["tcp://0.0.0.0:22000"],
            instance_id: 1234
          }

        # announcement packet is @magic followed by %Announcement{} 
        # and broadcast to the local network
        :ok =
          :gen_udp.send(
            socket,
            {{10, 0, 0, 255}, port},
            @magic <> Message.Announce.encode(message)
          )

        {:ok, state, {:continue, :recv}}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl true
  def handle_continue(:recv, %__MODULE__{} = state) do
    case :gen_udp.recv(state.socket, 0) do
      {:ok, {address, port, packet}} ->
        Logger.debug("Received announcement from #{inspect(address)}:#{inspect(port)}")

        # strip the magic bytes
        message =
          packet
          |> String.split_at(4)
          |> elem(1)
          |> Message.Announce.decode()

        Logger.debug("Announced addresses: #{inspect(message.addresses)}")

        addresses =
          message.addresses
          |> Enum.map(fn a ->
            {:ok, u} = URI.new(a)

            uri =
              case u.host do
                "0.0.0.0" ->
                  %URI{u | host: ip_to_host(address)}

                "" ->
                  %URI{u | host: ip_to_host(address)}

                _ ->
                  u
              end

            {message.id, URI.to_string(uri)}
          end)
          |> Enum.concat(state.peer_addresses)
          |> Enum.uniq()

        {:noreply, %{state | peer_addresses: addresses}, {:continue, :recv}}

      {:error, reason} ->
        :gen_udp.close(state.socket)
        {:stop, reason}
    end
  end

  defp ip_to_host({a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end
end
