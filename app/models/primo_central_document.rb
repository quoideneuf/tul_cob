# frozen_string_literal: true

class PrimoCentralDocument < HashWithIndifferentAccess
  require "blacklight/primo_central"

  include Blacklight::PrimoCentral::Document

  self.unique_key = :pnxId

  def initialize(constructor = {})
    if constructor.is_a?(Hash)
      super(constructor)
      update(constructor)
    else
      super(constructor)
    end
  end
end
