require 'rubyplots/scatterplot'


require 'orchestrator'


class RubyPlots

  @orchestrator = nil

  def initialize
  end

  # data can be a file or directory
  def generatePlotsFor(data)
    @orchestrator = Orchestrator.new

    dataPath = File.expand_path(data)

    if dataPath.file?
      checkTypeAndGenerateFor dataPath
    else
      Dir.foreach(dataPath) do |file|
        checkTypeAndGenerateFor file
      end
    end
    @orchestrator.generatePlots
  end


  private

  def checkTypeAndGenerateFor(file)
    if isRightType?(file)
      @orchestrator.addLatexFor(file)
    end
  end


  def isRightType?(file)
    return File.extension(file) == "scatterplot"
  end
