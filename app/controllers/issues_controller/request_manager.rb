class IssuesController
  module RequestManager
    def update_issues
      bug_id  = params["id"]
      request = json_body.dup
      raise BadRequestError, "Must specify an issue Id for performing an update" unless bug_id
      raise BadRequestError, "Blank update request specified" if request.blank?
      %w(id bug_id).each { |key| request.delete(key) }
      raise BadRequestError, "Must specify Non Id attributes in update request" if request.blank?
      issue = Issue.find_by_bug_id(bug_id)
      raise ActiveRecord::RecordNotFound, "Issue #{bug_id} specified does not exist" if issue.blank?

      bz = Bugzilla.new(@auth_username, @auth_password)

      bug_hash = bz.update_issue(bug_id, request)
      unless bug_hash.blank?
        begin
          Bugzilla.bug_to_issue(bug_id, bug_hash, Issue::ATTRIBUTES | [:comments])
        rescue StandardError => e
          log_error "Failed to Load Updated Issue #{bug_id} from #{bz_uri} - #{e}"
          log_error "Backtrace: #{e.backtrace.join('\n')}"
        end
      end

      get_one_issue(bug_id)
    end

    def refresh_issue
      id = params["id"]
      raise BadRequestError, "Must specify an issue Id for performing a refresh" unless id
      WorkerManager.update_issues_from_bugzilla([id])
      {}
    end

    def get_one_issue(id)
      klass  = Issue
      result = klass.where(:bug_id => id)
      attribute_selection ? result.select(attribute_selection_in_model).first : result.first
    end

    def get_multiple_issues(id_list)
      klass  = Issue
      ids = id_list.gsub(",", " ").split(" ")

      ids.collect do |id|
        result = klass.where(:bug_id => id)
        attribute_selection ? result.select(attribute_selection_in_model).first : result.first
      end
    end
  end
end
