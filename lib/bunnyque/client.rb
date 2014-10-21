module Bunnyque
  module Workers
    class Client < Bunnyque::Worker
      include Bunnyque::Direct
    end
  end
end

