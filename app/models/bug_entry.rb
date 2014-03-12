class BugEntry
  include ApplicationHelper

  attr_accessor :bug_id, :depends_on_ids, :commits
  attr_accessor :pm_acks, :devel_acks, :qa_acks, :doc_acks, :ver_acks
  attr_accessor :flag_version, :summary

  def initialize(bz)
    flags = bz.flags
    depends_on = bz.dependents_bug_ids
    @bug_id         = bz.bug_id
    @depends_on_ids = depends_on.blank? ? "" :  depends_on.join(" ")
    @commits        = bz.commits
    @pm_acks        = display_for_ack(get_flag_ack(flags, :pm))
    @devel_acks     = display_for_ack(get_flag_ack(flags, :devel))
    @qa_acks        = display_for_ack(get_flag_ack(flags, :qa))
    @doc_acks       = display_for_ack(get_flag_ack(flags, :doc))
    @ver_acks       = display_for_ack(get_flag_ack(flags, :version))
    @flag_version   = get_flag_version(flags)
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
