require "open3"


module JamCI
  class Shell
    
    def initialize(whiny = true)
      @whiny = whiny
    end

    def run(command)
      stdout, stderr, code = execute(command)

      case code
      when 1
        fail RuntimeError, "`#{command.join(" ")}` failed with error:\n#{stderr}"
      when 127
        fail RuntimeError, stderr
      end if @whiny

      $stderr.print(stderr)

      stdout
    end
    
    def execute(command)
      stdout, stderr, status = Open3.capture3(*command) 

      [stdout, stderr, status.exit_status]
    rescue Errno::ENOENT
      ["", "executable not found: \"#{command.first}\"", 127]
    end
  end
end
