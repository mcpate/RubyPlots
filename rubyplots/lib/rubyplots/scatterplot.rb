
class ScatterPlot

  def initialize(dataFile, latexFile)
    assertExists latexFile
    assertExists dataFile
    writeScatterPlot(dataFile, latexFile)
  end

  private

  def writeScatterPlot(dataFile, latexFile)
    File.open(latexFile, "a") do |file|
      #file << "\tikzsetnextfilename{#{File.basename(dataFile, 
      file << '\\begin{tikzpicture}' + "\n"
	    file << '\\begin{axis}[]' + "\n"
	    file << '\\addplot table [only marks, x=x, y=y] ' + "{#{dataFile}};\n"
	    file << '\\end{axis}' + "\n"
      file << '\\end{tikzpicture}' + "\n"
    end
  end

  def assertExists(file)
    unless File.exists? file then raise "File '#{file}' not found." end
  end

end
