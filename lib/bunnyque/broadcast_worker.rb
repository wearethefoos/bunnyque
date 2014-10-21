module Bunnyque
  module Workers
    class BroadcastWorker < Bunnyque::Worker
      include Bunnyque::Broadcast
    end
  end
end

