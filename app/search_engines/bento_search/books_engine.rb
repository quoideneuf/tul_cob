# frozen_string_literal: true

module BentoSearch
  class BooksEngine < BlacklightEngine
    def search_implementation(args)
      query = args.fetch(:query, "")
      @user_params = { q: query, f: { format: ["Book"] } }

      response = search_results(&proc_remove_facets).first.response
      results(response)
    end
  end
end
