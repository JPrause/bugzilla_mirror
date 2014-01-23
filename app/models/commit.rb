class Commit < ActiveRecord::Base
  has_and_belongs_to_many :issues

  attr_accessible :branch, :sha_id

  def self.update_from_git!
    raise ArgumentError, "cfme git checkout not defined in config/cfme_bz.yml" unless AppConfig["cfme_git"]["repo_path"]
    raise ArgumentError,  "Error no password specified in config/cfme_bz.yml" unless AppConfig["bugzilla"]["password"]

    self.destroy_all

    branches  = AppConfig["cfme_git"]["releases"].collect {|_, branches| branches}.flatten.uniq

    repo_path = AppConfig["cfme_git"]["repo_path"]
    branches.each do |branch|
      CFMEGit::Processor.new(repo_path, branch).commits_referencing_bz_urls.each do |commit|
        issues = Issue.where(:bz_id => commit.bz_ids).all
        # attributes = commit.attributes.merge(:issues => issues)
        c = self.new(commit.attributes)
        c.issues = issues
        c.save!
      end
    end
  end

  def inspect
    "branch: #{branch}, sha_id: #{sha_id}\n"
  end
end