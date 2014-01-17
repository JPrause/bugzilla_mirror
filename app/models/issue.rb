require 'ruby_bugzilla'

class Issue < ActiveRecord::Base
  attr_accessible :assigned_to,  :bz_id, :dep_id, :status, :summary, :version,
    :version_ack, :devel_ack, :doc_ack, :pm_ack, :qa_ack
  serialize :dep_id

  VERSION_REGEX=/cfme-[0-9]\.?[0-9]?\.?z?/

  def self.update_from_bz

    raise "Error no username specified in config/cfme_bz.yml" unless AppConfig['bugzilla']['username']
    raise "Error no password specified in config/cfme_bz.yml" unless AppConfig['bugzilla']['password']

    bz = RubyBugzilla.new(AppConfig['bugzilla']['uri'],
                          AppConfig['bugzilla']['username'],
                          AppConfig['bugzilla']['password'])

    output_format = "BZ_ID: %{id} BZ_ID_END ASSIGNED_TO: %{assigned_to} ASSIGNED_TO_END "
    output_format << "SUMMARY: %{summary} SUMMARY_END "
    output_format << "BUG_STATUS: %{bug_status} BUG_STATUS_END "
    output_format << "VERSION: %{version} VERSION_END "
    output_format << "FLAGS: %{flags} FLAGS_END "
    output_format << "KEYWORDS: %{keywords} KEYWORDS_END "
    output_format << "DEP_ID: %{dependson} DEP_ID_END"

    output = bz.query(
      :product      => AppConfig['bugzilla']['product'],
      :bug_status   => "OPEN",
      :flag         => "",
      :outputformat => output_format
    )
    self.recreate_all_issues(output)
    output

  end

  private
  def self.get_from_flags(str, regex)

    flags = self.get_token_values(str, "FLAGS").join
    match = regex.match(flags)

    if match
      return [match[0], match.post_match[0]]
    else
      return ["NONE", "+"]
    end
   
  end

  private
  def self.get_token_values(str, token)

    return [] if token.to_s.empty?

    token_values = str.scan(/(?<=#{token}:\s).*(?<=#{token}_END)/)

    # Because regexp lookahead and lookbehind must be a fixed length
    # removing the occasionally occuring trailing ->'<- character must
    # be done in a separate step.
    token_values.each do |x|
      x.sub!("#{token}_END", "")
      x.sub!(/'$/, '')
      x.strip!
    end

    token_values
  end

  private
  def self.recreate_all_issues(output)

    self.delete_all

    # create a new issue in the db for each bz.
    output.each_line do |bz_line|
      # create a new issue object in the db for each BZ.
      bz_id                    = self.get_token_values(bz_line, "BZ_ID").join
      dep_id                   = self.get_token_values(bz_line, "DEP_ID").join
      assigned_to              = self.get_token_values(bz_line, "ASSIGNED_TO").join
      summary                  = self.get_token_values(bz_line, "SUMMARY").join
      status                   = self.get_token_values(bz_line, "BUG_STATUS").join

      pm_ack_str, pm_ack       = self.get_from_flags(bz_line, /pm_ack/)
      devel_ack_str, devel_ack = self.get_from_flags(bz_line, /devel_ack/)
      qa_ack_str, qa_ack       = self.get_from_flags(bz_line, /qa_ack/)
      doc_ack_str, doc_ack     = self.get_from_flags(bz_line, /doc_ack/)
      version_str, version_ack = self.get_from_flags(bz_line, VERSION_REGEX)

      self.create(:bz_id         => bz_id,
                  :dep_id        => dep_id,
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
