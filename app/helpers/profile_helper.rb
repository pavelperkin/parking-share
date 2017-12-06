module ProfileHelper
  def full_name(resource)
    if resource.first_name && resource.last_name
      [resource.first_name, resource.last_name].join(' ')
    else
      resource.email
    end
  end
end
