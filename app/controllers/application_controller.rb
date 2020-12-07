#InstanceBase
class ApplicationController < ActionController::Base
    def index
        pool = Concurrent::FixedThreadPool.new 1
        1.times do
            pool.post do
                # binding.pry
                p InstanceBase
            end
        end
        pool.shutdown
        pool.wait_for_termination
        head :ok
    end
end
