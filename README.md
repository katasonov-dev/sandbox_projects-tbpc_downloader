# tbpc_downloader a.k.a “The Big Picture Corp" downloader

Simple downloader of images (and potentially not only images) operated by `Rake`

# Setup

This project requires `ruby 3.2.2`

For RVM users:

```
rvm instal 3.2.2
```

Gemfile is included, so it's quite easy to setup all required dependencies:
```
cd <project_name>
bundle install
```

**Please note** `Sidekiq` of this version (7.1.2) requires `Redis` 6.0+. Please update if you have an older version. To check `Redis` version type:
```
redis-server --version
```

If you need an update as a Mac/Brew user you could use this command:
```
brew upgrade redis
brew services restart redis
# or
ps aux | grep redis
# and then 
sudo -9 kill <redis_pid>
redis-server --daemonize yes
```

Once you are ready with `Redis` setup you will have to launch `Sidekiq` + `Redis` in this case project contains `Procfile`. Just type:
```
bundle exec foreman start
```

This command will launch `Redis` and `Sidekiq` servers within single terminal session

# Use

```
rake 'download:images[<path_to_file>]'
```

You will have to specify the file path as an argument for the rake task.
The file have to be a plain text file. URLs in this file should be separated with commas(`,`), whitespaces or newlines

Example:

Valid:
```
https://example1.com http://example2.com https://example3.com http://example4.com

```

Also valid:

```
https://example1.com, http://example2.com, https://example3.com, http://example4.com
```

Invalid:

```
https://example1.com - http://example2.com - https://example3.com - http://example4.com
```

# Test

Testing is powered by `RSpec`. To run suite:

```
bundle exec rspec spec/
```

# Debugging

Logging is provided by `Logger` and you could find `log.txt` in the root directory once something will be logged

That's it. Have fun!
