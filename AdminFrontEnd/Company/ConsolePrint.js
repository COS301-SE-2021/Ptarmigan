class ConsolePrint extends Output{
    constructor() {
        console.log("Printing Object Created")
        super();
    }
    printItem(company){
        console.log("Printing Company")
        console.log("Name:", company.companyJSON.content)
        console.log("Ticker:", company.companyJSON.Ticker)
    }
    removeItem(){}

    doesExist(){
        console.log("This Object Does Exist")
    }
}