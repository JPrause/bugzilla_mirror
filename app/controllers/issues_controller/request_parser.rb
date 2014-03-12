class IssuesController
  module RequestParser
    def parse_api_request
      @req = {}
      @req[:method] = request.request_method.downcase.to_sym
    end

    def json_body
      @req[:body] ||= begin
        body =
          if request.body
            request.body.read.tap do |b|
              log_debug("\n#{@name} Request Body:\n#{b}")
            end
          end
        body.blank? ? {} : JSON.parse(body)
      end
    end

    def paginate_params?
      params['offset'] || params['limit']
    end

    def expand_param
      params['expand'] && params['expand'].split(",")
    end

    def expand?(what)
      expand_param ? expand_param.include?(what.to_s) : false
    end

    def expand_paginate_params
      offset = params['offset']   # 0 based
      limit  = params['limit']    # i.e. page size
      [offset, limit]
    end

    def sqlfilter_param
      params['sqlfilter']
    end

    def search_param
      params['search']
    end

    def search_selection
      return {} unless search_param
      search_param.split(",").each_with_object({}) do |param, hash|
        k, v = param.split("=")
        hash[k.to_sym] = v
      end
    end

    def attribute_selection
      return unless params['attributes']
      params['attributes'].split(",") | %w(id bug_id)  # Let's always include the bug_id
    end

    def attribute_selection_in_model
      attrs = attribute_selection
      return unless attrs
      result = []
      model_attrs = Issue::ATTRIBUTES | %w(id bug_id)
      model_attrs.each do |key|
        result << key.to_s if attrs.include?(key.to_s)
      end
      result
    end

    def show_attribute?(attr)
      return true unless attribute_selection
      attribute_selection.include?(attr.to_s)
    end

    #
    # Returns the ActiveRecord's option for :order
    #
    # i.e. ['attr1 [asc|desc]', 'attr2 [asc|desc]', ...]
    #
    def sort_params
      return [] unless params['sort_by']

      orders = (params['sort_order'] ? params['sort_order'].split(",") : [""])
      sort_order = params['sort_by'].split(",").zip(orders).collect do |attr, order|
        next if attr.blank?
        sort_item = attr
        sort_item << " ASC"  if order && order.downcase.start_with?("asc")
        sort_item << " DESC" if order && order.downcase.start_with?("desc")
        sort_item
      end
      sort_order.compact
    end
  end
end
