defmodule Shortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :text, null: false
      add :hash, :text, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:links, :url)
    create unique_index(:links, :hash)
  end
end
