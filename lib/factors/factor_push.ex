defmodule FactorPush do
  @type device() :: String.t()
  @type type() :: String.t()
  @type display_username() :: String.t()
  @type pushinfo :: String.t()

  @type t :: %__MODULE__{
          device: device(),
          type: type(),
          display_username: display_username(),
          pushinfo: pushinfo()
        }
  defstruct device: nil, type: nil, display_username: nil, pushinfo: nil
end
