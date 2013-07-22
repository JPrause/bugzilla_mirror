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
      
describe ApplicationHelper do

  saved_bz_cmd = ApplicationHelper::BZ_CMD
  saved_bz_cookies_file = ApplicationHelper::BZ_COOKIES_FILE
  saved_bz_creds_file = ApplicationHelper::BZ_CREDS_FILE

  # Run after each tests to reset any faked ApplicationHelper constants.
  after :each do
    silence_warnings do
      ApplicationHelper::BZ_CMD = saved_bz_cmd
      ApplicationHelper::BZ_COOKIES_FILE = saved_bz_cookies_file
      ApplicationHelper::BZ_CREDS_FILE = saved_bz_creds_file
    end
  end

  context "#bz_logged_in?" do
    it "Check for an existing the bugzilla cookie." do
      Tempfile.new('cfme_bz_spec') do |file| 
        silence_warnings do
          ApplicationHelper::BZ_COOKIES_FILE = file.path
        end
        bz_logged_in?.should be true
      end
    end

    it "Check for no bugzilla cookie." do
      silence_warnings do
        ApplicationHelper::BZ_COOKIES_FILE = '/This/file/does/not/exist'
      end
      bz_logged_in?.should be false
    end
  end

  context "#bz_login!" do
    it "Handle bugzilla command not found." do
      silence_warnings do
        ApplicationHelper::BZ_CMD = '/This/cmd/does/not/exist'
      end
      expect{bz_login!}.to raise_exception
    end

    it "Handle bugzilla command produces output." do
      # Fake the command, cookies file and credentials file.
      TempCredFile.new('cfme_bz_spec') do |file| 
        silence_warnings do
          ApplicationHelper::BZ_CREDS_FILE = file.path
          ApplicationHelper::BZ_CMD = '/bin/echo'
          ApplicationHelper::BZ_COOKIES_FILE = '/This/file/does/not/exist'
        end
        bz_login!.should == "login My Username My Password"
      end
    end
  end

  context "#bz_get_credentials" do
    it "Handle bugzilla command not found." do
      silence_warnings do
        ApplicationHelper::BZ_CREDS_FILE = '/This/cmd/does/not/exist'
      end
      expect{bz_get_credentials}.to raise_exception
    end

    it "Handle valid YAML input." do
      # Fake the credentials YAML file.

      TempCredFile.new('cfme_bz_spec') do |file|
        silence_warnings do
          ApplicationHelper::BZ_CREDS_FILE = file.path
        end
        un, pw = bz_get_credentials
        un.should == "My Username"
        pw.should == "My Password"
      end
    end
  end

end

