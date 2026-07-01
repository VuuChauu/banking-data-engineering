import random
import uuid
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
NUM_TRANSACTIONS = 50000
NUM_SWIPES = 30000
NUM_LOANS = 3000
NUM_REPAYMENTS = 20000

# ==========================
# CUSTOMERS
# ==========================
customers = [{
    "customer_id": i,
    "full_name": fake.name(),
    "dob": fake.date_of_birth(minimum_age=18, maximum_age=70),
    "phone": fake.phone_number(),
    "email": fake.email(),
    "kyc_status": random.choice(["Verified", "Pending", "Rejected"]),
    "created_at": fake.date_time_this_decade()
} for i in range(1, NUM_CUSTOMERS+1)]

pd.DataFrame(customers).to_csv("data/raw/customers.csv", index=False)

# ==========================
# BRANCHES
# ==========================
cities = ["Hanoi", "Ho Chi Minh", "Da Nang", "Can Tho", "Hai Phong", "Hue"]

branches = [{
    "branch_id": i,
    "branch_name": f"Branch {i}",
    "city": random.choice(cities)
} for i in range(1, NUM_BRANCHES+1)]

pd.DataFrame(branches).to_csv("data/raw/branches.csv", index=False)

# ==========================
# ACCOUNTS
# ==========================
accounts = [{
    "account_id": i,
    "account_number": str(random.randint(10**9, 10**10)),
    "customer_id": random.randint(1, NUM_CUSTOMERS),
    "branch_id": random.randint(1, NUM_BRANCHES),
    "account_type": random.choice(["Saving", "Checking", "Business"]),
    "currency": random.choice(["USD", "VND", "EUR"]),
    "balance": round(random.uniform(100, 500000), 2),
    "status": random.choice(["Active", "Inactive", "Closed"]),
    "opened_at": fake.date_time_this_decade()
} for i in range(1, NUM_ACCOUNTS+1)]

pd.DataFrame(accounts).to_csv("data/raw/accounts.csv", index=False)

# ==========================
# CARDS
# ==========================
cards = [{
    "card_id": i,
    "account_id": random.randint(1, NUM_ACCOUNTS),
    "card_number": fake.credit_card_number(),
    "card_type": random.choice(["Debit", "Credit"]),
    "credit_limit": random.choice([5000, 10000, 20000, None]),
    "expiry_date": fake.date_between(start_date="today", end_date="+5y"),
    "status": random.choice(["Active", "Blocked", "Expired"])
} for i in range(1, NUM_CARDS+1)]

pd.DataFrame(cards).to_csv("data/raw/cards.csv", index=False)

# ==========================
# MERCHANTS
# ==========================
categories = ["Restaurant", "Shopping", "Fuel", "Hotel", "Coffee", "Supermarket"]

merchants = [{
    "merchant_id": i,
    "merchant_name": fake.company(),
    "category": random.choice(categories),
    "city": random.choice(cities)
} for i in range(1, NUM_MERCHANTS+1)]

pd.DataFrame(merchants).to_csv("data/raw/merchants.csv", index=False)

# ==========================
# TRANSACTIONS
# ==========================
transactions = []

for i in range(1, NUM_TRANSACTIONS+1):
    from_acc = random.randint(1, NUM_ACCOUNTS)
    to_acc = random.randint(1, NUM_ACCOUNTS)
    while from_acc == to_acc:
        to_acc = random.randint(1, NUM_ACCOUNTS)

    transactions.append({
        "transaction_id": i,
        "from_account_id": from_acc,
        "to_account_id": to_acc,
        "amount": round(random.uniform(1, 10000), 2),
        "transaction_type": random.choice(["Transfer", "Deposit", "Withdrawal"]),
        "channel": random.choice(["ATM", "Mobile", "POS", "Internet Banking"]),
        "status": random.choice(["SUCCESS", "FAILED"]),
        "timestamp": fake.date_time_this_year()
    })

pd.DataFrame(transactions).to_csv("data/raw/transactions.csv", index=False)

# ==========================
# SWIPES
# ==========================
swipes = [{
    "swipe_id": i,
    "card_id": random.randint(1, NUM_CARDS),
    "merchant_id": random.randint(1, NUM_MERCHANTS),
    "amount": round(random.uniform(5, 3000), 2),
    "device_id": str(uuid.uuid4())[:12],
    "timestamp": fake.date_time_this_year()
} for i in range(1, NUM_SWIPES+1)]

pd.DataFrame(swipes).to_csv("data/raw/card_swipe_logs.csv", index=False)

# ==========================
# LOANS
# ==========================
loans = [{
    "loan_id": i,
    "customer_id": random.randint(1, NUM_CUSTOMERS),
    "account_id": random.randint(1, NUM_ACCOUNTS),
    "loan_amount": round(random.uniform(10000, 1000000), 2),
    "interest_rate": round(random.uniform(3, 15), 2),
    "term_months": random.choice([12, 24, 36, 48]),
    "status": random.choice(["Active", "Closed", "Default"])
} for i in range(1, NUM_LOANS+1)]

pd.DataFrame(loans).to_csv("data/raw/loans.csv", index=False)

# ==========================
# REPAYMENTS
# ==========================
repayments = [{
    "repayment_id": i,
    "loan_id": random.randint(1, NUM_LOANS),
    "principal_paid": round(random.uniform(100, 5000), 2),
    "interest_paid": round(random.uniform(20, 1000), 2),
    "payment_date": fake.date_this_year(),
    "late_days": random.randint(0, 60)
} for i in range(1, NUM_REPAYMENTS+1)]

pd.DataFrame(repayments).to_csv("data/raw/loan_repayments.csv", index=False)

print("DONE - ALL CSV GENERATED")