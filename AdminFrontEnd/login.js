$(document).ready(function () {
    //initalize credentials
    // userPool = 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902'
    AWS.config.region = 'eu-west-1'; // Region
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({IdentityPoolId: 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902',
    });
    var cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({apiVersion: '2016-04-18'});

    var paramsDeleteUser = {UserPoolId: 'eu-west-1_gM8mCo99w', /* required */
        Username: username /* required */
    };

    cognitoidentityserviceprovider.adminInitiateAuth(paramsDeleteUser, function(err, data) {
        clientId: '',
        userPoolId: 'eu-west-1:5c966d13-0216-4546-b8cf-df082965aced', /* required */

    }
        if (err) console.log(err, err.stack); // an error occurred
        else
            alert("user deleted successfully")
        console.log(data);           // successful response
    });

var params = {
    AuthFlow: USER_SRP_AUTH | REFRESH_TOKEN_AUTH | REFRESH_TOKEN | CUSTOM_AUTH | ADMIN_NO_SRP_AUTH | USER_PASSWORD_AUTH | ADMIN_USER_PASSWORD_AUTH, /* required */
    ClientId: 'fb1pq20pcgdu7sn1af4ogihp4', /* required */
    UserPoolId: ' eu-west-1_XeVth2bqn', /* required */
    AnalyticsMetadata: {
        AnalyticsEndpointId: 'STRING_VALUE'
    },
    AuthParameters: {
        '<StringType>': 'STRING_VALUE',
        /* '<StringType>': ... */
    },
    ClientMetadata: {
        '<StringType>': 'STRING_VALUE',
        /* '<StringType>': ... */
    },
    ContextData: {
        HttpHeaders: [ /* required */
            {
                headerName: 'STRING_VALUE',
                headerValue: 'STRING_VALUE'
            },
            /* more items */
        ],
        IpAddress: 'STRING_VALUE', /* required */
        ServerName: 'STRING_VALUE', /* required */
        ServerPath: 'STRING_VALUE', /* required */
        EncodedData: 'STRING_VALUE'
    }
};
cognitoidentityserviceprovider.adminInitiateAuth(params, function(err, data) {
    if (err) console.log(err, err.stack); // an error occurred
    else     console.log(data);           // successful response
});