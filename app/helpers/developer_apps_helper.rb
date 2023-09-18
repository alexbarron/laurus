module DeveloperAppsHelper
    def render_changelog_event(version)
        user = User.find(version.whodunnit)
        result = ""
        if version.event == "create"
            result = "<li>#{version.created_at.strftime("%d %b %Y at %H:%M")}: #{user.name} created app: #{version.changeset["name"][1]}</li>"
        elsif version.event == "update"
            version.changeset.each do |key,value|
                change_item = "<li>#{version.created_at.strftime("%d %b %Y at %H:%M")}: #{user.name} changed #{key} from #{value[0]} to #{value[1]}</li>"
                result += change_item
            end
        end
        return result.html_safe
    end
end
