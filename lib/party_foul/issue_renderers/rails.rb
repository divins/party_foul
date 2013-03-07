class PartyFoul::IssueRenderers::Rails < PartyFoul::IssueRenderers::Rack
  # Rails params hash. Filtered parms are respected.
  #
  # @return [Hash]
  def params
    parameter_filter = ActionDispatch::Http::ParameterFilter.new(env["action_dispatch.parameter_filter"])
    parameter_filter.filter(env['action_dispatch.request.path_parameters'])
  end

  # Rails session hash. Filtered parms are respected.
  #
  # @return [Hash]
  def session
    parameter_filter = ActionDispatch::Http::ParameterFilter.new(env['action_dispatch.parameter_filter'])
    parameter_filter.filter(env['rack.session'])
  end

  def http_headers
    super.merge(Referer: referer)
  end

  private

  def app_root
    Rails.root
  end

  def raw_title
    %{#{env['action_controller.instance'].class}##{env['action_dispatch.request.path_parameters']['action']} (#{exception.class}) "#{exception.message}"}
  end

  # Get the referer in a Rails environment
  #
  # @return [String]
  def referer
    referer = env['action_controller.instance'].request.env['HTTP_REFERER']
  end
end
