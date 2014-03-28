
require_relative '../lib/rubyplots/orchestrator'


describe "Orchestrator" do

  $specTestFile = Dir.getwd + "/spec/dataFileTest.scatterplot"
  $specTexFile = Dir.getwd + "/spec/dataFileTest.tex"
  $badExtensions = [".aux", ".log", ".syntex.gz"]
  
  it "should not error during initialization when validating latex packages" do
    expect{ Orchestrator.new }.to_not raise_error
  end

  it "should raise error when adding latex for a non-existent data file" do
    o = Orchestrator.new
    expect{ o.addLatexFor "DoesntExist" }.to raise_error
  end

  it "should create latex file and write initial latex for specified data file" do
    o = Orchestrator.new
    o.addLatexFor $specTestFile
    expect( File.exists? $specTexFile ).to be_true
    File.delete $specTexFile
  end

  it "should generate pdf and leave no cruft behind" do
    o = Orchestrator.new
    o.addLatexFor $specTestFile
    o.generatePlots
  end

end
