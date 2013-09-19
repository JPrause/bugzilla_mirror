require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Issue do

  context "#Issue.update_from_bz" do
    it "when bz output is found" do
      issue_out = Issue.update_from_bz
      puts "JJV issue_spec -010- issue_out ->#{issue_out.count("\n")}<-"
      issue_out.should include("BZ_ID:")
    end
  end

  context "#Issue.errata_report" do
    it "when issues table is populated" do
      need_acks, have_acks = Issue.errata_report
      puts "JJV issue_spec -020- need_acks ->#{need_acks}<-"
      puts "JJV issue_spec -021- have_acks ->#{have_acks}<-"
      need_acks.should include("BZ_ID:")
    end
  end

end
