const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Ptarmigan": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://gp4zb3lbivcdznlxxs24ajr2ky.appsync-api.eu-west-2.amazonaws.com/graphql",
                    "region": "eu-west-2",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-bc3wcyoe3zaa3k7f7pjgiiqmp4"
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
                        "ApiUrl": "https://gp4zb3lbivcdznlxxs24ajr2ky.appsync-api.eu-west-2.amazonaws.com/graphql",
                        "Region": "eu-west-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-bc3wcyoe3zaa3k7f7pjgiiqmp4",
                        "ClientDatabasePrefix": "Ptarmigan_API_KEY"
                    },
                    "Ptarmigan_AWS_IAM": {
                        "ApiUrl": "https://gp4zb3lbivcdznlxxs24ajr2ky.appsync-api.eu-west-2.amazonaws.com/graphql",
                        "Region": "eu-west-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "Ptarmigan_AWS_IAM"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "eu-west-2:715aaad3-cd64-4470-bfc2-4a26fdb4b175",
                            "Region": "eu-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-west-2_a3DMqEf7X",
                        "AppClientId": "8avh270uk7t6jghahoon5mckg",
                        "Region": "eu-west-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                }
            }
        }
    }
}''';