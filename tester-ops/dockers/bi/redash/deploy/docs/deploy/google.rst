Google Workspace
================

Email
-----

Check DNS configuration
~~~~~~~~~~~~~~~~~~~~~~~

#. `Google Admin Toolbox Check MX <https://toolbox.googleapps.com/apps/checkmx/>`__ should report no problems (all green).
#. `MXToolBox Domain Health Report <https://mxtoolbox.com/emailhealth/>`__ should report no errors (only warnings).

.. _check-dmarc-compliance:

Check DMARC compliance
~~~~~~~~~~~~~~~~~~~~~~

Send an email to ping@tools.mxtoolbox.com and `check the results <https://mxtoolbox.com/deliverability>`__ (all green).

Similar tools include `mail-tester <https://www.mail-tester.com>`__ and `Postmark's Spam Check <https://spamcheck.postmarkapp.com>`__.

Monitor DMARC reports
~~~~~~~~~~~~~~~~~~~~~

open-contracting.org's DMARC policy sends reports to `DMARC Analyzer <https://app.dmarcanalyzer.com/>`__:

.. code-block:: bash

   dig TXT _dmarc.open-contracting.org

.. code-block:: none

   v=DMARC1; p=none; rua=mailto:e57de3ae23df489@rep.dmarcanalyzer.com; ruf=mailto:e57de3ae23df489@for.dmarcanalyzer.com; fo=1;

DMARC compliance should be over 95%, and DKIM alignment should be over 90%. Failures should be 3% or less.

.. note::

   Mailchimp is `not SPF aligned <https://dmarc.io/source/mailchimp/>`__; therefore, we have no target for SPF alignment. It `sends mail from <https://mailchimp.com/help/my-campaign-from-name-shows-mcsvnet/>`__ ``mcsv.net``, ``mcdlv.net``, ``mailchimpapp.net`` and ``rsgsv.net``.

When filtering per result, sending domains with volumes of less than 10 can be ignored, and SPF misalignment with ``calendar-server.bounces.google.com`` `can be ignored <https://dmarcian.com/google-calendar-invites-dmarc/>`__.
