FINAL_RESULT=""
readarray -t chains < <(cat channels.json | jq -c '.[]')
for chain in "${chains[@]}"; do
  chain_id=$(echo "$chain" | jq -r '.chain')
  channellist=$(echo "$chain" | jq -c '.channels')
  #echo "$chain_id"
    readarray -t channels < <(echo $channellist | jq -c '.[]')
    for channel in "${channels[@]}"; do
      channel="${channel%\"}"
      channel="${channel#\"}"
      #echo "$channel"
      QUERY="$(bash hermes_query.sh $chain_id $channel)"
      if [ "$QUERY" != "" ]; then
        FINAL_RESULT+="$QUERY"
        FINAL_RESULT+=$'\n'
      fi
    done
done
echo "$FINAL_RESULT"

source /root/packet-commitments-bot/.env
curl -d "text=$FINAL_RESULT" -d "channel=$DU" -H "Authorization: Bearer $BOT_OAUTH_TOKEN" -X POST https://slack.com/api/chat.postMessage | jq
