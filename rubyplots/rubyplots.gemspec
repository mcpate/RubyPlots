Gem::Specification.new do |s|
  s.name = "rubyplots"
  s.version = "0.0.1"
  s.date = "2014-04-06"
  s.summary = "RubyPlots - An open source plotting utility for Ruby!"
  s.description = "RubyPlots can be set loose on a directory of datafiles or a singluar datafile.  It uses the file extension to determine a datafile of interest and, using the Latex PgfPlots library, creates a single pdf plot for each data file.  See the Homepage for questions.  Enjoy!"
  s.author = ["Matthew Pate"]
  s.files = ["lib/rubyplots.rb", "lib/rubyplots/scatterplot.rb", "lib/rubyplots/orchestrator.rb"]
  s.homepage = "http://mcpate.github.io/RubyPlots/"
  s.license = "MIT"
end
