module CFMEGit
  class Processor
    attr_reader :repo

    MAX_COMMITS = 150

    def initialize(code_location)
      @repo = Rugged::Repository.new(code_location)
    end

    def branch_names
      @branch_names ||= repo.branches.collect(&:name)
    end

    def commits(branch)
      result = []
      repo.walk(branch).each_with_index do |native_commit, index|
        break if index >= MAX_COMMITS
        result << Commit.new(native_commit, branch)
      end
      result
    end
  end
end
