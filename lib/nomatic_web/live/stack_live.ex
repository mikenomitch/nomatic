defmodule NomaticWeb.StackLive do
  use NomaticWeb, :live_view

  alias Nomatic.Accounts
  alias Nomatic.Accounts.{LiveUpdates, Stack}

  @impl true
  def mount(_params, session, socket) do
    user_id = session |> Map.get("current_user") |> Map.get(:id)

    {:ok,
     assign(
       socket,
       %{stacks: stacks_for_user(user_id), user_id: user_id}
     )}
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
    |> assign(:stack, %Stack{
      user_id: socket.assigns.user_id
    })
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
     |> assign(:stacks, stacks_for_user(socket.assigns.user_id))}
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

  defp stacks_for_user(user_id) do
    Accounts.list_stacks_for_user(user_id)
  end
end
