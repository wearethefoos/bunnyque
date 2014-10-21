module Bunnyque
  # Public: Base class for Bunnyque Masters and Workers
  class Base
    define_const_unless_defined :DEFAULT_CONFIG, {
      host: "rabbitmq.springest.io",
      port: 5672,
      queue: "springest.messages"
    }

    # Public: Base class for Bunnyque Masters and Workers.
    #
    # options - optional hash with options for the Bunnyque
    #           host  - the hostname to bind to / listen on.
    #                   Default: rabbitmq.springest.io
    #           port  - the port to bind to / listen on
    #                   Default: 5672
    #           queue - the queue to use
    #                   Default: springest.messages
    def initialize options={}
      @config = DEFAULT_CONFIG.merge options
    end

    def connection
      @connection ||= AMQP.connect bind_addr
    end

    def channel
      @channel ||=
        begin
          channel = AMQP::Channel.new(connection)
          channel.on_error do |ch, close|
            puts "Handling a channel-level exception on channel1: #{close.reply_text}, #{close.inspect}"
          end
          channel
        end
    end

    def exchange
      raise NotImplementedError.new
    end

    # This should be implemented in a Bunnyque Master.
    def publish
      raise NotImplementedError.new
    end

    # This should be implemented in a Bunnyque Worker.
    def listen
      raise NotImplementedError.new
    end

    protected

    def bind_addr
      "amqp://#{config[:host]}:#{config[:port]}"
    end

    def config
      @config || DEFAULT_CONFIG
    end

    def log message
      STDOUT.puts Time.now.strftime "[%c]: #{message}"
    end

    def log_file
      File.expand_path('../../../log/bunnyque.log', __FILE__)
    end
  end
end

