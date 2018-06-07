defmodule Auth do
  @type id() :: String.t()
  @type id_type() :: :username | :user_id
  @type factor() :: :auto | :push | :passcode | :sms | :phone
  @type ipaddr() :: String.t()
  @type async :: String.t()

  @type t :: %__MODULE__{
          id: id(),
          id_type: id_type(),
          factor: factor(),
          ipaddr: ipaddr(),
          async: async()
        }
  defstruct id: nil, id_type: :username, factor: :auto, ipaddr: "", async: "0"

  def build_params(%Auth{id: nil}, _), do: {:error, :malformed_params, "id is required"}

  def build_params(%Auth{id_type: nil}, _), do: {:error, :malformed_params, "id_type is required"}

  def build_params(%Auth{id_type: :user_id} = params, factor_params),
    do: encode_params(params, factor_params)

  def build_params(%Auth{id_type: :username} = params, factor_params),
    do: encode_params(params, factor_params)

  def build_params(%Auth{id_type: _}, _),
    do: {:error, :malformed_params, "id_type must be either :user_id or :username"}

  def build_params(%Auth{} = params, factor_params), do: encode_params(params, factor_params)

  defp encode_params(params, factor_params) do
    base_params =
      params
      |> Map.from_struct()
      |> Map.merge(%{params.id_type => params.id})
      |> Map.drop([:id, :id_type])

    case pick_factor_params(params, factor_params) do
      {:ok, result} ->
        {:ok,
         result
         |> Map.from_struct()
         |> Map.merge(base_params)
         |> Enum.reject(fn {_, v} -> is_nil(v) end)
         |> Enum.into(%{})
         |> URI.encode_query()}

      {:error, response} ->
        {:error, response}

      _ ->
        {:error, :unrecgonized_push_factor_error}
    end
  end

  defp pick_factor_params(params, factor_params) do
    case params.factor do
      :auto -> {:error, :not_implemented}
      :push -> add_factor_params(factor_params)
      :passcode -> {:error, :not_implemented}
      :sms -> {:error, :not_implemented}
      :phone -> {:error, :not_implemented}
      _ -> {:error, :not_implemented}
    end
  end

  def add_factor_params(%FactorPush{device: nil}), do: {:error, :malformed_params}
  def add_factor_params(%FactorPush{device: _} = factor_params), do: {:ok, factor_params}
end
