class SearchesController < ApplicationController
  def show
    es = Elasticsearch::Client.new

    @q = params[:q]

    if @q
      @results = es.search(index: 'crz', body: {
        query: {
          bool: {
            must: [
              multi_match: {
                query: @q,
                type: :most_fields,
                fields: ['supplier_name^3', :identifier, :subject, :note, :description, :department]
              }
            ],
            filter: [
              build_filters
            ]
          }
        },
        # sort: {amount: :desc},
        highlight: {fields: {'*': {}}},
        aggs: {
          by_supplier: {
            terms: {
              field: 'supplier_name.untouched',
              size: 10
            }
          },
          by_price: {
            histogram: {
              field: 'amount',
              interval: 1000,
              min_doc_count: 1
            }
          }
        }
      })
    end
  end

  def build_filters
    if params[:supplier]
      {
        term: {'supplier_name.untouched': params[:supplier]}
      }
    else
      {}
    end
  end
end
