defmodule FactorPasscode do
  @type passcode() :: String.t()

  @type t :: %__MODULE__{
          passcode: passcode()
        }
  defstruct passcode: nil
end
