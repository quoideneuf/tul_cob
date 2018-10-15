# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlacklightAdvancedSearch::RenderConstraintsOverride, type: :helper do
  describe "#guided_search" do

    example "empty search fields" do
      expect(helper.guided_search).to be_empty
    end
  end

  describe ".operator_default" do
    example "default" do
      expect(helper.operator_default(2)).to eq("contains")
    end

    example "two consecutive searches" do
      params = ActionController::Parameters.new(
        q_1: "james",
        q_2: "john",
        q_3: "david",
        operator: { "q_1" => "foo", "q_2" => "bar", "q_3" => "bum" }
      )
      allow(helper).to receive(:params).and_return(params)

      expect(helper.operator_default(2)).to eq("bar")
    end
  end

end

RSpec.describe AdvancedHelper, type: :helper do

  describe "label_tag_default_for" do
    example "basic search to search" do
      params = {
        "search_field" => "First Name",
        "q" => "james"
      }
      allow(helper).to receive(:params).and_return(params)

      expect(helper.label_tag_default_for("q_1")).to eq("james")
      expect(helper.label_tag_default_for("f_1")).to eq("First Name")
    end
  end

  describe "#render_advanced_search_link" do
    before(:each) do
      allow(helper).to receive(:current_page?).with("/catalog") { false }
      allow(helper).to receive(:current_page?).with("/books") { false }
      allow(helper).to receive(:current_page?).with("/journals") { false }
      allow(helper).to receive(:current_page?).with("/articles") { false }
      allow(helper).to receive(:params) { { q: "foo", controller: "bar" } }
    end

    context "on the catalog search page" do
      it "renders the link to the advanced form" do
        allow(helper).to receive(:current_page?).with("/catalog") { true }
        link = "<a class=\"advanced_search\" id=\"catalog_advanced_search\" href=\"/catalog/advanced?q=foo\">Advanced Catalog Search</a>"
        expect(helper.render_advanced_search_link).to eq(link)
      end
    end

    context "on the books search page" do
      it "renders the link to the advanced books form" do
        allow(helper).to receive(:current_page?).with("/books") { true }
        link = "<a class=\"advanced_search\" id=\"books_advanced_search\" href=\"/books/advanced?q=foo\">Advanced Books Search</a>"
        expect(helper.render_advanced_search_link).to eq(link)
      end
    end

    context "on the journals search page" do
      it "renders the link to the advanced journals form" do
        allow(helper).to receive(:current_page?).with("/journals") { true }
        link = "<a class=\"advanced_search\" id=\"journals_advanced_search\" href=\"/journals/advanced?q=foo\">Advanced Journals Search</a>"
        expect(helper.render_advanced_search_link).to eq(link)
      end
    end

    context "on the articles serch page" do
      it "renders the link to the advanced articles form" do
        allow(helper).to receive(:current_page?).with("/articles") { true }
        link = "<a class=\"advanced_search\" id=\"articles_advanced_search\" href=\"/articles/advanced?q=foo\">Advanced Articles Search</a>"
        expect(helper.render_advanced_search_link).to eq(link)
      end
    end
  end

  describe "#basic_search_path" do
    before(:each) do
      allow(helper).to receive(:current_page?).with("/catalog/advanced") { false }
      allow(helper).to receive(:current_page?).with("/books/advanced") { false }
      allow(helper).to receive(:current_page?).with("/journals/advanced") { false }
      allow(helper).to receive(:current_page?).with("/articles/advanced") { false }
    end

    context "on the advanced catalog search page" do
      it "renders the link to the catalog search" do
        allow(helper).to receive(:current_page?).with("/catalog/advanced") { true }
        expect(helper.basic_search_path).to eq("/catalog")
      end
    end

    context "on the advanced books search page" do
      it "renders the link to the books search" do
        allow(helper).to receive(:current_page?).with("/books/advanced") { true }
        expect(helper.basic_search_path).to eq("/books")
      end
    end

    context "on the advanced journals search page" do
      it "renders the link to the journals search" do
        allow(helper).to receive(:current_page?).with("/journals/advanced") { true }
        expect(helper.basic_search_path).to eq("/journals")
      end
    end

    context "on the advanced articles page" do
      it "renders the link to the articles search" do
        allow(helper).to receive(:current_page?).with("/articles/advanced") { true }
        expect(helper.basic_search_path).to eq("/articles")
      end
    end

    context "on some unknown page" do
      it "renders the link to the everything search" do
        allow(helper).to receive(:current_page?).with("/foo/advanced") { true }
        expect(helper.basic_search_path).to eq("/catalog")
      end
    end
  end

  describe "#advanced_search_form_title" do
    before(:each) do
      allow(helper).to receive(:current_page?).with("/catalog/advanced") { false }
      allow(helper).to receive(:current_page?).with("/books/advanced") { false }
      allow(helper).to receive(:current_page?).with("/journals/advanced") { false }
      allow(helper).to receive(:current_page?).with("/articles/advanced") { false }
    end

    context "on the advanced catalog search page" do
      it "renders the link to the catalog search" do
        allow(helper).to receive(:current_page?).with("/catalog/advanced") { true }
        expect(helper.advanced_search_form_title).to eq("Advanced Catalog Search")
      end
    end

    context "on the advanced books search page" do
      it "renders the link to the books search" do
        allow(helper).to receive(:current_page?).with("/books/advanced") { true }
        expect(helper.advanced_search_form_title).to eq("Advanced Books Search")
      end
    end

    context "on the advanced journals search page" do
      it "renders the link to the journals search" do
        allow(helper).to receive(:current_page?).with("/journals/advanced") { true }
        expect(helper.advanced_search_form_title).to eq("Advanced Journals Search")
      end
    end

    context "on the advanced articles page" do
      it "renders the link to the articles search" do
        allow(helper).to receive(:current_page?).with("/articles/advanced") { true }
        expect(helper.advanced_search_form_title).to eq("Advanced Articles Search")
      end
    end

    context "on some unknown page" do
      it "renders the link to the everything search" do
        allow(helper).to receive(:current_page?).with("/foo/advanced") { true }
        expect(helper.advanced_search_form_title).to eq("Advanced Catalog Search")
      end
    end
  end
end
