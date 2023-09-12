nohup lighthouse vc \
	  --http \
	  --unencrypted-http-transport \
	  --init-slashing-protection \
	  --http-allow-origin="*" \
	  --http-port 5063 \
	  --http-address=127.0.0.1 \
	  --datadir "/mnt/testnet/database/validator/2" \
	  --testnet-dir "/mnt/testnet/testnet/output/custom_config_data" \
	  --suggested-fee-recipient "0x06c33915aaf10bccf6dfc86a412440a4347a0f88" \
	  --graffiti "Satsuki" \
	  --beacon-nodes "http://localhost:5053" \
	  > /mnt/testnet/testnet/logs/vc-2.log &
