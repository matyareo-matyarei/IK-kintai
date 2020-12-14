def spreadsheetset
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')
  key = '17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M'
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title('水野雅之')

end  
