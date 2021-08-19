const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Ptarmigan": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://6mdpm2tiijbx5jxsfjcekazodm.appsync-api.eu-west-1.amazonaws.com/graphql",
                    "region": "eu-west-1",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-j52s3vopxzaknljn2dhnqquoqm"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://6mdpm2tiijbx5jxsfjcekazodm.appsync-api.eu-west-1.amazonaws.com/graphql",
                        "Region": "eu-west-1",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-j52s3vopxzaknljn2dhnqquoqm",
                        "ClientDatabasePrefix": "Ptarmigan_API_KEY"
                    },
                    "Ptarmigan_AWS_IAM": {
                        "ApiUrl": "https://6mdpm2tiijbx5jxsfjcekazodm.appsync-api.eu-west-1.amazonaws.com/graphql",
                        "Region": "eu-west-1",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "Ptarmigan_AWS_IAM"
                    },
                    "Ptarmigan_AMAZON_COGNITO_USER_POOLS": {
                        "ApiUrl": "https://6mdpm2tiijbx5jxsfjcekazodm.appsync-api.eu-west-1.amazonaws.com/graphql",
                        "Region": "eu-west-1",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "Ptarmigan_AMAZON_COGNITO_USER_POOLS"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "eu-west-1:a82f369a-4f45-4f86-9cba-a196513fbe91",
                            "Region": "eu-west-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-west-1_TWPQfb9SE",
                        "AppClientId": "25a14qki0tb71kp3m7udp2hpt7",
                        "Region": "eu-west-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "loginMechanism": [],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_NUMBERS",
                                "REQUIRES_SYMBOLS",
                                "REQUIRES_UPPERCASE"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ]
                    }
                }
            }
        }
    }
}''';
