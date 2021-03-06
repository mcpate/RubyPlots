#-------------------------------------------------
# Copyright (c) 2014 Matthew Pate
# This program is licensed under the MIT License
# Please see the file 'copying.txt' in the source
# distribution of this software for license terms.
# ------------------------------------------------

require_relative './scatterplot'
require 'fileutils'


class Orchestrator

  @latexPath = nil
  @tempLatexDirectory = nil

  def initialize(tempLatexDirectory)
    validateLatexPackages
    @tempLatexDirectory = tempLatexDirectory
    @latexFile = File.join(@tempLatexDirectory, 'RubyPlotsLatexFile.tex')
    writeOpeningTo @latexFile
  end

  def addLatexFor(dataFile)
    ScatterPlot.new( dataFile, @latexFile )
  end

  def generatePlots
    writeClosingTo @latexFile
    compile @latexFile
  end

  def savePlotsAndCleanup(latexDir)
    parentDir = File.dirname(latexDir)
    plotsToKeep = Dir.glob(latexDir + File::SEPARATOR + "rubyplots-*.pdf")
    plotsToKeep.each do |plot|
      FileUtils.move(plot, parentDir, {:force => true})  
    end
    # Todo: Review options for this remove - this is unsecure right now.
    FileUtils.rm_rf @tempLatexDirectory
  end


  private

  def compile(pathToLatex)
    latexDir = File.split(pathToLatex)[0]
    file = File.split(pathToLatex)[1]

    FileUtils.cd latexDir 
    enableLatexSystemCallsFor file
    system "pdflatex #{file} > /dev/null"
  end

  # A requirement of generating individual PDF's
  # Todo: Figure out why you get 2 errors here that don't seem to effect compilation...
  def enableLatexSystemCallsFor(latex)
    system "pdflatex -shell-escape #{File.basename(latex, ".tex")} > /dev/null"
  end

  # Validates that latex, tikz, and pgfplots are installed
  def validateLatexPackages
    if which("pdflatex").nil? || !(system "kpsewhich tikz > /dev/null") || !(system "kpsewhich pgfplots > /dev/null")
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
