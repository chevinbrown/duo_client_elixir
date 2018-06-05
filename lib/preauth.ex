defmodule Preauth do
  @type id() :: String.t()
  @type id_type() :: :username | :user_id
  @type ipaddr() :: String.t()
  @type trusted_device_token() :: String.t()
  @type t :: %__MODULE__{
          id: id(),
          id_type: id_type(),
          ipaddr: ipaddr(),
          trusted_device_token: trusted_device_token()
        }
  defstruct id: nil, id_type: :username, ipaddr: "", trusted_device_token: ""

  def build_params(%Preauth{id: nil}), do: {:error, :malformed_params}
  def build_params(%Preauth{id_type: :user_id} = params), do: {:ok, encode_params(params)}
  def build_params(%Preauth{id_type: :username} = params), do: {:ok, encode_params(params)}
  def build_params(%Preauth{id_type: _}), do: {:error, :malformed_params}

  defp encode_params(params) do
    %{
      :ipaddr => params.ipaddr,
      :trusted_device_token => params.trusted_device_token,
      params.id_type => params.id
    }
    |> URI.encode_query()
  end
end
