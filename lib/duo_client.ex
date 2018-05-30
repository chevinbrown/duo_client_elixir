defmodule DuoClient do
  def check do
    HTTPoison.get!("https://#{host()}#{path()}", headers())
  end

  def headers do
    [
      {"Date", date_now()},
      {"Authorization", "Basic #{build_authorization()}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end

  def date_now do
    {:ok, date} = Timex.format(Timex.now(), "%a, %d %b %Y %H:%M:%S -0000", :strftime)
    date
  end

  def build_authorization do
    Base.encode64("#{ikey()}:#{auth_hash()}")
  end

  def auth_hash do
    params = ""
    request = date_now() <> "\n" <> "GET\n" <> host() <> "\n" <> path() <> "\n" <> params

    :crypto.hmac(:sha, skey(), request)
    |> Base.encode16()
  end

  defp path do
    "/auth/v2/check"
  end

  defp ikey do
    Application.get_env(:duo_client, :settings)[:ikey]
  end

  defp skey do
    Application.get_env(:duo_client, :settings)[:skey]
  end

  defp host do
    Application.get_env(:duo_client, :settings)[:host]
  end
end
