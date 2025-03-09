# frozen_string_literal: true

RSpec.shared_examples 'a paginated API resource' do |resource_path|
  let(:client) { instance_double(SamcartApi::Client) }
  let(:limit) { 3 } # Number of items per page
  let(:total_resources) { 10 }
  let(:path) { resource_path }

  let(:resources_data) do
    Array.new(total_resources) { |i| { 'id' => i + 1, 'name' => "resource ##{i + 1}" } }
  end

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(client).to receive(:get).and_return(stub_paginated_response(1, limit))
  end

  def stub_paginated_response(page, per_page)
    start_index = (page - 1) * per_page
    end_index = start_index + per_page - 1

    {
      'data' => resources_data[start_index..end_index] || [],
      'pagination' => {
        'next' => end_index < total_resources - 1 ? "#{path}?page=#{page + 1}&limit=#{per_page}" : nil,
      },
    }
  end

  it 'returns a Paginator instance' do
    paginator = described_class.all

    expect(paginator).to be_a(SamcartApi::Paginator)
  end

  it 'fetches all resources using pagination' do
    # Stub API responses for paginated requests
    (1..4).each do |page|
      allow(client).to receive(:get).with("#{path}?page=#{page}&limit=#{limit}").and_return(stub_paginated_response(
        page, limit
      ))
    end

    resources = []
    described_class.all(limit: limit).each_page do |page_resources|
      resources.concat(page_resources)
    end

    expect(resources.size).to eq(total_resources)
    expect(resources.pluck('id')).to match_array((1..10).to_a)
  end
end
