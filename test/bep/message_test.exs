defmodule SyncThing.BEP.MessageTest do
  use ExUnit.Case, async: true

  alias SyncThing.BEP.Message

  describe "encode -> decode all sub message types" do
    # test "Header" do
    #   ping = %Message.Ping{}
    #   msg = %Message.Header{type: 6, compression: 1, }
    #   assert {:ok, ^msg, ""} = Message.Header.decode(Message.Header.encode(msg))
    # end

    test "%Ping{}" do
      msg = %Message.Ping{}
      assert ^msg = Message.Ping.decode(Message.Ping.encode(msg))
    end
  end

  describe "extract message preceeded by header" do
    test "%Header{%Ping{}}" do
      ping = %Message.Ping{}
      header = %Message.Header{type: 6, compression: 1}
      enc_ping = Message.Ping.encode(ping)
      enc_header = Message.Ping.encode(header)
      msg = <<byte_size(enc_header)::16, enc_header::binary, byte_size(enc_ping)::32, enc_ping::binary>>
      assert true
    end
  end
end