defmodule Nomatic.AccountsTest do
  use Nomatic.DataCase

  alias Nomatic.Accounts

  describe "stacks" do
    alias Nomatic.Accounts.Stack

    @valid_attrs %{
      client_count: 42,
      consul_address: "some consul_address",
      consul_version: "some consul_version",
      max_clients: 42,
      nomad_address: "some nomad_address",
      nomad_version: "some nomad_version",
      provider: "some provider",
      region: "some region",
      server_count: 42,
      state_bucket: "some state_bucket",
      status: "some status",
      token: "some token",
      type: "some type",
      use_consul: true,
      use_vault: true,
      vault_address: "some vault_address",
      vault_version: "some vault_version"
    }
    @update_attrs %{
      client_count: 43,
      consul_address: "some updated consul_address",
      consul_version: "some updated consul_version",
      max_clients: 43,
      nomad_address: "some updated nomad_address",
      nomad_version: "some updated nomad_version",
      provider: "some updated provider",
      region: "some updated region",
      server_count: 43,
      state_bucket: "some updated state_bucket",
      status: "some updated status",
      token: "some updated token",
      type: "some updated type",
      use_consul: false,
      use_vault: false,
      vault_address: "some updated vault_address",
      vault_version: "some updated vault_version"
    }
    @invalid_attrs %{
      client_count: nil,
      consul_address: nil,
      consul_version: nil,
      max_clients: nil,
      nomad_address: nil,
      nomad_version: nil,
      provider: nil,
      region: nil,
      server_count: nil,
      state_bucket: nil,
      status: nil,
      token: nil,
      type: nil,
      use_consul: nil,
      use_vault: nil,
      vault_address: nil,
      vault_version: nil
    }

    def stack_fixture(attrs \\ %{}) do
      {:ok, stack} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_stack()

      stack
    end

    test "list_stacks/0 returns all stacks" do
      stack = stack_fixture()
      assert Accounts.list_stacks() == [stack]
    end

    test "get_stack!/1 returns the stack with given id" do
      stack = stack_fixture()
      assert Accounts.get_stack!(stack.id) == stack
    end

    test "create_stack/1 with valid data creates a stack" do
      assert {:ok, %Stack{} = stack} = Accounts.create_stack(@valid_attrs)
      assert stack.client_count == 42
      assert stack.consul_address == "some consul_address"
      assert stack.consul_version == "some consul_version"
      assert stack.max_clients == 42
      assert stack.nomad_address == "some nomad_address"
      assert stack.nomad_version == "some nomad_version"
      assert stack.provider == "some provider"
      assert stack.region == "some region"
      assert stack.server_count == 42
      assert stack.state_bucket == "some state_bucket"
      assert stack.status == "some status"
      assert stack.key == "some token"
      assert stack.type == "some type"
      assert stack.use_consul == true
      assert stack.use_vault == true
      assert stack.vault_address == "some vault_address"
      assert stack.vault_version == "some vault_version"
    end

    test "create_stack/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_stack(@invalid_attrs)
    end

    test "update_stack/2 with valid data updates the stack" do
      stack = stack_fixture()
      assert {:ok, %Stack{} = stack} = Accounts.update_stack(stack, @update_attrs)
      assert stack.client_count == 43
      assert stack.consul_address == "some updated consul_address"
      assert stack.consul_version == "some updated consul_version"
      assert stack.max_clients == 43
      assert stack.nomad_address == "some updated nomad_address"
      assert stack.nomad_version == "some updated nomad_version"
      assert stack.provider == "some updated provider"
      assert stack.region == "some updated region"
      assert stack.server_count == 43
      assert stack.state_bucket == "some updated state_bucket"
      assert stack.status == "some updated status"
      assert stack.key == "some updated token"
      assert stack.type == "some updated type"
      assert stack.use_consul == false
      assert stack.use_vault == false
      assert stack.vault_address == "some updated vault_address"
      assert stack.vault_version == "some updated vault_version"
    end

    test "update_stack/2 with invalid data returns error changeset" do
      stack = stack_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_stack(stack, @invalid_attrs)
      assert stack == Accounts.get_stack!(stack.id)
    end

    test "delete_stack/1 deletes the stack" do
      stack = stack_fixture()
      assert {:ok, %Stack{}} = Accounts.delete_stack(stack)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_stack!(stack.id) end
    end

    test "change_stack/1 returns a stack changeset" do
      stack = stack_fixture()
      assert %Ecto.Changeset{} = Accounts.change_stack(stack)
    end
  end
end
