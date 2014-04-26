#-------------------------------------------------
# Copyright (c) 2014 Matthew Pate
# This program is licensed under the MIT License
# Please see the file 'copying.txt' in the source
# distribution of this software for license terms.
# ------------------------------------------------

# This is used to configure Rspec so that the standard console output
# that is a part of Rubyplots is hidden during testing.  Comment this
# config out and all 'normal' console output will be visible during tests.
RSpec.configure do |config|
  original_stderr = $stderr
  original_stdout = $stdout

  config.before(:all) do
    # Redirect to the output stream '/dev/null'
    $stderr = File.new('/dev/null', 'w')
    $stdout = File.new('/dev/null', 'w')
  end

  config.after(:all) do 
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
