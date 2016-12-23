ENV['DOTENV'] = 'spec/data/test.env'

FakeWeb.allow_net_connect = false

def register_pantry(prefix, file_basename)
  auth = "#{prefix}-user:#{prefix}-password"
  url = "https://#{auth}@api.fieldbook.com/v1/#{prefix}-book/#{prefix}-sheet"
  body = File.read("spec/data/#{file_basename}.json")

  FakeWeb.register_uri(:get, url, body: body, content_type: 'application/json')
end

register_pantry('test', 'pantry')
register_pantry('override', 'other_pantry')
