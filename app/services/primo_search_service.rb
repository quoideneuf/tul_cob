# frozen_string_literal: true

# TODO: Remove once we no longer support article bookmarks.
class PrimoSearchService < Blacklight::SearchService
  def fetch(primo_doc_ids, params = {})
    # Primo cannot string more than 10 OR queries.
    documents = []

    primo_doc_ids
      .map { |id| id.gsub(/^TN_/, "") }
      .each_slice(10) do |ids|
      @response, docs = super(ids)
      documents.append(*docs)
      documents.append(*docs_not_found(docs, ids))
    end

    @response["response"]["numFound"] = documents.count
    @response["response"]["docs"] = documents

    [@response, documents]
  end

  private
    def docs_not_found(docs, ids)
      if docs.length == ids.length
        []
      else
        (ids - docs.map(&:id))
          .map { |id| PrimoCentralDocument.new("pnxId" => id, "ajax" => true, "status" => "Attempting to reload...") }
      end
    end
end
