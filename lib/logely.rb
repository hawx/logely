class String

  # @example
  #
  #   puts "bold".bold
  #   puts "underline".underline
  #   puts "blink".blink
  #   puts "green".green
  #   puts "red".red
  #   puts "magenta".magenta
  #   puts "yellow".yellow
  #   puts "blue".blue
  #   puts "grey".grey
  #
  #   puts "combo".blue.bold.underline.blink
  #
  # @param code
  #   Colour code, see http://en.wikipedia.org/wiki/ANSI_escape_code#Colors
  #
  def colour(code)
    r = "\e[#{code}m#{self}"
    r << "\e[0m" unless self[-4..-1] == "\e[0m"
    r
  end

  # Remove any colour codes from a string.
  def clear_colours
    gsub /\e\[?\d\d{0,2}m/, ''
  end

  COLOURS = {
    "black"   => 0,
    "red"     => 1,
    "green"   => 2,
    "yellow"  => 3,
    "blue"    => 4,
    "magenta" => 5,
    "cyan"    => 6,
    "white"   => 7
  }.each do |name, code|
    define_method name do
      colour "3#{code}"
    end

    define_method "#{name}!" do
      colour! "3#{code}"
    end

    define_method "#{name}_bg" do
      colour "4#{code}"
    end

    define_method "#{name}_bg!" do
      colour! "4#{code}"
    end

    # Change name to grey instead of l_black
    l_name = "l_#{name}"
    if name == "black"
      l_name = "grey"
    end

    define_method "#{l_name}" do
      colour "9#{code}"
    end

    define_method "#{l_name}!" do
      colour! "9#{code}"
    end

    define_method "#{l_name}_bg" do
      colour "10#{code}"
    end

    define_method "#{l_name}_bg!" do
      colour! "10#{code}"
    end
  end

  {
    "bold"      => 1,
    "underline" => 4,
    "blink"     => 5,
    "reverse"   => 7
  }.each do |name, code|
    define_method name do
      colour code
    end

    define_method "#{name}!" do
      colour! code
    end
  end

end

class Logely

  VERSION = '0.0.0'

  DEFAULT = {
    padding: 2,
    gutter:  2
  }

  def initialize(output=nil, opts={}, &config)
    @output   = output || STDOUT
    @padding  = opts.fetch(:padding, DEFAULT[:padding])
    @gutter   = opts.fetch(:gutter, DEFAULT[:gutter])
    @width    = 0

    instance_exec &config if block_given?
    @running = true
  end

  def flush
    @output.print "\n"
  end

  def method_missing(sym, *args)
    super if @running

    waiting = sym.to_s.end_with?('?')
    sym = sym.to_s[0..-2].to_sym if waiting

    action = sym.to_s.gsub(/_/, ' ')
    action = args.inject(action) {|a,e| a = a.send(e) }

    @width = [@width, action.clear_colours.size].max

    self.singleton_class.send :define_method, sym do |message|
      @output.print format(action, message)
      @output.print "\n" unless waiting
    end

    self.singleton_class.send :define_method, "#{sym}!" do |message|
      @output.print "\r" + format(action, message)
      @output.print "\n" unless waiting
    end
  end

  private

  def format(s, m)
    padding + pad_left(s) + gutter + m
  end

  def padding; " " * @padding; end
  def gutter;  " " * @gutter;  end

  def pad_left(s)
    w = s.clear_colours.size
    @width < w ? s : " " * (@width - w) + s
  end
end
