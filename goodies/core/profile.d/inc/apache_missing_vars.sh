# This script was meant to fix the apache warnings
# [core:warn] [pid …:tid …] AH00111: Config variable ${WD_TZ} is not defined
# [core:warn] [pid …:tid …] AH00111: Config variable ${MYCL_ID} is not defined
# … but unfortunately, while setting them here makes them available in the
# SSH session, it has no effect on apache.

# export WD_TZ=UTC
# export MYCL_ID=0

