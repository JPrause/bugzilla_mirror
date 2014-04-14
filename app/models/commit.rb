class Commit < ActiveRecord::Base
  include ApplicationHelper

  has_and_belongs_to_many :issues

  def self.update_from_git!
    raise ArgumentError, "repo_path not defined in config/cfme_bz.yml" unless cfme_git_configuration["repo_path"]

    raise ArgumentError, "releases not defined in config/cfme_bz.yml" unless cfme_git_configuration["releases"]

    destroy_all

    processor = CFMEGit::Processor.new(repo_path)
    common_branches = processor.branch_names & release_branches
    common_branches.each do |branch|
      update_git_branch(processor, branch)
    end
  end

  def self.release_branches
    cfme_git_configuration["releases"].values.flatten.compact.uniq
  end

  def self.update_git_branch(processor, branch)
    processor.commits(branch).each do |commit|
      c = Commit.new(commit.attributes)
      c.issues = Issue.where(:bug_id => commit.bug_ids).to_a unless commit.bug_ids.empty?
      c.save!
    end
  end

  def self.repo_path
    cfme_git_configuration["repo_path"]
  end

  def self.cfme_git_configuration
    app_config["cfme_git"]
  end
end
