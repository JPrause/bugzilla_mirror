require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../../app/models/', 'report_table'))

# [TODO] Move TEST_DATA into a test fixture or FactoryGirl
TEST_DATA="'BZ_ID: 945536 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 946284 BUG_STATUS: POST VERSION: unspecified'\n"
TEST_DATA << "'BZ_ID: 946320 BUG_STATUS: MODIFIED VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 946562 BUG_STATUS: POST VERSION: unspecified'\n"
TEST_DATA << "'BZ_ID: 946820 BUG_STATUS: POST VERSION: unspecified'\n"
TEST_DATA << "'BZ_ID: 946845 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 946852 BUG_STATUS: POST VERSION: 5.1.0'\n"
TEST_DATA << "'BZ_ID: 946855 BUG_STATUS: POST VERSION: unspecified'\n"
TEST_DATA << "'BZ_ID: 947637 BUG_STATUS: POST VERSION: 5.0.1'\n"
TEST_DATA << "'BZ_ID: 947645 BUG_STATUS: POST VERSION: 5.0.1'\n"
TEST_DATA << "'BZ_ID: 950080 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 950094 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 959045 BUG_STATUS: POST VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 960596 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 960693 BUG_STATUS: MODIFIED VERSION: unspecified'\n"
TEST_DATA << "'BZ_ID: 960704 BUG_STATUS: POST VERSION: 4.0.1'\n"
TEST_DATA << "'BZ_ID: 960705 BUG_STATUS: POST VERSION: 4.0.1'\n"
TEST_DATA << "'BZ_ID: 960712 BUG_STATUS: MODIFIED VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 962463 BUG_STATUS: POST VERSION: 5.1.0'\n"
TEST_DATA << "'BZ_ID: 963236 BUG_STATUS: POST VERSION: 5.1.0'\n"
TEST_DATA << "'BZ_ID: 962802 BUG_STATUS: MODIFIED VERSION: 4.0.1'\n"
TEST_DATA << "'BZ_ID: 963729 BUG_STATUS: MODIFIED VERSION: 5.0.1'\n"
TEST_DATA << "'BZ_ID: 965147 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 965406 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 967960 BUG_STATUS: POST VERSION: 4.0.1'\n"
TEST_DATA << "'BZ_ID: 968055 BUG_STATUS: POST VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 970395 BUG_STATUS: POST VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 969490 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 971596 BUG_STATUS: POST VERSION: 5.0.0'\n"
TEST_DATA << "'BZ_ID: 973357 BUG_STATUS: POST VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 974659 BUG_STATUS: POST VERSION: 4.0.1'\n"
TEST_DATA << "'BZ_ID: 979202 BUG_STATUS: MODIFIED VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 982367 BUG_STATUS: POST VERSION: 4.0.1'\n"
TEST_DATA << "'BZ_ID: 986834 BUG_STATUS: MODIFIED VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 990148 BUG_STATUS: MODIFIED VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 991274 BUG_STATUS: MODIFIED VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 996298 BUG_STATUS: POST VERSION: 5.2.0'\n"
TEST_DATA << "'BZ_ID: 997060 BUG_STATUS: POST VERSION: 5.1.0'"

describe ReportTable do

  context "#set_table_bz_count!" do
    it "Test empty table and empty test data" do
      set_table_bz_count!({}, "", "", "").should == {}
    end

    it "Test valid table." do
      source_table = {"MODIFIED"=>{"4.0.1"=>0,
                                   "5.0.0"=>0,
                                   "5.0.1"=>0,
                                   "5.1.0"=>0,
                                   "5.2.0"=>0,
                                   "unspecified"=>0},
                      "POST"=>{"4.0.1"=>0,
                                   "5.0.0"=>0,
                                   "5.0.1"=>0,
                                   "5.1.0"=>0,
                                   "5.2.0"=>0,
                                   "unspecified"=>0}}

      result_table = {"MODIFIED"=>{"4.0.1"=>1,
                                   "5.0.0"=>2,
                                   "5.0.1"=>1,
                                   "5.1.0"=>0,
                                   "5.2.0"=>4,
                                   "unspecified"=>1},
                      "POST"=>{"4.0.1"=>5,
                                   "5.0.0"=>9,
                                   "5.0.1"=>2,
                                   "5.1.0"=>4,
                                   "5.2.0"=>5,
                                   "unspecified"=>4}}

      set_table_bz_count!(source_table, TEST_DATA, "BUG_STATUS", "VERSION").should == result_table 
    end

    it "Test table with only one key." do
      source_table = {"MODIFIED"=>{"4.0.1"=>0,
                                   "5.0.0"=>0,
                                   "5.0.1"=>0,
                                   "5.1.0"=>0,
                                   "5.2.0"=>0,
                                   "unspecified"=>0}}

      result_table = {"MODIFIED"=>{"4.0.1"=>1,
                                   "5.0.0"=>2,
                                   "5.0.1"=>1,
                                   "5.1.0"=>0,
                                   "5.2.0"=>4,
                                   "unspecified"=>1}}

      set_table_bz_count!(source_table, TEST_DATA, "BUG_STATUS", "VERSION").should == result_table 
    end

  end

end
