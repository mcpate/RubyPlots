require 'pry'
require 'csv'

class ScatterPlot

  def initialize(dataFile, latexFile)
    assertExists latexFile
    assertExists dataFile
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
        file << '\\tikzsetnextfilename' + "{rubyplots-#{File.basename(dataFile, ".scatterplot")}}\n" 
        file << '\\begin{tikzpicture}' + "\n"
	      file << '\\begin{axis}[]' + "\n"
	      file << '\\addplot table [only marks, ' + "x=#{colNames[0]}, y=#{colNames[1]}] {#{dataFile}};\n"
	      file << '\\end{axis}' + "\n"
        file << '\\end{tikzpicture}' + "\n"
      end
    end
  end

  def assertExists(file)
    unless File.exists? file then raise "File '#{file}' not found." end
  end

  def validateColumnNames(x, y)
    if ( (x.split.count > 1 and (x[0] != "{" or x[-1] != "}")) or (y.split.count > 1 and (y[0] != "{" or y[1] != "}")) )
      raise "Columns with multiple words dectected in data file and no enclosing brackets found. One of: '#{x}' or '#{y}'"
    end
  end

end
