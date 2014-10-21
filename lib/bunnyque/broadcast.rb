module Bunnyque
  module Broadcast
    extend ActiveSupport::Concern

    included do
      def exchange
        @exchange ||= channel.fanout(queue_name)
      end

      def queue_name
        "#{config[:queue]}.fanout"
      end
    end
  end
end
