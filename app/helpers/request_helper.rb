# frozen_string_literal: true

module RequestHelper
  include Blacklight::CatalogHelperBehavior

  def request_modal(mms_id, pickup_locations, request_level)
    link_to(t("requests.request_button"), "#", id: "request-btn-#{mms_id}", class: "btn btn-sm btn-primary request-button search-results-request-btn float-right", data: { "blacklight-modal": "trigger", "action": "availability#modal show#loading", "target": "availability.href show.href" })
  end

  def request_redirect_url(mms_id)
    url = direct_request_options_url(mms_id: mms_id)
    new_user_session_with_redirect_path(url)
  end

  def ez_borrow_link_with_updated_query(url)
    uri = URI.parse(url)
    params = CGI.parse(uri.query)
    new_params = params.select { |key, value| ["group", "LS", "dest", "PI", "RK", "rft.title"].include? key }

    URI::HTTPS.build(
      host: uri.host,
      path: uri.path,
      query: URI.encode_www_form(new_params)).to_s
  end

  def successful_request_message
    t("requests.success_message_html", href: link_to(t("requests.success_message_href"), users_account_path))
  end

  def modal_exit_button_name(make_modal_link)
    name = raw("&times;")

    if make_modal_link
      render_nav_link(:search_catalog_path, name)
    else
      name
    end
  end
end
