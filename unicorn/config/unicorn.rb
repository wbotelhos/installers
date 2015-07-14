worker_processes  4
working_directory '/var/www/{{site_name}}/current'

listen '/var/run/unicorn/unicorn.sock', backlog: 64

# listen 5000
# listen 5001
# listen 5002

pid         '/var/run/unicorn/unicorn.pid'
preload_app true
timeout     30

stderr_path '/var/log/unicorn/error.log'
stdout_path '/var/log/unicorn/out.log'

check_client_connection false

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
