#
# DO NOT MODIFY!!!!
# This file is automatically generated by racc 1.4.5
# from racc grammer file "bracecomp.y".
#

require 'racc/parser'



require 'strscan'


class BraceComp < Racc::Parser

module_eval <<'..end bracecomp.y modeval..idf2d157fb92', 'bracecomp.y', 50

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
  return unless list

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

  if sets.empty?
    expandeds << src
  else
    permutation(sets) do |seq|
      expandeds << src % seq
    end
  end

  expandeds
end
..end bracecomp.y modeval..idf2d157fb92

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 0, 7, :_reduce_none,
 1, 7, :_reduce_none,
 1, 8, :_reduce_3,
 2, 8, :_reduce_4,
 1, 9, :_reduce_none,
 1, 9, :_reduce_none,
 1, 10, :_reduce_none,
 1, 10, :_reduce_none,
 1, 10, :_reduce_none,
 1, 10, :_reduce_none,
 3, 11, :_reduce_11,
 1, 12, :_reduce_12,
 3, 12, :_reduce_13,
 0, 13, :_reduce_14,
 1, 13, :_reduce_none ]

racc_reduce_n = 16

racc_shift_n = 19

racc_action_table = [
     2,     3,     4,     5,     2,     3,     4,     5,    15,    16,
    13,    11,    17,    11 ]

racc_action_check = [
     0,     0,     0,     0,     7,     7,     7,     7,    10,    10,
     6,     3,    13,    16 ]

racc_action_pointer = [
    -2,   nil,   nil,     9,   nil,   nil,    10,     2,   nil,   nil,
     4,   nil,   nil,    12,   nil,   nil,    11,   nil,   nil ]

racc_action_default = [
    -1,    -6,    -7,    -8,    -9,   -10,   -16,    -2,    -3,    -5,
   -16,   -15,   -12,   -16,    -4,   -11,   -14,    19,   -13 ]

racc_goto_table = [
    12,     8,     7,    10,     6,   nil,   nil,   nil,    14,   nil,
   nil,   nil,   nil,    18 ]

racc_goto_check = [
     7,     3,     2,     6,     1,   nil,   nil,   nil,     3,   nil,
   nil,   nil,   nil,     7 ]

racc_goto_pointer = [
   nil,     4,     2,     1,   nil,   nil,     0,    -3 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,     9,     1,   nil,   nil ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 :WORD => 2,
 "{" => 3,
 "}" => 4,
 "," => 5 }

racc_use_result_var = false

racc_nt_base = 6

Racc_arg = [
 racc_action_table,
 racc_action_check,
 racc_action_default,
 racc_action_pointer,
 racc_goto_table,
 racc_goto_check,
 racc_goto_default,
 racc_goto_pointer,
 racc_nt_base,
 racc_reduce_table,
 racc_token_table,
 racc_shift_n,
 racc_reduce_n,
 racc_use_result_var ]

Racc_token_to_s_table = [
'$end',
'error',
'WORD',
'"{"',
'"}"',
'","',
'$start',
'pattern',
'strings',
'string',
'words_or_sign',
'braced',
'exprs',
'expr']

Racc_debug_parser = false

##### racc system variables end #####

 # reduce 0 omitted

 # reduce 1 omitted

 # reduce 2 omitted

module_eval <<'.,.,', 'bracecomp.y', 10
  def _reduce_3( val, _values)
                    [val[0]]
  end
.,.,

module_eval <<'.,.,', 'bracecomp.y', 14
  def _reduce_4( val, _values)
                    val[0] << val[1]
  end
.,.,

 # reduce 5 omitted

 # reduce 6 omitted

 # reduce 7 omitted

 # reduce 8 omitted

 # reduce 9 omitted

 # reduce 10 omitted

module_eval <<'.,.,', 'bracecomp.y', 27
  def _reduce_11( val, _values)
                    val[1]
  end
.,.,

module_eval <<'.,.,', 'bracecomp.y', 32
  def _reduce_12( val, _values)
                    [val[0]]
  end
.,.,

module_eval <<'.,.,', 'bracecomp.y', 36
  def _reduce_13( val, _values)
                    val[0] << val[2]
  end
.,.,

module_eval <<'.,.,', 'bracecomp.y', 41
  def _reduce_14( val, _values)
                    ''
  end
.,.,

 # reduce 15 omitted

 def _reduce_none( val, _values)
  val[0]
 end

end   # class BraceComp
