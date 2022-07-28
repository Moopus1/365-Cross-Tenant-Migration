# 365-Cross-Tenant-Migration

If you haven't known, Microsoft has had their cross-tenant migration available to move mailboxes from 365 to 365 tenants natively. However, the documentation on it is horrible, and they don't accurately explain how to properly create the users in the destination environment.

I've created 3 scripts to simplify the user data exports, new destination MailUser creation, and the final checks needed before you can create your migration batches.

These should hopefully allow for easier and cheaper 365-to-365 migrations, without needing to rely on a vendor tool like BitTitan.

The scripts contain more documentation within the comments and header info at the top.
