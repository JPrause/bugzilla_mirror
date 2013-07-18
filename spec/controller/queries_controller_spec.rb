require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Query do

  describe "#run" do
    it "running an invalid query should return nothing" do
      file = Tempfile.new('cfme_bz_spec')  
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
      file.unlink
    end
  end

end
