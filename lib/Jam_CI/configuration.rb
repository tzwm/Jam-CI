require 'pathname'

module JamCI
  module Configuration
    attr_accessor :project_config_path

    ##
    # JamCI.configure do |config|
    #
    # end

    def configure
      yield self
    end

    def project_config_path
      @project_config_path || Pathname.new(File.dirname(__FILE__)) + ".." + "data/config/"
    end
  end
end
