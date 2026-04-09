# Slack IDs
# Single source of truth. All commands reference this file for Slack user/channel IDs.

## Key People (DMs)

| Person | Role | User ID |
|--------|------|---------|
| Jorge Garcia | Director Logistics & Purchasing | U03DHMPC8G6 |
| Miguel Pais | Sr. TPM, M-Band | U09J1BQ564V |
| Paulo Alves | PM, Pulse | U04CXBXFBUK |
| Pedro Pereira | Engineering (BLE/SDK) | U025EUN4JRL |
| Bianca Lourenco | Regulatory Affairs | U02B333KWCW |

## Key Channels

| Channel | ID | Purpose |
|---------|----|---------|
| #pulse-packagin-artwork | C0ARTEJPMRC | Pulse packaging design |
| #pm-npi-isc | C0AKYG8JR42 | NPI/ISC coordination |

## Usage
- To read DMs: use slack_read_channel with User ID as channel_id
- To read channels: use slack_read_channel with Channel ID
- For users without IDs listed: use slack_search_users by name first
