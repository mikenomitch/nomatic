defmodule NomaticWeb.StackLive.FormComponent do
  use NomaticWeb, :live_component

  alias Nomatic.Accounts

  @impl true
  def update(%{stack: stack} = assigns, socket) do
    changeset = Accounts.change_stack(stack)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"stack" => stack_params}, socket) do
    changeset =
      socket.assigns.stack
      |> Accounts.change_stack(stack_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"stack" => stack_params}, socket) do
    save_stack(socket, socket.assigns.action, stack_params)
  end

  defp save_stack(socket, :edit, stack_params) do
    case Accounts.update_stack(socket.assigns.stack, stack_params) do
      {:ok, _stack} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stack updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_stack(socket, :new, stack_params) do
    case Accounts.create_stack(stack_params) do
      {:ok, _stack} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stack created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
