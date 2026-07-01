DROP VIEW IF EXISTS warehouse.vw_transaction_summary;

CREATE OR REPLACE VIEW warehouse.vw_transaction_summary AS

SELECT

    ft.transaction_sk,

    ft.transaction_id,

    dd.full_date,

    from_acc.account_number AS from_account,

    to_acc.account_number AS to_account,

    sender.full_name AS sender_name,

    receiver.full_name AS receiver_name,

    from_branch.branch_name AS from_branch,

    to_branch.branch_name AS to_branch,

    ft.amount,

    ft.transaction_type,

    ft.channel,

    ft.status

FROM warehouse.fact_transaction ft

LEFT JOIN warehouse.dim_date dd
ON ft.date_sk = dd.date_sk

LEFT JOIN warehouse.dim_account from_acc
ON ft.from_account_sk = from_acc.account_sk

LEFT JOIN warehouse.dim_account to_acc
ON ft.to_account_sk = to_acc.account_sk

LEFT JOIN warehouse.dim_customer sender
ON from_acc.customer_sk = sender.customer_sk

LEFT JOIN warehouse.dim_customer receiver
ON to_acc.customer_sk = receiver.customer_sk

LEFT JOIN warehouse.dim_branch from_branch
ON from_acc.branch_sk = from_branch.branch_sk

LEFT JOIN warehouse.dim_branch to_branch
ON to_acc.branch_sk = to_branch.branch_sk;