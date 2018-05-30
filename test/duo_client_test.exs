defmodule DuoClientTest do
  use ExUnit.Case
  doctest DuoClient

  test "greets the world" do
    assert DuoClient.hello() == :world
  end
end
