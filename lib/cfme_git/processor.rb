module CFMEGit
  class Processor
    attr_reader :repo, :branch

    MAX_COMMITS = 150

    def initialize(code_location, branch)
      @repo = Grit::Repo.new(code_location)
      @branch = branch
    end

    def commits
      repo.commits(branch, MAX_COMMITS).collect {|commit| Commit.new(commit, branch)}
    end
  end
end
