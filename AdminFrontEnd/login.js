var adminUsers

$(document).ready(function () {

    AWS.config.region = 'eu-west-1'; // Region
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId: 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902',
    });
    var cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({apiVersion: '2016-04-18'});

    var params = {
        UserPoolId: 'eu-west-1_gM8mCo99w', /* required */ // actual pool eu-west-1_gM8mCo99w //Test pool eu-west-1_nn8eU3DXM
        AttributesToGet: [],
        Filter: '',
        Limit: '50'
        //PaginationToken: '1'
    };

    var paramsAdminUsers = {
        GroupName: 'Admin', /* required */
        UserPoolId: 'eu-west-1_gM8mCo99w', /* required */
        Limit: '50',
    };
    cognitoidentityserviceprovider.listUsersInGroup(paramsAdminUsers, function (err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else {
            adminData = data;
            adminUsers = adminData["Users"];
            console.log(adminData)
        }

        console.log("Users in admin group returned");           // successful response

    });
    $('#loginButton').click(function () {
        username = $("#loginUsername").val();
        password = $("#loginPassword").val();


        for (var i in adminUsers) {
            if (adminUsers[i]["Attributes"][2]["Value"] == username && password == "password") {
                window.location.href = "index.html";
                return
            }
        }
        alert("Incorrect username or password");

    });
});