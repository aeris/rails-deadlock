#!./bin/rails runner
pool = Concurrent::FixedThreadPool.new 5
10.times do
    pool.post do
        p InstanceBase
    end
end
pool.shutdown
pool.wait_for_termination
