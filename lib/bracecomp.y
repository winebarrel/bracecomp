class BraceComp
options no_result_var
rule
  pattern       : 
                | strings

  strings       : string
                  {
                    [val[0]]
                  }
                | strings string
                  {
                    val[0] << val[1]
                  }

  string        : words_or_sign
                | braced

  words_or_sign : WORD
                | '{'
                | '}'
                | ','

  braced        : '{' exprs '}'
                  {
                    val[1]
                  }

  exprs         : expr
                  {
                    [val[0]]
                  }
                | exprs ',' expr
                  {
                    val[0] << val[2]
                  }

  expr          :
                  {
                    ''
                  }
                | WORD
end

---- header

require 'strscan'

---- inner

attr_reader :tree

def initialize(obj)
  @src = obj.is_a?(IO) ? obj.read : obj.to_s
  @s = StringScanner.new(@src)
end
private :initialize

def scan
  piece = nil

  until @s.eos?
    if (piece = @s.scan /\A\s+/)
      # nothing to do
    elsif (piece = @s.scan /\A[^{},]+/)
      yield :WORD, piece
    elsif (piece = @s.scan /\A[{},]/)
      yield piece, piece
    else
      raise Racc::ParseError, 'parse error'
    end
  end

  yield false, '$'
end
private :scan

def parse
  begin
    @tree = yyparse self, :scan
  rescue Racc::ParseError
    @tree = [@src]
  end

  self
end

def permutation(stack, ary = [], &block)
  list = stack.shift

  list.each do |i|
    if stack.empty?
      block.call(ary + [i])
    else
      permutation(stack, ary + [i], &block)
    end
  end

  stack.unshift(list)
end
private :permutation

def swap(a, b)
  [b, a]
end
private :swap

def expand_range(first, last, is_num)
  reversed = false
  format = nil

  if is_num
    if first =~ /\A0+/
      format = "%0#{first.length}d"
    end

    first = first.to_i
    last = last.to_i
  end

  if first > last
    reversed = true
    first, last = swap(first, last)
  end

  expanded = Range.new(first, last).to_a

  if is_num and format
    expanded = expanded.map {|i| format % i }
  end

  reversed ? expanded.reverse : expanded
end
private :expand_range

def expand
  return nil unless @tree

  src = ''
  sets = []

  @tree.each do |i|
    if i.kind_of?(String)
      src << i
    else
      i = i.map {|expr|
        case expr
        when /\A([a-zA-Z])\.\.([a-zA-Z])\Z/
          expand_range($1, $2, false)
        when /\A(\d+)\.\.(\d+)\Z/
          expand_range($1, $2, true)
        else
          expr
        end
      }.flatten

      sets << i
      src << '%s'
    end
  end

  expandeds = []

  permutation(sets) do |seq|
    expandeds << src % seq
  end

  expandeds
end
