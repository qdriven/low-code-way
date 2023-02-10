{% from 'lib.sls' import set_firewall %}

{{ set_firewall("PUBLIC_SSH") }}
