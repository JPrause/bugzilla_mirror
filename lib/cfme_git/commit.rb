module CFMEGit
  class Commit
    attr_reader :bz_ids, :grit_commit, :branch, :sha_id

    BUG_URL_REGEX = %r{^\s*https://bugzilla\.redhat\.com/show_bug\.cgi\?id=(?<bug_id>\d+)$}

    def initialize(grit_commit, branch)
      @grit_commit = grit_commit
      @branch = branch
      @bz_ids = []
      @sha_id = grit_commit.id
      extract_bz_ids
    end

    def attributes
      {
        :branch => branch,
        :sha_id => sha_id
      }
    end

    def extract_bz_ids
      grit_commit.message.each_line do |line|
        match = BUG_URL_REGEX.match(line)
        @bz_ids << match[:bug_id] if match
      end
    end
  end
end