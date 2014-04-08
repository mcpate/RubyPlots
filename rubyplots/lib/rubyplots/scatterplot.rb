#-------------------------------------------------
# Copyright (c) 2014 Matthew Pate
# This program is licensed under the MIT License
# Please see the file 'copying.txt' in the source
# distribution of this software for license terms.
# ------------------------------------------------

require 'csv'


class ScatterPlot

  def initialize(dataFile, latexFile)
    writeScatterPlot(dataFile, latexFile)
  end

  private

  # This reads the datafile in a way that requires a certain format.
  # The title of this scatterplot becomes the name of the pdf file (minus the extension).
  # The first line of the file must be the names of the x and y columns.
  # Multiple words for an x or y column must be enclosed in brackets (see validateColumnNames)
  def writeScatterPlot(dataFile, latexFile)
   
    # Raising a custom error here because CSV.open will throw this automatically as expected and prefered, but
    # File.open will simply create a file if it doesn't exist, which we don't want, so we're just going to perform
    # the error handling here (rather than letting CSV throw and us manually throwing for File).
    if !(File.exists?(dataFile) && File.exists?(latexFile))
      raise SystemCallError, "One of '#{dataFile}' or '#{latexFile}' do not exist."
    end

    CSV.open(dataFile, "r", {:col_sep => "\t"}) do |data|
      colNames = data.readline
      validateColumnNames(colNames[0], colNames[1])

      File.open(latexFile, "a") do |file|
        fileBasename = File.basename(dataFile, ".scatterplot")
        file << '\\tikzsetnextfilename' + "{rubyplots-#{fileBasename}}\n" 
        file << '\\begin{tikzpicture}' + "\n"
        file << '\\begin{axis}' + "[title=#{fileBasename}, xlabel=#{colNames[0]}, ylabel=#{colNames[1]}]\n"
        file << '\\addplot table [only marks, ' + "x=#{colNames[0]}, y=#{colNames[1]}] {#{dataFile}};\n"
        file << '\\end{axis}' + "\n"
        file << '\\end{tikzpicture}' + "\n"
      end
    end
    puts "RubyPlots: added latex for '#{dataFile}'."
  end

  def validateColumnNames(x, y)
    if ( (x.split.count > 1 && (x[0] != "{" || x[-1] != "}")) || (y.split.count > 1 && (y[0] != "{" || y[1] != "}")) )
      raise "Columns with multiple words dectected in data file and no enclosing brackets found. One of: '#{x}' or '#{y}'"
    end
  end

end
