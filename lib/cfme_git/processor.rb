module CFMEGit
  class Processor
    attr_reader :repo, :branch

    def initialize(code_location, branch)
      @repo = Grit::Repo.new(code_location)
      @branch = branch
    end

    def commits_referencing_bz_urls
      grit_commits = repo.log(branch, nil, 'E' => true, 'grep' => "show_bug.cgi\\?id=[0-9]+")
      grit_commits.collect {|commit| Commit.new(commit, branch)}
    end
  end
end
