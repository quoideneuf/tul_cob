# frozen_string_literal: true

# TODO: Remove once we no longer support article bookmarks.
class CatalogBookmarkSearch < CatalogController
  include Searcher
  include BookmarksConfig

  def self.handle_bookmark_search?(document_model)
    blacklight_config.document_model == document_model ||
      [ SolrJournalDocument ].include?(document_model)
  end
end
