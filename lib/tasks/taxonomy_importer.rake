namespace :db do
  task :add_categories => :environment do
    file_to_load  = Rails.root + "config/taxonomy.en-US.txt"
    taxonomies    = File.read( file_to_load )

    taxonomies.each_line do |line|
      cats = line.split('>')
      cats.each_with_index do |cat, i|
        cat = cat.gsub(/\n/, '').strip.chomp.downcase
        pt = ProductType.find_by_name(cat)
        unless pt
          parent = i > 1 ? ProductType.find_by_name(cats[i-1].gsub(/\n/, '').strip.chomp.downcase).try(:id) : nil
          ProductType.create(name: cat, parent_id: parent)
        end
      end
    end
  end
end