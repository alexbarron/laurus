module DeveloperAppsHelper
  def render_activity(version)
    user = User.find(version.whodunnit)
    if version.item_type == "DeveloperApp"
      process_developer_app_activity(version, user)
    elsif version.item_type == "AppMembership"
      process_app_membership_activity(version, user)
    end
  end

  private

  def process_developer_app_activity(version, user)
    result = generate_prefix(version, user)
    if version.event == "create"
      result += "created app: #{version.changeset['name'][1]}</li>"
    elsif version.event == "update"
      version.changeset.each do |key, value|
        change_item = "changed #{key} from #{value[0]} to #{value[1]}</li>"
        result += change_item
      end
    end
    result.html_safe
  end

  def process_app_membership_activity(version, user)
    affected_user = AppMembership.find(version.item_id).user
    result = generate_prefix(version, user)
    if version.event == "update" && version.changeset.key?(:admin)
      new_role = version.changeset[:admin][1] ? "Admin" : "Read-only"
      result += "changed #{affected_user.name}'s role to #{new_role}</li>"
    elsif version.event == "update" && version.changeset.key?(:deleted_at)
      result += "removed #{affected_user.name}</li>"
    end
    result.html_safe
  end

  def generate_prefix(version, user)
    "<li>#{version.created_at.strftime('%d %b %Y at %H:%M')}: #{user.name} "
  end
end
