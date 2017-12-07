module ApplicationHelper
  def with_full_profile?
    current_user && current_user.profile&.persisted?
  end
end
