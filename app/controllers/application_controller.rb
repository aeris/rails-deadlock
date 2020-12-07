class ApplicationController < ActionController::Base
    def index
        pool = Concurrent::FixedThreadPool.new 5
        10.times do
            pool.post do
                binding.pry
                p InstanceBase::SLUG_FORMAT
            end
        end
        pool.shutdown
        pool.wait_for_termination
        head :ok
    end
end
