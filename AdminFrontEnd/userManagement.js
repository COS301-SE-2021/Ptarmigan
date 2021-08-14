function addCompanyToTable(name){
    let content = `<tr>
            <td scope="row" class="companyName">${name}</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
        </tr>`
    $("#companyTable").prepend(content)
}

$(document).ready(function () {
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
        let content = {"content": "input"}
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
