require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Issue do

  context "#update_from_bz" do

    it "with no bugzilla query output" do
      RubyBugzilla.stub(:login!).and_return(true)
      RubyBugzilla.stub(:query).and_return(["",""])
      Issue.update_from_bz
      Issue.order(:id).last.nil?.should == true
    end

    it "with valid bugzilla query output" do
      output = "BZ_ID: P30 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      output << "SUMMARY: Test Data SUMMARY_END "
      output << "BUG_STATUS: TEST BUG_STATUS_END "
      output << "VERSION: now VERSION_END "
      output << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      output << "KEYWORDS: stone KEYWORDS_END"

      RubyBugzilla.stub(:login!).and_return(true)
      RubyBugzilla.stub(:query).and_return(["",output])
      Issue.update_from_bz
      Issue.order(:id).last.bz_id.should == "P30"
    end

    it "with invalid bugzilla query flags output" do
      output = "BZ_ID: 02032003 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      output << "SUMMARY: Test Data SUMMARY_END "
      output << "BUG_STATUS: TEST BUG_STATUS_END "
      output << "VERSION: now VERSION_END "
      output << "FLAGS: flake FLAGS_END "
      output << "KEYWORDS: stone KEYWORDS_END"

      RubyBugzilla.stub(:login!).and_return(true)
      RubyBugzilla.stub(:query).and_return(["",output])
      Issue.update_from_bz
      Issue.order(:id).last.bz_id.should == "02032003"
      Issue.order(:id).last.pm_ack.should == "+"
      Issue.order(:id).last.devel_ack.should == "+"
      Issue.order(:id).last.qa_ack.should == "+"
      Issue.order(:id).last.doc_ack.should == "+"
    end
  end

  context "#get_from_flags" do

    it "with valid pm flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END bla "
      Issue.get_from_flags(flags, /pm_ack/).should == ["pm_ack", "+"]
    end

    it "with valid devel flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END bla "
      Issue.get_from_flags(flags, /devel_ack/).should == ["devel_ack", "?"]
    end

    it "with valid qa flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,qa_ack-,devel_ack?,qa_ack? FLAGS_END bla "
      Issue.get_from_flags(flags, /qa_ack/).should == ["qa_ack", "-"]
    end

    it "with no doc flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      Issue.get_from_flags(flags, /doc_ack/).should == ["NONE", "+"]
    end

    it "with no pm flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,zz_ack+,devel_ack?,qa_ack? FLAGS_END "
      Issue.get_from_flags(flags, /doc_ack/).should == ["NONE", "+"]
    end

    it "with valid devel flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,pm_ack+,none_ack?,qa_ack? FLAGS_END "
      Issue.get_from_flags(flags, /devel_ack/).should == ["NONE", "+"]
    end

    it "when no regex match is found" do
      flags = "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      Issue.get_from_flags(flags, /none/).should == ["NONE", "+"]
    end

    it "when FLAGS token is invalid" do
      flags = "snaAGS: cfme-5.2?,pm_ack+,none_ack?,qa_ack? snaGS_END "
      Issue.get_from_flags(flags, /devel_ack/).should == ["NONE", "+"]
    end

    it "with no flags" do
      flags = ""
      Issue.get_from_flags(flags, /devel_ack/).should == ["NONE", "+"]
    end
  end

  context "#get_token_values" do

    it "when BZ_ID token is found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      Issue.get_token_values(source_str, "BZ_ID").should == ["R19"]
    end

    it "when ASSIGNED_TO token is found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      Issue.get_token_values(source_str, "ASSIGNED_TO").should == ["calvin@hobbes.comic"]
    end

    it "when SUMMARY token is found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      Issue.get_token_values(source_str, "SUMMARY").should == ["Test Data"]
    end

    it "when BUG_STATUS token is found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      Issue.get_token_values(source_str, "BUG_STATUS").should == ["TEST"]
    end

    it "when token is found at the end of a valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      Issue.get_token_values(source_str, "KEYWORDS").should == ["stone"]
    end

    it "when token is not found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      Issue.get_token_values(source_str, "NOT_FOUND").should == []
    end

    it "when source string is empty" do
      source_str = ""
      Issue.get_token_values(source_str, "NOT_FOUND").should == []
    end

    it "when token is empty" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      Issue.get_token_values(source_str, "").should == []
    end

    it "when token is nil" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      Issue.get_token_values(source_str, "").should == []
    end

  end

  context "#recreate_all_issues" do

    it "with no bugzilla query output" do
      Issue.recreate_all_issues("")
      Issue.order(:id).last.nil?.should == true
    end

    it "with valid bugzilla query output" do

      output = "BZ_ID: 221906 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      output << "SUMMARY: Test Data SUMMARY_END "
      output << "BUG_STATUS: TEST BUG_STATUS_END "
      output << "VERSION: now VERSION_END "
      output << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      output << "KEYWORDS: stone KEYWORDS_END"

      Issue.recreate_all_issues(output)
      Issue.order(:id).last.bz_id.should == "221906"
    end

    it "with invalid bugzilla query flags output" do

      output = "BZ_ID: 10012003 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      output << "SUMMARY: Test Data SUMMARY_END "
      output << "BUG_STATUS: TEST BUG_STATUS_END "
      output << "VERSION: now VERSION_END "
      output << "FLAGS: flake FLAGS_END "
      output << "KEYWORDS: stone KEYWORDS_END"

      Issue.recreate_all_issues(output)
      Issue.order(:id).last.bz_id.should == "10012003"
      Issue.order(:id).last.pm_ack.should == "+"
      Issue.order(:id).last.devel_ack.should == "+"
      Issue.order(:id).last.qa_ack.should == "+"
      Issue.order(:id).last.doc_ack.should == "+"
    end
  end

end
