defmodule Preauth do
  def check_params(%{username: username} = params, ipaddr, trusted_device_token) do
    {:ok,
     params
     |> Map.merge(%{ipaddr: ipaddr, trusted_device_token: trusted_device_token})
     |> URI.encode_query()}
  end

  def check_params(%{user_id: user_id} = params, ipaddr, trusted_device_token) do
    {:ok,
     params
     |> Map.merge(%{ipaddr: ipaddr, trusted_device_token: trusted_device_token})
     |> URI.encode_query()}
  end

  def check_params(_, _, _) do
    {:error, :malformed_params}
  end
end
