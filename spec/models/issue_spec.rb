require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Issue do

  context "#update_from_bz" do

    it "with no username specified" do
      stub_const("APP_CONFIG", "bugzilla" => {"password" => "hobbes"})
      expect { Issue.update_from_bz }.to raise_error(RuntimeError,
                                                     "Error no username specified in config/cfme_bz.yml")
    end

    it "with no password specified" do
      stub_const("APP_CONFIG", "bugzilla" => {"username" => "calvin"})
      expect { Issue.update_from_bz }.to raise_error(RuntimeError,
                                                     "Error no password specified in config/cfme_bz.yml")
    end

    it "with no bugzilla query output" do
      stub_const("APP_CONFIG", "bugzilla" => {"username" => "calvin", "password" => "hobbes"})
      allow(RubyBugzilla).to receive(:new).and_return(double('bugzilla', :query => ""))
      Issue.update_from_bz
      expect(Issue.order(:id).last.nil?).to eq  true
    end

    it "with valid bugzilla query output" do
      output = "BZ_ID: P30 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      output << "SUMMARY: Test Data SUMMARY_END "
      output << "BUG_STATUS: TEST BUG_STATUS_END "
      output << "VERSION: now VERSION_END "
      output << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      output << "KEYWORDS: stone KEYWORDS_END"

      stub_const("APP_CONFIG", "bugzilla" => {"username" => "calvin", "password" => "hobbes"})
      allow(RubyBugzilla).to receive(:new).and_return(double('bugzilla', :query => output))
      Issue.update_from_bz
      expect(Issue.order(:id).last.bz_id).to eq  "P30"
    end

    it "with invalid bugzilla query flags output" do
      output = "BZ_ID: 02032003 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      output << "SUMMARY: Test Data SUMMARY_END "
      output << "BUG_STATUS: TEST BUG_STATUS_END "
      output << "VERSION: now VERSION_END "
      output << "FLAGS: flake FLAGS_END "
      output << "KEYWORDS: stone KEYWORDS_END"

      stub_const("APP_CONFIG", "bugzilla" => {"username" => "calvin", "password" => "hobbes"})
      allow(RubyBugzilla).to receive(:new).and_return(double('bugzilla', :query => output))
      Issue.update_from_bz
      expect(Issue.order(:id).last.bz_id).to eq  "02032003"
      expect(Issue.order(:id).last.pm_ack).to eq  "+"
      expect(Issue.order(:id).last.devel_ack).to eq  "+"
      expect(Issue.order(:id).last.qa_ack).to eq  "+"
      expect(Issue.order(:id).last.doc_ack).to eq  "+"
    end
  end

  context "#get_from_flags" do

    it "with valid pm flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END bla "
      expect(Issue.get_from_flags(flags, /pm_ack/)).to eq  ["pm_ack", "+"]
    end

    it "with valid devel flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END bla "
      expect(Issue.get_from_flags(flags, /devel_ack/)).to eq  ["devel_ack", "?"]
    end

    it "with valid qa flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,qa_ack-,devel_ack?,qa_ack? FLAGS_END bla "
      expect(Issue.get_from_flags(flags, /qa_ack/)).to eq %w(qa_ack -)
    end

    it "with no doc flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      expect(Issue.get_from_flags(flags, /doc_ack/)).to eq  ["NONE", "+"]
    end

    it "with no pm flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,zz_ack+,devel_ack?,qa_ack? FLAGS_END "
      expect(Issue.get_from_flags(flags, /doc_ack/)).to eq  ["NONE", "+"]
    end

    it "with valid devel flag" do
      flags = "bla bla bla FLAGS: cfme-5.2?,pm_ack+,none_ack?,qa_ack? FLAGS_END "
      expect(Issue.get_from_flags(flags, /devel_ack/)).to eq  ["NONE", "+"]
    end

    it "when no regex match is found" do
      flags = "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      expect(Issue.get_from_flags(flags, /none/)).to eq  ["NONE", "+"]
    end

    it "when FLAGS token is invalid" do
      flags = "snaAGS: cfme-5.2?,pm_ack+,none_ack?,qa_ack? snaGS_END "
      expect(Issue.get_from_flags(flags, /devel_ack/)).to eq  ["NONE", "+"]
    end

    it "with no flags" do
      flags = ""
      expect(Issue.get_from_flags(flags, /devel_ack/)).to eq  ["NONE", "+"]
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
      expect(Issue.get_token_values(source_str, "BZ_ID")).to eq  ["R19"]
    end

    it "when ASSIGNED_TO token is found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      expect(Issue.get_token_values(source_str, "ASSIGNED_TO")).to eq  ["calvin@hobbes.comic"]
    end

    it "when SUMMARY token is found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      expect(Issue.get_token_values(source_str, "SUMMARY")).to eq  ["Test Data"]
    end

    it "when BUG_STATUS token is found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      expect(Issue.get_token_values(source_str, "BUG_STATUS")).to eq  ["TEST"]
    end

    it "when token is found at the end of a valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      expect(Issue.get_token_values(source_str, "KEYWORDS")).to eq  ["stone"]
    end

    it "when token is not found in valid soure string" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "SUMMARY: Test Data SUMMARY_END "
      source_str << "BUG_STATUS: TEST BUG_STATUS_END "
      source_str << "VERSION: now VERSION_END "
      source_str << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      expect(Issue.get_token_values(source_str, "NOT_FOUND")).to eq  []
    end

    it "when source string is empty" do
      source_str = ""
      expect(Issue.get_token_values(source_str, "NOT_FOUND")).to eq  []
    end

    it "when token is empty" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      expect(Issue.get_token_values(source_str, "")).to eq  []
    end

    it "when token is nil" do
      source_str = "BZ_ID: R19 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      source_str << "KEYWORDS: stone KEYWORDS_END"
      expect(Issue.get_token_values(source_str, "")).to eq  []
    end

  end

  context "#recreate_all_issues" do

    it "with no bugzilla query output" do
      Issue.recreate_all_issues("")
      expect(Issue.order(:id).last.nil?).to eq  true
    end

    it "with valid bugzilla query output" do

      output = "BZ_ID: 221906 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      output << "SUMMARY: Test Data SUMMARY_END "
      output << "BUG_STATUS: TEST BUG_STATUS_END "
      output << "VERSION: now VERSION_END "
      output << "FLAGS: cfme-5.2?,pm_ack+,devel_ack?,qa_ack? FLAGS_END "
      output << "KEYWORDS: stone KEYWORDS_END"

      Issue.recreate_all_issues(output)
      expect(Issue.order(:id).last.bz_id).to eq  "221906"
    end

    it "with invalid bugzilla query flags output" do

      output = "BZ_ID: 10012003 BZ_ID_END ASSIGNED_TO: calvin@hobbes.comic ASSIGNED_TO_END "
      output << "SUMMARY: Test Data SUMMARY_END "
      output << "BUG_STATUS: TEST BUG_STATUS_END "
      output << "VERSION: now VERSION_END "
      output << "FLAGS: flake FLAGS_END "
      output << "KEYWORDS: stone KEYWORDS_END"

      Issue.recreate_all_issues(output)
      expect(Issue.order(:id).last.bz_id).to eq  "10012003"
      expect(Issue.order(:id).last.pm_ack).to eq  "+"
      expect(Issue.order(:id).last.devel_ack).to eq  "+"
      expect(Issue.order(:id).last.qa_ack).to eq  "+"
      expect(Issue.order(:id).last.doc_ack).to eq  "+"
    end
  end

end
