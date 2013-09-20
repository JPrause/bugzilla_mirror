require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Issue do
  before :each do
    @issue1 = Issue.create(
      bz_id: '1653',
      status: 'POST',
      assigned_to: 'calvin@hobbes.com',
      summary: 'summary Dragonfly',
      version: '5.1',
      version_ack: '-',
      devel_ack: '-',
      doc_ack: '-',
      pm_ack: '-',
      qa_ack: '-'
    )
    @issue2 = Issue.create(
      bz_id: '1906',
      status: 'MODIFIED',
      assigned_to: 'calvin@hobbes.com',
      summary: 'summary Swallow',
      version: '5.2',
      version_ack: '-',
      devel_ack: '+',
      doc_ack: '-',
      pm_ack: '+',
      qa_ack: '-'
    )
  end

  after :each do
    @issue1.destroy
    @issue2.destroy
  end


  context "#Issue.errata_report" do
    it "when issues table is populated" do
      need_acks, have_acks = Issue.errata_report
      need_acks.last[:BZ_ID].should include("1906")
    end
  end

end
