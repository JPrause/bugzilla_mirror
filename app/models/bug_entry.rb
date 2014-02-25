class BugEntry
  attr_accessor :bz_id, :depends_on_ids, :commits
  attr_accessor :pm_acks, :devel_acks, :qa_acks, :doc_acks, :ver_acks
  attr_accessor :flag_version, :summary

  def initialize(bz)
    @bz_id          = bz.bz_id
    @depends_on_ids = bz.depends_on_ids == "[]" ? "" :  bz.depends_on_ids.to_s.split(",")
    @commits        = bz.commits
    @pm_acks        = display_for_ack(bz.pm_ack)
    @devel_acks     = display_for_ack(bz.devel_ack)
    @qa_acks        = display_for_ack(bz.qa_ack)
    @doc_acks       = display_for_ack(bz.doc_ack)
    @ver_acks       = display_for_ack(bz.version_ack)
    @flag_version   = bz.flag_version
    @summary        = bz.summary
  end

  def all_acks?
    ![pm_acks, devel_acks, qa_acks, doc_acks, ver_acks].include?(" ")
  end

  private

  def display_for_ack(ack)
    ack == "+" ? "X" : " "
  end
end
