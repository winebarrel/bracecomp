require 'bracecomp.tab'

class String
  def expand
    BraceComp.new(self).parse.expand
  end
end
