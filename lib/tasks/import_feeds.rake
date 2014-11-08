namespace :import do
  desc 'Import all feeds'
  task feeds: :environment do
    Importer.import_feeds
  end
end
