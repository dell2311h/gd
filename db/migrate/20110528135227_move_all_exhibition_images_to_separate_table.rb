require 'pp'
class MoveAllExhibitionImagesToSeparateTable < ActiveRecord::Migration
  def self.up
    Exhibition.all.each do |exhibition|
      exhibition.images << Image.create(
                                          :file => exhibition.image,
                                          :kind => Image::KINDS[:default],
                                          :artist => exhibition.image_artist,
                                          :title => exhibition.image_title,
                                          :year => exhibition.image_year,
                                          :credit => exhibition.image_credit
                                        ) if exhibition.image?
                                        
      exhibition.images << Image.create(:file => exhibition.publication_pdf, :kind => Image::KINDS[:publication_pdf], :title => Image::KINDS[:publication_pdf_title]) if exhibition.publication_pdf?
      
      exhibition.exhibition_attachments.each do |att|
        exhibition.images << Image.create(
                                            :file => att.attachment,
                                            :kind => Image::KINDS[:attachment],
                                            :artist => att.artist,
                                            :title => att.title,
                                            :year => att.year,
                                            :credit => att.credit
                                          ) if att.attachment?
      end
      pp exhibition.title
    end
  end

  def self.down
  end
end
