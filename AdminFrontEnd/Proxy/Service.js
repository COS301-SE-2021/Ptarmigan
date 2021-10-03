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

        this.removeCompanies(company)
        console.log(company.companyJSON);
        return $.post(requestUrlAdd, JSON.stringify(company.companyJSON), function(result){
            console.log("Removed And Updated")
            console.log(result)
            return true
        }).fail(res => {
            return false
        })
    }

    removeCompanies(company){

        let ret
        let extentionRemove = "scraper/deleteBucketItem";
        let requestUrlRemove = this.url + extentionRemove;

        $.ajax({
            type: "POST",
            url: requestUrlRemove,
            async: false,
            data: JSON.stringify(company.companyJSON),
            success: function(result) {
                console.log(result)
                ret = true
                return true
            },
            error: (result) =>{
                ret = false
                console.log(result)
                return false
            }
        });
        //
        // let ret = await $.post(requestUrlRemove, JSON.stringify(company), function(result){
        //     console.log(result)
        //     return true
        // }).fail((results) => {
        //     console.log("Company Is Not in the list")
        //     return false
        //     // return false
        // })

        console.log(ret)
        return ret
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