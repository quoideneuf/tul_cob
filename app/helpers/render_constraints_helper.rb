# frozen_string_literal: true

module RenderConstraintsHelper
  include Blacklight::RenderConstraintsHelperBehavior

  def filter_elements(facet, values, search_state)
    facet_config = facet_configuration_for_field(facet)

    Array(values).reduce([]) do |acc, val|
      next acc if val.blank? # skip empty string

      presenter = facet_item_presenter(facet_config, val, facet)

      # Hide library_facet if matching location facet already selected.
      hidden_class = []
      if facet == "library_facet" &&
          search_state.dig(:f, :location_facet)&.any? { |l| l.match?(/#{val}/) }
        hidden_class << "hidden"
      end

      acc << { facet_field_label: facet_field_label(facet_config.key),
               label: presenter.label,
               remove: presenter.remove_href(search_state),
               classes: ["filter", "filter-" + facet.parameterize] + hidden_class }
    end
  end

  ##
  # Overridden from module RenderConstraintsHelperBehavior.
  #
  # Overridden in order to disable rendering unknown facet fields.
  # And, to handle library_pivot_facet contraints/filter elemens.
  #
  # Render a single facet's constraint
  # @param [String] facet field
  # @param [Array<String>] values selected facet values
  # @param [Blacklight::SearchState] path query parameters (unused)
  # @return [String]
  def render_filter_element(facet, values, search_state)
    return "" unless blacklight_config.facet_fields.map { |k, v|
      v.pivot ? v.pivot : k }.flatten.include? facet.to_s

    safe_join(filter_elements(
      facet = facet,
      values = values,
      search_state = search_state).map do |item|


      Deprecation.silence(Blacklight::RenderConstraintsHelperBehavior) do
        render_constraint_element(item[:facet_field_label],
                                  item[:label],
                                  remove: item[:remove],
                                  classes: item[:classes])
      end
    end, "\n")
  end
end
