class Commit < ActiveRecord::Base
  include ApplicationHelper

  has_and_belongs_to_many :issues

  def self.update_from_git!
    raise ArgumentError, "repo_path not defined in config/bugzilla_mirror.yml" unless git_helper_configuration["repo_path"]

    raise ArgumentError, "releases not defined in config/bugzilla_mirror.yml" unless git_helper_configuration["releases"]

    destroy_all

    processor = GitHelper::Processor.new(repo_path)
    common_branches = processor.branch_names & release_branches
    common_branches.each do |branch|
      update_git_branch(processor, branch)
    end
  end

  def self.release_branches
    git_helper_configuration["releases"].values.flatten.compact.uniq
  end

  def self.update_git_branch(processor, branch)
    processor.commits(branch).each do |commit|
      c = Commit.new(commit.attributes)
      c.issues = Issue.where(:bug_id => commit.bug_ids).to_a unless commit.bug_ids.empty?
      c.save!
    end
  end

  def self.repo_path
    git_helper_configuration["repo_path"]
  end

  def self.git_helper_configuration
    app_config["git_helper"]
  end
end
