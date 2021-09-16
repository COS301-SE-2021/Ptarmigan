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

    updateCompanies(company){
        this.service.updateCompanies(company)
    };
    removeCompanies(company){
        // let res = this.service.removeCompanies(company)
        let res = true;

        console.log("Removing Comapny")
        if (res){
            this.companyOutput.removeItem(company)
        }
        // console.log(res + "asdfasdf")
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

    getCompanies() {

    }

    getCompaniesByName(name){
        console.log(this.companies)

        for (let i = 0; i < this.companies.length; i++){
            console.log(i)
            console.log(this.companies[i].companyJSON.content)
            if (this.companies[i].companyJSON.content == name){
                // console.log(i.companyJSON.context)
                return this.companies[i];
            }
        }
        // this.companies.forEach((i) => {
        //     if (i.companyJSON.context == name){
        //         console.log(i.companyJSON.context)
        //         return i;
        //     }
        // })

        console.log("Company does not exist");
        return null
    }
}




//
// ser.updateCompanies(company);

// proxy.removeCompanies(company)