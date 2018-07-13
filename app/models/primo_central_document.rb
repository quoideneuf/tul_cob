# frozen_string_literal: true

class PrimoCentralDocument
  require "blacklight/primo_central"

  include Blacklight::PrimoCentral::Document

  self.unique_key = :pnxId
  field_semantics.merge!(
    title: "title" ,
    part_of: "isPartOf",
    author: "creator",
    contributor: "contributor",
    date: "date",
    isbn: "isbn",
    issn: "issn",
    doi: "doi",
  )

  # Email uses the semantic field mappings below to generate the body of an email.
  PrimoCentralDocument.use_extension(Blacklight::Document::ArticleEmail)
end
