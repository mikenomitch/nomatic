defmodule Nomatic.Provisioner do
  @moduledoc """
  Manages provisioning a HashiStack.
  """

  alias Nomatic.Accounts
  # alias Nomatic.Accounts.{Stack}

  def start(stack) do
    Accounts.update_stack(stack, %{status: "pre-provision"})
    Task.start(__MODULE__, :pre_provision, [stack])
  end

  def pre_provision(stack) do
    path = "/Users/mike/Code/nomattic/provisioning/pre_provision.sh"
    args = "#{stack.key} #{stack.secret_key} #{stack.name} #{stack.region}"
    command = String.to_atom("#{path} #{args}")

    res = :os.cmd(command)
    IO.puts("Pre res")
    IO.inspect(res)

    Accounts.update_stack(stack, %{status: "provisioning"})
    Task.start(__MODULE__, :provision, [stack])
  end

  def provision(stack) do
    path = "/Users/mike/Code/nomattic/provisioning/provision.sh"
    args = "#{stack.key} #{stack.secret_key} #{stack.name} #{stack.region}"
    command = String.to_atom("#{path} #{args}")

    res = :os.cmd(command)
    IO.puts("Provis res")
    IO.inspect(res)

    Accounts.update_stack(stack, %{status: "post-provision"})
    Task.start(__MODULE__, :post_provision, [stack])
  end

  def post_provision(stack) do
    path = "/Users/mike/Code/nomattic/provisioning/post_provision.sh"
    args = "#{stack.key} #{stack.secret_key} #{stack.name} #{stack.region}"
    command = String.to_atom("#{path} #{args}")

    res = :os.cmd(command)
    IO.puts("Post res")
    IO.inspect(res)

    parsed =
      res
      |> to_string
      |> String.split("^^^^^^^^^^")
      |> List.delete_at(0)
      |> List.first()
      |> to_charlist

    case Jason.decode(parsed) do
      {:ok,
       %{
         "consul_addr" => consul_address,
         "consul_token" => consul_token,
         "nomad_addr" => nomad_address,
         "nomad_token" => nomad_token,
         "nomad_client_addr" => nomad_client_address,
         "vault_addr" => vault_address
       }} ->
        Accounts.update_stack(stack, %{
          consul_address: consul_address,
          nomad_address: nomad_address,
          vault_address: vault_address,
          nomad_client_address: nomad_client_address,
          nomad_token: nomad_token,
          consul_token: consul_token,
          status: "ready"
        })

      _ ->
        Accounts.update_stack(stack, %{status: "errored"})
    end
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
