// import { CognitoIdentityClient, CreateIdentityPoolCommand } from "@aws-sdk/client-cognito-identity";
var adminUsers
let userpoolid = "eu-west-1_7XDVA9p2r"

//=============== AWS IDs ===============
var userPoolId = "eu-west-1_7XDVA9p2r";
var clientId = '7k7pnkdkvtp2bu0lkigkiu9n5k';
var region = 'eu-west-1';
var identityPoolId = 'eu-west-1:11c96690-9a61-4201-be73-36024890dd50';
//=============== AWS IDs ===============

var cognitoUser;
var idToken;
var userPool;

var poolData = {
    UserPoolId : userPoolId,
    ClientId : clientId
};

function logIn() {

    if (!$('#loginUsername').val() || !$('#loginPassword').val()) {
        alert('Please enter Username and Password!');
    } else {
        var authenticationData = {
            Username: $('#loginUsername').val(),
            Password: $("#loginPassword").val(),
        };
        var authenticationDetails = new AmazonCognitoIdentity.AuthenticationDetails(authenticationData);
        userPool = new AmazonCognitoIdentity.CognitoUserPool(poolData);

        var userData = {
            Username: $('#loginUsername').val(),
            Pool: userPool
        };
        cognitoUser = new AmazonCognitoIdentity.CognitoUser(userData);
        // $("#loader").show();
        cognitoUser.authenticateUser(authenticationDetails, {
            onSuccess: function (result) {
                console.log(result);
                var adminLogger = result.idToken.payload.email;
                sessionStorage.setItem("username", adminLogger);
                window.location.href = "index.html";
                return
                switchToLoggedInView();



                idToken = result.getIdToken().getJwtToken();
                getCognitoIdentityCredentials();


            },

            onFailure: function (err) {
                alert(err.message);
                // $("#loader").hide();
            },

        });
    }
}

$(document).ready(function () {

    AWS.config.region = 'eu-west-1'; // Region
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId: 'eu-west-1:11c96690-9a61-4201-be73-36024890dd50',
    });
    var cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({apiVersion: '2016-04-18'});

    var params = {
        UserPoolId: userpoolid, /* required */ // actual pool eu-west-1_gM8mCo99w //Test pool eu-west-1_nn8eU3DXM
        AttributesToGet: [],
        Filter: '',
        Limit: '50'
        //PaginationToken: '1'
    };

    var paramsAdminUsers = {
        GroupName: 'Admin', /* required */
        UserPoolId: userpoolid, /* required */
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
        logIn()
        // username = $("#loginUsername").val();
        // password = $("#loginPassword").val();
        //
        //
        // for (var i in adminUsers) {
        //     for (var k in adminUsers[i].Attributes) {
        //         if (adminUsers[i]["Attributes"][k]["Name"] == "email") {
        //             if (adminUsers[i]["Attributes"][k]["Value"] == username && password == "password") {
        //                 window.location.href = "index.html";
        //                 return
        //             }
        //         }
        //     }
        // }
        // alert("Incorrect username or password");

    });
});