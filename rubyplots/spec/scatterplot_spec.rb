#-------------------------------------------------
# Copyright (c) 2014 Matthew Pate
# This program is licensed under the MIT License
# Please see the file 'copying.txt' in the source
# distribution of this software for license terms.
# ------------------------------------------------

require_relative '../lib/rubyplots/scatterplot'
require 'csv'


describe "ScatterPlot" do
 
  # The files for testing.
  $dataFile = Dir.getwd + "/spec/scatterPlotSpec.scatterplot"
  $latexFile = Dir.getwd + "/spec/scatterPlotSpec.tex"

  before(:all) do

    # Create a data file for testing.
    CSV.open($dataFile, "w+", {:col_sep => "\t"}) do |file|
      file << ["x", "y"]
      file << [10, 20]
      file << [20, 40]
      file << [30, 80]
    end
    
    # Create an empty latex file for testing.
    File.open($latexFile, "w") { |file| file.truncate(0) }
  end

  it "should raise an error if the latex file being passed in doesn't exist" do
    expect { ScatterPlot.new($dataFile, "DoesntExist") }.to raise_error
  end

  it "should raise an error if the data file being passed in doesn't exist" do
    expect { ScatterPlot.new("DoesntExist", $latexFile) }.to raise_error
  end

  it "should write the correct data to the latex file" do
    ScatterPlot.new($dataFile, $latexFile)
  end

  # Clean-up the above files.
  after(:all) do
    File.delete $dataFile
    File.delete $latexFile
  end


end
