defmodule DuoClient do
  @ikey Application.get_env(:duo_client, :settings)[:ikey]
  @skey Application.get_env(:duo_client, :settings)[:skey]
  @host Application.get_env(:duo_client, :settings)[:host]

  def check do
    path = "/auth/v2/check"
    signature = build_authorization("POST", path, "")
    HTTPoison.get!("https://#{@host}#{path}", headers(signature))
  end

  def preauth(identifier, ipaddr \\ "", trusted_device_token \\ "") do
    path = "/auth/v2/preauth"
    params = identifier
    signature = build_authorization("POST", path, params)
    resp = HTTPoison.post!("https://#{@host}#{path}", params, headers(signature))
  end

  def auth(identifier \\ "", factor \\ "") do
    path = "/auth/v2/auth"
    params = identifier
    signature = build_authorization("POST", path, params)

    HTTPoison.post!(
      "https://#{@host}#{path}",
      params,
      headers(signature),
      timeout: 50_000,
      recv_timeout: 50_000
    )
  end

  def headers(signature) do
    [
      {"Date", date_now()},
      {"Authorization", "Basic #{signature}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end

  def date_now do
    {:ok, date} = Timex.format(Timex.now(), "%a, %d %b %Y %H:%M:%S -0000", :strftime)
    date
  end

  def build_authorization(method, path, params) do
    "#{@ikey}:#{auth_hash(method, path, params)}"
    |> Base.encode64()
  end

  def auth_hash(method, path, params) do
    request = date_now() <> "\n" <> method <> "\n" <> @host <> "\n" <> path <> "\n" <> params

    :crypto.hmac(:sha, @skey, request)
    |> Base.encode16()
  end
end
