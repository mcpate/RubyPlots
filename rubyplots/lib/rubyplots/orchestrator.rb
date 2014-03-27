
require 'SecureRandom'
require 'scatterplot'

class Orchestrator

  @@latex = nil

  def initialize
    validateLatexPackages
    # Create a file path using current dir and random hex string
    @@latex = (Dir.getwd) + SecureRandom.hex(5) + ".tex"
    enableLatexStystemCalls
    writeOpeningTo @@latex
  end


  def addLatexFor(dataFile)
    
  end

  def generatePlots

  end


  private

  # A requirement of generating individual PDF's
  def enableLatexSystemCalls
    system "cd #{Dir.getwd}; pdflatex -shell-escape #{File.basename(@@latex, ".tex")}"
  end

  # Validates that latex, tikz, and pgfplots are installed
  def validateLatexPackages
    if which("pdflatex").nil? or not system "kpsewhich tikz" or not system "kpsewhich pgfplots"
      raise "Missing required latex packages."
    end
  end


  # Cross-platform way of finding an executable in the $PATH.
  #
  #   which('ruby') #=> /usr/bin/ruby
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
      f << "\documentclass{article}"
      f << "\usepackage{pgfplots}"
      f << "\pgfplotsset{compat = newest}"
      f << "\begin{document}"
    end
  end

  def writeClosingTo(file)
    File.open(file, "a") do |f|
      f << "\end{document}"
    end
  end


  
end
