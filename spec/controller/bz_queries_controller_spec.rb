require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe BzQuery do

  saved_bz_cookies_file = BzCommand::COOKIES_FILE

  # Run after each tests to reset any faked BzCommand constants.
  after :each do
    silence_warnings do
      BzCommand::COOKIES_FILE = saved_bz_cookies_file
    end
  end

  describe "#run" do
    it "with an invalid query should return nothing" do
      file = Tempfile.new('cfme_bz_spec')
      begin
        silence_warnings do
          BzCommand::COOKIES_FILE = file.path
        end
        query = BzQuery.create(
          :name          => 'query name',
          :description   => 'query description',
          :product       => 'query product',
          :flag          => 'query flag',
          :bug_status    => 'query bug status',
          :output_format => 'query output format')
        query.run.should be_empty
      ensure
        file.unlink unless file.nil?
      end
    end
  end

end
