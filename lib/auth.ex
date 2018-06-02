defmodule Auth do
  def check_params(%{username: username} = params, factor, device, ipaddr, async) do
    {:ok,
     params
     |> Map.merge(%{ipaddr: ipaddr, factor: factor, device: device, ipaddr: ipaddr, async: async})
     |> URI.encode_query()}
  end

  def check_params(%{user_id: user_id} = params, factor, device, ipaddr, async) do
    {:ok,
     params
     |> Map.merge(%{ipaddr: ipaddr, factor: factor, device: device, ipaddr: ipaddr, async: async})
     |> URI.encode_query()}
  end

  def check_params(_, _, _) do
    {:error, :malformed_params}
  end
end
