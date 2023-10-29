defmodule SyncThing.BEP.Message.MessageType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :MESSAGE_TYPE_CLUSTER_CONFIG, 0
  field :MESSAGE_TYPE_INDEX, 1
  field :MESSAGE_TYPE_INDEX_UPDATE, 2
  field :MESSAGE_TYPE_REQUEST, 3
  field :MESSAGE_TYPE_RESPONSE, 4
  field :MESSAGE_TYPE_DOWNLOAD_PROGRESS, 5
  field :MESSAGE_TYPE_PING, 6
  field :MESSAGE_TYPE_CLOSE, 7
end

defmodule SyncThing.BEP.Message.MessageCompression do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :MESSAGE_COMPRESSION_NONE, 0
  field :MESSAGE_COMPRESSION_LZ4, 1
end

defmodule SyncThing.BEP.Message.Compression do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :COMPRESSION_METADATA, 0
  field :COMPRESSION_NEVER, 1
  field :COMPRESSION_ALWAYS, 2
end

defmodule SyncThing.BEP.Message.FileInfoType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :FILE_INFO_TYPE_FILE, 0
  field :FILE_INFO_TYPE_DIRECTORY, 1
  field :FILE_INFO_TYPE_SYMLINK_FILE, 2
  field :FILE_INFO_TYPE_SYMLINK_DIRECTORY, 3
  field :FILE_INFO_TYPE_SYMLINK, 4
end

defmodule SyncThing.BEP.Message.ErrorCode do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :ERROR_CODE_NO_ERROR, 0
  field :ERROR_CODE_GENERIC, 1
  field :ERROR_CODE_NO_SUCH_FILE, 2
  field :ERROR_CODE_INVALID_FILE, 3
end

defmodule SyncThing.BEP.Message.FileDownloadProgressUpdateType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :FILE_DOWNLOAD_PROGRESS_UPDATE_TYPE_APPEND, 0
  field :FILE_DOWNLOAD_PROGRESS_UPDATE_TYPE_FORGET, 1
end

defmodule SyncThing.BEP.Message.Hello do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :device_name, 1, type: :string, json_name: "deviceName"
  field :client_name, 2, type: :string, json_name: "clientName"
  field :client_version, 3, type: :string, json_name: "clientVersion"
  field :num_connections, 4, type: :int32, json_name: "numConnections"
  field :timestamp, 5, type: :int64
end

defmodule SyncThing.BEP.Message.Header do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :type, 1, type: SyncThing.BEP.Message.MessageType, enum: true
  field :compression, 2, type: SyncThing.BEP.Message.MessageCompression, enum: true
end

defmodule SyncThing.BEP.Message.ClusterConfig do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :folders, 1, repeated: true, type: SyncThing.BEP.Message.Folder
  field :secondary, 2, type: :bool
end

defmodule SyncThing.BEP.Message.Folder do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :label, 2, type: :string
  field :read_only, 3, type: :bool, json_name: "readOnly"
  field :ignore_permissions, 4, type: :bool, json_name: "ignorePermissions"
  field :ignore_delete, 5, type: :bool, json_name: "ignoreDelete"
  field :disable_temp_indexes, 6, type: :bool, json_name: "disableTempIndexes"
  field :paused, 7, type: :bool
  field :devices, 16, repeated: true, type: SyncThing.BEP.Message.Device
end

defmodule SyncThing.BEP.Message.Device do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :bytes
  field :name, 2, type: :string
  field :addresses, 3, repeated: true, type: :string
  field :compression, 4, type: SyncThing.BEP.Message.Compression, enum: true
  field :cert_name, 5, type: :string, json_name: "certName"
  field :max_sequence, 6, type: :int64, json_name: "maxSequence"
  field :introducer, 7, type: :bool
  field :index_id, 8, type: :uint64, json_name: "indexId"
  field :skip_introduction_removals, 9, type: :bool, json_name: "skipIntroductionRemovals"
  field :encryption_password_token, 10, type: :bytes, json_name: "encryptionPasswordToken"
end

defmodule SyncThing.BEP.Message.Index do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :folder, 1, type: :string
  field :files, 2, repeated: true, type: SyncThing.BEP.Message.FileInfo
end

defmodule SyncThing.BEP.Message.IndexUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :folder, 1, type: :string
  field :files, 2, repeated: true, type: SyncThing.BEP.Message.FileInfo
end

defmodule SyncThing.BEP.Message.FileInfo do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :name, 1, type: :string
  field :size, 3, type: :int64
  field :modified_s, 5, type: :int64, json_name: "modifiedS"
  field :modified_by, 12, type: :uint64, json_name: "modifiedBy"
  field :version, 9, type: SyncThing.BEP.Message.Vector
  field :sequence, 10, type: :int64
  field :blocks, 16, repeated: true, type: SyncThing.BEP.Message.BlockInfo
  field :symlink_target, 17, type: :string, json_name: "symlinkTarget"
  field :blocks_hash, 18, type: :bytes, json_name: "blocksHash"
  field :encrypted, 19, type: :bytes
  field :type, 2, type: SyncThing.BEP.Message.FileInfoType, enum: true
  field :permissions, 4, type: :uint32
  field :modified_ns, 11, type: :int32, json_name: "modifiedNs"
  field :block_size, 13, type: :int32, json_name: "blockSize"
  field :platform, 14, type: SyncThing.BEP.Message.PlatformData
  field :local_flags, 1000, type: :uint32, json_name: "localFlags"
  field :version_hash, 1001, type: :bytes, json_name: "versionHash"
  field :inode_change_ns, 1002, type: :int64, json_name: "inodeChangeNs"
  field :encryption_trailer_size, 1003, type: :int32, json_name: "encryptionTrailerSize"
  field :deleted, 6, type: :bool
  field :invalid, 7, type: :bool
  field :no_permissions, 8, type: :bool, json_name: "noPermissions"
end

defmodule SyncThing.BEP.Message.BlockInfo do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :hash, 3, type: :bytes
  field :offset, 1, type: :int64
  field :size, 2, type: :int32
  field :weak_hash, 4, type: :uint32, json_name: "weakHash"
end

defmodule SyncThing.BEP.Message.Vector do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :counters, 1, repeated: true, type: SyncThing.BEP.Message.Counter
end

defmodule SyncThing.BEP.Message.Counter do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :uint64
  field :value, 2, type: :uint64
end

defmodule SyncThing.BEP.Message.PlatformData do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :unix, 1, type: SyncThing.BEP.Message.UnixData
  field :windows, 2, type: SyncThing.BEP.Message.WindowsData
  field :linux, 3, type: SyncThing.BEP.Message.XattrData
  field :darwin, 4, type: SyncThing.BEP.Message.XattrData
  field :freebsd, 5, type: SyncThing.BEP.Message.XattrData
  field :netbsd, 6, type: SyncThing.BEP.Message.XattrData
end

defmodule SyncThing.BEP.Message.UnixData do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :owner_name, 1, type: :string, json_name: "ownerName"
  field :group_name, 2, type: :string, json_name: "groupName"
  field :uid, 3, type: :int32
  field :gid, 4, type: :int32
end

defmodule SyncThing.BEP.Message.WindowsData do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :owner_name, 1, type: :string, json_name: "ownerName"
  field :owner_is_group, 2, type: :bool, json_name: "ownerIsGroup"
end

defmodule SyncThing.BEP.Message.XattrData do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :xattrs, 1, repeated: true, type: SyncThing.BEP.Message.Xattr
end

defmodule SyncThing.BEP.Message.Xattr do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :name, 1, type: :string
  field :value, 2, type: :bytes
end

defmodule SyncThing.BEP.Message.Request do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :int32
  field :folder, 2, type: :string
  field :name, 3, type: :string
  field :offset, 4, type: :int64
  field :size, 5, type: :int32
  field :hash, 6, type: :bytes
  field :from_temporary, 7, type: :bool, json_name: "fromTemporary"
  field :weak_hash, 8, type: :uint32, json_name: "weakHash"
  field :block_no, 9, type: :int32, json_name: "blockNo"
end

defmodule SyncThing.BEP.Message.Response do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :int32
  field :data, 2, type: :bytes
  field :code, 3, type: SyncThing.BEP.Message.ErrorCode, enum: true
end

defmodule SyncThing.BEP.Message.DownloadProgress do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :folder, 1, type: :string
  field :updates, 2, repeated: true, type: SyncThing.BEP.Message.FileDownloadProgressUpdate
end

defmodule SyncThing.BEP.Message.FileDownloadProgressUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :update_type, 1,
    type: SyncThing.BEP.Message.FileDownloadProgressUpdateType,
    json_name: "updateType",
    enum: true

  field :name, 2, type: :string
  field :version, 3, type: SyncThing.BEP.Message.Vector
  field :block_indexes, 4, repeated: true, type: :int32, json_name: "blockIndexes"
  field :block_size, 5, type: :int32, json_name: "blockSize"
end

defmodule SyncThing.BEP.Message.Ping do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule SyncThing.BEP.Message.Close do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :reason, 1, type: :string
end