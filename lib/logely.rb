require 'clive/output'

class Logely

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
