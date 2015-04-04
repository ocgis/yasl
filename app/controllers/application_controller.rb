class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_flags

  private

  def set_flags
    flags = { debug: false }
    flags.each do |k, v|
      unless params[k].nil?
        if params[k] == "true"
          flags[k] = true
        end
      end
    end

    @flags = OpenStruct.new(flags)
  end

end
