# JJV require 'ruby_bugzilla'
require '/home/jvlcek/.rvm/gems/ruby-1.9.3-p392@cfme_bz/gems/ruby_bugzilla-0.1.0/lib/ruby_bugzilla'

class Issue < ActiveRecord::Base
  attr_accessible :assigned_to,  :bz_id, :status, :summary, :version,
    :version_ack, :devel_ack, :doc_ack, :pm_ack, :qa_ack

  VERSION_REGEX=/cfme-[0-9]\.?[0-9]?\.?z?/

  def self.errata_report
    logger.debug "Invoked Issue.self.errata_report"

    bzs_need_acks = []
    bzs_have_acks = []

    self.order(:id).each do |bz|
      ack_code = ""

      ack_code << (self.ack_not_needed?(bz.pm_ack) ? "-" : "P")
      ack_code << (self.ack_not_needed?(bz.devel_ack) ? "-" : "D")
      ack_code << (self.ack_not_needed?(bz.qa_ack) ? "-" : "Q")
      ack_code << (self.ack_not_needed?(bz.doc_ack) ? "-" : "O")
      # The version ack is set by the Bugzilla Bot so user "B".
      ack_code << (self.ack_not_needed?(bz.version_ack) ? "-" : "B")
      bz_entry = {:BZ_ID   => bz.bz_id,
                  :ACKS    => ack_code,
                  :SUMMARY  => bz.summary}

      if ack_code == "-----"
        bzs_have_acks << bz_entry
      else
        bzs_need_acks << bz_entry
      end
    end

    [bzs_need_acks, bzs_have_acks]

  end

  def self.update_from_bz

    RubyBugzilla.login!

    product = "CloudForms Management Engine"
    bug_status = "NEW, ASSIGNED, POST, MODIFIED, ON_DEV, ON_QA, VERIFIED, RELEASE_PENDING"
    flag = ""
    output_format = 'BZ_ID: %{id} BZ_ID_END ASSIGNED_TO: %{assigned_to} ASSIGNED_TO_END '
    output_format << 'SUMMARY: %{summary} SUMMARY_END '
    output_format << 'BUG_STATUS: %{bug_status} BUG_STATUS_END '
    output_format << 'VERSION: %{version} VERSION_END '
    output_format << 'FLAGS: %{flags} FLAGS_END '
    output_format << 'KEYWORDS: %{keywords} KEYWORDS_END'

    cmd, output = RubyBugzilla.query(product, flag, bug_status, output_format)
    self.recreate_all_issues(output)
    output

  end

  private
  def self.ack_not_needed?(ack)
    ack == "+" || ack.upcase == "NONE"
  end

  private
  def self.get_from_flags(str, regex)

    flags = self.get_token_values(str, "FLAGS").join
    match = regex.match(flags)

    if match
      return [match[0], match.post_match[0]]
    else
      return ["NONE", "NONE"]
    end
   
  end

  # TODO Update all tokens to have token_END delimiter.
  private
  def self.get_token_values(str, token)

    token_values = str.scan(/(?<=#{token}:\s).*(?<=#{token}_END)/)
    token_values = str.scan(/(?<=#{token}:\s)\S*/) unless token_values != []

    # Because regexp lookahead and lookbehind must be a fixed length
    # removing the occasionally occuring trailing ->'<- character must
    # be done in a separate step.
    token_values.each do |x|
      x.sub!("#{token}_END", "")
      x.sub!(/'$/, '')
    end

    token_values
  end

  private
  def self.recreate_all_issues(output)

    self.delete_all

    # create a new bz_query_entries object in the db for each bz.
    output.each_line do |bz_line|
      # create a new issue object in the db for each BZ.
      bz_id = self.get_token_values(bz_line, "BZ_ID").join
      assigned_to = self.get_token_values(bz_line, "ASSIGNED_TO").join
      summary = self.get_token_values(bz_line, "SUMMARY").join
      status = self.get_token_values(bz_line, "BUG_STATUS").join

      pm_ack_str, pm_ack = self.get_from_flags(bz_line, /pm_ack/)
      devel_ack_str, devel_ack = self.get_from_flags(bz_line, /devel_ack/)
      qa_ack_str, qa_ack = self.get_from_flags(bz_line, /qa_ack/)
      doc_ack_str, doc_ack = self.get_from_flags(bz_line, /doc_ack/)
      version_str, version_ack = self.get_from_flags(bz_line, VERSION_REGEX)

      self.create(:bz_id         => bz_id,
                  :assigned_to   => assigned_to,
                  :status        => status,
                  :summary       => summary,
                  :version       => version_str,
                  :version_ack   => version_ack,
                  :devel_ack     => devel_ack,
                  :doc_ack       => doc_ack,
                  :pm_ack        => pm_ack,
                  :qa_ack        => qa_ack)

    end
    
  end

end
