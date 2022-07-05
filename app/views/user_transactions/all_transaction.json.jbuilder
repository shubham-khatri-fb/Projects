json.transactions_list @transaction do |t|
    json.id t.id
    json.amount_transfer t.amount_transfer
    json.made_with_user t.user_id_transaction_made
    json.type t.transaction_type
    json.conversion_rate t.conversion_rate
    json.date t.created_at
    json.transfer_currency_type AllTransaction.transfer_currency_types.key(t.transfer_currency_type)
    json.receive_currency_type AllTransaction.transfer_currency_types.key(t.receive_currency_type)
end