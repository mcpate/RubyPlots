require 'orchestrator'


class RubyPlots

  @orchestrator = nil

  def initialize
  end

  # data can be a file or directory
  def generatePlotsFor(data)
    dataPath = File.expand_path(data)
    tempDir = createTempDirectoryIn dataPath
    @orchestrator = Orchestrator.new(tempDir)

    if dataPath.file?
      checkTypeAndGenerateForFile dataPath
    else
      checkTypeAndGenerateForDir dataPath
    end

    @orchestrator.generatePlots
    #cleanup
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
