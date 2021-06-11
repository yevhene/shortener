defmodule Shortener.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false

  alias Phoenix.PubSub
  alias Shortener.Links.Link
  alias Shortener.Repo

  @hash_size 8
  @attempts 5
  @topic "links"

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
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link_by_hash!(hash), do: Repo.get_by!(Link, hash: hash)

  @doc """
  Returns existing link for an url or creates new.

  ## Examples

      iex> get_or_create_link_by(%{field: value})
      {:ok, %Link{}}

      iex> get_or_create_link_by(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def get_or_create_link_by(%{"url" => url} = link_params) do
    case Repo.get_by(Link, url: url) do
      %Link{} = link -> {:ok, link}
      _ -> generate_hash_and_create_link(link_params)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.validation_changeset(link, attrs)
  end

  @doc """
  Subscribes for links updates.

  ## Examples

      iex> subscribe()

  """
  def subscribe do
    PubSub.subscribe(Shortener.PubSub, @topic)
  end

  @doc """
  Broadcasts links updates.

  ## Examples

      iex> broadcast(:update)

  """
  def broadcast(event, payload \\ %{}) do
    PubSub.broadcast(Shortener.PubSub, @topic, {{:links, event}, payload})
  end

  defp generate_hash_and_create_link(attrs, attempt \\ 0) do
    link_attrs = Map.put(attrs, "hash", generate_hash(@hash_size))

    case create_link(link_attrs) do
      {:ok, link} ->
        {:ok, link}

      {:error, %Ecto.Changeset{} = changeset} ->
        cond do
          has_no_more_attempts?(attempt) ->
            {:error, :no_more_attempts}

          hash_is_not_unique?(changeset) ->
            generate_hash_and_create_link(attrs, attempt + 1)

          true ->
            {:error, changeset}
        end
    end
  end

  defp has_no_more_attempts?(attempt) do
    attempt + 1 >= @attempts
  end

  defp hash_is_not_unique?(%Ecto.Changeset{} = changeset) do
    case changeset.errors[:hash] do
      {_, [constraint: :unique, constraint_name: _]} -> true
      _ -> false
    end
  end

  defp create_link(attrs) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  defp generate_hash(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  defp paginate(query, current_page, per_page) do
    from query,
      offset: ^((current_page - 1) * per_page),
      limit: ^per_page
  end
end
