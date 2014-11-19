require 'yaml'

module JamCI
  class Manager
    def findProject(url, branch)
      Dir.glob(JamCI.config.project_config_path + "*.yml") do |file|
        config = YAML.load_file file
        if config.url == url && config.branch == branch
          return config
        end
      end

      return nil
    end

    def addProject(name, url, branch, push_or_pull)
      
    end
  end
end
