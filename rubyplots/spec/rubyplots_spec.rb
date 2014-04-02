require_relative '../lib/rubyplots.rb'
require 'csv'
require 'fileutils'
require 'pry'

describe 'RubyPlots' do
  
  $tempDir = File.join(Dir.getwd, 'spec', 'OrchestratorSpecTempDir')

  before(:all) do
    Dir.mkdir $tempDir
    # Create 3 different data files
    3.times do |i|
      dataFilePath = File.join($tempDir, "orchestratorDataFile#{i}.scatterplot")
      CSV.open(dataFilePath, "w+", {:col_sep => "\t"}) do |file|
        file << ["{Number Of Points}", "Times"]
        file << [10, 20]
        file << [20, 40]
        file << [30, 80]
        file << [40, 160]
        file << [50, 320]
      end
    end
    # Create data files with the wrong extension to make sure they don't have data generated.
    3.times do |i|
      dataFilePath = File.join($tempDir, "orchestratorDataFile#{i}.dat")
      CSV.open(dataFilePath, "w+", {:col_sep => "\t"}) do |file|
        file << ["{Number Of Points}", "Times"]
        file << [10, 20]
        file << [20, 40]
        file << [30, 80]
        file << [40, 160]
        file << [50, 320]
      end
    end
  end

  it 'should initialize without errors' do
    expect{ RubyPlots.new() }.to_not raise_error
  end

  it 'should not generate anything for wrong type of file' do
    rp = RubyPlots.new()
    wrongFiles = Dir.glob( File.join($tempDir, '*.dat') )
    expect{ rp.generatePlotsFor wrongFiles[0] }.to_not raise_error
    expect( Dir.glob(File.join($tempDir, '*.pdf')).empty? ).to be_true
  end

  it 'should generate 3 pdfs for 3 data files' do
    rp = RubyPlots.new()
    expect{ rp.generatePlotsFor $tempDir }.to_not raise_error
    pdfs = Dir.glob(File.join($tempDir, '*.pdf'))
    expect( pdfs.empty? ).to be_false
    expect( pdfs.count ).to eq(3)
  end

  # Delete the data file created for testing.
  after(:all) do
    FileUtils.rm_rf($tempDir)
  end

end
