# Hours Sync (Harvest to TrackingTime)

We use Harvest to track billable time, but one of our clients tracks overall company hours spent in TrackingTime.  Instead of us manually transferring hours every day, this script transfers them for us.

Because we don't have a 1-1 mapping between our Harvest tasks and those in TrackingTime, this script makes a TrackingTime entry for every Harvest entry but links it to a single designated task there.  The script also transfers notes from Harvest to TrackingTime entries so that we can quickly go into TrackingTime and select the most appropriate task there.

## Packaged with rumbda

This script is set up to be packaged with rumbda to run on AWS Lambda.

## How to use

The authentication and configuration is controlled by environment variables.  In development, this script uses the `dotenv` gem to load these from a `.env` file of the following form:

```
# Your Harvest account ID
HARVEST_ACCOUNT_ID=123456

# Your Harvest API token (with full read privileges)
HARVEST_API_TOKEN=some_token_here

# The Harvest project ID you want to transfer from (isolates to one client)
HARVEST_PROJECT_ID=123456

# ID of the task in TrackingTime that you want to attach transferred entries to
TRACKING_TIME_TARGET_TASK_ID=123456

# Information about the users for whom we are transferring time
# Format is HARVEST_USER_ID:TT_USER_ID:TT_LOGIN:TT_PASSWORD||||repeat for next user
USER_DATA=123456:654321:someone@example.com:password1||||22222:44444:other@example.com:password2
```
