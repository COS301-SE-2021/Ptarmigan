

function addCompanyToTable(name){
    let content = `<tr>
            <td scope="row" class="companyName">${name}</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
        </tr>`
    $("#companyTable").prepend(content)
}

//add Company ticker to list of suggestions

function addCompanyTickerToDropdown(ticker, name, index){
    dropDownItem = `
        <option value="${index}">
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

function addAdditionalParametersToList(){

    value = $("#additionalScrapeParameters").val()
    tableRow = `<tr>
            <td scope="row" class="parameterName">${name}</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
        </tr>`
    $("#parameterTable").prepend(tableRow)

}

//logout

$('#logoutCompany').click(function () {
    window.location.href = "login.html";
});

var typingTimer;                //timer identifier
var doneTypingInterval = 1000;  //time in ms, 5 second for example

$(document).ready(function () {
    $("#addParameterButton").click(function(){
        addAdditionalParametersToList()
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

    //This will populate the company table with elements from the db
    let getBucketItemsURL = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"

    $.post(getBucketItemsURL, {}, function(result){

        console.log(result)
        console.log(result["scrape-detail"])
        for (let i in  result["scrape-detail"]){
            console.log(i)
            console.log(result["scrape-detail"][i]["content"])
            addCompanyToTable(result["scrape-detail"][i]["content"])
        }
    });

    //Add event listener to the dynamically created events
    $('#companyTable').on('click', '.removeOnClick', function() {
        console.log("CLICK")
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

    });

    //Add button
    $('#addButton').on("click", function (){
        console.log("Click")
        let input = $("#myInput").val()
        console.log(input)

        $(this).addClass("disabled")
        //Add Api call
        let content = {"content": input}
        updateBucketcall = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/UpdateBucket"
        $.post(updateBucketcall, JSON.stringify(content), function(result){
            console.log(result)
            addCompanyToTable(input)
        })
            .fail(function (value){
                alert("Unable to add Company to list")
                $("#myInput").val("")

            })

        $(this).removeClass("disabled")
    })
});
