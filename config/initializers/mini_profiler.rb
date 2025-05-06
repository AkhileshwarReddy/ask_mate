# config/initializers/mini_profiler.rb
if Rails.env.development?
    require 'rack-mini-profiler'
  
    # Mount the middleware
    Rack::MiniProfilerRails.initialize!(Rails.application)
  
    # Only inject into HTML responses (so your JSON stays clean)
    Rack::MiniProfiler.config.auto_inject = lambda do |env|
      env['HTTP_ACCEPT'] && env['HTTP_ACCEPT'].include?('text/html')
    end
  
    # Show the mini-profiler UI to any developer
    Rack::MiniProfiler.config.authorization_mode = :allow_all
  end
  