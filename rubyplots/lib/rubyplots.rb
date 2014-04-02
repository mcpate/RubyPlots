#-------------------------------------------------
# Copyright (c) 2014 Matthew Pate
# This program is licensed under the MIT License
# Please see the file 'copying.txt' in the source
# distribution of this software for license terms.
# ------------------------------------------------

require_relative './rubyplots/orchestrator'
require 'pry'

class RubyPlots

  @orchestrator = nil

  def initialize
  end

  # data can be a file or directory
  def generatePlotsFor(data)
    dataPath = File.expand_path(data)
    tempLatexDir = createTempDirectoryFor dataPath
    @orchestrator = Orchestrator.new(tempLatexDir)

    if File.directory? dataPath
      checkTypeAndGenerateForDir dataPath
    else
      checkTypeAndGenerateForFile dataPath
    end

    @orchestrator.generatePlots
    @orchestrator.savePlotsAndCleanup tempLatexDir
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
