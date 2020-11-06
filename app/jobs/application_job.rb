class ApplicationJob < ActiveJob::Base

  def google_drive
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['KPI_SHEET_CLIENT_ID'],
      client_secret: ENV['KPI_SHEET_CLIENT_SECRET'],
      scope: %w(https://www.googleapis.com/auth/drive https://spreadsheets.google.com/feeds/),
      redirect_uri: 'http://localhost'
    )
    credentials.refresh_token = ENV['KPI_SHEET_REFRESH_TOKEN']
    credentials.fetch_access_token!
    GoogleDrive::Session.from_credentials(credentials)
  end

end
