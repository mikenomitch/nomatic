defmodule Nomatic.Accounts.Stack do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nomatic.Accounts.User

  schema "stacks" do
    belongs_to :user, User

    field(:name, :string)
    field(:key, :string)

    field(:status, :string)
    field(:client_count, :integer)
    field(:consul_address, :string)
    field(:consul_version, :string)
    field(:max_clients, :integer)
    field(:nomad_address, :string)
    field(:nomad_version, :string)
    field(:provider, :string)
    field(:region, :string)
    field(:server_count, :integer)
    field(:state_bucket, :string)
    field(:type, :string)
    field(:use_consul, :boolean, default: false)
    field(:use_vault, :boolean, default: false)
    field(:vault_address, :string)
    field(:vault_version, :string)
    field(:nomad_client_port, :integer)
    field(:nomad_client_address, :string)
    field(:consul_client_port, :integer)
    field(:consul_client_address, :string)

    # TODO: Encrypt and fix
    field(:secret_key, :string)
    field(:hashed_secret_key, :string)
    field(:nomad_token, :string)
    field(:consul_token, :string)
    field(:vault_token, :string)

    timestamps()
  end

  def changeset(stack, attrs) do
    stack
    |> cast(attrs, [
      :key,
      :secret_key,
      :name,
      :region,
      :status,
      :consul_address,
      :nomad_address,
      :nomad_client_address,
      :nomad_token,
      :consul_token,
      :user_id
    ])
    |> validate_required([
      :key,
      :name,
      :region,
      :user_id
    ])
    |> maybe_hash_secret_key(attrs)
  end

  def provision({:ok, stack}) do
    Task.start(Nomatic.Provisioner, :start, [stack])
    {:ok, stack}
  end

  def provision(not_ok_res), do: not_ok_res

  def maybe_hash_secret_key(changeset, attrs) do
    hash_secret_key? = Map.get(attrs, :secret_key, true)
    secret_key = get_change(changeset, :secret_key)

    if hash_secret_key? && secret_key && changeset.valid? do
      changeset
      |> put_change(:hashed_secret_key, Bcrypt.hash_pwd_salt(secret_key))

      # |> delete_change(:secret_key)
    else
      changeset
    end
  end
end
