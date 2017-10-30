# Log Weasel

Prepend transaction IDs to logs in order to trace execution of a unit of work across
applications and application instances.

## Installation

Add log_weasel to your Gemfile:

```ruby
gem "schwifty_logger", git: "git@github.com:restorando/schwifty_logger.git", branch: "master"
```

Use bundler to install it:

```ruby
bundle install
```

## Usage

1. Configure
```ruby
LogWeasel.configure do |config|
  config.enabled = true
  # Any other options, see Configuration section
end
```

2. You're done! We use a Railtie that automatically adds the a Rack middleware if Log Weasel is enabled (see step #1)


## Configuration

Valid configuration options are:

- `enabled`
  - Whether Log Weasel is enabled or not. Default is `false`.
- `header_name`
  - HTTP header name under which transaction IDs will be read and written. Default is `X_TRANSACTION_ID`.
- `id_generator`
  - Block, method or lambda to generate new transaction IDs. Default is `lambda { SecureRandom.hex(10) }`
- `generate_id_if_missing`
  - Whether to generate a new transaction ID if no ID is read from HTTP headers. Default is `true`.


## Example

### TODO, this example is from the original repo and is partially obsolete

In this example we have a Rails app pushing jobs to Resque and a Resque worker that run with the Rails environment loaded.

### HelloController

<pre>
class HelloController &lt; ApplicationController

  def index
    Resque.enqueue EchoJob, 'hello from HelloController'
    Rails.logger.info("HelloController#index: pushed EchoJob")
  end

end
</pre>

### EchoJob

<pre>
class EchoJob
  @queue = :default_queue

  def self.perform(args)
    Rails.logger.info("EchoJob.perform: #{args.inspect}")
  end
end
</pre>

Start Resque with:

<pre>
QUEUE=default_queue rake resque:work VERBOSE=1
</pre>

Requesting <code>http://localhost:3030/hello/index</code>, our development log shows:

<pre>
[2011-02-14 14:37:42] YOUR_APP-WEB-192587b585fa66b19638 48353 INFO

Started GET "/hello/index" for 127.0.0.1 at 2011-02-14 14:37:42 -0800
[2011-02-14 14:37:42] YOUR_APP-WEB-192587b585fa66b19638 48353 INFO   Processing by HelloController#index as HTML
[2011-02-14 14:37:42] YOUR_APP-WEB-192587b585fa66b19638 48353 INFO HelloController#index: pushed EchoJob
[2011-02-14 14:37:42] YOUR_APP-WEB-192587b585fa66b19638 48353 INFO Rendered hello/index.html.erb within layouts/application (1.8ms)
[2011-02-14 14:37:42] YOUR_APP-WEB-192587b585fa66b19638 48353 INFO Completed 200 OK in 14ms (Views: 6.4ms | ActiveRecord: 0.0ms)
[2011-02-14 14:37:45] YOUR_APP-WEB-192587b585fa66b19638 48461 INFO EchoJob.perform: "hello from HelloController"
</pre>

Fire up a Rails console and push a job directly with:

<pre>
> Resque.enqueue EchoJob, 'hi from Rails console'
</pre>

and our development log shows:

<pre>
[2011-02-14 14:37:10] YOUR_APP-RESQUE-a8e54bfb76718d09f8ed 48453 INFO EchoJob.perform: "hi from Rails console"
</pre>

and our resque log shows:

<pre>
***  got: (Job{default_queue} | EchoJob | ["hello from HelloController"] | {"log_weasel_id"=>"SAMPLE_APP-WEB-a65e45476ff2f5720e23"})
***  Running after_fork hook with [(Job{default_queue} | EchoJob | ["hello from HelloController"] | {"log_weasel_id"=>"SAMPLE_APP-WEB-a65e45476ff2f5720e23"})]
*** SAMPLE_APP-WEB-a65e45476ff2f5720e23 done: (Job{default_queue} | EchoJob | ["hello from HelloController"] | {"log_weasel_id"=>"SAMPLE_APP-WEB-a65e45476ff2f5720e23"})

***  got: (Job{default_queue} | EchoJob | ["hi from Rails console"] | {"log_weasel_id"=>"SAMPLE_APP-RESQUE-00919a012476121cf89c"})
***  Running after_fork hook with [(Job{default_queue} | EchoJob | ["hi from Rails console"] | {"log_weasel_id"=>"SAMPLE_APP-RESQUE-00919a012476121cf89c"})]
*** SAMPLE_APP-RESQUE-00919a012476121cf89c done: (Job{default_queue} | EchoJob | ["hi from Rails console"] | {"log_weasel_id"=>"SAMPLE_APP-RESQUE-00919a012476121cf89c"})
</pre>

Units of work initiated from Resque, for example if using a scheduler like
<a href="https://github.com/bvandenbos/resque-scheduler">resque-scheduler</a>,
will include 'RESQUE' in the transaction ID to indicate that the work started in Resque.


## Original Authors

<a href="http://github.com/asalant">Alon Salant</a> and <a href="http://github.com/brettfishman">Brett Fishman</a>.

## LICENSE

Copyright (c) 2011 Carbon Five. See LICENSE for details.
