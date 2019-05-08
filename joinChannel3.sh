
# Join peer0.org1.example.com to the channel.
docker exec peer0.rs2.hospital.com peer channel fetch config -o orderer.hospital.com:7050 -c composerchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hospital.com/msp/tlscacerts/tlsca.hospital.com-cert.pem
docker exec peer0.rs2.hospital.com peer channel join -b composerchannel_config.block

# Join peer1.org1.example.com to the channel.
docker exec peer1.rs2.hospital.com peer channel fetch config -o orderer.hospital.com:7050 -c composerchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hospital.com/msp/tlscacerts/tlsca.hospital.com-cert.pem
docker exec peer1.rs2.hospital.com peer channel join -b composerchannel_config.block
