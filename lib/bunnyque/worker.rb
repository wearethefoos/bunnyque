module Bunnyque
  # Public: Base class for Bunnyque Workers
  class Worker < Base
    def initialize name, options={}
      @name = name.chomp
      super(options)
    end

    def start options={}, &blk
      if File.exist?(pid_path)
        existing_pid = IO.read(pid_path).to_i
        begin
          Process.kill(0, existing_pid)
          raise "Worker is already running with PID #{existing_pid}"
        rescue Errno::ESRCH
          log "Removing stale PID file at #{pid_path}"
          FileUtils.rm(pid_path)
        end
      end
      pid = fork do
        Process.setsid
        STDIN.reopen('/dev/null')
        STDOUT.reopen(log_file, 'a')
        STDOUT.sync = true
        STDERR.reopen(STDOUT)
        listen &blk
      end
      FileUtils.mkdir_p(pid_dir)
      File.open(pid_path, 'w') do |file|
        file << pid
      end
      log "Worker '#{name}' started with PID #{pid}"
    end

    def restart &blk
      begin
        stop
      rescue
      ensure
        start &blk
      end
    end

    def stop
      if File.exist?(pid_path)
        pid = IO.read(pid_path).to_i
        begin
          Process.kill('TERM', pid)
        rescue Errno::ESRCH
          raise "Process with PID #{pid} is no longer running"
        ensure
          FileUtils.rm(pid_path)
        end
      else
        raise "No PID file at #{pid_path}"
      end
    end

    def listen(&blk)
      EventMachine.run do
        queue.bind(exchange).subscribe do |payload|
          log "#{name} received #{payload}"
          if block_given?
            blk.call(payload)
          else
            work payload
          end
        end
        log "#{name} is now listening on #{queue_name}"
      end
    end

    def name
      @name || ""
    end

    def queue
      @queue ||= channel.queue!(name, durable: true)
    end

    protected

    def work payload
      log "#{name} is working on #{payload}"
      parcel = JSON.parse payload
      begin
        parcel["class"].constantize.send :perform, parcel["params"]
      rescue => e
        log "#{name} choked on #{payload} with error #{e}"
      end
      log "#{name} is idle after working on #{payload}"
    end

    def pid_dir
      File.expand_path('../../../tmp/pids', __FILE__)
    end

    def pid_path
      File.join(pid_dir, "rabbit-worker-#{name}.pid")
    end
  end
end

