require_relative '../lib/rubyplots/scatterplot'
require 'pry'

describe "ScatterPlot" do
 
  $dataFile = Dir.getwd + ("/spec/dataFileTest.scatterplot")
  $latexFile = Dir.getwd + ("/spec/latexFileTest.tex")
  File.open($latexFile, "w") { |file| file.truncate(0) }

  it "should raise an error if the latex file being passed in doesn't exist" do
    expect{ ScatterPlot.new($dataFile, "DoesntExist") }.to raise_error
  end

  it "should raise an error if the data file being passed in doesn't exist" do
    expect{ ScatterPlot.new("DoesntExist", $latexFile) }.to raise_error
  end

  it "should write the correct data to the latex file" do
    ScatterPlot.new($dataFile, $latexFile)
  end

end
