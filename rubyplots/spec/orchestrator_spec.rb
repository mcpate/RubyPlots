#-------------------------------------------------
# Copyright (c) 2014 Matthew Pate
# This program is licensed under the MIT License
# Please see the file 'copying.txt' in the source
# distribution of this software for license terms.
# ------------------------------------------------

require_relative '../lib/rubyplots/orchestrator'
require 'csv'
require 'fileutils'


describe "Orchestrator" do
  
  $tempDir = File.join(Dir.getwd, "spec", "OrchestratorSpecTempDir")
  $orchestratorDataFile = File.join($tempDir, "orchestratorSpec.scatterplot")
  $badExtensions = [".aux", ".log", ".syntex.gz", ".tex", ".dpth", ".auxlock", ".toc"]
  
  before(:each) do
    Dir.mkdir $tempDir
    CSV.open($orchestratorDataFile, "w+", {:col_sep => "\t"}) do |file|
      file << ["x", "y"]
      file << [10, 20]
      file << [20, 40]
      file << [30, 80]
      file << [40, 160]
      file << [50, 320]
    end
  end

  it "should not error during initialization when validating 'valid' latex packages" do
    expect{ Orchestrator.new($tempDir) }.to_not raise_error
  end

  it "should create a latex file" do
    o = Orchestrator.new($tempDir)
    o.addLatexFor $orchestratorDataFile
    expect( Dir.glob(File.join($tempDir, "*.tex")).empty? ).to be_false
  end

  it "should not create files in the parent directory" do
    o = Orchestrator.new $tempDir
    o.addLatexFor $orchestratorDataFile
    o.generatePlots
    # Look in spec and make sure no 'badExtensions' files were created here.
    $badExtensions.each do |ext|
      badFiles = Dir.glob( File.join( File.dirname($tempDir), ('*' + ext) ) )
      expect( badFiles.empty? ).to be_true
    end
  end

  it "should generate pdf plots and leave no cruft behind" do
    o = Orchestrator.new($tempDir)
    o.addLatexFor $orchestratorDataFile
    o.generatePlots
    o.savePlotsAndCleanup $tempDir
    
    expect( Dir.exists? $tempDir ).to be_false
    existingPlots = Dir.glob(File.join(File.dirname($tempDir), "*.pdf"))
    expect( existingPlots.empty? ).to be_false
    FileUtils.rm existingPlots[0]
  end

  after(:each) do
    FileUtils.rm_rf($tempDir)
  end

end
