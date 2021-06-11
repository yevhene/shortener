defmodule Shortener.Services do
  @moduledoc """
  The Services context.
  """

  import Ecto.Query, warn: false
  alias Shortener.Repo

  alias Shortener.Services.Link

  @doc """
  Returns paginated list of links.

  ## Examples

      iex> list_links(1, 10)
      [%Link{}, ...]

  """
  def list_links(current_page, per_page) do
    Link
    |> paginate(current_page, per_page)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  defp paginate(query, current_page, per_page) do
    from query,
      offset: ^((current_page - 1) * per_page),
      limit: ^per_page
  end
end
