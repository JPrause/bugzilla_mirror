module CFMEGit
  class Commit
    attr_reader :bz_ids, :rugged_commit, :branch, :sha_id

    BUG_URL_REGEX = %r{^\s*https://bugzilla\.redhat\.com/show_bug\.cgi\?id=(?<bug_id>\d+)$}

    def initialize(rugged_commit, branch)
      @rugged_commit = rugged_commit
      @branch = branch
      @bz_ids = []
      @sha_id = rugged_commit.oid
      extract_bz_ids
    end

    def attributes
      {
        :branch => branch,
        :sha_id => sha_id
      }
    end

    def extract_bz_ids
      rugged_commit.message.each_line do |line|
        match = BUG_URL_REGEX.match(line)
        @bz_ids << match[:bug_id] if match
      end
    end
  end
end