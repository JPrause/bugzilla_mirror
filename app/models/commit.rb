class Commit < ActiveRecord::Base
  has_and_belongs_to_many :issues

  attr_accessible :branch, :sha_id

  def self.update_from_git!
    raise ArgumentError, "cfme git checkout not defined in config/cfme_bz.yml" unless cfme_git_configuration["repo_path"]
    raise ArgumentError, "cfme git releases not defined in config/cfme_bz.yml" unless cfme_git_configuration["releases"]
    self.destroy_all

    branches  = cfme_git_configuration["releases"].collect {|_, branches| branches}.flatten.uniq
    branches.each do |branch|
      update_git_branch(branch)
    end
  end

  def self.update_git_branch(branch)
    processor = CFMEGit::Processor.new(repo_path, branch)
    processor.commits.each do |commit|
      c = Commit.new(commit.attributes)
      c.issues = Issue.where(:bz_id => commit.bz_ids).all unless commit.bz_ids.empty?
      c.save!
    end
  end

  def self.repo_path
    cfme_git_configuration["repo_path"]
  end

  def self.cfme_git_configuration
    AppConfig["cfme_git"]
  end
end
