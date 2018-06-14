defmodule DuoClient do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://#{@host}")
  plug(Tesla.Middleware.FormUrlencoded)
  plug(Tesla.Middleware.DecodeJson)

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

  def preauth(%Preauth{} = preauth_params) do
    path = "/auth/v2/preauth"

    case Preauth.build_params(preauth_params) do
      {:ok, params} ->
        {:ok, resp} =
          path
          |> build_authorization("POST", params)
          |> client()
          |> post(path, params)

        case resp.body["response"]["result"] do
          "auth" ->
            {:ok, :auth, resp.body["response"]}

          "allow" ->
            {:ok, :allow, resp.body["response"]}

          "deny" ->
            {:ok, :deny, resp.body["response"]}

          "enroll" ->
            {:ok, :enroll, resp.body["response"]}

          _ ->
            {:error, "Preauth Client Error"}
        end

      {:error, resp} ->
        {:error, resp}
    end
  end

  # For now, only support "Push" factor
  def auth(preauth_params, factor_params) do
    path = "/auth/v2/auth"

    case Auth.build_params(preauth_params, factor_params) do
      {:ok, params} ->
        {:ok, resp} =
          path
          |> build_authorization("POST", params)
          |> client()
          |> post(path, params)

        case resp.body["response"]["result"] do
          "allow" ->
            {:ok, resp.body["response"]}

          "deny" ->
            {:deny, resp.body["response"]}

          _ ->
            {:error, resp}
        end

      {:error, resp} ->
        {:error, resp}
    end
  end

  def headers(signature) do
    [
      {"Date", date_now()},
      {"Authorization", "Basic #{signature}"}
    ]
  end

  def date_now do
    Rfc2282.current_timestamp()
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
