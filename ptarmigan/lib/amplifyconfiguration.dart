const amplifyconfig = ''' {
    "UserAgen": "aws-amplify-cli/2.0",
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

                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-west-1_gM8mCo99w",
                        "AppClientId": "3df2qnjks8rd8j4kpm0idhfl41",
                        "Region": "eu-west-1"
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