defmodule Shortener.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :hash, :string
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  def validation_changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :hash])
    |> validate_required(:url)
    |> unique_constraint(:url)
  end

  def changeset(link, attrs) do
    link
    |> validation_changeset(attrs)
    |> validate_required(:hash)
    |> unique_constraint(:hash)
  end
end
