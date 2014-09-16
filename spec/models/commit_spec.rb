require 'spec_helper'

describe Commit do
  context ".update_from_git!" do
    before do
      @config = {
        "repo_path" => "/some_path",
        "releases"  => {
          "cfme-5.2.z" => ["5_2_release"]
        }
      }
      described_class.stub(:git_helper_configuration => @config)

      GitHelper::Processor.any_instance.stub(:branch_names => ["5_2_release"])
      Rugged::Repository.stub(:new)
    end

    context "two branches" do
      before do
        @config = {
          "repo_path" => "/some_path",
          "releases"  => {
            "cfme-5.2.z" => ["5_2_release"],
            "cfme-5.3"   => ["5_3_release"]
          }
        }
        described_class.stub(:git_helper_configuration => @config)
        GitHelper::Processor.any_instance.stub(:branch_names => %w(5_2_release 5_3_release))
      end

      it "normal case" do
        double1 = double(:attributes => {}, :bz_ids => [])

        GitHelper::Processor.any_instance.stub(:commits => [double1])

        expect { described_class.update_from_git! }.to change { Commit.count }.by(2)
      end

      # TODO: Should we really create two commits with the same sha1?
      it "the same commit sha1 is on two branches" do
        double1 = double(:attributes => {:branch => "one", :sha_id => "123"}, :bz_ids => [])
        double(:attributes => {:branch => "two", :sha_id => "123"}, :bz_ids => [])

        GitHelper::Processor.any_instance.stub(:commits => [double1])

        expect { described_class.update_from_git! }.to change { Commit.count }.by(2)
      end
    end

    it "two commits referencing one issue" do
      issue1   = Issue.create(:bz_id => 1000)
      double1 = double(:attributes => {}, :bz_ids => [1000])
      double2 = double(:attributes => {}, :bz_ids => [1000])

      GitHelper::Processor.any_instance.stub(:commits => [double1, double2])
      described_class.update_from_git!

      expect(described_class.count).to eq 2

      commits = described_class.all
      expect(commits[0].issues).to eq [issue1]
      expect(commits[1].issues).to eq [issue1]
    end

    it "one commit referencing multiple issues" do
      issue1   = Issue.create(:bz_id => 1000)
      issue2   = Issue.create(:bz_id => 2000)
      double1  = double(:attributes => {}, :bz_ids => [1000, 2000])

      GitHelper::Processor.any_instance.stub(:commits => [double1])
      described_class.update_from_git!

      expect(described_class.count).to eq 1
      commit = described_class.first

      expect(issue1.commits).to eq [commit]
      expect(issue2.commits).to eq [commit]
    end
  end
end
