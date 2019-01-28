class WorkflowResult
  attr_accessor :context

  def initialize
    self.context = SymbolizedHash.new
  end
end
