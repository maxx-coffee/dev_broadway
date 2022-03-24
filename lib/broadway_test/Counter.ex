defmodule Counter do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(_args) do
    {:producer, 0}
  end

  def handle_info(:get_messages, demand) do
    messages = Events.get_event()

    new_demand =
      cond do
        messages |> length() === 0 ->
          demand + 1

        true ->
          demand
      end

    IO.inspect(messages |> length())

    cond do
      new_demand == 0 ->
        :ok

      messages |> length() == 0 ->
        Process.send_after(self(), :get_messages, 1000)

      true ->
        Process.send(self(), :get_messages, [])
    end

    {:noreply, messages, new_demand}
  end

  @spec handle_demand(number, {any, number}) :: {:noreply, [], {any, number}}
  def handle_demand(incoming_demand, 0) do
    Process.send(self(), :get_messages, [])

    {:noreply, [], incoming_demand}
  end

  def handle_demand(incoming_demand, demand) do
    new_demand = demand + incoming_demand

    {:noreply, [], new_demand}
  end
end
