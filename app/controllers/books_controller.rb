# frozen_string_literal: true

class BooksController < CatalogController
  add_breadcrumb "Books", :back_to_books_path, options: { id: "breadcrumbs_book" }, only: [ :show ]
  add_breadcrumb "Record", :solr_book_document_path, only: [ :show ]

  configure_blacklight do |config|
    config.show.route = { controller: "books" }
    config.search_builder_class = BooksSearchBuilder
    config.document_model = ::SolrBookDocument
    # Do not allow any further filtering on type.
    config.facet_fields.delete("format")
  end
end
