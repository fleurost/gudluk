# Create the channel
docker exec peer0.org2.aryastorage.com peer channel create -o orderer.aryastorage.com:7050 -c composerchannel2 -f /var/hyperledger/channel-artifacts/channel2.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/aryastorage.com/msp/tlscacerts/tlsca.aryastorage.com-cert.pem

# Join peer0.org2.example.com to the channel.
docker exec peer0.org2.aryastorage.com peer channel join -b composerchannel2.block

# Join peer1.org2.example.com to the channel.
docker exec peer1.org2.aryastorage.com peer channel fetch config -o orderer.aryastorage.com:7050 -c composerchannel2 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/aryastorage.com/msp/tlscacerts/tlsca.aryastorage.com-cert.pem
docker exec peer1.org2.aryastorage.com peer channel join -b composerchannel2_config.block
