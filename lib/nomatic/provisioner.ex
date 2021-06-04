defmodule Nomatic.Provisioner do
  @moduledoc """
  Manages provisioning a HashiStack.
  """

  alias Nomatic.Accounts
  # alias Nomatic.Accounts.{Stack}

  def start(stack) do
    Accounts.update_stack(stack, %{status: "validated"})
    Task.start(__MODULE__, :build_state_bucket, [stack])
  end

  def build_state_bucket(stack) do
    path = "/Users/mike/Code/nomattic/provisioning/build_bucket.sh"
    args = "#{stack.key} #{stack.secret_key} #{stack.name} #{stack.region}"
    command = String.to_atom("#{path} #{args}")

    :os.cmd(command)

    Accounts.update_stack(stack, %{status: "pre-provisioned"})
    Task.start(__MODULE__, :build_hashistack, [stack])
  end

  def build_hashistack(stack) do
    path = "/Users/mike/Code/nomattic/provisioning/provision_infra.sh"
    args = "#{stack.key} #{stack.secret_key} #{stack.name} #{stack.region}"
    command = String.to_atom("#{path} #{args}")

    :os.cmd(command)

    Accounts.update_stack(stack, %{status: "provisioned"})
    Task.start(__MODULE__, :post_provisioning, [stack])
  end

  def post_provisioning(stack) do
    path = "/Users/mike/Code/nomattic/provisioning/post_provision.sh"
    args = "#{stack.key} #{stack.secret_key} #{stack.name} #{stack.region}"
    command = String.to_atom("#{path} #{args}")

    :os.cmd(command)

    Accounts.update_stack(stack, %{status: "ready"})
  end

  def deprovision(stack) do
    Accounts.update_stack(stack, %{status: "removing"})

    path = "/Users/mike/Code/nomattic/provisioning/deprovision.sh"
    args = "#{stack.key} #{stack.secret_key} #{stack.name} #{stack.region}"
    command = String.to_atom("#{path} #{args}")

    :os.cmd(command)

    Accounts.delete_stack(stack)
  end
end
