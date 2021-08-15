$(document).ready(function () {
    //initalize credentials
    AWS.config.region = 'eu-west-1'; // Region
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({IdentityPoolId: 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902',
    });
    //initalize cognito service
    var cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({apiVersion: '2016-04-18'});

    var userListdata;
    var params = {
        UserPoolId: 'eu-west-1_nn8eU3DXM', /* required */
        AttributesToGet: [],
        Filter: '',
        Limit: '50'
        //PaginationToken: '1'
        };
    cognitoidentityserviceprovider.listUsers(params, function(err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else
            {
                userListData = data
                console.log(data);
            }           // successful response
    });
// This actually returns the object wtf
});