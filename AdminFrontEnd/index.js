function setUsers(numberOfUsers){
    $("#numberOfUsers").text(numberOfUsers)
}

function addUserToTable(user){
    console.log(user)
    $("#userTable").append(`<tr>
                    <td scope="row">${user["Username"]}</td>
                    <td>${user["UserLastModifiedDate"]}</td>
                    <td>
                        <button type="button" class="btn btn-danger adminStatus" value="notThisValue">No<span class="glyphicon glyphicon-thumbs-down"></span></button>
                    </td>
                    <th scope="col">
                        <button type="button" class="btn btn-danger removeOnClick removeOnClick">Delete</button>
                    </th>
                </tr>`)
}

function userTable(users){
    console.log(users)
    for (let i in users){
        console.log(i)
        addUserToTable(users[i])
    }
}


$(document).ready(function () {
    // functionality to remove on click
    $('#userTable').on('click', '.removeOnClick', function() {
        console.log("Somethinhg")
        companyName = $(this).parent().parent().remove()
    })
    //Set User to admin
    $('#userTable').on('click', '.adminStatus', function() {
        console.log("Somethinhg")
        // companyName = $(this).text("YES")

        if($(this).text() == 'Yes') {
            $(this).text('No');
        }
        else {
            $(this).text('Yes');
        }
        })
    //initalize credentials
    // userPool = 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902'
    AWS.config.region = 'eu-west-1'; // Region
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({IdentityPoolId: 'eu-west-1:16273994-4cdf-42fd-b2f9-48c1728f6902',
    });
    //initalize cognito service
    var cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({apiVersion: '2016-04-18'});

    var userListdata;
    var params = {
        UserPoolId: 'eu-west-1_gM8mCo99w', /* required */ // actual pool eu-west-1_gM8mCo99w //Test pool eu-west-1_nn8eU3DXM
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
                length = data["Users"]["length"]
                setUsers(length)
                userTable(data["Users"])
                console.log(data);
            }           // successful response
    });
// This actually returns the object wtf
});