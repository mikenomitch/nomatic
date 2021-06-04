defmodule Nomatic.Accounts.LiveUpdates do
  @topic inspect(__MODULE__)

  def subscribe_live_view(topic_name) do
    Phoenix.PubSub.subscribe(Nomatic.PubSub, topic(topic_name), link: true)
  end

  def notify_live_view(topic_name, message) do
    Phoenix.PubSub.broadcast(Nomatic.PubSub, topic(topic_name), message)
  end

  defp topic, do: @topic
  defp topic(topic_name), do: topic() <> to_string(topic_name)
end
