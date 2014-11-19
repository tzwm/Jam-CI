class Task
  @output = "====Begin====\n"

  def initialize(payload)
    @url = payload["repository"]["url"]
    @branch = payload["ref"].split(/refs\/heads\//).last
    @commits = payload["commits"]
    @head_commit = payload["head_commit"]
  end

  def run
  end

  def enterDir

  end 
end
