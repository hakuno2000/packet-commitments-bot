CHAIN_ID="$1"
CHANNEL="$2"
RESULT=""
RESPONSE="$(hermes --json query packet commitments --chain $CHAIN_ID --port transfer --channel $CHANNEL | jq -n '[inputs] | add')"
STATUS="$(echo $RESPONSE | jq -r '.status')"
if [ "$STATUS" != "success" ]; then
  RESULT="$RESPONSE"
else
  RESULT="Query successful"
  SEQS="$(echo $RESPONSE | jq -r '.result.seqs')"
  if [ "$SEQS" = "[]" ]; then
    RESULT=""
  else
    RESULT="Packet commitments found for $CHAIN_ID $CHANNEL"
  fi
fi
echo "$RESULT"
