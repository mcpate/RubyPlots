Gem::Specification.new do |s|
  s.name = "rubyplots"
  s.version = "0.0.1"
  s.date = "2014-03-24"
  s.summary = "RubyPlots - A simple data plotting utility for Ruby!"
  s.description = "RubyPlots can be set loose on a directory of datafiles or a singluar datafile.  It uses the file extension to determine a datafile of interest and, using the Latex PgfPlots library, creates a single pdf plot for each data file.  Hopefully more functionality will be added regularly, however, we will always favor convention over configuration so the use of this utility should never get too complicated.  Enjoy!"
  s.author = ["Matthew Pate"]
  s.files = ["lib/rubyplots.rb", "lib/rubyplots/scatterplot.rb", "lib/rubyplots/orchestrator.rb"]
  s.homepage = "http://mcpate.github.io/RubyPlots/"
  s.license = "MIT"
end
