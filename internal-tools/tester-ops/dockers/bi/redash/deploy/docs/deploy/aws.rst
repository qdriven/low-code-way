Amazon Web Services (AWS)
=========================

Simple Email Service (SES)
--------------------------

Reference: `Setting up Email with Amazon SES <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-set-up.html>`__

Verify a domain
~~~~~~~~~~~~~~~

#. Go to SES' `Domains <https://console.aws.amazon.com/ses/home?region=us-east-1#verified-senders-domain:>`__:

   #. Click *Verify a New Domain*
   #. Enter the domain in *Domain:*
   #. Check the *Generate DKIM Settings* box
   #. Click *Verify This Domain*

#. Go to GoDaddy's `DNS Management <https://dcc.godaddy.com/manage/OPEN-CONTRACTING.ORG/dns>`__:

   #. Add the TXT and CNAME records. Add the MX record if none exists.

      .. note::

         SES' *DKIM Record Set* is a scrollable table with three records.

      .. note::

         Omit ``.open-contracting.org`` from hostnames. GoDaddy appends it automatically.

   #. `Add or update the SPF record <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-spf.html>`__

#. Wait for the domain's verification status to become "verified" on SES' `Domains <https://console.aws.amazon.com/ses/home?region=us-east-1#verified-senders-domain:>`__

   .. note::

      AWS will notify you by email. Last time, it took a few minutes.

Reference: `Verifying a Domain <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domain-procedure.html>`__

Verify an email address
~~~~~~~~~~~~~~~~~~~~~~~

#. Check that the domain's verification status is "verified" on SES' `Domains <https://console.aws.amazon.com/ses/home?region=us-east-1#verified-senders-domain:>`__

#. If an MX record didn't exist, go to SES' `Rule Sets <https://console.aws.amazon.com/ses/home?region=us-east-1#receipt-rules:>`__:

   #. Click *Create a New Rule Set*
   #. Click the rule set's name
   #. Click *Create Rule*
   #. Click *Next Step*
   #. Select "S3" from the *Add action* dropdown
   #. Select "Create S3 bucket" from the *S3 bucket* dropdown
   #. Enter a bucket name in *Bucket Name*
   #. Click *Create Bucket*
   #. Click *Next Step*
   #. Enter a rule name in *Rule Name*
   #. Click *Next Step*
   #. Click *Create Rule*
   #. Go to SES' `Rule Sets <https://console.aws.amazon.com/ses/home?region=us-east-1#receipt-rules:>`__
   #. Check the rule set's box
   #. Click *Set as Active Rule Set*

#. Go to SES' `Email Addresses <https://console.aws.amazon.com/ses/home?region=us-east-1#verified-senders-email:>`__:

   #. Click *Verify a New Email Address*
   #. Enter the email address in *Email Address:*
   #. Click *Verify This Email Address*

#. If an MX record didn't exist, go to `S3 <https://s3.console.aws.amazon.com/s3/home?region=us-east-1#>`__ (otherwise, check your email):

   #. Click the bucket name
   #. Click the long alpha-numeric string (if there is none, double-check the earlier steps)
   #. Click *Download*
   #. Copy the URL in the downloaded file
   #. Open the URL in a web browser

#. Check that the email address's verification status is "verified" on SES' `Email Addresses <https://console.aws.amazon.com/ses/home?region=us-east-1#verified-senders-email:>`__

#. If an MX record didn't exist, cleanup:

   #. Delete the bucket
   #. Disable and delete the rule set
   #. Remove the MX record

Reference: `Verifying an Email Address <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-email-addresses-procedure.html>`__

Create SMTP credentials
~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   You only need to do this once per AWS region.

#. Go to SES' `SMTP Settings <https://console.aws.amazon.com/ses/home?region=us-east-1#smtp-settings:>`__:

   #. Click *Create My SMTP Credentials*
   #. Enter a user name in *IAM User Name:*
   #. Click *Create*
   #. Click *Download Credentials*
   #. Click *Close*

Reference: `Getting Your SMTP Credentials <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/get-smtp-credentials.html>`__

Move out of sandbox
~~~~~~~~~~~~~~~~~~~

.. note::

   You only need to do this once per AWS account.

Reference: `Moving Out of the Amazon SES Sandbox <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/request-production-access.html>`__

Set up MAIL FROM domain
~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   This optional step improves email deliverability.

Reference: `Setting up a custom MAIL FROM domain <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/mail-from.html>`__

Disable account-level suppression list
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   This optional step can negatively affect sender reputation.

Reference: `Disabling the account-level suppression list <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-email-suppression-list.html#sending-email-suppression-list-disabling>`__

Set up notifications
~~~~~~~~~~~~~~~~~~~~

#. Go to SNS' `Topics <https://console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics>`__:

   #. Click *Create topic*
   #. Set *Type* to *Standard*
   #. Enter a hyphenated address in *Name* (``data-open-contracting-org``, for example)
   #. Click *Create topic*

#. Click *Create subscription*:

   #. Select "Email" from the *Protocol* dropdown
   #. Enter an email address in *Endpoint*
   #. Click *Create subscription*

#. Click the email address on SES' `Email Addresses <https://console.aws.amazon.com/ses/home?region=us-east-1#verified-senders-email:>`__:

   #. Expand *Notifications*
   #. Click *Edit configuration*
   #. Select the created topic from the *Bounces:* dropdown
   #. Check the *Include original headers* box
   #. Select the created topic from the *Complaints:* dropdown
   #. Check the *Include original headers* box
   #. Click *Save Config*

Reference: `Configuring Amazon SNS notifications for Amazon SES <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/configure-sns-notifications.html>`__

Check DMARC compliance
~~~~~~~~~~~~~~~~~~~~~~

:ref:`check-dmarc-compliance`, sending the email using SES.

.. note::

   `SES adds two DKIM signatures <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/troubleshoot-dkim.html>`__ ("The extra DKIM signature, which contains ``d=amazonses.com``, is automatically added by Amazon SES. You can ignore it"). This signature's domain is not aligned, but according to `RFC 7489 <https://tools.ietf.org/html/rfc7489#page-10>`, "a single email can contain multiple DKIM signatures, and it is considered to be a DMARC "pass" if any DKIM signature is aligned and verifies."

Debug delivery issues
~~~~~~~~~~~~~~~~~~~~~

Bounces and complaints are sent to the subscribed address. The relevant properties of the notification message are:

-  `complaintSubType <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/notification-contents.html#complaint-object>`__ (`Viewing a list of addresses that are on the account-level suppression list <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-email-suppression-list.html#sending-email-suppression-list-view-entries>`__, `Removing an email address from the account-level suppression list <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-email-suppression-list.html#sending-email-suppression-list-manual-delete>`__)

-  `bounceType <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/notification-contents.html#bounce-types>`__ and ``bounceSubType``
-  `diagnosticCode <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/notification-contents.html#bounced-recipients>`__

Reference: `DNS Blackhole List (DNSBL) FAQs <https://docs.aws.amazon.com/ses/latest/DeveloperGuide/faqs-dnsbls.html>`__

Aurora Serverless
-----------------

Note: `"You can't give an Aurora Serverless DB cluster a public IP address." <https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html#aurora-serverless.limitations>`__; instead, you need to use an EC2 instance as a bastion host.

Create a VPC
~~~~~~~~~~~~

#. Set *IPv4 CIDR block* to 10.0.0.0/16
#. Click *Create*

Reference: `Create a DB instance in the VPC <https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.CreateDBInstanceInVPC>`__

Create subnets
~~~~~~~~~~~~~~

#. Set *VPC* to the created VPC
#. Set *Availability Zone* to any zone
#. Set *IPv4 CIDR block* to 10.0.1.0/24
#. Click *Create*

Then:

#. Set *VPC* to the created VPC
#. Set *Availability Zone* to another zone
#. Set *IPv4 CIDR block* to 10.0.2.0/24
#. Click *Create*

Create security group
~~~~~~~~~~~~~~~~~~~~~

#. Set *Security group name* to "postgresql-anywhere"
#. Set *Description* to "Allows PostgreSQL connections from anywhere"
#. Click *Add rule* under *Inbound rules*
#. Set *Type* to "PostgreSQL"
#. Set *Source* to "Anywhere"
#. Click *Create security group*

Create database
~~~~~~~~~~~~~~~

#. Choose a database creation method: (no changes)
#. Engine options

   #. *Engine type*: Amazon Aurora
   #. *Edition*: Amazon Aurora with PostgreSQL compatibility
   #. *Version*: Aurora PostgreSQL (compatible with PostgreSQL 10.7)

#. Database features: Serverless
#. Settings: (no changes)
#. Capacity settings

   #. *Minimum Aurora capacity unit*: 2
   #. *Maximum Aurora capacity unit*: 2
   #. Expand *Additional scaling configuration*
   #. Check *Pause compute capacity after consecutive minutes of inactivity*
   #. Set to *1* hours 0 minutes 0 seconds

#. Connectivity

   #. *Virtual private cloud (VPC)*: Select the created VPC
   #. Expand *Additional connectivity configuration*
   #. *VPC security group*:

      #. Select the created group
      #. Remove the default group

   #. Check *Data API*

#. Additional configuration

   #. *Initial database name*: common
   #. *Backup retention period*: 1 day

#. Click *Create database*
