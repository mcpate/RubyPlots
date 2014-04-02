#-------------------------------------------------
# Copyright (c) 2014 Matthew Pate
# This program is licensed under the MIT License
# Please see the file 'copying.txt' in the source
# distribution of this software for license terms.
# ------------------------------------------------

require 'orchestrator'


class RubyPlots

  @orchestrator = nil

  def initialize
  end

  # data can be a file or directory
  def generatePlotsFor(data)
    dataPath = File.expand_path(data)
    tempLatexDir = createTempDirectoryIn dataPath
    @orchestrator = Orchestrator.new(tempLatexDir)

    if dataPath.file?
      checkTypeAndGenerateForFile dataPath
    else
      checkTypeAndGenerateForDir dataPath
    end

    @orchestrator.generatePlots
    @orchestrator.savePlotsAndCleanup tempLatexDir
  end


  private

  def createTempDirectoryIn(dir)
    newDir = dir + "/RubyPlotsWorkingDir"
    Dir.mkdir(newDir)
    return newDir
  end

  def checkTypeAndGenerateForFile(file)
    if isRightType?(file)
      @orchestrator.addLatexFor(file)
    end
  end

  def checkTypeAndGenerateForDir(dir)
    Dir.foreach(dir) do |file|
      checkTypeAndGenerateFor file
    end
  end

  def isRightType?(file)
    return File.extension(file) == "scatterplot"
  end