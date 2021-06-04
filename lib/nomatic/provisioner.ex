defmodule Nomatic.Provisioner do
  @moduledoc """
  Manages provisioning a HashiStack.
  """

  alias Nomatic.Accounts
  # alias Nomatic.Accounts.{Stack}

  def start(stack) do
    :timer.sleep(1000)

    Accounts.update_stack(stack, %{status: "validated"})
    Task.start(__MODULE__, :build_state_bucket, [stack])
  end

  def build_state_bucket(stack) do
    :timer.sleep(1000)

    Accounts.update_stack(stack, %{status: "pre-provisioned"})
    Task.start(__MODULE__, :build_hashistack, [stack])
  end

  def build_hashistack(stack) do
    :timer.sleep(1000)

    Accounts.update_stack(stack, %{status: "provisioned"})
    Task.start(__MODULE__, :post_provisioning, [stack])
  end

  def post_provisioning(stack) do
    :timer.sleep(1000)
    Accounts.update_stack(stack, %{status: "ready"})
  end
end
