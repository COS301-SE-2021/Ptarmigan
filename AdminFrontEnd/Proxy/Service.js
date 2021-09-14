class Service extends ServiceInterface{
    constructor(url, token) {
        super();
        this.url = url;
        this.token = token;
        console.log("Creating Object");

    }
    getCompanies(){
        let extention = "scraper/returnBucketList";
        let requestUrl = this.url + extention;

        // console.log(requestUrl)
        console.log("Getting Companies");
        let res;

        $.ajax({
            type: "POST",
            url: requestUrl,
            async: false,
            data: {},
            success: function(result) {
                console.log(result)
                res = result["scrape-detail"];
                return res;
            }
        });

        // res = await $.post(requestUrl, {}, function(result){
        //     console.log(result)
        //     let res = result;
        //     return result;
        // });
        return res

    }
    updateCompanies(company){

        let extentionAdd = "scraper/UpdateBucket"
        let requestUrlAdd = this.url + extentionAdd;
        console.log('updating companies')

        let extentionRemove = "scraper/deleteBucketItem";
        let requestUrlRemove = this.url + extentionRemove;

        this.removeCompanies(company)
        $.post(requestUrlAdd, JSON.stringify(company), function(result){
            console.log("Removed And Updated")
            console.log(result)
        })
    }

    removeCompanies(company){
        let extentionRemove = "scraper/deleteBucketItem";
        let requestUrlRemove = this.url + extentionRemove;

        $.post(requestUrlRemove, JSON.stringify(company), function(result){
            console.log(result)
        }).fail((results) => {
            console.log("Company Is Not in the list")
            // return false
        })
    }
}

// ser = new Service("https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/","")
// ser.getCompanies()
//
// company = {
//     "content": "TestCompany",
//     "Ticker" : "TSLA"
// }
//
// ser.updateCompanies(company);
//
// ser.removeCompanies(company)