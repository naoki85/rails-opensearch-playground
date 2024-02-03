class DocumentsController < ApplicationController
  OPENSEARCH_INDEX_NAME = 'students'
  OPENSEARCH_URL = 'http://opensearch-node1:9200'

  def index
    response = client.search(index: OPENSEARCH_INDEX_NAME)
    @documents = response.dig("hits", "hits") || []
  end

  def new
  end

  def edit
    response = client.search(index: OPENSEARCH_INDEX_NAME, id: params[:id])
    @document = (response.dig("hits", "hits") || []).first
  end

  def create
    index_body = {
      'first_name': params['first_name'],
      'last_name': params['last_name'],
      'grade': params['grade'].to_i,
      'created': Time.zone.now
    }

    response = client.index(
      index: OPENSEARCH_INDEX_NAME,
      body: index_body,
      id: SecureRandom.hex(16),
      refresh: true
    )
    if response['error'].present?
      redirect_to render :new, status: :unprocessable_entity
    end

    redirect_to documents_url, notice: "Document was successfully created."
  end

  def update
    index_body = {
      'first_name': params['first_name'],
      'last_name': params['last_name'],
      'grade': params['grade'].to_i,
      'created': Time.zone.now
    }

    response = client.index(
      index: OPENSEARCH_INDEX_NAME,
      body: index_body,
      id: SecureRandom.hex(16),
      refresh: true
    )
    if response['error'].present?
      redirect_to render :edit, status: :unprocessable_entity
    end

    redirect_to documents_url, notice: "Document was successfully updated."
  end

  def destroy
    client.delete(
      index: OPENSEARCH_INDEX_NAME,
      id: params[:id],
      refresh: true
    )

    redirect_to documents_url, notice: "Document was successfully destroyed."
  end

  private

    def document_params
      params.fetch(:document, {})
    end

    def client
      @client ||= OpenSearch::Client.new(
        url: OPENSEARCH_URL,
        retry_on_failure: 5,
        request_timeout: 120,
        log: true
      )
    end
end
