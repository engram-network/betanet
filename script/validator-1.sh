nohup lighthouse vc \
	  --http \
	  --unencrypted-http-transport \
	  --init-slashing-protection \
	  --http-allow-origin="*" \
	  --http-port 5062 \
	  --http-address=127.0.0.1 \
	  --datadir "/mnt/testnet/database/validator/1" \
	  --testnet-dir "/mnt/testnet/testnet/output/custom_config_data" \
	  --suggested-fee-recipient "0xfd935bdfd3df86081e81f85bb30035452d5cd5b0" \
	  --graffiti "Hector" \
	  --beacon-nodes "http://localhost:5052" \
	  > /mnt/testnet/testnet/logs/vc-1.log &
