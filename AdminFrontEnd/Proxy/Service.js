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

        $.post(requestUrl, {}, function(result){
            console.log(result)
        });
    }
    updateCompanies(company){
        console.log('updating companies')
    }
    removeCompanies(companyName){
        console.log("Removing Companies")
    }
}

ser = new Service("https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/","")
ser.getCompanies()