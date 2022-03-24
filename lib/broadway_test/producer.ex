defmodule Producer do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Counter, 1},
        transformer: {__MODULE__, :transform, []},
        rate_limiting: [
          allowed_messages: 60,
          interval: 5_000
        ]
      ],
      processors: [
        default: [concurrency: 1]
      ],
      batchers: [
        default: [concurrency: 2, batch_size: 5]
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
    IO.inspect(message)
  end

  def handle_batch(_, messages, _batch_info, _context) do
    IO.inspect(messages)
  end

  def ack(:ack_id, successful, failed) do
    # Write ack code here
  end
end
