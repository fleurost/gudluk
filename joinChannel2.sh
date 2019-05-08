# Create the channel
docker exec peer0.rs1.hospital.com peer channel create -o orderer.hospital.com:7050 -c composerchannel -f /var/hyperledger/channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hospital.com/msp/tlscacerts/tlsca.hospital.com-cert.pem

# Join peer0.rs1.example.com to the channel.
docker exec peer0.rs1.hospital.com peer channel join -b composerchannel.block

# Join peer1.rs1.example.com to the channel.
docker exec peer1.rs1.hospital.com peer channel fetch config -o orderer.hospital.com:7050 -c composerchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hospital.com/msp/tlscacerts/tlsca.hospital.com-cert.pem
docker exec peer1.rs1.hospital.com peer channel join -b composerchannel_config.block
