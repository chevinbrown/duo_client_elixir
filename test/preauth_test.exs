defmodule PreauthTest do
  use ExUnit.Case
  doctest DuoClient

  test "malformed on nil id" do
    assert Preauth.build_params(%Preauth{}) == {:error, :malformed_params}
  end

  test "malformed on nil or non-accepted id_type" do
    assert Preauth.build_params(%Preauth{id_type: nil}) == {:error, :malformed_params}
    assert Preauth.build_params(%Preauth{id_type: :nonexistent}) == {:error, :malformed_params}
  end

  test "acceptable preauth params" do
    assert Preauth.build_params(%Preauth{id: "duo_user"}) ==
             {:ok, "ipaddr=&trusted_device_token=&username=duo_user"}

    assert Preauth.build_params(%Preauth{id: "duo_user", id_type: :user_id}) ==
             {:ok, "ipaddr=&trusted_device_token=&user_id=duo_user"}

    assert Preauth.build_params(%Preauth{id: "duo_user", id_type: :username}) ==
             {:ok, "ipaddr=&trusted_device_token=&username=duo_user"}
  end
end
