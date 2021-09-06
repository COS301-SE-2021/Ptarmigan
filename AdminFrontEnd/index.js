//initalize credentials
    // userPool = 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902'
AWS.config.region = 'eu-west-1'; // Region
AWS.config.credentials = new AWS.CognitoIdentityCredentials({IdentityPoolId: 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902',
});
var cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({apiVersion: '2016-04-18'});

let userpoolid = "eu-west-1_TWPQfb9SE"

console.log(sessionStorage.getItem("favoriteMovie"))

function setUsers(numberOfUsers){
    $("#numberOfUsers").text(numberOfUsers)
}

//Adding username to the navbar

function addingUsername(){

}



function addUserToTable(user,adminFlag){
    console.log(user)
    if (adminFlag == false)
    {
        $("#userTable").append(`<tr>
                    <td scope="row" class="Username">${user["Attributes"][0]["Value"]}</td>
                    <td>${user["UserLastModifiedDate"]}</td>
                    <td>
                        <button type="button" class="btn btn-danger adminStatus" value="notThisValue">No<span class="glyphicon glyphicon-thumbs-down"></span></button>
                    </td>
                    <th scope="col">
                        <button type="button" class="btn btn-danger removeOnClick removeOnClick">Delete</button>
                    </th>
                </tr>`)
    }
    else
    {
        {
        $("#userTable").append(`<tr>
                    <td scope="row" class="Username">${user["Attributes"][0]["Value"]}</td>
                    <td>${user["UserLastModifiedDate"]}</td>
                    <td>
                        <button type="button" class="btn btn-success adminStatus" value="notThisValue">Yes<span class="glyphicon glyphicon-thumbs-down"></span></button>
                    </td>
                    <th scope="col">
                        <button type="button" class="btn btn-danger removeOnClick removeOnClick">Delete</button>
                    </th>
                </tr>`)
    }
    }

}

function userTable(users,adminUsers){
    console.log(users)
    console.log(adminUsers)
    for (let i in users){
        adminFlag = false
        console.log(i)
        userID = (users[i])["Username"]
        for (let k in adminUsers)
        {
            adminID = ((adminUsers[k])["Username"])
            if (userID == adminID)
            {
                adminFlag = true
            }
        }
        addUserToTable(users[i],adminFlag)
    }
}



$(document).ready(function () {
    //initalize credentials
    // userPool = 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902'
    // AWS.config.region = 'eu-west-1'; // Region
    // AWS.config.credentials = new AWS.CognitoIdentityCredentials({IdentityPoolId: 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902',
    // });
    // var cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({apiVersion: '2016-04-18'});

    // functionality to remove on click
    $('#userTable').on('click', '.removeOnClick', function() {
        username = $(this).parent().parent().find(".Username").text()
        console.log(username + " hello this is the username")
        var paramsDeleteUser = {UserPoolId: userpoolid, /* required */
        Username: username /* required */
        };
        cognitoidentityserviceprovider.adminDeleteUser(paramsDeleteUser, function(err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else
            alert("user deleted successfully")
            console.log(data);           // successful response
        });
        companyName = $(this).parent().parent().remove()
    })
    //Set User to admin
    $('#userTable').on('click', '.adminStatus', function() {
        let button = $(this)
    //check state of admin
        if($(this).text() == 'Yes') {
            //get username
            username = $(this).parent().parent().find(".Username").text()
            var params = {
                GroupName: 'Admin', /* required */
                UserPoolId: userpoolid, /* required */
                Username: username /* required */
            };
            cognitoidentityserviceprovider.adminAddUserToGroup(params, function (err, data) {
                if (err) {
                    console.log(err, err.stack); // an error occurred
                    console.log("Unable to change user status ")
                } else {
                    console.log("User removed as admin");           // successful response
                    button.text('No')
                    button.removeClass("btn-success")
                    button.addClass("btn-danger");
                }
            });
        }
        else {
            username =$(this).parent().parent().find(".Username").text()
            var params = {
              GroupName: 'Admin', /* required */
              UserPoolId: userpoolid, /* required */
              Username: username /* required */
            };
            cognitoidentityserviceprovider.adminRemoveUserFromGroup(params, function(err, data) {
              if (err) {
                  console.log(err, err.stack); // an error occurred
                  console.log("Unable to change user status ")
              }
              else{
                  console.log("USer Added as admin");
                    button.text('Yes')
                    button.removeClass("btn-danger")
                    button.addClass("btn-success");// successful response
              }
            });
        }
    })

    //Logout

    $('#logoutIndex').click(function () {
        window.location.href = "login.html";
    });


        //initalize cognito service
    var params = {
        UserPoolId: userpoolid, /* required */ // actual pool eu-west-1_gM8mCo99w //Test pool eu-west-1_nn8eU3DXM
        Filter: '',
        Limit: '50',
        AttributesToGet: ['email']
        //PaginationToken: '1'
        };
    cognitoidentityserviceprovider.listUsers(params, function(err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else
            {
                // successful response
                var adminData
                var userListData = data
                length = userListData["Users"]["length"]
                setUsers(length)

                var paramsAdminUsers = {
                  GroupName: 'Admin', /* required */
                  UserPoolId: userpoolid, /* required */
                  Limit: '50'
                };
                cognitoidentityserviceprovider.listUsersInGroup(paramsAdminUsers, function(err, data) {
                    if (err) console.log(err, err.stack); // an error occurred
                    else
                        adminData = data;
                        //console.log("Users in admin group returned");           // successful response
                        userTable(userListData["Users"],adminData["Users"])
                    });
            }
    });
});

