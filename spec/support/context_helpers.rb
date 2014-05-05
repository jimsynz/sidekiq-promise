module ContextHelpers
  def When(msg=nil,&block)
    context("When#{left_pad msg}", &block)
  end

  def Otherwise(msg=nil,&block)
    context("Otherwise#{left_pad msg}", &block)
  end

  def And(msg=nil,&block)
    context("And#{left_pad msg}", &block)
  end

  private

  def left_pad(msg)
    msg ? " #{msg}" : ""
  end
end
