class BzQuery < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name,
    :output_format, :product

  has_many :bz_query_outputs, :dependent => :destroy

  def run

    BzCommand.login!

    cmd, output = BzCommand.query(self.product, self.flag,
      self.bug_status, self.output_format)

    # create a new bz_query_outputs entry in the db and save this output there.
    bz_query_outputs.create(:output => output)
    
    output
  end
end
