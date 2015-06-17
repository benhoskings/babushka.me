worker_processes 4
working_directory '.'

preload_app true
timeout 60

listen "/home/babushka/current/tmp/sockets/unicorn.socket", :backlog => 64
pid "/home/babushka/current/tmp/pids/unicorn.pid"
stderr_path "/home/babushka/current/log/unicorn.stderr.log"
stdout_path "/home/babushka/current/log/unicorn.stdout.log"

before_fork do |server, worker|
  begin
    old_pid = File.read("#{server.pid}.oldbin").to_i
    STDERR.puts "[worker #{worker.nr}] sending SIGQUIT to #{old_pid}"
    Process.kill("QUIT", old_pid)
  rescue Errno::ENOENT
    STDERR.puts "[worker #{worker.nr}] no old master running."
  rescue Errno::ESRCH
    STDERR.puts "[worker #{worker.nr}] #{old_pid} was already gone."
  end
  # ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # ActiveRecord::Base.establish_connection
end
