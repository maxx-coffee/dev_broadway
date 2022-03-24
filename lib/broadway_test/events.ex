defmodule Events do
  use GenServer

  # Callbacks

  def start_link(_) do
    GenServer.start_link(__MODULE__, :queue.new(), name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, :queue.new()}
  end

  @impl true
  def handle_cast({:add, event}, events) do
    {:noreply, :queue.in(event, events)}
  end

  def handle_call(:retrieve, _from, events) do
    with {item, events} <- :queue.out(events),
         {:value, event} <- item do
      {:reply, [event], events}
    else
      _ -> {:reply, [], events}
    end
  end

  def get_event() do
    GenServer.call(__MODULE__, :retrieve)
  end

  def add(event) do
    GenServer.cast(__MODULE__, {:add, event})
  end
end
