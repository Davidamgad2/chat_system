class DropActiveStorageAndActionMailboxTables < ActiveRecord::Migration[6.0]
  def change
    if table_exists?(:active_storage_blobs)
      drop_table :active_storage_blobs
    end

    if table_exists?(:active_storage_attachments)
      drop_table :active_storage_attachments
    end

    if table_exists?(:action_mailbox_inbound_emails)
      drop_table :action_mailbox_inbound_emails
    end

    if table_exists?(:action_mailbox_routing)
      drop_table :action_mailbox_routing
    end
  end
end
