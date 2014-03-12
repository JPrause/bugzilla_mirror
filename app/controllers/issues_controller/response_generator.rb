class IssuesController
  module ResponseGenerator
    def issue_to_hash(issue)
      return {} unless issue
      issue_hash  = issue.attribute_names.each_with_object({}) do |key, hash|
        hash[key] = issue[key] if issue.respond_to?(key)
      end
      issue_hash.delete("id") # Let's not show the Issue id so there's no confusion.
      Issue::ASSOCIATIONS.each do |key, association|
        if expand?("associations") || !attribute_selection
          associated_bug_id_method = "#{association}_bug_ids".to_sym
          next unless issue.respond_to?(associated_bug_id_method)
          issue_hash[key.to_s] = issue.send(associated_bug_id_method)
        end
      end
      if expand?("comments") || show_attribute?("comments")
        issue_hash["comments"] = issue.comments.order("count ASC").collect do |comment|
          Comment::ATTRIBUTES.each_with_object({}) do |key, hash|
            hash[key.to_s] = comment[key]
          end
        end
      end

      flags = issue_hash["flags"]
      issue_hash["flags"] = Bugzilla.flags_to_hash(flags) unless flags.blank?
      issue_hash
    end

    def response_to_hash(response)
      case response
      when Hash
        response
      when Array
        response.collect { |issue| issue_to_hash(issue) }
      else
        issue_to_hash(response)
      end
    end

    def generate_response
      klass  = Issue

      id  = params["id"]
      return get_one_issue(id) if id

      ids = params["bug_ids"]
      return get_multiple_issues(ids) if ids

      result =
        if attribute_selection
          klass.select(attribute_selection_in_model)
        else
          klass.scoped
        end
      result = result.where(search_selection) if search_param
      result = result.where(sqlfilter_param)  if sqlfilter_param
      result = result.reorder(sort_params)    if sort_params
      if paginate_params?
        req_offset, req_limit = expand_paginate_params
        result = result.offset(req_offset).limit(req_limit)
      end
      result.collect { |item| item }
    end

    def render_accepted_response(response = {"status" => "Request Accepted for Processing"})
      render :json => response, :status => 202
    end

    def render_nocontent_response
      render :nothing => true, :status => 204
    end

    #
    # Verifies we can handle the response format requested, i.e. :json or raise an error
    #
    def validate_response_format
      accept = request.headers["Accept"]
      return :json if accept.include?("json") || accept.include?("*/*")
      raise IssuesController::UnsupportedMediaTypeError, "Invalid Response Format #{accept} requested"
    end
  end
end
