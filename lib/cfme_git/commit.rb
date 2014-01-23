module CFMEGit
  class Commit
    attr_reader :bz_ids, :grit_commit, :branch, :sha_id

    def initialize(grit_commit, branch)
      @grit_commit = grit_commit
      @branch = branch
      @bz_ids = []
      @sha_id = grit_commit.id
      extract_bz_ids
    end

    def extract_bz_ids
      grit_commit.message.each_line do |line|
        if line =~ /show_bug.cgi\?id=([0-9]+)/
          @bz_ids << $1
        end
      end
    end
  end
end