require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'tempfile'

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

  describe "#bz_logged_in? true" do
    it "Check for an existing the bugzilla cookie." do
      file = Tempfile.new('cfme_bz_spec')  
      silence_warnings do
        ApplicationHelper::BZ_COOKIES_FILE = file.path
      end
      bz_logged_in?.should be true
      file.close
      file.unlink
    end
  end

  describe "#bz_logged_in? false" do
    it "Check for no bugzilla cookie." do
      silence_warnings do
        ApplicationHelper::BZ_COOKIES_FILE = '/This/file/does/not/exist'
      end
      bz_logged_in?.should be false
    end
  end

  describe "#bz_login! Raise Exception" do
    it "Handle bugzilla command not found." do
      silence_warnings do
        ApplicationHelper::BZ_CMD = '/This/cmd/does/not/exist'
      end
      expect{bz_login!}.to raise_exception
    end
  end

  describe "#bz_login! run" do
    it "Handle bugzilla command produces output." do
      # Fake the command,  cookies file and credentials file.
      file = Tempfile.new('cfme_bz_spec')  
      silence_warnings do
        ApplicationHelper::BZ_CREDS_FILE = file.path
        ApplicationHelper::BZ_CMD = '/bin/echo'
        ApplicationHelper::BZ_COOKIES_FILE = '/This/file/does/not/exist'
      end
      file.write("---\n")
      file.write(":bugzilla_credentials:\n")
      file.write("  :username: My Username\n")
      file.write("  :password: My Password\n")
      file.close
      bz_login!.should match "login My Username My Password"
      file.unlink
    end
  end

  describe "#bz_get_credentials Raise Exception" do
    it "Handle bugzilla command not found." do
      silence_warnings do
        ApplicationHelper::BZ_CREDS_FILE = '/This/cmd/does/not/exist'
      end
      expect{bz_get_credentials}.to raise_exception
    end
  end

  describe "#bz_get_credentials read YAML" do
    it "Exercise bz_get_credentials with YAML input." do
      # Fake the credentials YAML file.

      file = Tempfile.new('cfme_bz_spec')  
      silence_warnings do
        ApplicationHelper::BZ_CREDS_FILE = file.path
      end
      file.write("---\n")
      file.write(":bugzilla_credentials:\n")
      file.write("  :username: My Username\n")
      file.write("  :password: My Password\n")
      file.close
      un, pw = bz_get_credentials
      file.unlink

      un.should match "My Username"
      pw.should match "My Password"
    end
  end

end
