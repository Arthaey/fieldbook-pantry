FakeWeb.allow_net_connect = false

FakeWeb.register_uri(
  :get,
  'https://test-user:test-password@api.fieldbook.com/v1/test-book-id/test-sheet-name',
  body: File.read('spec/data/pantry.json'),
  content_type: 'application/json'
)
