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
      described_class.stub(:cfme_git_configuration => @config)

      CFMEGit::Processor.any_instance.stub(:branch_names => ["5_2_release"])
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
        described_class.stub(:cfme_git_configuration => @config)
        CFMEGit::Processor.any_instance.stub(:branch_names => %w(5_2_release 5_3_release))
      end

      it "normal case" do
        double1 = double(:attributes => {}, :bz_ids => [])

        CFMEGit::Processor.any_instance.stub(:commits => [double1])

        expect { described_class.update_from_git! }.to change{ Commit.count }.by(2)
      end

      #TODO: Should we really create two commits with the same sha1?
      it "the same commit sha1 is on two branches" do
        double1 = double(:attributes => {:branch => "one", :sha_id => "123"}, :bz_ids => [])
        double2 = double(:attributes => {:branch => "two", :sha_id => "123"}, :bz_ids => [])

        CFMEGit::Processor.any_instance.stub(:commits => [double1])

        expect { described_class.update_from_git! }.to change{ Commit.count }.by(2)
      end
    end

    it "two commits referencing one issue" do
      issue1   = Issue.create(:bz_id => 1000)
      double1 = double(:attributes => {}, :bz_ids => [1000])
      double2 = double(:attributes => {}, :bz_ids => [1000])

      CFMEGit::Processor.any_instance.stub(:commits => [double1, double2])
      described_class.update_from_git!

      described_class.count.should == 2

      commits = described_class.all
      commits[0].issues.should == [issue1]
      commits[1].issues.should == [issue1]
    end

    it "one commit referencing multiple issues" do
      issue1   = Issue.create(:bz_id => 1000)
      issue2   = Issue.create(:bz_id => 2000)
      double1  = double(:attributes => {}, :bz_ids => [1000, 2000])

      CFMEGit::Processor.any_instance.stub(:commits => [double1])
      described_class.update_from_git!

      described_class.count.should == 1
      commit = described_class.first

      issue1.commits.should == [commit]
      issue2.commits.should == [commit]
    end
  end
end
