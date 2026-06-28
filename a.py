import random
import uuid
from datetime import datetime, timedelta

import numpy as np
import pandas as pd
from faker import Faker

fake = Faker()

random.seed(42)
np.random.seed(42)

# ==========================
# CONFIG
# ==========================

NUM_CUSTOMERS = 10000
NUM_BRANCHES = 100
NUM_ACCOUNTS = 15000
NUM_CARDS = 20000
NUM_MERCHANTS = 2000
NUM_TRANSACTIONS = 500000
NUM_SWIPE = 300000
NUM_LOANS = 3000
NUM_REPAYMENTS = 20000

# ==========================
# CUSTOMERS
# ==========================

customers = []

for cid in range(1, NUM_CUSTOMERS + 1):

    customers.append({

        "customer_id": cid,
        "full_name": fake.name(),
        "dob": fake.date_between("-70y", "-18y"),
        "phone": fake.phone_number(),
        "email": fake.email(),
        "kyc_status": random.choice([
            "Verified",
            "Pending",
            "Rejected"
        ]),
        "created_at": fake.date_time_between("-5y", "now")
    })

customers = pd.DataFrame(customers)

# ==========================
# BRANCHES
# ==========================

cities = [
    "Hanoi",
    "Ho Chi Minh",
    "Da Nang",
    "Can Tho",
    "Hai Phong",
    "Hue"
]

branches = []

for bid in range(1, NUM_BRANCHES + 1):

    branches.append({

        "branch_id": bid,
        "branch_name": f"Branch {bid}",
        "city": random.choice(cities)
    })

branches = pd.DataFrame(branches)

# ==========================
# ACCOUNTS
# ==========================

accounts = []

for aid in range(1, NUM_ACCOUNTS + 1):

    accounts.append({

        "account_id": aid,
        "account_number": str(random.randint(1000000000,9999999999)),
        "customer_id": random.randint(1, NUM_CUSTOMERS),
        "branch_id": random.randint(1, NUM_BRANCHES),
        "account_type": random.choice([
            "Saving",
            "Checking",
            "Business"
        ]),
        "currency": random.choice([
            "USD",
            "VND",
            "EUR"
        ]),
        "balance": round(random.uniform(100,500000),2),
        "status": random.choice([
            "Active",
            "Inactive",
            "Closed"
        ]),
        "opened_at": fake.date_time_between("-10y","now")
    })

accounts = pd.DataFrame(accounts)

# ==========================
# CARDS
# ==========================

cards = []

for cid in range(1, NUM_CARDS + 1):

    acc = random.randint(1, NUM_ACCOUNTS)

    cards.append({

        "card_id": cid,
        "account_id": acc,
        "card_number": fake.credit_card_number(),
        "card_type": random.choice([
            "Debit",
            "Credit"
        ]),
        "credit_limit": random.choice([
            5000,
            10000,
            20000,
            None
        ]),
        "expiry_date": fake.date_between("today","+5y"),
        "status": random.choice([
            "Active",
            "Blocked",
            "Expired"
        ])
    })

cards = pd.DataFrame(cards)

# ==========================
# MERCHANTS
# ==========================

merchant_categories = [
    "Restaurant",
    "Shopping",
    "Fuel",
    "Hotel",
    "Coffee",
    "Supermarket",
    "Hospital",
    "Airline"
]

merchants = []

for mid in range(1, NUM_MERCHANTS + 1):

    merchants.append({

        "merchant_id": mid,
        "merchant_name": fake.company(),
        "category": random.choice(merchant_categories),
        "city": random.choice(cities)
    })

merchants = pd.DataFrame(merchants)

# ==========================
# TRANSACTIONS
# ==========================

transactions = []

for tid in range(1, NUM_TRANSACTIONS + 1):

    from_acc = random.randint(1, NUM_ACCOUNTS)
    to_acc = random.randint(1, NUM_ACCOUNTS)

    while from_acc == to_acc:
        to_acc = random.randint(1, NUM_ACCOUNTS)

    transactions.append({

        "transaction_id": tid,
        "from_account_id": from_acc,
        "to_account_id": to_acc,
        "amount": round(random.uniform(1,10000),2),
        "transaction_type": random.choice([
            "Transfer",
            "Deposit",
            "Withdrawal"
        ]),
        "channel": random.choice([
            "ATM",
            "Mobile",
            "Branch",
            "POS",
            "Internet Banking"
        ]),
        "status": random.choice([
            "SUCCESS",
            "FAILED",
            "PENDING"
        ]),
        "timestamp": fake.date_time_between("-2y","now")
    })

transactions = pd.DataFrame(transactions)

# ==========================
# CARD SWIPE LOGS
# ==========================

swipes = []

for sid in range(1, NUM_SWIPE + 1):

    swipes.append({

        "swipe_id": sid,
        "card_id": random.randint(1, NUM_CARDS),
        "merchant_id": random.randint(1, NUM_MERCHANTS),
        "amount": round(random.uniform(5,3000),2),
        "device_id": str(uuid.uuid4())[:12],
        "timestamp": fake.date_time_between("-2y","now")
    })

swipes = pd.DataFrame(swipes)

# ==========================
# LOANS
# ==========================

loans = []

for lid in range(1, NUM_LOANS + 1):

    customer = random.randint(1, NUM_CUSTOMERS)

    loans.append({

        "loan_id": lid,
        "customer_id": customer,
        "account_id": random.randint(1, NUM_ACCOUNTS),
        "loan_amount": round(random.uniform(10000,1000000),2),
        "interest_rate": round(random.uniform(3,15),2),
        "term_months": random.choice([
            12,
            24,
            36,
            48,
            60
        ]),
        "status": random.choice([
            "Active",
            "Closed",
            "Default"
        ])
    })

loans = pd.DataFrame(loans)

# ==========================
# LOAN REPAYMENTS
# ==========================

repayments = []

for rid in range(1, NUM_REPAYMENTS + 1):

    repayments.append({

        "repayment_id": rid,
        "loan_id": random.randint(1, NUM_LOANS),
        "principal_paid": round(random.uniform(100,5000),2),
        "interest_paid": round(random.uniform(20,1000),2),
        "payment_date": fake.date_between("-5y","today"),
        "late_days": random.randint(0,60)
    })

repayments = pd.DataFrame(repayments)

# ==========================
# EXPORT
# ==========================

customers.to_csv("customers.csv", index=False)
branches.to_csv("branches.csv", index=False)
accounts.to_csv("accounts.csv", index=False)
cards.to_csv("cards.csv", index=False)
merchants.to_csv("merchants.csv", index=False)
transactions.to_csv("transactions.csv", index=False)
swipes.to_csv("card_swipe_logs.csv", index=False)
loans.to_csv("loans.csv", index=False)
repayments.to_csv("loan_repayments.csv", index=False)

print("Done!")