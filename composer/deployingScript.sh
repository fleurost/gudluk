if [ -z ${1} ]; then
	ls | grep hospital-network
	exit
fi

VERSION=$1
ORDERER_HOST=192.168.56.12
RS1_HOST=192.168.56.10
RS2_HOST=192.168.56.11

composer card delete -c PeerAdmin@byfn-network-rs2
composer card delete -c PeerAdmin@byfn-network-rs1
composer card delete -c bob@hospital-network
composer card delete -c alice@hospital-network

rm -rv alice
rm -rv bob

echo "INSERT_ORG1_CA_CERT: "
awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' crypto-config/peerOrganizations/rs1.hospital.com/peers/peer0.rs1.hospital.com/tls/ca.crt > ./tmp/INSERT_ORG1_CA_CERT

echo "INSERT_ORG2_CA_CERT: "
awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' crypto-config/peerOrganizations/rs2.hospital.com/peers/peer0.rs2.hospital.com/tls/ca.crt > ./tmp/INSERT_ORG2_CA_CERT

echo "INSERT_ORDERER_CA_CERT: "
awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' crypto-config/ordererOrganizations/hospital.com/orderers/orderer.hospital.com/tls/ca.crt > ./tmp/INSERT_ORDERER_CA_CERT


cat << EOF > ./byfn-network-rs1.json
{
    "name": "byfn-network-rs1",
    "x-type": "hlfv1",
    "version": "1.0.0",
	"client": {
		"organization": "rs1",
		"connection": {
			"timeout": {
				"peer": {
					"endorser": "2100",
					"eventHub": "2100",
					"eventReg": "2100"
				},
				"orderer": "2100"
			}
		}
	},
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer.hospital.com"
            ],
            "peers": {
                "peer0.rs1.hospital.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.rs1.hospital.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer0.rs2.hospital.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.rs2.hospital.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                }
            }
        }
    },
    "organizations": {
        "rs1": {
            "mspid": "rs1MSP",
            "peers": [
                "peer0.rs1.hospital.com",
                "peer1.rs1.hospital.com"
            ],
            "certificateAuthorities": [
                "ca.rs1.hospital.com"
            ]
        },
        "rs2": {
            "mspid": "rs2MSP",
            "peers": [
                "peer0.rs2.hospital.com",
                "peer1.rs2.hospital.com"
            ],
            "certificateAuthorities": [
                "ca.rs2.hospital.com"
            ]
        }
    },
    "orderers": {
        "orderer.hospital.com": {
            "url": "grpcs://${ORDERER_HOST}:7050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORDERER_CA_CERT`"
            }
        }
    },
    "peers": {
        "peer0.rs1.hospital.com": {
            "url": "grpcs://${RS1_HOST}:7051",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.rs1.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORG1_CA_CERT`"
            }
        },
        "peer1.rs1.hospital.com": {
            "url": "grpcs://${RS1_HOST}:8051",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.rs1.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORG1_CA_CERT`"
            }
        },
        "peer0.rs2.hospital.com": {
            "url": "grpcs://${RS2_HOST}:9051",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.rs2.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORG2_CA_CERT`"
            }
        },
        "peer1.rs2.hospital.com": {
            "url": "grpcs://${RS2_HOST}:10051",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.rs2.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORG2_CA_CERT`"
            }
        }
    },
    "certificateAuthorities": {
        "ca.rs1.hospital.com": {
            "url": "https://${RS1_HOST}:7054",
            "caName": "ca-rs1",
            "httpOptions": {
                "verify": false
            }
        },
        "ca.rs2.hospital.com": {
            "url": "https://${RS2_HOST}:8054",
            "caName": "ca-rs2",
            "httpOptions": {
                "verify": false
            }
        }
    }
}
EOF


cat << EOF > ./byfn-network-rs2.json
{
    "name": "byfn-network-rs2",
    "x-type": "hlfv1",
    "version": "1.0.0",
	"client": {
		"organization": "rs2",
		"connection": {
			"timeout": {
				"peer": {
					"endorser": "2100",
					"eventHub": "2100",
					"eventReg": "2100"
				},
				"orderer": "2100"
			}
		}
	},
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer.hospital.com"
            ],
            "peers": {
                "peer0.rs1.hospital.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.rs1.hospital.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer0.rs2.hospital.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.rs2.hospital.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                }
            }
        }
    },
    "organizations": {
        "rs1": {
            "mspid": "rs1MSP",
            "peers": [
                "peer0.rs1.hospital.com",
                "peer1.rs1.hospital.com"
            ],
            "certificateAuthorities": [
                "ca.rs1.hospital.com"
            ]
        },
        "rs2": {
            "mspid": "rs2MSP",
            "peers": [
                "peer0.rs2.hospital.com",
                "peer1.rs2.hospital.com"
            ],
            "certificateAuthorities": [
                "ca.rs2.hospital.com"
            ]
        }
    },
    "orderers": {
        "orderer.hospital.com": {
            "url": "grpcs://${ORDERER_HOST}:7050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORDERER_CA_CERT`"
            }
        }
    },
    "peers": {
        "peer0.rs1.hospital.com": {
            "url": "grpcs://${RS1_HOST}:7051",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.rs1.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORG1_CA_CERT`"
            }
        },
        "peer1.rs1.hospital.com": {
            "url": "grpcs://${RS1_HOST}:8051",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.rs1.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORG1_CA_CERT`"
            }
        },
        "peer0.rs2.hospital.com": {
            "url": "grpcs://${RS2_HOST}:9051",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.rs2.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORG2_CA_CERT`"
            }
        },
        "peer1.rs2.hospital.com": {
            "url": "grpcs://${RS2_HOST}:10051",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.rs2.hospital.com"
            },
            "tlsCACerts": {
                "pem": "`cat ./tmp/INSERT_ORG2_CA_CERT`"
            }
        }
    },
    "certificateAuthorities": {
        "ca.rs1.hospital.com": {
            "url": "https://${RS1_HOST}:7054",
            "caName": "ca-rs1",
            "httpOptions": {
                "verify": false
            }
        },
        "ca.rs2.hospital.com": {
            "url": "https://${RS2_HOST}:8054",
            "caName": "ca-rs2",
            "httpOptions": {
                "verify": false
            }
        }
    }
}
EOF
 
RS1ADMIN="./crypto-config/peerOrganizations/rs1.hospital.com/users/Admin@rs1.hospital.com/msp"
RS2ADMIN="./crypto-config/peerOrganizations/rs2.hospital.com/users/Admin@rs2.hospital.com/msp"

composer card create -p ./byfn-network-rs1.json -u PeerAdmin -c $RS1ADMIN/signcerts/A*.pem -k $RS1ADMIN/keystore/*_sk -r PeerAdmin -r ChannelAdmin -f PeerAdmin@byfn-network-rs1.card
composer card create -p ./byfn-network-rs2.json -u PeerAdmin -c $RS2ADMIN/signcerts/A*.pem -k $RS2ADMIN/keystore/*_sk -r PeerAdmin -r ChannelAdmin -f PeerAdmin@byfn-network-rs2.card

composer card import -f PeerAdmin@byfn-network-rs1.card --card PeerAdmin@byfn-network-rs1
composer card import -f PeerAdmin@byfn-network-rs2.card --card PeerAdmin@byfn-network-rs2

composer network install --card PeerAdmin@byfn-network-rs1 --archiveFile hospital-network@$VERSION.bna
composer network install --card PeerAdmin@byfn-network-rs2 --archiveFile hospital-network@$VERSION.bna

composer identity request -c PeerAdmin@byfn-network-rs1 -u admin -s adminpw -d alice
composer identity request -c PeerAdmin@byfn-network-rs2 -u admin -s adminpw -d bob

composer network start -c PeerAdmin@byfn-network-rs1 -n hospital-network -V $VERSION -o endorsementPolicyFile=./endorsement-policy.json -A alice -C alice/admin-pub.pem -A bob -C bob/admin-pub.pem

# create card for alice, as business network admin
composer card create -p ./byfn-network-rs1.json -u alice -n hospital-network -c alice/admin-pub.pem -k alice/admin-priv.pem
composer card import -f alice@hospital-network.card

# create card for bob, as business network admin
composer card create -p ./byfn-network-rs2.json -u bob -n hospital-network -c bob/admin-pub.pem -k bob/admin-priv.pem
composer card import -f bob@hospital-network.card
