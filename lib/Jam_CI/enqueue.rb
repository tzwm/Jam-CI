module JamCI
  class Enqueue
    
    def initialize
      @running = nil
      @queues = []
    end

    def addJob(payload)
      url = payload["repository"]["url"]
      branch = payload["ref"].split(/refs\/heads\//).last

      project = JamCI::Manager.findProject(url, branch)
      payload["name"] = project.name
      return if project.nil?

      task = JamCI::Task.new(payload)
      @queues.add(task)
    end

  end
end
