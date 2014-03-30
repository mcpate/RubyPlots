
require 'SecureRandom'
require_relative './scatterplot'

require 'pry'


class Orchestrator


  @latexPath = nil
  @workingDirectory = nil
  @extensionsToCleanup = nil


  def initialize
    validateLatexPackages
    @extensionsToCleanup = [".aux", ".log", ".syntex.gz", ".tex", ".auxlock", ".dep", ".dpth"]
  end


  def addLatexFor(dataFile)
    if not File.exists? dataFile
      raise "File '#{dataFile}' not found."
    end
    if @workingDirectory.nil?
      setWorkingDirectoryTo dataFile 
      @latex = @workingDirectory + "/" + File.basename(dataFile, ".scatterplot") + ".tex"
      writeOpeningTo @latex
    end
    ScatterPlot.new( dataFile, @latex )
  end


  def generatePlots
    writeClosingTo @latex
    enableLatexSystemCallsFor @latex
    compile @latex
    cleanupCruftFrom(@latex, @workingDirectory)
  end


  private

  def compile(file)
    system "pdflatex #{@latex} > /dev/null"
  end


  def cleanupCruftFrom(latex, workingDir)
    @extensionsToCleanup.each do |ext|
      Dir.foreach(workingDir) do |file|
        if File.extname(file) == ext
          File.delete(workingDir + "/" + file)
        end
      end
    end
  end


  # Finds the directory to work in and enables system calls
  def setWorkingDirectoryTo(fileOrDir)
    if File.file? File.expand_path fileOrDir
      @workingDirectory = File.dirname(fileOrDir)
    else
      @workingDirectory = File.expand_path(fileOrDir)
    end
  end


  # A requirement of generating individual PDF's
  def enableLatexSystemCallsFor(latex)
    system "cd #{File.dirname(latex)}; pdflatex -shell-escape #{File.basename(latex, ".tex")}"
  end


  # Validates that latex, tikz, and pgfplots are installed
  def validateLatexPackages
    if which("pdflatex").nil? or not system "kpsewhich tikz > /dev/null" or not system "kpsewhich pgfplots > /dev/null"
      raise "Missing required latex packages."
    end
  end


  def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each { |ext|
        exe = File.join(path, "#{cmd}#{ext}")
        return exe if File.executable? exe
      }
    end
    return nil
  end


  def writeOpeningTo(file)
    File.open(file, "a") do |f|
      f << '\\documentclass{article}' + "\n"
      f << '\\usepackage{pgfplots}' + "\n"
      f << '\\pgfplotsset{compat = newest}' + "\n"
      f << '\\usepgfplotslibrary{external}' + "\n"
      f << '\\tikzexternalize' + "{#{File.basename(file, ".tex")}}\n" 
      f << '\\begin{document}' + "\n"
    end
  end


  def writeClosingTo(file)
    File.open(file, "a") do |f|
      f << '\\end{document}'
    end
  end


end
