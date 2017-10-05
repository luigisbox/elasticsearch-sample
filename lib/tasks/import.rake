namespace :import do
  task :mapping do
    es = Elasticsearch::Client.new

    es.indices.create(index: 'crz', body: {
      settings: {
        analysis: {
          analyzer: {
            whitespace_asciifolding: {
              tokenizer: :standard,
              filter: [:standard, :lowercase, :asciifolding]
            }
          }
        }
      },
      mappings: {
        contract: {
          properties: {
            identifier: {
              type: :keyword
            },
            supplier_name: {
              type: :text,
              analyzer: :whitespace_asciifolding,
              fields: {
                untouched: {
                  type: :keyword
                }
              }
            },
            subject: {
              type: :text,
              analyzer: :whitespace_asciifolding
            },
            effective_from: {
              type: :date
            },
            effective_to: {
              type: :date
            },
            amount: {
              type: :float
            },
            note: {
              type: :text,
              analyzer: :whitespace_asciifolding
            },
            description: {
              type: :text,
              analyzer: :whitespace_asciifolding
            },
            department: {
              type: :text,
              analyzer: :whitespace_asciifolding
            },
            attachments: {
              type: :text,
              analyzer: :whitespace_asciifolding
            }
          }
        }
      }
    })
  end

  task dump: :environment do
    es = Elasticsearch::Client.new

    Contract.find_each do |contract|
      es.index(index: 'crz', type: 'contract', body: {
        identifier: contract.contract_identifier,
        supplier_name: contract.supplier_name,
        subject: contract.subject,
        effective_from: contract.effective_from,
        effective_to: contract.effective_to,
        amount: contract.contract_price_total_amount,
        note: contract.note,
        description: contract.description,
        department: contract.department&.name,
        attachments: contract.attachments.map(&:title)
      })
    end
  end
end
