This project is damn small and standard, but got a deadlock when accessing `/` route.

Just start the server (`rails s`) and try to access `/` (`http http://localhost:3000`).
It will just hang forever, no way to stop the server anymore (`ctrl-c` not working, only `kill -9` works)
The culprit line is `app/controllers/application_controller.rb#7`

app/models/instance_base.rb
```
module InstanceBase
end
```

app/controllers/application_controller.rb
```
class ApplicationController < ActionController::Base
    def index
        pool = Concurrent::FixedThreadPool.new 1
        1.times do
            pool.post do
                p InstanceBase # Hang here
            end
        end
        pool.shutdown
        pool.wait_for_termination
        head :ok
    end
end
```

If commenting the thread pool (lines 5 & 7), it works…
Same thread pooled code works directly on a script (see `bin/crashtest.rb`)

Seems the trouble is on the rails class loader, forcing preload of `InstanceBase` outside the thread pool restore a good behavior.
