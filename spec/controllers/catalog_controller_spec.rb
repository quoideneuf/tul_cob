# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogController, type: :controller do


  let(:doc_id) { "991012041239703811" }
  let(:mock_response) { instance_double(Blacklight::Solr::Response) }
  let(:mock_document) { instance_double(SolrDocument) }

  describe "show action" do
    it "gets the staff_view_path" do
      get :show, params: { id: doc_id }
      expect(staff_view_path).to eq("/catalog/#{doc_id}/staff_view")
    end

    it "is properly routed for staff_view" do
      expect(get: "/catalog/:id/staff_view").to route_to(controller: "catalog", action: "librarian_view", id: ":id")
    end
  end

  describe "GET index as json" do
    render_views
    before do
      get(:index, params: { q: "education" }, format: :json)
    end
    let(:docs) { JSON.parse(response.body)["response"]["docs"] }
    # Collect the keys from the document hashes into a single array
    let(:docs_keys) { docs.collect { |doc| doc.keys }.flatten.uniq }
    let(:expected_keys) {
      %w[ id imprint_display creator_display pub_date
          format isbn_display lccn_display
        ]
    }

    context "an individual index result" do
      it "has an the expected fields" do
        expected_keys.each do |key|
          expect(docs_keys).to include key
        end
      end
    end
  end

  describe "using lower case boolen operators in normal search" do
    render_views
    let(:uppercase_and) { JSON.parse(get(:index, params: { q: "race affirmative action AND higher education" }, format: :json).body)["response"]["pages"]["total_count"] }
    let(:lowercase_and) { JSON.parse(get(:index, params: { q: "race affirmative action and higher education " }, format: :json).body)["response"]["pages"]["total_count"] }

    it "returns more results that using uppercase boolean" do
      expect(lowercase_and).to be > uppercase_and
    end
  end

  describe "using & or and produce the same results" do
    render_views
    let(:letters_and) { JSON.parse(get(:index, params: { q: "pride and prejudice" }, format: :json).body)["response"]["pages"]["total_count"] }
    let(:ampers_and) { JSON.parse(get(:index, params: { q: "pride & prejudice" }, format: :json).body)["response"]["pages"]["total_count"] }

    it "returns the same number of results" do
      expect(letters_and).to eql ampers_and
    end
  end

  describe "Boundwith Host records should not have been indexed" do
    render_views
    let(:bwh) { JSON.parse(get(:index, params: { q: "22293201420003811" }, format: :json).body)["response"]["pages"]["total_count"] }

    it "returns no results" do
      expect(bwh).to eql 0
    end
  end

  describe "Handling rapidill formatted requests" do
    it "routes the request to the show page of the item in the rft.mms_id param" do
      expect(get(:index, params: { "rft.mms_id" => 123 })).to redirect_to solr_document_path(123)
    end
  end


end
