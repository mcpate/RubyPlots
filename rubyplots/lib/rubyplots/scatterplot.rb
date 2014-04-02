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
  # The title of this scatterplot is the name of the file (minus the extension).
  # The first line of the file must be the names of the x and y columns.
  def writeScatterPlot(dataFile, latexFile)
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
  end

  def validateColumnNames(x, y)
    if ( (x.split.count > 1 and (x[0] != "{" or x[-1] != "}")) or (y.split.count > 1 and (y[0] != "{" or y[1] != "}")) )
      raise "Columns with multiple words dectected in data file and no enclosing brackets found. One of: '#{x}' or '#{y}'"
    end
  end

end
