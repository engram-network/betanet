amount=32000000000
smin=20000
smax=30000

eth2-val-tools deposit-data \
  --source-min=$smin \
  --source-max=$smax \
  --amount=$amount \
  --fork-version=0x10000044 \
  --withdrawals-mnemonic="galaxy galaxy galaxy .. decline" \
  --validators-mnemonic="galaxy galaxy galaxy .. decline" > devnet7_deposits_$smin\_$smax.txt

while read x; do
   account_name="$(echo "$x" | jq '.account')"
   pubkey="$(echo "$x" | jq '.pubkey')"
   echo "Sending deposit for validator $account_name $pubkey"
   ethereal beacon deposit \
      --allow-unknown-contract=true \
      --address="0x4242424242424242424242424242424242424242" \
      --connection=https://rpc.withdrawal-devnet-7.ethpandaops.io \
      --data="$x" \
      --allow-excessive-deposit \
      --value="$amount" \
      --from="0x285F1c6671108e88684fe3A8c966464A80E4c442" \ #your public key
      --privatekey="0x6b737d36d588...80263bdb2071a726d0983ad283456889dc8fd0874" # the public's key's private key
   echo "Sent deposit for validator $account_name $pubkey"
   sleep 2
done < devnet7_deposits_$smin\_$smax.txt