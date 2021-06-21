const amplifyconfig = ''' {
    "UserAgen": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Ptarmigan": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://acy6wmegzfas3fmwxla3hycxfi.appsync-api.eu-west-2.amazonaws.com/graphql",
                    "region": "eu-west-2",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-ku3jjwsgjjeljmuhf5zoon6rh4"
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
                        "ApiUrl": "https://acy6wmegzfas3fmwxla3hycxfi.appsync-api.eu-west-2.amazonaws.com/graphql",
                        "Region": "eu-west-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-ku3jjwsgjjeljmuhf5zoon6rh4",
                        "ClientDatabasePrefix": "Ptarmigan_API_KEY"
                    },
                    "Ptarmigan_AWS_IAM": {
                        "ApiUrl": "https://acy6wmegzfas3fmwxla3hycxfi.appsync-api.eu-west-2.amazonaws.com/graphql",
                        "Region": "eu-west-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "Ptarmigan_AWS_IAM"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "eu-west-2:b31f9508-405f-4461-b51e-bc4b96705f64",
                            "Region": "eu-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-west-2_smsu78wGa",
                        "AppClientId": "79ji24k1mlp099qtqh2rcp6k4g",
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