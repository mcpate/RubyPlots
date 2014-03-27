
class ScatterPlot

  def initialize(dataFile, latexFile)
    assertExists latexFile
    writeScatterPlot(dataFile, latexFile)
  end

  private

  def writeScatterPlot(dataFile, latexFile)
    File.open(latexFile, "a") do |file|
      #file << "\tikzsetnextfilename{#{File.basename(dataFile, 
      file << "\begin{tikzpicture}"
	    file << "\begin{axis}[]"
	    file << "\addplot table [only marks, x=x, y=y] {#{datafile}};"
	    file << "\end{axis}"
      file << "\end{tikzpicture}"
    end
  end

  def assertExists(file)
    unless File.exists? file raise "Latex file '#{file}' not found." end
  end

end
