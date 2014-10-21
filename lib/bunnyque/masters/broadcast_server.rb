module Bunnyque
  module Masters
    class BroadcastServer < Bunnyque::Master
      include Bunnyque::Broadcast
    end
  end
end

