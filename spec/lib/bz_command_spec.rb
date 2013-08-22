require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'tempfile'

class TempCredFile < Tempfile
  def initialize(file)
    f = super
    f.puts("---")
    f.puts(":bugzilla_credentials:")
    f.puts("  :username: My Username")
    f.puts("  :password: My Password")
    f.puts(":bugzilla_options:")
    f.puts("  :bugzilla_uri: MyURI")
    f.puts("  :debug: MyDebug")
    f.flush
  end
end
      
describe BzCommand do
  saved_cmd = BzCommand::CMD
  saved_cookies_file = BzCommand::COOKIES_FILE
  saved_creds_file = BzCommand::CREDS_FILE

  # Run after each tests to reset any faked BzCommand constants.
  after :each do
    silence_warnings do
      BzCommand::CMD = saved_cmd
      BzCommand::COOKIES_FILE = saved_cookies_file
      BzCommand::CREDS_FILE = saved_creds_file
    end
  end

  context "#logged_in?" do
    it "with an existing bugzilla cookie" do
      Tempfile.open('cfme_bz_spec') do |file|
        silence_warnings do
          BzCommand::COOKIES_FILE = file.path
        end
        BzCommand.logged_in?.should be true
      end
    end

    it "with no bugzilla cookie" do
      silence_warnings do
        BzCommand::COOKIES_FILE = '/This/file/does/not/exist'
      end
      BzCommand.logged_in?.should be false
    end
  end

  context "#login!" do

    it "when the bugzilla command is not found" do
      silence_warnings do
        BzCommand::CMD = '/This/cmd/does/not/exist'
      end
      expect{BzCommand.login!}.to raise_exception
    end

    it "when the bugzilla login command produces output" do
      # Fake the command, cookies file and credentials file.
      TempCredFile.open('cfme_bz_spec') do |file|
        silence_warnings do
          BzCommand::CREDS_FILE = file.path
          BzCommand::CMD = '/bin/echo'
          BzCommand::COOKIES_FILE = '/This/file/does/not/exist'
        end
        cmd, output = BzCommand.login!
        output.should include("login My Username My Password")
      end
    end

  end

  context "#query" do

    it "when the bugzilla command is not found" do
      silence_warnings do
        BzCommand::CMD = '/This/cmd/does/not/exist'
      end
      expect{BzCommand.query}.to raise_exception
    end

    it "when no product is specified" do
      silence_warnings do
        BzCommand::CMD = '/bin/echo'
      end
      expect{BzCommand.query}.to raise_exception
    end

    it "when the bugzilla query command produces output" do
      # Fake the command, cookies file and credentials file.
      TempCredFile.open('cfme_bz_spec') do |file|
        silence_warnings do
          BzCommand::CMD = '/bin/echo'
        end
        cmd, output = BzCommand.query("MyProduct")
        file.unlink unless file.nil?
        output.should include("query --product=MyProduct")
      end
    end

  end

  context "#credentials" do
    it "when the bugzilla command is not found" do
      silence_warnings do
        BzCommand::CREDS_FILE = '/This/cmd/does/not/exist'
      end
      expect{BzCommand.credentials}.to raise_exception
    end

    it "when the YAML input is invalid" do
      # Fake the credentials YAML file.
      TempCredFile.open('cfme_bz_spec') do |file|
        silence_warnings do
          BzCommand::CREDS_FILE = file.path
        end
        un, pw = BzCommand.credentials
        un.should == "My Username"
        pw.should == "My Password"
      end
    end
  end

end

