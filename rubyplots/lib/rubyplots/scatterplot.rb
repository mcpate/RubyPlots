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

      File.open(latexFile, "a") do |file|
        file << '\\tikzsetnextfilename' + "{#{File.basename(dataFile, ".scatterplot")}}" 
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

end
