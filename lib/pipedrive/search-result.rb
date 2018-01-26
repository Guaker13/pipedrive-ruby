module Pipedrive
  class SearchResult < Base
    # Class Methods
    class << self
      def search(term, start = 0, limit = nil, opts = {})
        set_base_uri(opts)
        params = auth_params(opts)
        params[:query] ||= {}
        params[:query].merge!(term: term, start: start, limit: limit)
        res = get resource_path, params
        if res.ok?
          res['data'].nil? ? [] : res['data'].map { |obj| new(obj) }
        else
          bad_response(res, term: term, start: start, limit: limit)
        end
      end

      def field(term, field_type, field_key, opts = {})
        set_base_uri(opts)
        params = auth_params(opts)
        params[:query] ||= {}
        params[:query].merge!(term: term,
                              field_type: field_type,
                              field_key: field_key)
        res = get "#{resource_path}/field", params
        if res.ok?
          res['data'].nil? ? [] : res['data'].map { |obj| new(obj) }
        else
          bad_response(res, { term: term, field_type: field_type, field_key: field_key }.merge(opts))
        end
      end
    end
  end
end
