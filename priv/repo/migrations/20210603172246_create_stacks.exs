defmodule Nomatic.Repo.Migrations.CreateStacks do
  use Ecto.Migration

  def change do
    create table(:stacks) do
      add :key, :string
      add :hashed_secret_key, :string
      add :name, :string

      add :status, :string
      add :state_bucket, :string
      add :type, :string
      add :provider, :string
      add :nomad_address, :string
      add :consul_address, :string
      add :vault_address, :string
      add :use_vault, :boolean, default: false, null: false
      add :use_consul, :boolean, default: false, null: false
      add :server_count, :integer
      add :client_count, :integer
      add :max_clients, :integer
      add :consul_version, :string
      add :nomad_version, :string
      add :vault_version, :string
      add :region, :string

      timestamps()
    end

  end
end
