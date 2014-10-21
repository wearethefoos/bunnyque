%w(
  base
  direct
  broadcast
  master
  worker
  masters/broadcast_server
  masters/server
  workers/broadcast_worker
  workers/client
  version
).each do |lib|
  require File.expand_path("../bunnyque/#{lib}.rb", __FILE__)
end

module Bunnyque

  class <<self
    def broadcast object, params
      Bunnyque::Masters::BroadcastServer.new(host: config.host, port: config.port, queue: config.queue).publish object.to_s, params
    end

    def send node_name, object, params
      Bunnyque::Masters::Server.new(host: config.host, port: config.port, queue: node_name).publish object.to_s, params
    end

    def config
      @config ||
        begin
          Utilities::HashAsObject.new(
            Base::DEFAULT_CONFIG.merge(
              YAML.load(
                ERB.new(
                  File.read(
                    File.join(File.expand_path('../../config/bunnyque.yml', __FILE__)))).result
          )[defined?(Rails) ? Rails.env : (ENV['RAILS_ENV'] || 'development')]))
        end
    end
  end
end
