# DuoClient

The elixir connector for the [Duo Authentication API](https://duo.com/docs/authapi). Currently, this package should be considered unstable and incomplete.

## Installation
Add duo_client as dependency in mix.exs
```elixir
def deps do
  [
    {:duo_client, "~> 0.1.0"}
  ]
end
```

Configuration
```elixir
config :duo_client, :settings,
  ikey: "",
  skey: "",
  host: "api-secret.duosecurity.com"
```
## Usage

Methods supported:
- ping
- check
- preauth
- auth

Authentication factors supported:
- `:push`

Each method requires a struct to format parameters. For example, `DuoClient.preauth` requires a `%Preauth{}` struct as the first argument.

Where applicable, default key-values will be picked.

#### Preauth Example
```elixir
DuoClient.preauth(%Preauth{id: "username"})```

Example success response:
```elixir
{:ok, :auth,
 %{
   "devices" => [
     %{
       "capabilities" => ["auto", "push", "sms", "phone", "mobile_otp"],
       "device" => "DPZXXXXX",
       "display_name" => "iOS (XXX-XXX-XXXX)",
       "name" => "",
       "number" => "XXX-XXX-XXXX",
       "type" => "phone"
     }
   ],
   "result" => "auth",
   "status_msg" => "Account is active"
 }}
```
#### Auth Example

````elixir
DuoClient.auth(%Auth{id: "username", factor: :push}, %FactorPush{device: "auto"})
````

Example success response:
```elixir
{:ok,
 %{
   "result" => "allow",
   "status" => "allow",
   "status_msg" => "Success. Logging you in..."
 }}
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
