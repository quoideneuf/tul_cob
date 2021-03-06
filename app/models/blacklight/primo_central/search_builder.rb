# frozen_string_literal: true

module Blacklight::PrimoCentral
  class SearchBuilder < Blacklight::SearchBuilder
    include Blacklight::PrimoCentral::SearchBuilderBehavior
    include Blacklight::PrimoCentral::SolrAdaptor

    self.default_processor_chain = [
      :add_query_to_primo_central,
      :set_query_field,
      :process_advanced_search,
      :previous_and_next_document,
      :add_query_facets,
      :process_date_range_query,
    ]
  end
end
