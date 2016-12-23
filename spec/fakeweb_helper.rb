ENV['DOTENV'] = 'spec/data/test.env'

FakeWeb.allow_net_connect = false

def register_pantry(prefix, file_basename = nil)
  file_basename ||= prefix
  auth = "#{prefix}-user:#{prefix}-password"
  url = "https://#{auth}@api.fieldbook.com/v1/#{prefix}-book/#{prefix}-sheet"
  body = File.read("spec/data/#{file_basename}.json")

  FakeWeb.register_uri(:get, url, body: body, content_type: 'application/json')
end

def with_env(basename, &block)
  register_pantry(basename)
  original_env = ENV.to_hash
  ENV['DOTENV'] = ''
  ENV['FIELDBOOK_KEY']        = "#{basename}-user"
  ENV['FIELDBOOK_SECRET']     = "#{basename}-password"
  ENV['FIELDBOOK_BOOK_ID']    = "#{basename}-book"
  ENV['FIELDBOOK_SHEET_NAME'] = "#{basename}-sheet"

  begin
    yield block
  ensure
    ENV.replace(original_env)
  end
end

register_pantry('test', 'pantry')
register_pantry('override', 'other_pantry')
