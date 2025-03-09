# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SamcartApi::Paginator do
  let(:client) { instance_double(SamcartApi::Client) }
  let(:limit) { 3 } # Number of items per page
  let(:total_resources) { 10 }
  let(:path) { '/resource' }

  let(:resources_data) do
    Array.new(total_resources) { |i| { 'id' => i + 1, 'name' => "resource ##{i + 1}" } }
  end

  before do
    allow(client).to receive(:get).and_return(stub_paginated_response(1, limit))
  end

  def stub_paginated_response(page, per_page)
    start_index = (page - 1) * per_page
    end_index = start_index + per_page - 1

    {
      'data' => resources_data[start_index..end_index] || [],
      'pagination' => {
        'next' => end_index < total_resources - 1 ? "/resources?page=#{page + 1}&limit=#{per_page}" : nil,
      },
    }
  end

  it 'fetches paginated resources correctly using `next_page`' do
    # Stub paginated responses dynamically
    (1..4).each do |page|
      response = stub_paginated_response(page, limit)
      allow(client).to receive(:get).with("/resources?page=#{page}&limit=#{limit}").and_return(response)
    end

    paginator = described_class.new(client, path, { limit: })
    all_resources = []

    all_resources.concat(paginator.next_page) while paginator.next_page?

    expect(all_resources.size).to eq(total_resources)
    expect(all_resources.map { |o| o['id'] }).to match_array((1..10).to_a)
  end

  it 'iterates over each page using `each_page`' do
    (1..4).each do |page|
      response = stub_paginated_response(page, limit)
      allow(client).to receive(:get).with("/resources?page=#{page}&limit=#{limit}").and_return(response)
    end

    paginator = described_class.new(client, path, { limit: })
    all_resources = []

    paginator.each_page do |page_resources|
      all_resources.concat(page_resources)
    end

    expect(all_resources.size).to eq(total_resources)
    expect(all_resources.map { |o| o['id'] }).to match_array((1..10).to_a)
  end
end
