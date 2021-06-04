defmodule NomaticWeb.StackLive do
  use NomaticWeb, :live_view

  alias Nomatic.Accounts
  alias Nomatic.Accounts.{LiveUpdates, Stack}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :stacks, list_stacks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    LiveUpdates.subscribe_live_view("stacks")

    stack = Accounts.get_stack!(id)

    socket
    |> assign(:page_title, "Stack")
    |> assign(:stack, stack)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Stack")
    |> assign(:stack, Accounts.get_stack!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Stack")
    |> assign(:stack, %Stack{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stacks")
    |> assign(:stack, nil)
  end

  @impl true
  @spec handle_event(<<_::48, _::_*8>>, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("delete", %{"id" => id}, socket) do
    stack = Accounts.get_stack!(id)
    {:ok, _} = Accounts.deprovision_stack(stack)

    {:noreply,
     socket
     |> put_flash(:info, "Deprovisioning Stack")
     |> assign(:stacks, list_stacks())}
  end

  def handle_event("go-to-new", _params, socket) do
    {:noreply, push_redirect(socket, to: "/stacks/new")}
  end

  def handle_event("go-to-show", %{"id" => id}, socket) do
    {:noreply, push_redirect(socket, to: "/stacks/#{id}")}
  end

  def handle_info("updated", socket) do
    stack = Accounts.get_stack!(socket.assigns.stack.id)
    {:noreply, assign(socket, :stack, stack)}
  end

  defp list_stacks do
    Accounts.list_stacks()
  end
end
