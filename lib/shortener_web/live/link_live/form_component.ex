defmodule ShortenerWeb.LinkLive.FormComponent do
  use ShortenerWeb, :live_component

  import ShortenerWeb.LinkHelpers

  alias Shortener.Links
  alias Shortener.Links.Link

  @impl true
  def update(_assigns, socket) do
    {:ok, socket |> reset_form()}
  end

  @impl true
  def handle_event("validate", %{"link" => link_params}, socket) do
    changeset =
      %Link{}
      |> Links.change_link(link_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("new-link", _, socket) do
    {:noreply, socket |> reset_form()}
  end

  @impl true
  def handle_event("save", %{"link" => link_params}, socket) do
    case Links.get_or_create_link_by(link_params) do
      {:ok, link} ->
        Links.broadcast(:updated, link)
        {:noreply, socket |> assign(:link, link)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(:changeset, changeset)}

      {:error, :no_more_attempts} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error. Try again later")
         |> push_redirect(to: "/")}
    end
  end

  defp reset_form(socket) do
    socket |> assign(%{changeset: Links.change_link(%Link{}), link: nil})
  end
end
