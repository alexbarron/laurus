class AppInvitationMailer < ApplicationMailer

    def invited(app_invitation)
        @app_invitation = app_invitation

        mail to: app_invitation.invitee_email, subject: "You've been invited to join the #{app_invitation.developer_app.name} team"
    end
end
