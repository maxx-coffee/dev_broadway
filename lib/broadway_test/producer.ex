defmodule Producer do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Counter, 1},
        transformer: {__MODULE__, :transform, []}
      ],
      processors: [
        default: [concurrency: 1]
      ],
      batchers: [
        default: [concurrency: 10, batch_size: 5]
      ]
    )
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def handle_message(_, message, _) do
    IO.inspect(message, label: "messages")
  end

  def handle_batch(_, messages, _batch_info, _context) do
    IO.inspect(messages, label: "batch")
  end

  def ack(:ack_id, successful, failed) do
    # Write ack code here
  end
end
