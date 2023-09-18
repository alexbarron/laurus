module DeveloperAppsHelper
    def render_changelog_event(version)
        user = User.find(version.whodunnit)
        result = ""
        
        version.changeset.each do |key,value|
            change_item = "<li>#{version.created_at.strftime("%d %b %Y at %H:%M")}: #{user.name} changed #{key} from #{value[0]} to #{value[1]}</li>"
            result += change_item
        end
        return result.html_safe
    end
end
