# Sidekiq::Promise

`Sidekiq::Promise` turns Sidekiq workers into asynchronous promises using
[MrDarcy](https://github.com/jamesotron/MrDarcy).

[![Build Status](https://travis-ci.org/jamesotron/sidekick-promise.svg?branch=master)](https://travis-ci.org/jamesotron/sidekick-promise)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-promise'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-promise

## Usage

In your worker classes, you can now simply include `Sidekiq::Promise`:

```ruby
class HardWorker
  include Sidekiq::Promise

  def perform(name, count)
    puts 'Doing hard work'
  end
end
```

In your controller or model you can call: `HardWorker.as_promise`

```ruby
HardWorker.as_promise('bob', 5)
```

This will return a promise which will not resolve until the job is successfully
completed.

*WARNING* `Sidekiq::Promise` disables retries, so your job, if it fails will
reject it's promise and Sidekiq will not retry it.

### Why promises you say?

Because promises have [amazing chaining properties](https://github.com/jamesotron/MrDarcy#key-points-to-know-about-promises)
you can use them to build interesting and complicated workflows, eg:

```ruby
class ProcessWorker
  include Sidekiq::Promise

  def perform file_to_process
    UnzipWorker.as_promise(file_to_process).then do |dir|
      MrDarcy.all_promises do
        dir.entries.map do |file|
          ImageThumbnailWorker.as_promise(file)
        end
      end
    end.then do
      UserNotificationMailer.all_images_processed
    end
  end
end
```

In the above case, we use a worker to unzip a file full of images, then when
unzipped it simultaneously resizes all the images to thumbnail size, then
notifies the user that the processing is complete.

## Contributing

1. Fork it ( https://github.com/jamesotron/sidekiq-promise/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
