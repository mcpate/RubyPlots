
require_relative '../lib/rubyplots/orchestrator'
require 'csv'
require 'fileutils'

describe "Orchestrator" do
  
  $tempDir = Dir.getwd + "/spec/SpecTempDir"
  $specTestFile = $tempDir + "/orchestratorSpec.scatterplot"
  $badExtensions = [".aux", ".log", ".syntex.gz"]
  
  before(:all) do
    Dir.mkdir $tempDir
    CSV.open($specTestFile, "w+", {:col_sep => "\t"}) do |file|
      file << ["x", "y"]
      file << [10, 20]
      file << [20, 40]
      file << [30, 80]
      file << [40, 160]
      file << [50, 320]
    end
  end

  it "should not error during initialization when validating latex packages" do
    expect{ Orchestrator.new($tempDir) }.to_not raise_error
  end

#  This should never happen and if it does, the library doing the writing should take care of the error
#  it "should raise error when adding latex for a non-existent data file" do
#    o = Orchestrator.new
#    expect{ o.addLatexFor "DoesntExist" }.to raise_error
#  end
#
  it "should create a latex file" do
    o = Orchestrator.new($tempDir)
    o.addLatexFor $specTestFile
    expect( !Dir.glob($tempDir + "/*.tex").empty? ).to be_true
  end

#  it "should generate pdf and leave no cruft behind" do
#    o = Orchestrator.new
#    o.addLatexFor $specTestFile
#    o.generatePlots
#  end
#
#
  # Delete the data file created for testing.
  after(:all) do
    FileUtils.rm_rf($tempDir)
  end

end
