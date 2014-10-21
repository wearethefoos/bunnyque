module Bunnyque
  module Masters
    class Server < Bunnyque::Master
      include Bunnyque::Direct
    end
  end
end

