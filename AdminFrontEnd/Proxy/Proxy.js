class Proxy extends ServiceInterface {
    constructor(service, output) {
        super();
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
    removeCompanies(companyName){};
    printList(){
        let comp = this.companyOutput
        this.companies.forEach((i) => {
            comp.printItem(i)
        })
    }
}

proxy = new Proxy( new Service("https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/", ""), new ConsolePrint())
proxy.printList()
