# frozen_string_literal: true

module ApplicationHelper
  # value ex: "MAIN stacks"
  def render_location(value)
    params = value.to_s.split
    [ Rails.configuration.libraries[params.first],
      Rails.configuration.locations.dig(*params) ]
      .compact
      .join(" ")
  end

  def render_location_show(value)
    render_location(value[:value].first)
  end

  def aeon_request_url(document)
    form_fields = {
         ItemTitle: document.fetch("title_statement_display", ""),
         ItemPlace: document.fetch("imprint_display", ""),
         ReferenceNumber: document.fetch("mms_id_display", ""),
         CallNumber: document.fetch("call_number_display", ""),
         ItemAuthor: document.fetch("creator_display", ""),
         "rft.pages": document["collection_area_display"]
     }

    openurl_field_values = form_fields.map { |k, v|
      [k, v.to_s.delete('[]""')] }.to_h

    openurl_field_values["Action"] = 10
    openurl_field_values["Form"] = 30


    URI::HTTPS.build(
      host:  "temple.aeon.atlas-sys.com",
      path: "/Logon/",
      query: openurl_field_values.to_query).to_s
  end

  def aeon_request_allowed(document)
    document_items = document.fetch("items_json_display", [])
    libraries = document_items.collect { |item| library(item) }
    libraries.include?("SCRC")
  end

  def aeon_request_button(document)
    document_items = document.fetch("items_json_display", [])
    libraries = document_items.collect { |item| library(item) }

    if libraries.include?("SCRC")
      button_to(t("requests.aeon_button_text"), aeon_request_url(document), class: "btn btn-primary")
    end
  end

  def total_items(results)
    results.total_items[:query_total] || 0 rescue 0
  end

  def total_online(results)
    results.total_items[:online_total] || 0 rescue 0
  end

  def bento_single_link(field)
    alma_electronic_resource_direct_link(field.first["portfolio_id"])
  end

  def bento_engine_nice_name(engine_id)
    I18n.t("bento.#{engine_id}.nice_name")
  end

  def bento_icons(engine_id)
    case engine_id
    when "articles"
      content_tag(:span, "", class: "bento-icon bento-article m-3")
    when "journals"
      content_tag(:span, "", class: "bento-icon bento-journal m-3")
    when "databases"
      content_tag(:span, "", class: "bento-icon bento-database m-3")
    when "books_and_media"
      content_tag(:span, "", class: "bento-icon bento-book m-3")
    when "website"
      content_tag(:span, "", class: "bento-icon bento-website m-3")
    end
  end

  def bento_link_to_full_results(results)
    total = number_with_delimiter(total_items results)
    BentoSearch.get_engine(results.engine_id).view_link(total, self)
  end

  # TODO: move to decorator or engine class.
  def bento_link_to_online_results(results)
    total = number_with_delimiter(total_online results)
    case results.engine_id
    when "blacklight"
      url = search_catalog_path(q: params[:q], f: { availability_facet: ["Online"] })
      link_to "View all #{total} online items", url, class: "full-results"
    when "journals"
      url = search_catalog_path(q: params[:q], f: {
        format: ["Journal/Periodical"],
        availability_facet: ["Online"]
      })
      link_to "View all #{total} online journals", url, class: "full-results"
    when "books_and_media"
      ""
    when "articles"
      url = url_for(
        action: :index, controller: :primo_central,
        q: params[:q], f: { availability_facet: ["Online"] }
      )
      link_to "View all #{total} online articles", url, class: "full-results"
    else
      ""
    end
  end

  # Gets the base_path of current_page (i.e. /articles if at /articles/foobar)
  def base_path
    File.dirname(url_for)
  end

  # Render the index field (link)
  def index_field_url_link(arg)
    url = arg[:value].first
    link_to "direct link", url, remote: true
  end

  def login_disabled?
    Rails.configuration.features.fetch(:login_disabled, false)
  end

  def render_search_history?
    false
  end

  def faq_link(type = :short)
    label =
      case type
      when :short
        "FAQs"
      when :long
        "Frequently Asked Questions"
      else
        type
      end

    link_to(label, "https://library.temple.edu/pages/42")
  end

  def former_search_link
    link_to("former Library Search", "https://temple-primo.hosted.exlibrisgroup.com/primo-explore/search?vid=TULI&lang=en_US&sortby=rank")
  end

  def help_link
    link_to t("ask_librarian"), Rails.configuration.ask_link, target: "_blank", class: "text-red"
  end

  def explanation_translations(controller_name)
    case controller_name
    when "primo_central"
      t("articles.explanation_html")
    when "journals"
      t("#{controller_name}.explanation_html")
    when "catalog"
      t("blacklight.explanation_html")
    when "databases"
      t("databases.home_html")
    when "web_content"
      t("web_content.explanation_html")
    else
      ""
    end
  end

  def ris_path(opts = {})
    if controller_name == "bookmarks"
      bookmarks_path(opts.merge(format: "ris"))
    elsif controller_name == "primo_central"
      article_document_path(opts.merge(format: "ris"))
    else
      solr_document_path(opts.merge(format: "ris"))
    end
  end

  # Overrides the helper method from the Blacklight RIS gem so that we can use @documents.
  def render_ris(documents)
    @documents.map { |x| x.export_as(:ris) }.compact.join("\n")
  end

  def render_nav_link(path, name, analytics_id = nil)
    active = is_active?(path) ? [ "active" ] : []
    button_class = ([ "nav-item nav-link header-links" ] + active).join(" ")

    link_to(name, send(path, search_params), id: analytics_id, class: button_class)
  end

  def search_params
    # current_search_session is only defined under search context:
    # Therefore it will not be available in /users/sign_in etc.
    begin
      # Sometimes current_search_session will return nil.
      current_search_session&.query_params&.except(:controller, :action) || {}
    rescue
      {}
    end
  end

  def is_active?(path)
    url_path = send(path)
    root_page = [ :everything_path ]
    request.original_fullpath.match?(/^#{url_path}/) ||
      current_page?(root_path) && root_page.include?(path)
  end

  def citation_labels(format)
    case format
    when "APA"
      format = "APA (6th)"
    when "MLA"
      format = "MLA (7th)"
    when "CHICAGO"
      format = "Chicago Author-Date (15th)"
    when "HARVARD"
      format = "Harvard (18th)"
    when "TURABIAN"
      format = "Chicago Notes & Bibliography (15th)/Turabian (6th)"
    end
  end

  def presenter_field_value(presenter, field)
    if blacklight_config.show_fields[field]
      presenter.field_value(blacklight_config.show_fields[field])
    end
  end

  def border_radius_class
    if search_fields.length == 1
      "rounded-left"
    end
  end
end
