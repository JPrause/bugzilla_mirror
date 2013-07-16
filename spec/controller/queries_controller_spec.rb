require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Query do

  # Run before each tests.
  before :each do
    @query = Query.create(
      name: 'query name',
      description: 'query description',
      product: 'query product',
      flag: 'query flag',
      bug_status: 'query bug status',
      output_format: 'query output format')
  end

  describe "#new" do
    it "returns a new query object" do
      @query.should be_an_instance_of Query
    end
  end

  describe "#name" do
    it "returns the query name" do
      @query.name.should eql 'query name'
    end
  end

  describe "#description" do
    it "returns the query description" do
      @query.description.should eql 'query description'
    end
  end

  describe "#product" do
    it "returns the query product" do
      @query.product.should eql 'query product'
    end
  end

  describe "#flag" do
    it "returns the query flag" do
      @query.flag.should eql 'query flag'
    end
  end

  describe "#bug_status" do
    it "returns the query bug_status" do
      @query.bug_status.should eql 'query bug status'
    end
  end

  describe "#output_format" do
    it "returns the query output_format" do
      @query.output_format.should eql 'query output format'
    end
  end

  describe "#run" do
    it "running an invalid query should return nothing" do
      query = Query.create(
        name: 'query name',
        description: 'query description',
        product: 'query product',
        flag: 'query flag',
        bug_status: 'query bug status',
        output_format: 'query output format')
      @query.run(query).should be_empty
    end
  end

end
