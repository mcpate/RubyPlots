
class RubyPlots

  @dataDir = nil

  def initialize(dataDir = nil)
    dataDir.nil? ? @dataDir = makeDir(".") : @dataDir = makeDir(dataDir)  
  end

  def generate()
    Dir.foreach(@dataDir) do |file|
      checkAndGenerate(file)
    end
  end

  private

  def checkAndGenerate(file)
    if isRightType?(file)
      generatePdf(file)
    end
  end

  def generatePdf(file)

  end

  def getExtension(file)
    # return the extension
  end

  def isRightType?(file)
    extension = getExtension(file)
    return extension == "scatter"
  end

  def makeDir(str)
    dir = Dir.new(str)
  end
