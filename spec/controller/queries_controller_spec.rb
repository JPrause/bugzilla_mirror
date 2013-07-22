require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Query do

  saved_bz_cookies_file = ApplicationHelper::BZ_COOKIES_FILE

  # Run after each tests to reset any faked ApplicationHelper constants.
  after :each do
    silence_warnings do
      ApplicationHelper::BZ_COOKIES_FILE = saved_bz_cookies_file
    end
  end

  describe "#run" do
    it "running an invalid query should return nothing" do
      Tempfile.new('cfme_bz_spec') do |file| 
        silence_warnings do
          ApplicationHelper::BZ_COOKIES_FILE = file.path
        end
        query = Query.create(
          name: 'query name',
          description: 'query description',
          product: 'query product',
          flag: 'query flag',
          bug_status: 'query bug status',
          output_format: 'query output format')
        query.run(query).should be_empty
      end
    end
  end

end
