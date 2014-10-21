module Bunnyque
  module Direct
    extend ActiveSupport::Concern

    included do
      def exchange
        @exchange ||= channel.direct(queue_name)
      end

      def queue_name
        "#{`hostname`.chomp}.direct"
      end
    end
  end
end
