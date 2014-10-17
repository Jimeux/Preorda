class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_departments

  def set_departments
    # Needed on all pages for the section headings and footer
    @departments ||= Department.all
  end

end
