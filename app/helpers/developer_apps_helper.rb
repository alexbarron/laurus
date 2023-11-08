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
    activity = prefix(version, user)
    if version.event == "create"
      activity += app_creation(version)
    elsif version.event == "update" && version.changeset.key?(:archived_at)
      activity += app_archival_and_unarchival(version)
    elsif version.event == "update"
      activity += app_update(version)
    end
    activity.html_safe
  end

  def process_app_membership_activity(version, user)
    activity = prefix(version, user)
    if version.event == "update" && version.changeset.key?(:admin)
      activity += role_change(version)
    elsif version.event == "update" && version.changeset.key?(:deleted_at)
      activity += membership_removal(version)
    end
    activity.html_safe
  end

  def prefix(version, user)
    "<li>#{version.created_at.strftime('%d %b %Y at %H:%M')}: #{user.name} "
  end

  # Developer App activity methods
  def app_creation(version)
    "created app: #{version.changeset['name'][1]}</li>"
  end

  def app_update(version)
    activity = ""
    version.changeset.each do |key, value|
      activity += "changed #{key} from #{value[0]} to #{value[1]}</li>"
    end
    activity
  end

  def app_archival_and_unarchival(version)
    if version.changeset[:archived_at][1].nil?
      "reactivated the app"
    else
      "archived the app"
    end
  end

  # App Membership activity methods
  def affected_user(version)
    AppMembership.find(version.item_id).user
  end

  def role_change(version)
    new_role = version.changeset[:admin][1] ? "Admin" : "Read-only"
    "changed #{affected_user(version).name}'s role to #{new_role}</li>"
  end

  def membership_removal(version)
    "removed #{affected_user(version).name}</li>"
  end
end
