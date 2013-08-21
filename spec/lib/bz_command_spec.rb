require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'tempfile'

class TempCredFile < Tempfile
  def initialize(file)
    f = super
    f.puts("---")
    f.puts(":bugzilla_credentials:")
    f.puts("  :username: My Username")
    f.puts("  :password: My Password")
    f.close
  end
end
      
describe BzCommand do
  saved_bz_cmd = BzCommand::BZ_CMD
  saved_bz_cookies_file = BzCommand::BZ_COOKIES_FILE
  saved_bz_creds_file = BzCommand::BZ_CREDS_FILE

  # Run after each tests to reset any faked BzCommand constants.
  after :each do
    silence_warnings do
      BzCommand::BZ_CMD = saved_bz_cmd
      BzCommand::BZ_COOKIES_FILE = saved_bz_cookies_file
      BzCommand::BZ_CREDS_FILE = saved_bz_creds_file
    end
  end

  context "#bz_logged_in?" do
    it "with an existing bugzilla cookie" do
      Tempfile.new('cfme_bz_spec') do |file| 
        silence_warnings do
          BzCommand::BZ_COOKIES_FILE = file.path
        end
        BzCommand.bz_logged_in?.should be true
      end
    end

    it "with no bugzilla cookie" do
      silence_warnings do
        BzCommand::BZ_COOKIES_FILE = '/This/file/does/not/exist'
      end
      BzCommand.bz_logged_in?.should be false
    end
  end

  context "#bz_login!" do
    it "when the bugzilla command is not found" do
      silence_warnings do
        BzCommand::BZ_CMD = '/This/cmd/does/not/exist'
      end
      expect{BzCommand.bz_login!}.to raise_exception
    end

    it "when the bugzilla command produces output" do
      # Fake the command, cookies file and credentials file.
      TempCredFile.new('cfme_bz_spec') do |file| 
        silence_warnings do
          BzCommand::BZ_CREDS_FILE = file.path
          BzCommand::BZ_CMD = '/bin/echo'
          BzCommand::BZ_COOKIES_FILE = '/This/file/does/not/exist'
        end
        BzCommand.bz_login!.should == "login My Username My Password"
      end
    end
  end

  context "#bz_get_credentials" do
    it "when the bugzilla command is not found" do
      silence_warnings do
        BzCommand::BZ_CREDS_FILE = '/This/cmd/does/not/exist'
      end
      expect{BzCommand.bz_get_credentials}.to raise_exception
    end

    it "when the YAML input is invalid" do
      # Fake the credentials YAML file.

      TempCredFile.new('cfme_bz_spec') do |file|
        silence_warnings do
          BzCommand::BZ_CREDS_FILE = file.path
        end
        un, pw = BzCommand.bz_get_credentials
        un.should == "My Username"
        pw.should == "My Password"
      end
    end
  end

end

