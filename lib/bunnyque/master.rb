module Bunnyque
  # Public: Base class for Bunnyque Masters and Workers
  class Master < Base
    def publish klass, *params
      EventMachine.run do
        payload = prepare_payload klass, params
        exchange.publish(payload) do
          connection.disconnect { EventMachine.stop }
        end
        log "Published payload #{payload} to #{queue_name}"
      end
    end

    protected

    def prepare_payload klass, params
      {
        class: klass,
        params: params
      }.to_json
    end
  end
end

