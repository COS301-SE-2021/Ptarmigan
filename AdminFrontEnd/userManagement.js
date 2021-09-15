
function addCompanyToTable(name){
    let content = `<tr>
            <td scope="row" class="companyName">${name}</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
            <th scope="col">
                <button type="button" class="btn btn-success viewClick">View</button>
            </th>
        </tr>`
    $("#companyTable").prepend(content)
}

//Add username to navbar
function addingUsername(){
    $("#username").html(sessionStorage.getItem("username"))
}

//add Company ticker to list of suggestions

function addCompanyTickerToDropdown(ticker, name, index){
    dropDownItem = `
        <option value="${ticker}">
            <div class="companyTickerSymbol">${ticker} - </div>
            <div>${name}</div>
        </option>`
    $("#tickerDropDown").append(dropDownItem)
}

function loadTickerSymbols(){
    clearDropdown()
    companySearch = $("#companyNameInput").val()
    link = `https://api.polygon.io/v3/reference/tickers?search=${companySearch}&active=true&sort=ticker&order=asc&limit=10&apiKey=4RTTEtcaiXt4pdaVkrjbfcQDygvKbiqp`
    $.get(link, data =>{
        console.log(data)
        for (i = 0; i < data.results.length; i++){
            console.log(data.results[i]["ticker"])
            addCompanyTickerToDropdown(data.results[i]["ticker"], data.results[i]["name"], i)
        }
    })
}

function clearDropdown(){
    $("#tickerDropDown").html(`<option value="0">Choose...</option>`)
}

//Remove parameter from table
$('#parameterTable').on('click', '.removeOnClick', function(e){
    $(this).closest('tr').remove()
})

function addAdditionalParametersToList(){
    let value = $("#additionalScrapeParameters").val()
    if (value == ""){
        alert("Please enter data into the input box")
    }
    tableRow = `
        <tr>
            <td scope="row" class="parameterName">${value}</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
        </tr>`
    $("#parameterTable").prepend(tableRow)
    $("#additionalScrapeParameters").val("")
}

function getFormDataFromPage(){
    let companyName = $("#companyNameInput").val()
    let tickerSymbol = $("#tickerDropDown").val()

    let additionalParameters = []
    $(".parameterName").each(function (){
        additionalParameters.push($(this).text())
    })

    if (additionalParameters.length <= 3){
        for (i=0; i <= 4-additionalParameters.length; i++){
            additionalParameters.push(null)
        }
    }

    console.log(additionalParameters.length)

    jsonObj = {
        content: companyName,
        Ticker: tickerSymbol,
        // Associated1: additionalParameters[0],
        // Associated2: additionalParameters[1],
        // Associated3: additionalParameters[2]
    }

    if (additionalParameters[0] != null) {
        jsonObj["Associated1"] = additionalParameters[0];
    }
    if (additionalParameters[1] != null) {
        jsonObj["Associated2"] = additionalParameters[0];
    }
    if (additionalParameters[2] != null) {
        jsonObj["Associated3"] = additionalParameters[0];
    }

    console.log(jsonObj)+
    console.log(companyName + tickerSymbol + additionalParameters)

    $("#companyNameInput").val("")
    $("#tickerDropDown").val("Choose..")
    $("#parameterTable").html("")

    return jsonObj

}

function submitForm(){
    jsonObj = getFormDataFromPage()
    // console.log(jsonObj)
    deleteFromBucket(jsonObj.content)
    updateTableBucket(jsonObj)

}

function updateTableBucket(object){
    let content = object
    updateBucketcall = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/UpdateBucket"
    $.post(updateBucketcall, JSON.stringify(content), function(result){
        console.log(result)
        addCompanyToTable(object.content)
    })
        .fail(function (value){
            alert("Unable to add Company to list")
            $("#myInput").val("")

        })

    $(this).removeClass("disabled")
}

function deleteFromBucket(obj){
    companyName = obj.content
    $(this).addClass("disabled")
    companyName = $(this).parent().parent().find("td").text()
    // $(this).parent().parent().remove()
    let row = this
    //    TODO: Add call to the Api
    updateBucketcall = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/deleteBucketItem"
    $.post(updateBucketcall, JSON.stringify({"content": companyName}), function(result){
        console.log(result)
        $(row).parent().parent().remove()
    })
        .fail(function (value){
            alert("Unable to remove company from bucket")
        })
}

function viewCompanyDetails(companyName){
    console.log("Getting company details")
    let getBucketItemsURL = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"
    $.post(getBucketItemsURL, {}, function(result){
        console.log(result)
    });
}

// View button populates the parameter table, ticker symbol and Company name

$('#companyTable').on('click', '.viewClick', function() {


    let companyName = $(this).parent().parent().find("td").text()
    $('#companyNameInput').val(companyName)
    // loadTickerSymbols()

    let companySearch = $("#companyNameInput").val()
    link = `https://api.polygon.io/v3/reference/tickers?search=${companySearch}&active=true&sort=ticker&order=asc&limit=10&apiKey=4RTTEtcaiXt4pdaVkrjbfcQDygvKbiqp`
    $.get(link, data =>{
        console.log(data)
        for (i = 0; i < data.results.length; i++){
            console.log(data.results[i]["ticker"])
            addCompanyTickerToDropdown(data.results[i]["ticker"], data.results[i]["name"], i)
        }
        $('#tickerDropDown').val('AAPL')

    })

    let value = $("#additionalScrapeParameters").val()
    tableRow = `
        <tr>
            <td scope="row" class="parameterName">Ipad</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
        </tr>`
    $("#parameterTable").prepend(tableRow)
    $("#additionalScrapeParameters").val("")

    // loadTickerSymbols()
    // addAdditionalParametersToList()
});


//logout

$('#logoutCompany').click(function () {
    window.location.href = "login.html";
});

var typingTimer;                //timer identifier
var doneTypingInterval = 1000;  //time in ms, 5 second for example

proxy = new Proxy( new Service("https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/", ""), new TableOut("companyTable"))

$(document).ready(function () {

    proxy.printList()



    addingUsername()
//     viewCompanyDetails("Bitcoin")
//
    $("#addParameterButton").click(function(){
        addAdditionalParametersToList()
    })

    $("#submitFormButton").click(function(){
        submitForm()
    })

    $("#companyNameInput").on('keyup', function () {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(doneTyping, doneTypingInterval);
    });

//on keydown, clear the countdown
    $("#companyNameInput").on('keydown', function () {
        clearTimeout(typingTimer);
    });

//user is "finished typing," do something
    function doneTyping () {
        console.log("Somethibg")
        loadTickerSymbols()
    }

//
//     //Add event listener to the dynamically created events
    $('#companyTable').on('click', '.removeOnClick', function() {
        $(this).addClass("disabled")
        companyName = $(this).parent().parent().find("td").text()

        company = proxy.getCompaniesByName(companyName)
        console.log(company)
        proxy.removeCompanies(company)

    });
//
//     //Add button
//     $('#addButton').on("click", function (){
//         console.log("Click")
//         let input = $("#myInput").val()
//         console.log(input)
//
//         $(this).addClass("disabled")
//         //Add Api call
//         let content = {"content": input}
//         updateBucketcall = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/UpdateBucket"
//         $.post(updateBucketcall, JSON.stringify(content), function(result){
//             console.log(result)
//             addCompanyToTable(input)
//         })
//             .fail(function (value){
//                 alert("Unable to add Company to list")
//                 $("#myInput").val("")
//
//             })
//
//         $(this).removeClass("disabled")
//     })
});
