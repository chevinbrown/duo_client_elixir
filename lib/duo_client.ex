defmodule DuoClient do
  import IEx
  use Tesla
  plug(Tesla.Middleware.BaseUrl, "https://#{@host}")
  plug(Tesla.Middleware.FormUrlencoded)

  @ikey Application.get_env(:duo_client, :settings)[:ikey]
  @skey Application.get_env(:duo_client, :settings)[:skey]
  @host Application.get_env(:duo_client, :settings)[:host]

  def ping do
    get("/auth/v2/ping")
  end

  def check do
    path = "/auth/v2/check"

    path
    |> build_authorization("GET", "")
    |> client()
    |> get(path)
  end

  # identifier must be EITHER username or user_id
  def preauth(identifier, ipaddr \\ "", trusted_device_token \\ "") do
    path = "/auth/v2/preauth"

    path
    |> build_authorization("POST", identifier)
    |> client()
    |> post(path, identifier)
  end

  def auth(identifier \\ "", factor \\ "") do
    path = "/auth/v2/auth"
    params = identifier
    signature = build_authorization(path, "POST", params)

    path
    |> build_authorization("POST", identifier)
    |> client()
    |> post(path, identifier)
  end

  def headers(signature) do
    [
      {"Date", date_now()},
      {"Authorization", "Basic #{signature}"}
    ]
  end

  def date_now do
    {:ok, date} = Timex.format(Timex.now(), "%a, %d %b %Y %H:%M:%S -0000", :strftime)
    date
  end

  def build_authorization(path, method, params) do
    "#{@ikey}:#{auth_hash(method, path, params)}"
    |> Base.encode64()
  end

  def auth_hash(method, path, params) do
    request = date_now() <> "\n" <> method <> "\n" <> @host <> "\n" <> path <> "\n" <> params

    :crypto.hmac(:sha, @skey, request)
    |> Base.encode16()
  end

  def client(signature) do
    Tesla.build_client([
      {Tesla.Middleware.Headers, headers(signature)}
    ])
  end
end
