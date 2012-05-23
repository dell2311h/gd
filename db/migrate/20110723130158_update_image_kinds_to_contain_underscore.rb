class UpdateImageKindsToContainUnderscore < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute("update images set kind='publication_pdf' where kind = 'publication pdf'")
    ActiveRecord::Base.connection.execute("update images set kind='attachment_art' where kind = 'attachment-art'")
    ActiveRecord::Base.connection.execute("update images set kind='attachment_installation' where kind = 'attachment-installation'")
    ActiveRecord::Base.connection.execute("update images set kind='attachment_reception' where kind = 'attachment-reception'")
    ActiveRecord::Base.connection.execute("update images set kind='attachment_other' where kind = 'attachment-other'")
  end

  def self.down
    ActiveRecord::Base.connection.execute("update images set kind='publication pdf' where kind = 'publication_pdf'")
    ActiveRecord::Base.connection.execute("update images set kind='attachment-art' where kind = 'attachment_art'")
    ActiveRecord::Base.connection.execute("update images set kind='attachment-installation' where kind = 'attachment_installation'")
    ActiveRecord::Base.connection.execute("update images set kind='attachment-reception' where kind = 'attachment_reception'")
    ActiveRecord::Base.connection.execute("update images set kind='attachment-other' where kind = 'attachment_other'")
  end
end
