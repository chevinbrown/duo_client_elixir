use Mix.Config

config :duo_client, :settings,
  ikey: "",
  skey: "",
  host: "api-secret.duosecurity.com"

config :tesla, adapter: Tesla.Mock
