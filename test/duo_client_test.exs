defmodule DuoClientTest do
  use ExUnit.Case
  doctest DuoClient

  import Tesla.Mock

  setup do
    mock(fn
      %{method: :get, url: "https://api-secret.duosecurity.com/auth/v2/ping"} ->
        %Tesla.Env{status: 200, body: %{"response" => %{"time" => 1_528_758_917}, "stat" => "OK"}}

      %{method: :get, url: "https://api-secret.duosecurity.com/auth/v2/check"} ->
        %Tesla.Env{status: 200, body: %{"response" => %{"time" => 1_528_758_917}, "stat" => "OK"}}
    end)

    :ok
  end

  test "ping" do
    assert {:ok, %Tesla.Env{} = env} = DuoClient.get("/auth/v2/ping")
    assert env.status == 200
    assert env.body == %{"response" => %{"time" => 1_528_758_917}, "stat" => "OK"}
  end

  test "check" do
    assert {:ok, %Tesla.Env{} = env} = DuoClient.get("/auth/v2/check")
    assert env.status == 200
    assert env.body == %{"response" => %{"time" => 1_528_758_917}, "stat" => "OK"}
  end
end
