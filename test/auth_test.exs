defmodule AuthTest do
  use ExUnit.Case

  test "malformed on nil id" do
    assert Auth.build_params(%Auth{}, nil) == {:error, :malformed_params, "id is required"}
  end

  test "malformed on nil or non-accepted id_type" do
    assert Auth.build_params(%Auth{id_type: nil}, nil) ==
             {:error, :malformed_params, "id is required"}

    assert Auth.build_params(%Auth{id: "filler", id_type: :nonexistent}, nil) ==
             {:error, :malformed_params, "id_type must be either :user_id or :username"}
  end

  test "acceptable auth params, but non implmented factor" do
    assert Auth.build_params(%Auth{id: "duo_user"}, nil) == {:error, :not_implemented}

    assert Auth.build_params(%Auth{id: "duo_user", factor: :passcode}, nil) ==
             {:error, :not_implemented}

    assert Auth.build_params(%Auth{id: "duo_user", factor: :sms}, nil) ==
             {:error, :not_implemented}

    assert Auth.build_params(%Auth{id: "duo_user", factor: :phone}, nil) ==
             {:error, :not_implemented}

    assert Auth.build_params(%Auth{id: "duo_user", factor: :bad_factor}, nil) ==
             {:error, :not_implemented}
  end

  test "empty FactorPush param" do
    assert Auth.build_params(%Auth{id: "duo_user", factor: :push}, %FactorPush{}) ==
             {:error, :malformed_params}
  end

  test "correct FactorPush with all keys" do
    ok_string =
      "async=0&device=DUOX1234&display_username=Bingo&factor=push&ipaddr=&pushinfo=Login&type=Fake&username=duo_user"

    factor_params = %FactorPush{
      device: "DUOX1234",
      display_username: "Bingo",
      pushinfo: "Login",
      type: "Fake"
    }

    assert Auth.build_params(%Auth{id: "duo_user", factor: :push}, factor_params) ==
             {:ok, ok_string}
  end
end
