# customer-value
Scenario for The Complete Journey by Dunnhumby

> **Environment paths**
>
> | | |
> |--:|:--|
> | `repo://` | [GitHub](https://github.com/dataseer-carl/customer-value.git)
> | `data://` | [GDrive](https://drive.google.com/open?id=13LmePIfxYAjTfZmY2ES-k0LXb5HOEpJx) |
> | Tracker | Trello |

## Data files

### Raw

| Data name | Description | Documentation | Data filepath | GDrive ID |
|:--|:--|:--|:--|:--|
| *hh_demographic* | Demographic information for a portion of households | `repo:///Docs/dunnhumby - The Complete Journey User Guide.pdf` | [`datalake:///Dunnhumby/The Complete Journey/raw/hh_demographic.csv`](https://drive.google.com/open?id=1XihLIZNBOES16ukjCXRFq3kYt03IRpz9) | `1XihLIZNBOES16ukjCXRFq3kYt03IRpz9` |
| *transaction_data* | All products purchased by households within this study | `repo:///Docs/dunnhumby - The Complete Journey User Guide.pdf` | [`datalake:///Dunnhumby/The Complete Journey/raw/transaction_data.csv`](https://drive.google.com/open?id=1UNLrd6q7yqeLTwVUCNMl1trR3dvB2YR1) | `1UNLrd6q7yqeLTwVUCNMl1trR3dvB2YR1` |

### Ingested and parsed

| Data name | Description | Data filepath | GDrive ID | Input data | Processing script |
|:--|:--|:--|:--|:--|:--|
| *hh.df* | Cleaned *hh_demographic* | [`data:///data00_cleaned hh ingest.RData`](https://drive.google.com/open?id=1uYSaJ9au_biJDUngWmcU23qltWR5Jenv) | `1uYSaJ9au_biJDUngWmcU23qltWR5Jenv` | *hh_demographic* | `repo:///scripts00_data.R` |
| *bskt.df* | Basket-level transactions | [`data:///data00_cleaned hh ingest.RData`](https://drive.google.com/open?id=1uYSaJ9au_biJDUngWmcU23qltWR5Jenv) | `1uYSaJ9au_biJDUngWmcU23qltWR5Jenv` | *transaction_data* | `repo:///scripts00_data.R` |
| *bskt.df* | Basket-level transactions | [`data:///data01_trans-lvl.csv`](https://drive.google.com/open?id=1FNOLwSMGjaC-4aZvj1XJ9COpxD0jKTqq) | `1FNOLwSMGjaC-4aZvj1XJ9COpxD0jKTqq` | *transaction_data* | `repo:///scripts00_data.R` |

## Plots

| Plot description | Data filepath | Input data | Processing script |
|:--|:--|:--|:--|:--|:--|
|  |  |  |  |

## Models

| Response | Model | Filepath | Input data | Processing script | GDrive ID |
|:-:|:-:|:--|:--|:--|:-:|
|  |  |  |  |  |  |