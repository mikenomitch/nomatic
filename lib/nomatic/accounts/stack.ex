defmodule Nomatic.Accounts.Stack do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stacks" do
    field(:name, :string)
    field(:key, :string)
    field(:secret_key, :string, virtual: true)
    field(:hashed_secret_key, :string)

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
    field(:status, :string)
    field(:type, :string)
    field(:use_consul, :boolean, default: false)
    field(:use_vault, :boolean, default: false)
    field(:vault_address, :string)
    field(:vault_version, :string)

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(stack, attrs) do
    stack
    |> cast(attrs, [
      :key,
      :secret_key,
      :name,
      :region
    ])
    |> validate_required([
      :key,
      :name,
      :region
    ])
    |> maybe_hash_secret_key(attrs)
  end

  defp maybe_hash_secret_key(changeset, attrs) do
    hash_secret_key? = Map.get(attrs, :secret_key, true)
    secret_key = get_change(changeset, :secret_key)

    if hash_secret_key? && secret_key && changeset.valid? do
      changeset
      |> put_change(:hashed_secret_key, Bcrypt.hash_pwd_salt(secret_key))
      |> delete_change(:secret_key)
    else
      changeset
    end
  end
end
