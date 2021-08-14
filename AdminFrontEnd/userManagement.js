$(document).ready(function () {
    $('.removeOnClick').click(function () {
        $(this).parent().parent().remove()
    })
});

function addCompany(name){
    let content = `<tr>
            <td scope="row">BitCoin</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
        </tr>`
    $("#companyTable").append(content)
    return
}

getBucketItemsURL = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"

$.post(getBucketItemsURL, {}, function(result){
    console.log(result)
    console.log(result["scrape-detail"])
    for (let i in  result["scrape-detail"]){
        console.log(i)
        console.log(result["scrape-detail"][i]["content"])
        let content = `<tr>
            <td scope="row">${result["scrape-detail"][i]["content"]}</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
        </tr>`
        $("#companyTable").append(content)
    }
});