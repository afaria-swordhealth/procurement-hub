# Slack IDs
# Single source of truth. All commands reference this file for Slack user/channel IDs.
# log=true: scanned by /slack-scan for procurement signals → OI DB.
# log_types: signal types to extract (all = all 5 types; or comma-separated subset).

## Key People (DMs)

| Person | Role | User ID | log | log_types |
|--------|------|---------|-----|-----------|
| Jorge Garcia | Director Logistics & Purchasing | U03DHMPC8G6 | true | all |
| Anand Singh | VP ISC | U03GY4T555K | true | all |
| Miguel Pais | Sr. TPM, M-Band | U09J1BQ564V | true | all |
| Paulo Alves | PM, Pulse | U04CXBXFBUK | true | all |
| Pedro Pereira | Engineering (BLE/SDK) | U025EUN4JRL | false | — |
| Bianca Lourenco | Regulatory Affairs | U02B333KWCW | false | — |
| Sofia Lourenço | Expert Quality Systems Engineer | U044W9SFLAE | true | all |
| João Quirino | Director QA/Regulatory | U06C7Q2PDQE | false | — |
| Max Strobel | Director Engineering, Kaia PM | U0AAQKPS267 | false | — |
| Gustavo Burmester | NPI Engineering Manager | U03PB7X8HL2 | false | — |
| Catarina Barbosa | Logistics Specialist | U08R6PCUWER | false | — |
| Bradley Bruchs | Senior Contract Manager | U07S3401T1Q | true | Commitment,Decision |
| Fernando Saraiva | International Logistics Specialist | U04H6RT4A0J | false | — |
| Kevin Wang | GM, Pulse | U02L4KTU1CH | true | all |
| Marta Valente | Senior Brand Designer | U094DN98DL1 | false | — |
| Andreia Gomes | Procurement Specialist | U01TACJ5SLB | false | — |
| Mariana Peixoto | Associate to CSO | U05F4TU91L0 | false | — |
| Caio Pereira | Kaia sourcing / global | U0777KPTBED | true | all |
| Rúben Silva | Finance / Vendor onboarding (NetSuite) | D07T4UWB5LP | false | — |

## Group DMs

| Members | ID | Purpose | log | log_types |
|---------|----|---------|-----|-----------|
| André, Jorge, Miguel, Gustavo | C0AGZ2WNUEM | M-Band sourcing ops (quotes, visits, supplier questions) | true | all |
| André, Paulo Alves, Kevin Wang | C0AUDR0D5EX | Pulse device decisions (scale/BPM quantities, supplier updates, key commercial decisions) | true | all |

## Key Channels

| Channel | ID | Purpose | log | log_types |
|---------|----|---------|-----|-----------|
| #pulse-devices | C0ARTEJPMRC | Pulse device decisions (cuff sizes, QARA, packaging, BOM) | true | all |
| #pm-npi-isc | C0AKYG8JR42 | NPI/ISC coordination | true | all |
| #m-band_sourcing | C08170ETSKG | M-Band COO-X sourcing updates | true | all |
| #pulse-isc | C0905Q7SFU2 | Pulse/Move ISC operations | true | all |
| #kaia-nimbl-fullfillment | C0B1BT09CRM | Kaia/Nimbl fulfillment coordination (mats delivery, order CSVs) | true | all |

## Usage
- To read DMs: use slack_read_channel with User ID as channel_id
- To read channels: use slack_read_channel with Channel ID
- For users without IDs listed: use slack_search_users by name first
- /slack-scan reads only entries with log=true
