class Proxy extends ServiceInterface {
    constructor(service, output) {
        super();
        this.service = service;
        this.companyOutput = output;
        output.doesExist()
        let companiesArr = [];
        let companies = service.getCompanies();
        console.log(companies);

        companies.forEach((i)=>{
            companiesArr.push(new Company(i));
            console.log(i);
        })

        // console.log(companiesArr);

        this.companies = companiesArr;
    }

    updateCompanies(company){};
    removeCompanies(company){
        let res = this.service.removeCompanies(company)
        console.log(res + "asdfasdf")
        //Get the company By name First
        // if (this.service.removeCompanies(company)){
        //     this.output.removeItem(company)
        // }else {
        //     alert("Unable to remove Item")
        // }
    };
    printList(){
        let comp = this.companyOutput
        this.companies.forEach((i) => {
            comp.printItem(i)
        })
    }
}

proxy = new Proxy( new Service("https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/", ""), new TableOut("companyTable"))

company = {
    "content": "TestCompany",
    "Ticker" : "TSLA"
}
//
// ser.updateCompanies(company);
proxy.printList()
proxy.removeCompanies(company)