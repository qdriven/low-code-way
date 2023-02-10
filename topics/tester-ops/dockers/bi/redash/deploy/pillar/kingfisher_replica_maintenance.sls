maintenance:
  enabled: True
  patching: manual
  rkhunter_customisation: |
    ALLOWDEVFILE=/dev/shm/PostgreSQL.*
  hardware_sensors: True
  custom_sensors:
    - coretemp
    - nct6775
