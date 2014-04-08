#-------------------------------------------------
# Copyright (c) 2014 Matthew Pate
# This program is licensed under the MIT License
# Please see the file 'copying.txt' in the source
# distribution of this software for license terms.
# ------------------------------------------------

require_relative './rubyplots/orchestrator'


class RubyPlots

  @orchestrator = nil
  @filesFound = 0

  def initialize
  end

  # data can be a file or directory
  def generatePlotsFor(data)
    dataPath = File.absolute_path(data)
    tempLatexDir = createTempDirectoryFor dataPath
    puts "RubyPlots: created temporary working directory '#{tempLatexDir}'."
    @orchestrator = Orchestrator.new(tempLatexDir)

    if File.directory? dataPath
      checkTypeAndGenerateForDir dataPath
    else
      checkTypeAndGenerateForFile dataPath
    end

    @orchestrator.generatePlots
    @orchestrator.savePlotsAndCleanup tempLatexDir
    return {:filesFound => @filesFound}
  end


  private

  def createTempDirectoryFor(fileOrDir)
    newDir = nil
    if File.directory? fileOrDir
      newDir = File.join(fileOrDir, 'RubyPlotsWorkingDir')
    else
      newDir = File.join(File.dirname(fileOrDir), 'RubyPlotsWorkingDir')
    end
    Dir.mkdir(newDir)
    return newDir
  end

  def checkTypeAndGenerateForFile(file)
    if isRightType?(file)
      @filesFound += 1
      @orchestrator.addLatexFor(file)
    end
  end

  def checkTypeAndGenerateForDir(dir)
    Dir.entries(dir).each do |file|
      # We loose the full path on .entries, so rejoin.
      checkTypeAndGenerateForFile File.join(dir, file)
    end
  end

  def isRightType?(file)
    return File.extname(file) == ".scatterplot"
  end

end
