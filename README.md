# Logely

Human readable logging tool.

``` ruby
require 'logely'

$log = Logely.new do
  ok    :green
  error :red, :bold
end

$log.ok "Created file"
#=>     ok  Created file

$log.error "No such directory"
#=>  error  No such directory  
```

You can set the output, padding and gutter by passing them to `Logely.new` like:

``` ruby
$log = Logely.new $stdout, padding: 4, gutter: 1 do
  # ...
end
```

By default, when called, a logging method will write a new line. You can stop
this by creating the action with a `?` appended. These can then be overwritten
using a `!` method, or a new line can be forced by calling `#flush`. For
example,

``` ruby
$log = Logely.new do
  waiting? :grey
  success  :green
  error    :red
end

def some_long_process
  $log.waiting "for some_long_process"
  
  # ...
  
  if ok?
    $log.success! "some_long_proccess"
  else
    $log.error! "some_long_proccess"
  end
end

def another_proccess
  $log.waiting "..."
  $log.flush
  loop {}
end
```
