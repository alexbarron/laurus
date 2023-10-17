json.extract! app_invitation, :id, :inviter_id, :invitee_id, :invitee_email, :developer_app_id, :admin, :status, :created_at, :updated_at
json.url app_invitation_url(app_invitation, format: :json)
